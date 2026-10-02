"""Measure a skill's trigger rate against its EVAL.md queries in fresh headless sessions.

Each query runs several times in a fresh `claude -p` session. A run counts as a trigger when the
stream-json transcript contains a Skill tool call for the skill under test.

The installed user-scope copy of the skill, if any, is switched off per run with skillOverrides,
and the repo copy is loaded as a local plugin, so the description under test is always the repo's.
`--ref` loads the skill as it was at a git ref instead, which is how a control run is made.

    python3 eval/run_eval.py ui-ux-design --fixture eval/fixtures/nextjs-app
    python3 eval/run_eval.py ui-ux-design --only positives --ref v10.4.0
"""

import argparse
import json
import re
import secrets
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PLUGIN_NAME = "evalbox"
ROW_PATTERN = re.compile(r'^\| ([TNVX]\d+) \| "(.+)" \| (.+?) \|$')


@dataclass
class Query:
    query_id: str
    text: str
    should_trigger: bool
    block: str


@dataclass
class RunResult:
    query_id: str
    triggered: bool
    other_skills: list[str] = field(default_factory=list)
    hit_max_turns: bool = False
    error: str = ""


@dataclass
class Harness:
    skill_names: set[str]
    plugin_dir: Path
    settings_file: Path
    fixture: Path | None
    workspaces: Path
    transcripts: Path
    model: str
    max_turns: int
    timeout_seconds: int


def find_eval_file(skill: str) -> Path:
    for directory in ("references", "reference"):
        candidate = REPO_ROOT / "skills" / skill / directory / "EVAL.md"
        if candidate.exists():
            return candidate
    raise SystemExit(f"No EVAL.md under skills/{skill}/references or skills/{skill}/reference")


def parse_queries(eval_text: str) -> list[Query]:
    queries: list[Query] = []
    block = ""
    for line in eval_text.splitlines():
        if line.startswith("## "):
            block = line[3:].split(" ")[0].strip("()")
        match = ROW_PATTERN.match(line)
        if match:
            query_id, text, expected = match.groups()
            queries.append(Query(query_id, text, expected.startswith("trigger"), block))
    return queries


def build_plugin(skill: str, ref: str | None, destination: Path) -> None:
    skill_destination = destination / "skills" / skill
    if ref is None:
        shutil.copytree(REPO_ROOT / "skills" / skill, skill_destination)
    else:
        skill_destination.mkdir(parents=True)
        archive = subprocess.run(
            ["git", "-C", str(REPO_ROOT), "archive", ref, f"skills/{skill}"],
            capture_output=True, check=True,
        )
        subprocess.run(
            ["tar", "-x", "--strip-components", "2", "-C", str(skill_destination)],
            input=archive.stdout, check=True,
        )
    manifest = destination / ".claude-plugin" / "plugin.json"
    manifest.parent.mkdir(parents=True)
    manifest.write_text(json.dumps({"name": PLUGIN_NAME, "version": "0.0.0", "description": "eval copy"}))


def prepare_workspace(harness: Harness) -> Path:
    workspace = harness.workspaces / secrets.token_hex(4) / "project"
    if harness.fixture is None:
        workspace.mkdir(parents=True)
        return workspace
    shutil.copytree(harness.fixture, workspace)
    for command in (["git", "init", "-q"], ["git", "add", "-A"],
                    ["git", "-c", "user.name=dev", "-c", "user.email=dev@example.com", "commit", "-qm", "initial"]):
        subprocess.run(command, cwd=workspace, check=True)
    return workspace


def skills_invoked(transcript: str) -> tuple[list[str], bool]:
    invoked: list[str] = []
    hit_max_turns = False
    for raw_line in transcript.splitlines():
        try:
            event = json.loads(raw_line)
        except json.JSONDecodeError:
            continue
        if event.get("type") == "result" and event.get("subtype") == "error_max_turns":
            hit_max_turns = True
        if event.get("type") != "assistant":
            continue
        for block in event.get("message", {}).get("content", []):
            if block.get("type") == "tool_use" and block.get("name") == "Skill":
                invoked.append(str(block.get("input", {}).get("skill", "")))
    return invoked, hit_max_turns


def run_once(harness: Harness, query: Query, run_number: int) -> RunResult:
    workspace = prepare_workspace(harness)
    command = [
        "claude", "-p", query.text,
        "--model", harness.model,
        "--max-turns", str(harness.max_turns),
        "--output-format", "stream-json", "--verbose",
        "--plugin-dir", str(harness.plugin_dir),
        "--settings", str(harness.settings_file),
    ]
    error = ""
    try:
        completed = subprocess.run(
            command, cwd=workspace, capture_output=True, text=True, timeout=harness.timeout_seconds, check=False
        )
        transcript = completed.stdout
        if completed.returncode != 0:
            error = f"exit {completed.returncode}: {completed.stderr[:200]}"
    except subprocess.TimeoutExpired as timeout_error:
        partial = timeout_error.stdout
        transcript = partial.decode() if isinstance(partial, bytes) else (partial or "")
        error = "timeout"
    finally:
        shutil.rmtree(workspace.parent, ignore_errors=True)
    (harness.transcripts / f"{query.query_id}-run{run_number}.jsonl").write_text(transcript)
    invoked, hit_max_turns = skills_invoked(transcript)
    other_skills = [name for name in invoked if name not in harness.skill_names]
    if hit_max_turns and error.startswith("exit 1"):
        error = ""
    return RunResult(query.query_id, bool(harness.skill_names & set(invoked)), other_skills, hit_max_turns, error)


def summarize(queries: list[Query], results: list[RunResult]) -> list[dict]:
    summary = []
    for query in queries:
        runs = [result for result in results if result.query_id == query.query_id]
        rate = sum(result.triggered for result in runs) / len(runs)
        summary.append({
            "id": query.query_id, "block": query.block, "query": query.text,
            "expected": "trigger" if query.should_trigger else "no",
            "triggered_runs": sum(result.triggered for result in runs), "runs": len(runs),
            "rate": round(rate, 2),
            "pass": rate > 0.5 if query.should_trigger else rate < 0.5,
            "max_turns_hits": sum(result.hit_max_turns for result in runs),
            "other_skills": sorted({name for result in runs for name in result.other_skills}),
            "errors": [result.error for result in runs if result.error],
        })
    return summary


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("skill", help="skill directory name under skills/")
    parser.add_argument("--fixture", type=Path, help="project directory each run starts in; omit for an empty directory")
    parser.add_argument("--ref", help="git ref to load the skill from instead of the working tree (a control run)")
    parser.add_argument("--only", help='"positives", "negatives", or comma-separated query ids such as T3,V2')
    parser.add_argument("--runs", type=int, default=3)
    parser.add_argument("--max-turns", type=int, default=6)
    parser.add_argument("--model", default="sonnet")
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--timeout", type=int, default=420, help="seconds per run")
    parser.add_argument("--out", type=Path, help="directory for transcripts and results.json; defaults to a temp dir")
    return parser.parse_args()


def select_queries(queries: list[Query], only: str | None) -> list[Query]:
    if only is None:
        return queries
    if only == "positives":
        return [query for query in queries if query.should_trigger]
    if only == "negatives":
        return [query for query in queries if not query.should_trigger]
    wanted = set(only.split(","))
    return [query for query in queries if query.query_id in wanted]


def main() -> None:
    arguments = parse_arguments()
    eval_file = find_eval_file(arguments.skill)
    queries = select_queries(parse_queries(eval_file.read_text()), arguments.only)
    if not queries:
        raise SystemExit(f'No queries matched in {eval_file}. Rows must look like: | T1 | "query" | trigger |')

    out_dir = arguments.out or Path(tempfile.mkdtemp(prefix=f"eval-{arguments.skill}-"))
    work_dir = Path(tempfile.mkdtemp(prefix="eval-work-"))
    plugin_dir = work_dir / "plugin"
    build_plugin(arguments.skill, arguments.ref, plugin_dir)
    settings_file = work_dir / "settings.json"
    settings_file.write_text(json.dumps({"skillOverrides": {arguments.skill: "off"}}))
    harness = Harness(
        skill_names={arguments.skill, f"{PLUGIN_NAME}:{arguments.skill}"},
        plugin_dir=plugin_dir, settings_file=settings_file,
        fixture=arguments.fixture.resolve() if arguments.fixture else None,
        workspaces=work_dir / "workspaces", transcripts=out_dir / "transcripts",
        model=arguments.model, max_turns=arguments.max_turns, timeout_seconds=arguments.timeout,
    )
    harness.workspaces.mkdir()
    harness.transcripts.mkdir(parents=True, exist_ok=True)

    jobs = [(query, run_number) for query in queries for run_number in range(1, arguments.runs + 1)]
    print(f"{arguments.skill} @ {arguments.ref or 'working tree'}: {len(queries)} queries, {len(jobs)} runs", flush=True)
    with ThreadPoolExecutor(max_workers=arguments.workers) as pool:
        results = list(pool.map(lambda job: run_once(harness, *job), jobs))
    shutil.rmtree(work_dir, ignore_errors=True)

    summary = summarize(queries, results)
    (out_dir / "results.json").write_text(json.dumps(summary, indent=2))
    for row in summary:
        print(f"{row['id']:>4} {row['block']:<11} {row['expected']:<7} {row['triggered_runs']}/{row['runs']} "
              f"rate {row['rate']:.2f} {'PASS' if row['pass'] else 'FAIL'}  max-turns={row['max_turns_hits']} "
              f"other={row['other_skills']} errors={row['errors']}")
    positives = [row for row in summary if row["expected"] == "trigger"]
    print(f"positive runs triggered: {sum(row['triggered_runs'] for row in positives)}/"
          f"{sum(row['runs'] for row in positives)}  queries passed: {sum(row['pass'] for row in summary)}/{len(summary)}")
    print(f"transcripts and results.json: {out_dir}")
    if any(row["errors"] for row in summary):
        sys.exit(1)


if __name__ == "__main__":
    main()

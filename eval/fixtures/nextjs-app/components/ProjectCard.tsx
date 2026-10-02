type Project = { id: string; title: string; owner: string; coverUrl: string; progress: number };

export function ProjectCard({ project }: { project: Project }) {
  return (
    <a href={`/projects/${project.id}`} className="card">
      <img src={project.coverUrl} width={196} height={110} />
      <h3>{project.title}</h3>
      <p>{project.owner}</p>
      <div style={{ background: project.progress > 50 ? "green" : "red", height: 4, width: `${project.progress}%` }} />
      <button className="btn" onClick={() => alert("starred")}>★</button>
    </a>
  );
}

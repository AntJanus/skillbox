# Packaging to a desktop binary — deep reference

Load when shipping the app without Node/Deno/node_modules on the target. Possible because persistence is `node:sqlite` (no native addon). `output: "standalone"` in the Next config is the enabler.

**The key rule:** compile the Next.js **standalone `server.js`**, NOT the repo root. `deno compile .` of the root embeds the entire node_modules (~750MB); compiling the standalone server embeds only its slim node_modules (~115MB).

## Two build paths

### Headless single-file binary (`deno compile`)
- `deno compile` the standalone `server.js` → a single executable that opens `localhost:PORT` in a browser.
- Creates `./data/<app>.sqlite` next to the binary on first run.
- Simplest; good for "download and run".

### Native-window app (`deno desktop`, Deno 2.9+)
- Compile a custom entrypoint that sets the data-dir env (e.g. `<APP>_DATA_DIR`) to the OS per-user data dir (e.g. `~/Library/Application Support/<App>`) **before** booting Next, so the store survives app updates (vs the read-only bundle dir).
- For slimness, **copy the entrypoint + the data-dir helper into `.next/standalone` and compile from there** — compiling from the repo root pulls in the whole root tree.

## Gotchas

- **Always `next build` first** — `deno desktop` reuses a stale `.next`.
- **Compile needs `-A`** — else Next throws `NotCapable` on `process.env` access.
- **Remove any prior `*.app` bundle** before rebuilding.
- **Deno version shadowing** — a Homebrew Deno can shadow `~/.deno/bin/deno`; ensure 2.9+ is the one on PATH.
- **Exclude the Deno entrypoint + `*.app`** from `tsc`/eslint and gitignore them (the entrypoint is a Deno file, not part of the Next app).

## Signing / distribution

Bundles are **ad-hoc signed only** by these tools — local builds run fine (no quarantine), but a downloaded/AirDropped copy is Gatekeeper-blocked until `xattr -dr com.apple.quarantine <App>.app` (or right-click → Open).

Distribution-without-warning needs **paid certs** as a post-build step on the produced bundle:
- **macOS:** Apple Developer ID + notarization (`codesign --options runtime` → `xcrun notarytool` → `stapler staple`).
- **Windows:** Authenticode cert + `signtool`.

`deno desktop` has no signing flags, so signing always happens after the bundle is produced.

## Data-dir resolution

A single helper resolves the path: the env override (set by the desktop entrypoint) else `./data`. Both the Deno entrypoint and the produced bundles are excluded from `tsc`/eslint and gitignored.

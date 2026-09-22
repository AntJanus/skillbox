# Carbon — the complete palette

Deep slate-blue, dark-first. The default for analytics dashboards, performance reports and dev tooling. Everything Carbon needs is in this file — roles, dashboard kit, and the fill/subtle/emphasis triads, light and dark — so a page or artifact that must use Carbon reads this file alone. The other palettes are in [palettes.md](palettes.md).

## Roles (light + dark)

A dark-led sibling of Graphite, pulled from a working pipeline-performance dashboard. Bluer panels/borders than Graphite and a brighter sky-blue primary; ships with a full **dashboard kit** (grade pills, ordered stage sequence, inline-code tone, success highlight) below the role table. Both columns sit on **GitHub Primer** tokens (dark = Primer-dark, the light companion = Primer-light), so the 13 roles stay swappable and you can cross-check Primer's published contrast data. The dark column is the star.

| Role | Light | Dark |
|---|---|---|
| background | `#f6f8fa` | `#0d1117` |
| surface | `#ffffff` | `#161b22` |
| surface-elevated | `#eceff3` | `#1c232d` |
| border | `#d8dee4` | `#2d3744` |
| text-primary | `#0c1f33` | `#e6edf3` |
| text-secondary | `#5b6b7d` | `#8b949e` |
| primary | `#0969da` | `#58a6ff` |
| primary-hover | `#0550ae` | `#79b8ff` |
| accent | `#8250df` | `#a371f7` |
| success | `#1a7f37` | `#3fb950` |
| warning | `#9a6700` | `#d29922` |
| error | `#cf222e` | `#f85149` |
| info | `#0969da` | `#58a6ff` |

## Dashboard kit (dark)

The report-tested extras that make Carbon a dashboard palette, not just a theme.

- **Grade pills (A→F)** — paired `bg`/`fg` badge tones, each fg readable on its own dim bg:

  | Grade | bg | fg |
  |---|---|---|
  | A | `#1a3326` | `#3fb950` |
  | B | `#2a2f1a` | `#bdc02b` |
  | C | `#33291a` | `#d29922` |
  | D | `#331f1a` | `#f0883e` |
  | F | `#3a1a1a` | `#f85149` |

- **Stage sequence (ordered, 4 steps)** — `#3fb950` → `#d29922` → `#f85149` → `#a371f7` (green→amber→red→violet). Reuses success/warning/error/accent as an ordered set for pipeline stages, stacked bars, and legends. Cap at these 4; it is *not* a general categorical ramp.
- **Inline code** — bg `#0c1f33` (deep navy) / fg `#9fd0ff` (ice blue). The same `#9fd0ff` doubles as a monospace label/identifier accent.
- **Success highlight ("big win")** — gradient `#10261a` → `#161b22`, border `#1f5132`, emphasis text `#7ee787`. A call-out card that reads as a win without a full success-green flood.
- **Text on colored fills** (stage segments, critical-path blocks): `#ffffff`.

## Triads — fill, subtle, emphasis

One hex cannot do three jobs, so each colored role ships a set. `fill` + `on-fill` for buttons and active chips; `subtle` + `subtle-border` + `emphasis` for badge and callout backgrounds and their label; `as text` for the hue as a link directly on `surface`. Every `on-fill`, `emphasis` and `as text` value clears 4.5:1 against the ground it sits on. The token mapping to Bootstrap, Material 3 and Radix is in [palettes.md](palettes.md#triads--every-color-three-jobs).

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#0969da` | `#ffffff` | `#dfebfc` | `#b2cef6` | `#0165d6` | `#0969da` |
| accent | `#8250df` | `#ffffff` | `#ece7fd` | `#d1c6f8` | `#7c49d8` | `#8250df` |
| success | `#1a7f37` | `#ffffff` | `#e1ede2` | `#b6d3b9` | `#117a32` | `#1a7f37` |
| warning | `#9a6700` | `#ffffff` | `#f1e9df` | `#ddcab1` | `#915f00` | `#9a6700` |
| error | `#cf222e` | `#ffffff` | `#fde3e1` | `#f8bcb7` | `#cc1e2c` | `#cf222e` |
| info | `#0969da` | `#ffffff` | `#dfebfc` | `#b2cef6` | `#0165d6` | `#0969da` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#58a6ff` | `#0d1117` | `#223144` | `#325176` | `#58a6ff` | `#58a6ff` |
| accent | `#a371f7` | `#0d1117` | `#2c2a43` | `#4c3e74` | `#aa79ff` | `#a371f7` |
| success | `#3fb950` | `#0d1117` | `#1f342d` | `#2a5839` | `#3fb950` | `#3fb950` |
| warning | `#d29922` | `#0d1117` | `#333029` | `#5e4d2f` | `#d29922` | `#d29922` |
| error | `#f85149` | `#0d1117` | `#3b282b` | `#6f3635` | `#ff5b52` | `#f85149` |
| info | `#58a6ff` | `#0d1117` | `#223144` | `#325176` | `#58a6ff` | `#58a6ff` |


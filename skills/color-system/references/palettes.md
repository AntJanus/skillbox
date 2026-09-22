# Palette Library — full hex tables

Every palette below maps to semantic roles (UI) or ordered color lists (data viz) or ANSI slots (TUI). Copy the table you need. All values are verified from the source noted, hand-tuned for this library, or generated from the OKLCH recipe in build-your-own.md.

Two things live here beyond the role tables: the [Triads section](#triads--every-color-three-jobs) gives every UI color its `fill` / `subtle` / `emphasis` set, and the three generated palettes ship their full 12-step scales so they can be extended or re-derived.

---

## Web App UI (light + dark)

13 roles each. In dark mode, `surface-elevated` is intentionally lighter than `surface` (elevation = lighter). The six palettes in this first group were authored as flat roles; **Dusk**, **Driftwood** and **Meadow** were generated from 12-step scales and ship those scales alongside their roles.

### Graphite — cool slate + blue · dense B2B dashboards, dev tools

| Role | Light | Dark |
|---|---|---|
| background | `#f8fafc` | `#0d1117` |
| surface | `#ffffff` | `#161b22` |
| surface-elevated | `#f1f5f9` | `#21262d` |
| border | `#e2e8f0` | `#30363d` |
| text-primary | `#0f172a` | `#e6edf3` |
| text-secondary | `#64748b` | `#8b949e` |
| primary | `#2563eb` | `#388bfd` |
| primary-hover | `#1d4ed8` | `#58a6ff` |
| accent | `#7c3aed` | `#a371f7` |
| success | `#16a34a` | `#3fb950` |
| warning | `#d97706` | `#d29922` |
| error | `#dc2626` | `#f85149` |
| info | `#0284c7` | `#388bfd` |

### Teal Slate — deep teal on cool slate · technical reports, SRE / rate-limit dashboards

Single-accent system: teal carries structure/data; amber is the one warm signal (doubles as `accent` and `warning`); green = headroom, red = risk. Light values are the "keeper" set; dark mirrors them (not a naive invert).

| Role | Light | Dark |
|---|---|---|
| background | `#f5f8f9` | `#0b1015` |
| surface | `#ffffff` | `#121a21` |
| surface-elevated | `#eef3f5` | `#1a232b` |
| border | `#d8e0e4` | `#25313a` |
| text-primary | `#121a20` | `#e7eef2` |
| text-secondary | `#48565f` | `#9aa8b1` |
| primary | `#0c6d78` | `#3fb6c4` |
| primary-hover | `#095a63` | `#62cad6` |
| accent | `#a96811` | `#dca23f` |
| success | `#2f7d52` | `#4cbe80` |
| warning | `#a96811` | `#dca23f` |
| error | `#bd3831` | `#ef6b62` |
| info | `#0c6d78` | `#3fb6c4` |

Extended tokens as shipped (the tints + extra neutrals that make it work — soft = 10–15% wash of its hue for callout/chip/fill backgrounds):

```css
/* light */
--ink-faint:#7b8a92; --line-strong:#c2ccd1;
--accent-soft:#dceff1; --good-soft:#dcefe3; --warn-soft:#f6ecd7; --crit-soft:#f7e0de;
--shadow:0 1px 2px rgba(18,26,32,.06),0 8px 24px -12px rgba(18,26,32,.16);
/* dark */
--ink-faint:#6c7b84; --line-strong:#34424c;
--accent-soft:#10323a; --good-soft:#122c20; --warn-soft:#322611; --crit-soft:#331715;
--shadow:0 1px 2px rgba(0,0,0,.4),0 10px 30px -14px rgba(0,0,0,.7);
```

Pairs with a mono face (`ui-monospace`) for labels/figures + a system sans for prose.

### Evergreen — emerald on neutral zinc · fresh, confident, non-blue

| Role | Light | Dark |
|---|---|---|
| background | `#fafafa` | `#18181b` |
| surface | `#ffffff` | `#27272a` |
| surface-elevated | `#f4f4f5` | `#3f3f46` |
| border | `#e4e4e7` | `#3f3f46` |
| text-primary | `#18181b` | `#fafafa` |
| text-secondary | `#71717a` | `#a1a1aa` |
| primary | `#059669` | `#34d399` |
| primary-hover | `#047857` | `#6ee7b7` |
| accent | `#0d9488` | `#2dd4bf` |
| success | `#16a34a` | `#4ade80` |
| warning | `#d97706` | `#fbbf24` |
| error | `#dc2626` | `#f87171` |
| info | `#0891b2` | `#22d3ee` |

### Terracotta — warm clay/espresso + rust · editorial, content, writing

| Role | Light | Dark |
|---|---|---|
| background | `#faf6f2` | `#1f1714` |
| surface | `#fffdfb` | `#2a201b` |
| surface-elevated | `#f4ede6` | `#3a2d25` |
| border | `#e7ddd3` | `#3a2d25` |
| text-primary | `#2a201a` | `#f7ede4` |
| text-secondary | `#7a6a5d` | `#c0a896` |
| primary | `#c2410c` | `#fb923c` |
| primary-hover | `#9a3412` | `#fdba74` |
| accent | `#b45309` | `#fbbf24` |
| success | `#4d7c0f` | `#a3e635` |
| warning | `#ca8a04` | `#fcd34d` |
| error | `#b91c1c` | `#f87171` |
| info | `#0e7490` | `#38bdf8` |

### Bloom — pastel periwinkle/violet · friendly, playful-but-clean

| Role | Light | Dark |
|---|---|---|
| background | `#f6f5fb` | `#16141f` |
| surface | `#ffffff` | `#1f1c2b` |
| surface-elevated | `#efedf7` | `#2b2740` |
| border | `#e0dcef` | `#383350` |
| text-primary | `#3b3654` | `#ece9f7` |
| text-secondary | `#6f6a87` | `#b0aacb` |
| primary | `#6d5ef0` | `#a594ff` |
| primary-hover | `#5a4bd8` | `#c4b8ff` |
| accent | `#a855f7` | `#d8a0ff` |
| success | `#22a06b` | `#7ee0a8` |
| warning | `#d98e0b` | `#f5c97a` |
| error | `#e0356b` | `#ff7aa2` |
| info | `#2aa7d8` | `#7ad4f0` |

### Carbon ⭐ *(recommended top pick)* — deep slate-blue, dark-first · moved to [carbon.md](carbon.md) (roles, dashboard kit, triads)

### Dusk — generated from 12-step scales

Indigo primary, turquoise accent, near-neutral cool greys. Focus tools, editors, long-session apps.

Seed hues from the [Color Hunt 30-day popular feed](https://colorhunt.co/palettes/popular) (901 likes): `#321e48` · `#43637e` · `#65dcd5` · `#d9fff4`. The seed itself cannot carry an interface — it is hue material. The scales below are what make it usable.

**Generator parameters** — 12 steps, OKLCH, chroma peaked at step 9, gamut-mapped by reducing chroma (never by clamping channels).

| Scale | Hue | Peak chroma |
|---|---|---|
| neutral (light) | 272 | 0.011 |
| neutral (dark) | 262 | 0.013 |
| primary | 272 | 0.155 |
| accent | 192 | 0.125 |
| success | 158 | 0.135 |
| warning | 80 | 0.15 |
| error | 24 | 0.175 |
| info | 244 | 0.16 |

**Light scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#fdfdfd` | `#f7f7f8` | `#f0f0f1` | `#e8e8ea` | `#dfe0e2` | `#d4d5d8` | `#c6c7cb` | `#b3b4b9` | `#8c8e95` | `#808288` | `#66686e` | `#363739` |
| primary | `#fcfdff` | `#f4f7ff` | `#ebf0ff` | `#e1e8ff` | `#d5dfff` | `#c7d4ff` | `#b6c5fb` | `#9eb1f6` | `#6e85ec` | `#6479d9` | `#4e60b5` | `#2b345a` |
| accent | `#f9fefe` | `#effaf9` | `#e1f5f4` | `#d2f0ee` | `#c2e9e7` | `#afe1de` | `#98d5d2` | `#71c6c2` | `#00a3a0` | `#009592` | `#007875` | `#05403e` |

**Dark scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#111112` | `#18191a` | `#222325` | `#292a2e` | `#303236` | `#3a3c40` | `#484b50` | `#606369` | `#8a8e96` | `#9a9ea6` | `#b3b7bd` | `#e0e2e6` |
| primary | `#0e111a` | `#141828` | `#19203e` | `#1e264f` | `#232d5e` | `#2b366d` | `#374584` | `#4a5bab` | `#6e85ec` | `#7e96fc` | `#9db2ff` | `#d8e1ff` |
| accent | `#091413` | `#091d1c` | `#002928` | `#003231` | `#003b39` | `#004644` | `#005755` | `#00726f` | `#00a3a0` | `#00b5b1` | `#65cac6` | `#b9efec` |

**Roles**

| Role | Light | Dark |
|---|---|---|
| background | `#f7f7f8` | `#111112` |
| surface | `#fdfdfd` | `#18191a` |
| surface-elevated | `#f0f0f1` | `#222325` |
| border | `#d4d5d8` | `#3a3c40` |
| border-strong | `#929397` | `#62656b` |
| text-primary | `#363739` | `#e0e2e6` |
| text-secondary | `#66686e` | `#b3b7bd` |
| primary | `#5a6fd3` | `#6e85ec` |
| primary-hover | `#5063c1` | `#7e96fc` |
| link | `#4e60b5` | `#9db2ff` |
| accent | `#008482` | `#00a3a0` |
| success | `#008852` | `#2ea66e` |
| warning | `#a16c00` | `#b98300` |
| error | `#d04546` | `#e55957` |
| info | `#007ac9` | `#0096e7` |

### Driftwood — generated from 12-step scales

Deep marine primary on warm sand neutrals with a clay accent. Dark mode swings its neutrals cool.

Seed hues from the [Color Hunt 30-day popular feed](https://colorhunt.co/palettes/popular) (701 likes): `#0f3040` · `#464858` · `#a56f63` · `#d99b7f`. The seed itself cannot carry an interface — it is hue material. The scales below are what make it usable.

**Generator parameters** — 12 steps, OKLCH, chroma peaked at step 9, gamut-mapped by reducing chroma (never by clamping channels).

| Scale | Hue | Peak chroma |
|---|---|---|
| neutral (light) | 64 | 0.014 |
| neutral (dark) | 224 | 0.015 |
| primary | 228 | 0.13 |
| accent | 38 | 0.135 |
| success | 152 | 0.12 |
| warning | 70 | 0.145 |
| error | 26 | 0.165 |
| info | 228 | 0.13 |

**Light scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#fdfdfc` | `#f8f7f6` | `#f1f0ee` | `#eae8e6` | `#e2dfdd` | `#d8d5d2` | `#cbc7c3` | `#b9b3af` | `#958d86` | `#88807a` | `#6d6761` | `#393634` |
| primary | `#fafdff` | `#eff9fd` | `#e2f3fc` | `#d3edfa` | `#c3e6f7` | `#b2ddf2` | `#9bd1e9` | `#77c0e0` | `#009cca` | `#008fb9` | `#007295` | `#0e3c4e` |
| accent | `#fffcfb` | `#fff5f1` | `#ffebe5` | `#fee1d9` | `#fcd7cb` | `#f7cabc` | `#efb9a8` | `#e7a18b` | `#d26e4e` | `#c16346` | `#9f4c32` | `#512b20` |

**Dark scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#101212` | `#17191a` | `#202325` | `#272b2d` | `#2e3335` | `#373d3f` | `#454c4f` | `#5c6568` | `#859095` | `#95a0a5` | `#afb8bc` | `#dee3e5` |
| primary | `#091317` | `#0a1b23` | `#022735` | `#002f40` | `#00384b` | `#004258` | `#00536d` | `#006d8e` | `#009cca` | `#27addc` | `#6dc3e8` | `#beeaff` |
| accent | `#180f0c` | `#24140f` | `#371910` | `#451d10` | `#512213` | `#5f2a19` | `#743623` | `#974930` | `#d26e4e` | `#e37e5f` | `#f0a087` | `#ffd8cc` |

**Roles**

| Role | Light | Dark |
|---|---|---|
| background | `#f8f7f6` | `#101212` |
| surface | `#fdfdfc` | `#17191a` |
| surface-elevated | `#f1f0ee` | `#202325` |
| border | `#d8d5d2` | `#373d3f` |
| border-strong | `#97928e` | `#5e676a` |
| text-primary | `#393634` | `#dee3e5` |
| text-secondary | `#6d6761` | `#afb8bc` |
| primary | `#007eab` | `#009cca` |
| primary-hover | `#00749d` | `#27addc` |
| link | `#007295` | `#6dc3e8` |
| accent | `#bc5a3b` | `#d26e4e` |
| success | `#2e854d` | `#4ea369` |
| warning | `#ac6600` | `#c47c00` |
| error | `#cc4b46` | `#e15e57` |
| info | `#007eab` | `#009cca` |

### Meadow — generated from 12-step scales

Muted sage primary, old-gold accent, warm bone neutrals. The softest of the set; restful rather than confident.

Seed hues from the [Color Hunt 30-day popular feed](https://colorhunt.co/palettes/popular) (542 likes): `#8fa28a` · `#c7d3c0` · `#f7f4ed` · `#c8a96b`. The seed itself cannot carry an interface — it is hue material. The scales below are what make it usable.

**Generator parameters** — 12 steps, OKLCH, chroma peaked at step 9, gamut-mapped by reducing chroma (never by clamping channels).

| Scale | Hue | Peak chroma |
|---|---|---|
| neutral (light) | 110 | 0.012 |
| primary | 148 | 0.105 |
| accent | 82 | 0.115 |
| success | 148 | 0.115 |
| warning | 72 | 0.135 |
| error | 22 | 0.15 |
| info | 232 | 0.115 |

**Light scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#fdfdfc` | `#f7f7f6` | `#f0f0ef` | `#e8e9e6` | `#e0e0dd` | `#d5d6d2` | `#c8c8c4` | `#b5b5af` | `#8e8f87` | `#82837b` | `#686962` | `#373734` |
| primary | `#fbfefb` | `#f3f9f4` | `#e9f4ea` | `#ddeedf` | `#d1e7d3` | `#c3dec6` | `#b1d2b5` | `#97c19c` | `#5fa069` | `#56925f` | `#407649` | `#263e29` |
| accent | `#fefcf9` | `#fbf7ef` | `#f7efe2` | `#f2e7d3` | `#eddec4` | `#e5d3b3` | `#dbc59e` | `#cdb07d` | `#b1872e` | `#a27b27` | `#856112` | `#443416` |

**Dark scales**

| Scale | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#111111` | `#191918` | `#232321` | `#2a2b27` | `#32322f` | `#3c3c38` | `#4b4b46` | `#63635d` | `#8e8f87` | `#9e9f97` | `#b7b7b1` | `#e2e3df` |
| primary | `#0d130e` | `#121c13` | `#152818` | `#17311b` | `#1b3a20` | `#224528` | `#2d5634` | `#3d7046` | `#5fa069` | `#70b079` | `#94c59a` | `#cfebd1` |
| accent | `#15110a` | `#1f180c` | `#2d2108` | `#382702` | `#422e01` | `#4e3704` | `#60460b` | `#7e5d13` | `#b1872e` | `#c19743` | `#d3b275` | `#f3e0bd` |

**Roles**

| Role | Light | Dark |
|---|---|---|
| background | `#f7f7f6` | `#111111` |
| surface | `#fdfdfc` | `#191918` |
| surface-elevated | `#f0f0ef` | `#232321` |
| border | `#d5d6d2` | `#3c3c38` |
| border-strong | `#92928d` | `#666660` |
| text-primary | `#373734` | `#e2e3df` |
| text-secondary | `#686962` | `#b7b7b1` |
| primary | `#43844e` | `#5fa069` |
| primary-hover | `#3b7645` | `#70b079` |
| link | `#407649` | `#94c59a` |
| accent | `#986f06` | `#b1872e` |
| success | `#3d854a` | `#59a165` |
| warning | `#a76700` | `#c07e0f` |
| error | `#c55053` | `#da6364` |
| info | `#007fac` | `#329ac8` |

**Contrast watch-outs:** Terracotta `primary #c2410c` is **5.18:1** on white — it clears AA for body text; step to `#9a3412` (7.31:1) only if you want AAA. The shade to avoid as text is the lighter `#ea580c` at **3.56:1**. Bloom light `accent #a855f7` is **3.96:1** — large-text/fill only. Verify pairs in contrast.md before shipping.

---

## Triads — every color, three jobs

A palette role is not one value. Bootstrap 5.3 gives every theme color a `-bg-subtle`, a `-border-subtle` and a `-text-emphasis`; Material 3 gives every one an `on-` and a `container` with its own `on-`; Radix reaches into one scale at step 9, step 3 and step 11. Three systems, three vocabularies, one structure. Copy the rows you need.

| Token | Job | Bootstrap 5.3 | Material 3 | Radix |
|---|---|---|---|---|
| `fill` | Buttons, active chips, solid badges | `--bs-{c}` | `primary` | step 9 |
| `on-fill` | The label sitting on that fill | `color-contrast()` | `on-primary` | white or step 12 |
| `subtle` | Badge and callout backgrounds, validation field states | `--bs-{c}-bg-subtle` | `primary-container` | step 3 |
| `subtle-border` | The border around that subtle background | `--bs-{c}-border-subtle` | — | step 6 |
| `emphasis` | The label sitting on that subtle background | `--bs-{c}-text-emphasis` | `on-primary-container` | step 11 |
| `as text` | The same hue as a link directly on `surface` | — | — | step 11 |

**`fill` and `as text` are different jobs and often different values.** A hue authored to be sat on is not automatically readable as text on the same surface — Evergreen light is the case in this library where they diverge (`#059669` carries a button label at 4.70:1 but only reaches 3.77:1 as a link on white, so its link value steps to `#00875b`). Bootstrap is making the same split in v6, deliberately decoupling core theme colors from text-contrast requirements.

Every `on-fill`, `emphasis` and `as text` value below clears 4.5:1 against the ground it sits on, in both modes.

### Carbon

Moved to [carbon.md](carbon.md#triads--fill-subtle-emphasis).

### Graphite

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#2563eb` | `#ffffff` | `#dfebff` | `#b3cdfd` | `#215fe7` | `#2563eb` |
| accent | `#7c3aed` | `#ffffff` | `#eae6ff` | `#cdc2fe` | `#7c3aed` | `#7c3aed` |
| success | `#16a34a` | `#0f172a` | `#e3f3e5` | `#bce1c1` | `#007e25` | `#008930` |
| warning | `#d97706` | `#0f172a` | `#fcece1` | `#f5d2b7` | `#af5100` | `#bb5c00` |
| error | `#dc2626` | `#ffffff` | `#ffe4e1` | `#fcbeb6` | `#d2151c` | `#dc2626` |
| info | `#0284c7` | `#0f172a` | `#e1eef8` | `#b7d5ee` | `#006fb1` | `#007bbe` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#388bfd` | `#0d1117` | `#1e2e44` | `#274776` | `#4194ff` | `#388bfd` |
| accent | `#a371f7` | `#0d1117` | `#2c2a43` | `#4c3e74` | `#aa79ff` | `#a371f7` |
| success | `#3fb950` | `#0d1117` | `#1f342d` | `#2a5839` | `#3fb950` | `#3fb950` |
| warning | `#d29922` | `#0d1117` | `#333029` | `#5e4d2f` | `#d29922` | `#d29922` |
| error | `#f85149` | `#0d1117` | `#3b282b` | `#6f3635` | `#ff5b52` | `#f85149` |
| info | `#388bfd` | `#0d1117` | `#1e2e44` | `#274776` | `#4194ff` | `#388bfd` |

### Evergreen

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#059669` | `#18181b` | `#e2f0e9` | `#b9dbca` | `#007b50` | `#00875b` |
| accent | `#0d9488` | `#18181b` | `#e2f0ee` | `#badad5` | `#00796e` | `#00857a` |
| success | `#16a34a` | `#18181b` | `#e3f3e5` | `#bce1c1` | `#007e25` | `#008930` |
| warning | `#d97706` | `#18181b` | `#fcece1` | `#f5d2b7` | `#af5100` | `#bb5c00` |
| error | `#dc2626` | `#ffffff` | `#ffe4e1` | `#fcbeb6` | `#d2151c` | `#dc2626` |
| info | `#0891b2` | `#18181b` | `#e2f0f4` | `#b9d9e5` | `#007595` | `#0081a2` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#34d399` | `#18181b` | `#31433c` | `#396a56` | `#34d399` | `#34d399` |
| accent | `#2dd4bf` | `#18181b` | `#314342` | `#396a64` | `#2dd4bf` | `#2dd4bf` |
| success | `#4ade80` | `#18181b` | `#324439` | `#3e6e4e` | `#4ade80` | `#4ade80` |
| warning | `#fbbf24` | `#18181b` | `#484032` | `#786338` | `#fbbf24` | `#fbbf24` |
| error | `#f87171` | `#18181b` | `#4a3537` | `#794747` | `#ff7b7b` | `#f87171` |
| info | `#22d3ee` | `#18181b` | `#304349` | `#386a76` | `#22d3ee` | `#22d3ee` |

### Terracotta

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#c2410c` | `#fffdfb` | `#fae4db` | `#f0bfaf` | `#bc3c01` | `#c2410c` |
| accent | `#b45309` | `#fffdfb` | `#f6e5db` | `#e9c3af` | `#ac4c00` | `#b45309` |
| success | `#4d7c0f` | `#fffdfb` | `#e5ebdb` | `#c0d1af` | `#467500` | `#4d7c0f` |
| warning | `#ca8a04` | `#2a201a` | `#f8edde` | `#eed6b6` | `#9c5e00` | `#a46700` |
| error | `#b91c1c` | `#fffdfb` | `#fae0db` | `#efb7ae` | `#b91c1c` | `#b91c1c` |
| info | `#0e7490` | `#fffdfb` | `#e0e9ec` | `#b4cdd6` | `#05708c` | `#0e7490` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#fb923c` | `#1f1714` | `#4b3323` | `#7b4d2d` | `#fb923c` | `#fb923c` |
| accent | `#fbbf24` | `#1f1714` | `#4b3923` | `#7a5e2a` | `#fbbf24` | `#fbbf24` |
| success | `#a3e635` | `#1f1714` | `#3f3f25` | `#5c6c2e` | `#a3e635` | `#a3e635` |
| warning | `#fcd34d` | `#1f1714` | `#4b3c26` | `#7a6534` | `#fcd34d` | `#fcd34d` |
| error | `#f87171` | `#1f1714` | `#4b2e29` | `#7a413d` | `#fb7473` | `#f87171` |
| info | `#38bdf8` | `#1f1714` | `#343a3e` | `#3d5e70` | `#38bdf8` | `#38bdf8` |

### Bloom

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#6d5ef0` | `#ffffff` | `#e8eaff` | `#c8cbfe` | `#6452e3` | `#6d5ef0` |
| accent | `#a855f7` | `#ffffff` | `#f2e9ff` | `#e0c9ff` | `#923bde` | `#9e4aec` |
| success | `#22a06b` | `#3b3654` | `#e4f2e9` | `#bddfcb` | `#007d4b` | `#008855` |
| warning | `#d98e0b` | `#3b3654` | `#fbefe3` | `#f4d9ba` | `#a35c00` | `#ad6500` |
| error | `#e0356b` | `#ffffff` | `#ffe5e9` | `#fdc0ca` | `#cc1b5b` | `#dc3068` |
| info | `#2aa7d8` | `#3b3654` | `#e5f3fa` | `#c0e2f3` | `#0075a4` | `#007fae` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#a594ff` | `#16141f` | `#342f4c` | `#534b7d` | `#a594ff` | `#a594ff` |
| accent | `#d8a0ff` | `#16141f` | `#3c314c` | `#664f7c` | `#d8a0ff` | `#d8a0ff` |
| success | `#7ee0a8` | `#16141f` | `#303b40` | `#47675d` | `#7ee0a8` | `#7ee0a8` |
| warning | `#f5c97a` | `#16141f` | `#40383b` | `#705f4f` | `#f5c97a` | `#f5c97a` |
| error | `#ff7aa2` | `#16141f` | `#432c3f` | `#76435a` | `#ff7aa2` | `#ff7aa2` |
| info | `#7ad4f0` | `#16141f` | `#30394a` | `#466277` | `#7ad4f0` | `#7ad4f0` |

### Teal Slate

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#0c6d78` | `#ffffff` | `#dfeaeb` | `#b3cccf` | `#0c6d78` | `#0c6d78` |
| accent | `#a96811` | `#ffffff` | `#f4e9e0` | `#e3cbb4` | `#9b5b00` | `#a8670f` |
| success | `#2f7d52` | `#ffffff` | `#e2ece5` | `#b9d2c1` | `#28774c` | `#2f7d52` |
| warning | `#a96811` | `#ffffff` | `#f4e9e0` | `#e3cbb4` | `#9b5b00` | `#a8670f` |
| error | `#bd3831` | `#ffffff` | `#f9e4e1` | `#efbeb7` | `#bd3831` | `#bd3831` |
| info | `#0c6d78` | `#ffffff` | `#dfeaeb` | `#b3cccf` | `#0c6d78` | `#0c6d78` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#3fb6c4` | `#0b1015` | `#1c323b` | `#285660` | `#3fb6c4` | `#3fb6c4` |
| accent | `#dca23f` | `#0b1015` | `#32302b` | `#5f5035` | `#dca23f` | `#dca23f` |
| success | `#4cbe80` | `#0b1015` | `#1d3431` | `#2b5948` | `#4cbe80` | `#4cbe80` |
| warning | `#dca23f` | `#0b1015` | `#32302b` | `#5f5035` | `#dca23f` | `#dca23f` |
| error | `#ef6b62` | `#0b1015` | `#36292d` | `#683d3d` | `#ef6b62` | `#ef6b62` |
| info | `#3fb6c4` | `#0b1015` | `#1c323b` | `#285660` | `#3fb6c4` | `#3fb6c4` |

### Dusk

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#5a6fd3` | `#ffffff` | `#ebf0ff` | `#c7d4ff` | `#4e60b5` | `#4e60b5` |
| accent | `#008482` | `#ffffff` | `#e1f5f4` | `#afe1de` | `#007875` | `#007875` |
| success | `#008852` | `#ffffff` | `#e4f5ea` | `#b8e1c8` | `#0c7c4d` | `#0c7c4d` |
| warning | `#a16c00` | `#ffffff` | `#f9efdd` | `#ebd2a8` | `#886000` | `#886000` |
| error | `#d04546` | `#ffffff` | `#ffebe9` | `#ffc5c0` | `#af3a3a` | `#af3a3a` |
| info | `#007ac9` | `#ffffff` | `#e4f2ff` | `#b1dbfe` | `#006eab` | `#006eab` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#6e85ec` | `#0e111a` | `#19203e` | `#2b366d` | `#9db2ff` | `#9db2ff` |
| accent | `#00a3a0` | `#091413` | `#002928` | `#004644` | `#65cac6` | `#65cac6` |
| success | `#2ea66e` | `#0b140e` | `#082a19` | `#01482b` | `#7bcb9e` | `#7bcb9e` |
| warning | `#b98300` | `#161007` | `#301f00` | `#503700` | `#ddae5c` | `#ddae5c` |
| error | `#e55957` | `#1a0d0c` | `#3d1413` | `#691e1e` | `#ff948e` | `#ff948e` |
| info | `#0096e7` | `#09121a` | `#03253d` | `#003f66` | `#6ebfff` | `#6ebfff` |

### Driftwood

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#007eab` | `#ffffff` | `#e2f3fc` | `#b2ddf2` | `#007295` | `#007295` |
| accent | `#bc5a3b` | `#ffffff` | `#ffebe5` | `#f7cabc` | `#9f4c32` | `#9f4c32` |
| success | `#2e854d` | `#ffffff` | `#e7f4ea` | `#bedfc6` | `#317949` | `#317949` |
| warning | `#ac6600` | `#ffffff` | `#fbeedf` | `#efcfac` | `#905a00` | `#905a00` |
| error | `#cc4b46` | `#ffffff` | `#ffebe8` | `#ffc5bf` | `#ab3f3a` | `#ab3f3a` |
| info | `#007eab` | `#ffffff` | `#e2f3fc` | `#b2ddf2` | `#007295` | `#007295` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#009cca` | `#091317` | `#022735` | `#004258` | `#6dc3e8` | `#6dc3e8` |
| accent | `#d26e4e` | `#180f0c` | `#371910` | `#5f2a19` | `#f0a087` | `#f0a087` |
| success | `#4ea369` | `#0c130e` | `#102918` | `#184628` | `#8ac89a` | `#8ac89a` |
| warning | `#c47c00` | `#171008` | `#331d01` | `#553300` | `#e4aa65` | `#e4aa65` |
| error | `#e15e57` | `#1a0e0c` | `#3b1513` | `#66211e` | `#fd968c` | `#fd968c` |
| info | `#009cca` | `#091317` | `#022735` | `#004258` | `#6dc3e8` | `#6dc3e8` |

### Meadow

**Light**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#43844e` | `#ffffff` | `#e9f4ea` | `#c3dec6` | `#407649` | `#407649` |
| accent | `#986f06` | `#ffffff` | `#f7efe2` | `#e5d3b3` | `#856112` | `#856112` |
| success | `#3d854a` | `#ffffff` | `#e8f4e9` | `#c2dfc4` | `#3b7846` | `#3b7846` |
| warning | `#a76700` | `#ffffff` | `#faeee0` | `#edd0ae` | `#8f5c00` | `#8f5c00` |
| error | `#c55053` | `#ffffff` | `#ffebe9` | `#fcc6c3` | `#a64345` | `#a64345` |
| info | `#007fac` | `#ffffff` | `#e4f3fb` | `#b7dcf0` | `#137197` | `#137197` |

**Dark**

| Color | fill | on-fill | subtle | subtle-border | emphasis | as text |
|---|---|---|---|---|---|---|
| primary | `#5fa069` | `#0d130e` | `#152818` | `#224528` | `#94c59a` | `#94c59a` |
| accent | `#b1872e` | `#15110a` | `#2d2108` | `#4e3704` | `#d3b275` | `#d3b275` |
| success | `#59a165` | `#0d130e` | `#142817` | `#1f4626` | `#90c797` | `#90c797` |
| warning | `#c07e0f` | `#161009` | `#311e03` | `#543400` | `#e0ac6b` | `#e0ac6b` |
| error | `#da6364` | `#190e0d` | `#391716` | `#632425` | `#f79996` | `#f79996` |
| info | `#329ac8` | `#0b1317` | `#092634` | `#04425a` | `#7bc1e5` | `#7bc1e5` |

---

## Marketing / Landing

Each ships a hero gradient plus roles. Use gradient as a hero background with light text.

### Sunbloom — refined coral/amber · approachable consumer/creator

| Role | Light | Dark |
|---|---|---|
| background | `#fff8f3` | `#1e1512` |
| surface | `#fff1e8` | `#2c1e18` |
| text-primary | `#3a2218` | `#ffeede` |
| text-secondary | `#8a5a44` | `#e0a888` |
| primary | `#e8553d` | `#ff7a5c` |
| accent | `#f59e0b` | `#fbbf24` |
| success | `#16a34a` | `#22c55e` |
| warning | `#d97706` | `#fbbf24` |
| error | `#dc2626` | `#f87171` |
| gradient | `#f97048` → `#f99a4b` → `#ffcf8a` | `#f97048` → `#ffcf8a` |

### Tidewater — teal/sage · fintech, wellness, B2B trust

| Role | Light | Dark |
|---|---|---|
| background | `#f7faf9` | `#0a1a18` |
| surface | `#e6f2ef` | `#13302c` |
| text-primary | `#0f2e2a` | `#d5f0ea` |
| text-secondary | `#3f6b63` | `#7fbdb2` |
| primary | `#0d9488` | `#2dd4bf` |
| accent | `#9caf88` | `#a3c293` |
| success | `#059669` | `#10b981` |
| warning | `#d97706` | `#fbbf24` |
| error | `#dc2626` | `#f87171` |
| gradient | `#0d9488` → `#14b8a6` → `#5eead4` | `#14b8a6` → `#6ee7b7` |

### Obsidian & Gold — near-black + gold · premium, luxury, agency (dark-led)

| Role | Dark (primary) | Light (companion) |
|---|---|---|
| background | `#0a0a0a` | `#faf8f3` |
| surface | `#16140f` | `#f1ece0` |
| text-primary | `#f4eade` | `#1a1814` |
| text-secondary | `#bfb6a3` | `#6b6452` |
| primary | `#c69b3c` | `#9a7726` |
| accent | `#22d3ee` | `#0e7490` |
| success | `#34d399` | `#059669` |
| warning | `#fbbf24` | `#b45309` |
| error | `#f87171` | `#b91c1c` |
| gradient | `#e8c56a` → `#c69b3c` → `#8a6a1f` | `#c69b3c` → `#9a7726` |

Gold `#c69b3c` is 7.69:1 on near-black — readable as text (the rare metallic that is).

### Paper & Ink — warm paper + ink + terracotta accent · blogs, long-form, portfolios

| Role | Light | Dark |
|---|---|---|
| background | `#faf8f3` | `#14110d` |
| surface | `#ffffff` | `#1e1a15` |
| text-primary | `#1a1a1a` | `#f2ede4` |
| text-secondary | `#5c574e` | `#a8a092` |
| primary | `#c2410c` | `#fb7c4a` |
| accent | `#1a1a1a` | `#f2ede4` |
| success | `#15803d` | `#34d399` |
| warning | `#b45309` | `#fbbf24` |
| error | `#b91c1c` | `#f87171` |
| gradient | `#c2410c` → `#ea580c` | `#fb7c4a` → `#f59e0b` |

Hairline/divider tone: `#c9c4b8` (light).

---

## Data Viz

### Categorical (distinct, unordered series) — cap at ~8 colors before distinguishability drops; aggregate the rest into "Other".

**Hearthstead** — warm hearth/autumn
`#B85C38` Terracotta · `#D8A23A` Honey Gold · `#7C8B52` Olive Sage · `#8E5A7A` Dusty Plum · `#C87941` Burnt Apricot · `#5F7A6B` Eucalyptus · `#A4473F` Brick Red · `#8B6F47` Walnut · `#6E5A8A` Heather · `#D07C7C` Dusty Rose · `#4F6F73` Slate Teal · `#6F4E37` Cocoa

**Vintage Warm** — aged book / antique
`#A95B44` Clay Ember · `#C99A46` Amber Wheat · `#6F8452` Moss Olive · `#7F617C` Mulberry Smoke · `#B8714C` Cinnamon · `#6E8C73` Pine Mist · `#944B3E` Russet · `#B98E5C` Caramel Bark · `#6A6288` Dusky Iris · `#C48686` Rosewood Blush · `#587378` Storm Teal · `#72513D` Chestnut

**Glass Wall** — fog / coastline / glass (cool)
`#5D7A8A` Fjord Blue · `#5F8B8C` Mist Teal · `#7A9587` Sage Frost · `#6A7196` Slate Indigo · `#7FB3B0` Sea Glass · `#7A93B2` Dusty Blue · `#4F6B73` Pine Blue · `#8A90B8` Periwinkle Smoke · `#8DB4A2` Cool Mint · `#5A97A0` Glacier Teal · `#617487` Blue Steel · `#9C9EC3` Lavender Mist

**Lunar Valley** *(signature)* — warm cottage/CRT core + cool lunar edge + hologram accent
`#C2623A` Clay Hearth · `#E8A93C` Amber CRT · `#8C9D55` Cottage Sage · `#557C56` Pine Cellar · `#C0533F` Aged Paper Rust · `#976986` Dusk Mulberry · `#3E8A8B` Spare-Cycle Teal · `#5E87B2` Glass-Wall Blue · `#A89F8E` Lunar Dust · `#677183` Tether Slate · `#5BC6C2` Hologram Cyan · `#7E5840` Walnut Console

**Okabe-Ito** *(colorblind-safe alternate, use when CVD-accessibility is required)*
`#000000` · `#E69F00` · `#56B4E9` · `#009E73` · `#F0E442` · `#0072B2` · `#D55E00` · `#CC79A7`

### Sequential (ordered low→high) — perceptually uniform & colorblind-safe

| Name | Stops (low → high) |
|---|---|
| Viridis | `#440154` `#423f85` `#31668e` `#21908d` `#25ac82` `#90d743` `#fde725` |
| Magma | `#000004` `#1c1044` `#4f127b` `#812581` `#b5367a` `#e55064` `#fb8761` `#fec287` `#fcfdbf` |
| Inferno | `#000004` `#1f0c48` `#550f6d` `#88226a` `#ba3655` `#e35933` `#f9950a` `#f8c932` `#fcffa4` |
| Plasma | `#0d0887` `#41049d` `#6a00a8` `#8f0da4` `#b12a90` `#cc4778` `#e16462` `#f2844b` `#fca636` `#fcce25` `#f0f921` |
| Blues | `#eff3ff` `#c6dbef` `#9ecae1` `#6baed6` `#4292c6` `#2171b5` `#084594` |
| YlOrRd | `#ffffb2` `#fed976` `#feb24c` `#fd8d3c` `#fc4e2a` `#e31a1c` `#b10026` |

**Never use rainbow/jet** — non-uniform luminance fabricates false boundaries in the data.

### Diverging (meaningful midpoint) — 11 stops, −5 … 0 … +5, neutral center. All warm↔cool (no red↔green).

| Name | −5 | −4 | −3 | −2 | −1 | 0 | +1 | +2 | +3 | +4 | +5 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Alien Sun (clay↔teal) | `#8F3F35` | `#B25C49` | `#D18467` | `#E8B49B` | `#F3D9CA` | `#F4F1EA` | `#D5E5E0` | `#9FC7C0` | `#6FA5A0` | `#438286` | `#2E626D` |
| Orchard Dusk (plum↔olive) | `#71435E` | `#965B78` | `#BD8098` | `#D8B0C0` | `#EBD7DF` | `#F2F0EC` | `#DCE6CB` | `#B6CF98` | `#8BAD65` | `#6F8845` | `#516B35` |
| Coffee & Coolant (amber↔blue) | `#9B5D24` | `#BD7B32` | `#D99E54` | `#EBC585` | `#F4DFC0` | `#F2F1EE` | `#D4E1EA` | `#A9C3D5` | `#7FA4BF` | `#5B829E` | `#3F637D` |
| Console & Window *(signature)* (amber-CRT↔glass-wall) | `#AE4F2C` | `#CC6F3A` | `#E89A53` | `#F4C488` | `#F9E1C0` | `#F4F0E7` | `#C9E0E9` | `#97C6D8` | `#5C9DC0` | `#3878A4` | `#1F5A88` |

---

## Terminal / TUI

ANSI slot order: `0` black, `1` red, `2` green, `3` yellow, `4` blue, `5` magenta, `6` cyan, `7` white, `8–15` = bright variants. Bind **meaning to slots 1–6**, not hex, so the user's terminal theme renders it. Slot 8 (bright-black) is de-emphasis only — never load-bearing text.

### Solarized Dark
`0 #073642` `1 #dc322f` `2 #859900` `3 #b58900` `4 #268bd2` `5 #d33682` `6 #2aa198` `7 #eee8d5` `8 #002b36` `9 #cb4b16` `10 #586e75` `11 #657b83` `12 #839496` `13 #6c71c4` `14 #93a1a1` `15 #fdf6e3`
bg `#002b36` · fg `#839496` · cursor `#93a1a1` · selection `#073642`

### Nord
`0 #3b4252` `1 #bf616a` `2 #a3be8c` `3 #ebcb8b` `4 #81a1c1` `5 #b48ead` `6 #88c0d0` `7 #e5e9f0` `8 #4c566a` `9 #bf616a` `10 #a3be8c` `11 #ebcb8b` `12 #81a1c1` `13 #b48ead` `14 #8fbcbb` `15 #eceff4`
bg `#2e3440` · fg `#d8dee9` · cursor `#d8dee9` · selection `#434c5e`

### Catppuccin Mocha (dark)
`0 #45475a` `1 #f38ba8` `2 #a6e3a1` `3 #f9e2af` `4 #89b4fa` `5 #f5c2e7` `6 #94e2d5` `7 #bac2de` `8 #585b70` `9 #f38ba8` `10 #a6e3a1` `11 #f9e2af` `12 #89b4fa` `13 #f5c2e7` `14 #94e2d5` `15 #a6adc8`
bg `#1e1e2e` · fg `#cdd6f4` · cursor `#f5e0dc` · selection `#585b70`

### Catppuccin Latte (light)
`0 #bcc0cc` `1 #d20f39` `2 #40a02b` `3 #df8e1d` `4 #1e66f5` `5 #ea76cb` `6 #179299` `7 #5c5f77` `8 #acb0be` `9 #d20f39` `10 #40a02b` `11 #df8e1d` `12 #1e66f5` `13 #ea76cb` `14 #179299` `15 #6c6f85`
bg `#eff1f5` · fg `#4c4f69` · cursor `#dc8a78` · selection `#acb0be`

### Dracula
`0 #21222c` `1 #ff5555` `2 #50fa7b` `3 #f1fa8c` `4 #bd93f9` `5 #ff79c6` `6 #8be9fd` `7 #f8f8f2` `8 #6272a4` `9 #ff6e6e` `10 #69ff94` `11 #ffffa5` `12 #d6acff` `13 #ff92df` `14 #a4ffff` `15 #ffffff`
bg `#282a36` · fg `#f8f8f2` · cursor `#f8f8f2` · selection `#44475a`
*(Dracula defines genuinely distinct bright variants — safe for bold+color emphasis.)*

### Tokyo Night
`0 #363b54` `1 #f7768e` `2 #73daca` `3 #e0af68` `4 #7aa2f7` `5 #bb9af7` `6 #7dcfff` `7 #787c99` `8 #363b54` `9 #f7768e` `10 #73daca` `11 #e0af68` `12 #7aa2f7` `13 #bb9af7` `14 #7dcfff` `15 #acb0d0`
bg `#1a1b26` · fg `#c0caf5` · cursor `#c0caf5` · selection `#283457`

---

## Sources

- Web-UI neutrals/brands: Tailwind, Radix Colors, GitHub Primer conventions.
- Triad structure: [Bootstrap 5.3 color](https://getbootstrap.com/docs/5.3/customize/color/) (`-bg-subtle` / `-border-subtle` / `-text-emphasis`), [Material 3 color roles](https://developer.android.com/develop/ui/compose/designsystems/material3) (`on-` / `container`), [Radix scale semantics](https://www.radix-ui.com/colors/docs/palette-composition/understanding-the-scale) (steps 9 / 3 / 6 / 11). Bootstrap's v6 plan to decouple theme colors from text contrast: [twbs discussion #37937](https://github.com/orgs/twbs/discussions/37937).
- Dusk / Driftwood / Meadow: generated for this library. Seed hues from the [Color Hunt 30-day popular feed](https://colorhunt.co/palettes/popular); scales built with the OKLCH recipe in build-your-own.md and solved against WCAG targets.
- Data-viz sequential: matplotlib (viridis family), ColorBrewer (Blues, YlOrRd). Okabe-Ito: Color Universal Design.
- TUI: official theme repos — ethanschoonover.com/solarized, nordtheme.com, catppuccin.com, draculatheme.com, enkia/tokyo-night.
- Hearthstead/Vintage Warm/Glass Wall categorical and the diverging ramps: curated for this library; Lunar Valley & Console & Window are originals tuned to a warm-cozy-with-cool-edge aesthetic.

# Palette Library — full hex tables

Every palette below maps to semantic roles (UI) or ordered color lists (data viz) or ANSI slots (TUI). Copy the table you need. All values are verified from the source noted, or hand-tuned for this library.

---

## Web App UI (light + dark)

13 roles each. In dark mode, `surface-elevated` is intentionally lighter than `surface` (elevation = lighter).

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

### Carbon ⭐ *(recommended top pick)* — deep slate-blue, dark-first · analytics dashboards, perf reports, dev tooling

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

**Dashboard kit (dark):** the report-tested extras that make Carbon a dashboard palette, not just a theme.

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

**Contrast watch-outs:** Terracotta `primary #c2410c` ≈ 3.4:1 on white — use as a fill or step to `#9a3412` for text. Bloom light `accent #a855f7` is large-text/fill only. Verify pairs in contrast.md before shipping.

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

Gold `#c69b3c` ≈ 7.9:1 on near-black — readable as text (the rare metallic that is).

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
- Data-viz sequential: matplotlib (viridis family), ColorBrewer (Blues, YlOrRd). Okabe-Ito: Color Universal Design.
- TUI: official theme repos — ethanschoonover.com/solarized, nordtheme.com, catppuccin.com, draculatheme.com, enkia/tokyo-night.
- Hearthstead/Vintage Warm/Glass Wall categorical and the diverging ramps: curated for this library; Lunar Valley & Console & Window are originals tuned to a warm-cozy-with-cool-edge aesthetic.

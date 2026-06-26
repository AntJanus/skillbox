# Readability & accessibility

Load this when verifying type is actually readable, or sizing fluid/responsive type. The #1 job: stop tiny, thin, low-contrast, cramped text.

## Minimum sizes

| Text role | Recommend | Hard floor | Why |
|---|---|---|---|
| Body (desktop & mobile) | **16px / 1rem** | 14px | Browser default; people read screens at arm's length |
| Form inputs (mobile) | **16px** | 16px | iOS Safari auto-zooms a focused input whose text < 16px |
| Captions / labels / legal | 14px | **12px** | Below ~12px legibility collapses |
| Large text (unlocks 3:1 AA) | ≥24px or ≥18.66px bold | — | WCAG "large text" definition (18pt / 14pt bold) |

- **Size in `rem`, not px.** `rem` tracks the user's browser font-size setting and zoom; hardcoding `html{font-size:14px}` or px body silently overrides their accessibility choice.
- The iOS input-zoom fix is **≥16px text**, never `user-scalable=no` / `maximum-scale=1` (those disable pinch-zoom and violate WCAG). ([CSS-Tricks](https://css-tricks.com/16px-or-larger-text-prevents-ios-form-zoom/))
- Conversion: `1pt = 1.333px` → 14pt = 18.66px, 18pt = 24px.

## WCAG 2 AA — the compliance gate

| | Normal text | Large text (≥24px / ≥18.66px bold) |
|---|---|---|
| **AA (1.4.3)** | **4.5:1** | **3:1** |
| **AAA (1.4.6)** | 7:1 | 4.5:1 |

- Compute the ratio, don't round (4.499:1 fails 4.5:1). Formula: `(L1+0.05)/(L2+0.05)`.
- **1.4.4 Resize text:** must scale to 200% without loss — so don't cap fluid `max` too low and don't size in non-scaling `vw`.
- **1.4.12 Text spacing:** layout must survive user overrides of LH 1.5×, paragraph 2×, letter 0.12em, word 0.16em — no clipping/overlap. Set body `line-height: 1.5` and avoid fixed-height text boxes.
- **1.4.8 Visual presentation (AAA):** line width ≤ 80 chars, line spacing ≥ 1.5, not fully justified.

Sources: [W3C 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) · [1.4.4](https://www.w3.org/WAI/WCAG21/Understanding/resize-text.html) · [1.4.12](https://www.w3.org/WAI/WCAG21/Understanding/text-spacing.html) · [1.4.8](https://www.w3.org/WAI/WCAG21/Understanding/visual-presentation.html)

## APCA — the readability gate (catches what WCAG2 misses)

WCAG 2's fixed ratio ignores font **weight and size** and overstates contrast for near-black colors. APCA (the WCAG 3 draft model) conditions the required contrast (Lc) on size and weight — smaller/thinner text needs *more* contrast.

| Lc | Use | Min font |
|---|---|---|
| 90 | preferred fluent body | 14px+/400 |
| 75 | minimum body text | 18px+/400 |
| 60 | other content | 24px/400 or 16px/700 |
| 45 | headlines, large/bold | 36px/400 or 24px/700 |
| 30 | placeholder/disabled only | — (not for real content) |

APCA is **draft / non-normative** — use it as a readability heuristic *on top of* WCAG2 AA compliance, especially for **dark mode and thin fonts** where WCAG2 lies. ([APCA easy intro](https://git.apcacontrast.com/documentation/APCAeasyIntro) · [Why APCA](https://git.apcacontrast.com/documentation/WhyAPCA))

## Weight × size × contrast

The dimension WCAG2 can't see. **Body weight ≥ 400** always; never 100–300 on body or small text (thin strokes drop perceived contrast). Reserve 300 for large display only, with high contrast. **Never combine small + thin + low-contrast** — any two is risky, all three is the canonical unreadable panel.

## Fluid type with clamp()

`clamp(MIN, PREFERRED, MAX)`. The trap: browsers **don't scale `vw` on zoom**, so `vw`-only sizing fails 1.4.4. Safe pattern:

1. MIN and MAX in **`rem`** (both bounds honor zoom).
2. PREFERRED mixes a `rem` term + a `vw` term: `calc(rem + vw)`.
3. MAX ≤ ~2.5× MIN (and ≥ 2× MIN) so text can still double.
4. Body MIN ≥ 1rem.

```css
body     { font-size: clamp(1rem, 0.95rem + 0.25vw, 1.25rem); line-height: 1.5; }
h1       { font-size: clamp(1.75rem, 1.1rem + 3.2vw, 3rem); line-height: 1.1; }
.caption { font-size: clamp(0.875rem, 0.85rem + 0.1vw, 1rem); } /* floor at 14px */
```

([Smashing — Accessible fluid type](https://www.smashingmagazine.com/2023/11/addressing-accessibility-concerns-fluid-type/) · [MDN clamp()](https://developer.mozilla.org/en-US/docs/Web/CSS/clamp))

## Common AI-generated failures → fix

| Failure | Why wrong | Fix |
|---|---|---|
| `color:#999` body on white | ≈2.85:1, fails AA | `#595959` or darker (≈7:1) |
| 12–13px body | below floor, iOS input zoom | body ≥16px/1rem; inputs ≥16px |
| `font-weight:300` body | thin stroke, low perceived contrast | ≥400; 300 for large display only |
| `#bbb`/`#ccc` placeholder/caption | often <3:1 | meaningful muted text ≥4.5:1 |
| h1 48px + body 13px | inverted hierarchy | set body first (≥16px), scale headings |
| text over image, no scrim | per-pixel contrast varies | overlay/`text-shadow`; check worst case |
| `font-size:4vw` | no zoom scaling, fails 1.4.4 | `clamp(rem, calc(rem+vw), rem)` |
| `html{font-size:14px}` | overrides user setting | keep root default; size in `rem` |
| `line-height:1.2` body | cramped, fails 1.4.12 | body `line-height:1.5` |
| `user-scalable=no` | disables zoom | remove; fix with ≥16px |

## Readability floor — quick check

Body ≥ **16px/1rem** · weight ≥ **400** · contrast ≥ **4.5:1** (large ≥3:1) · line-height ≥ **1.5** · measure ≤ **~66–80ch** · inputs ≥ **16px** · sizes in **rem**, fluid via **clamp() with rem bounds** · no `user-scalable=no`. Re-check dark mode with **APCA**. Meet these and most "impossible to read" output disappears.

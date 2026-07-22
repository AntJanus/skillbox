# App chrome, identity & shared shells — deep reference

Load when scaffolding a new app's shell, wiring theming, or building the screens. This file exists because everything in it is what makes a family of apps *look* related — and it is exactly the layer a fresh build reinvents when the blueprint only specifies architecture. Copy these implementations rather than re-deriving them.

Pairs with **color-system** (the actual palette values) and **typography** (the type decisions). This file specifies the *structure*; those skills choose the *values*.

## The shell

One `'use client'` chrome wraps every route. Dashboard layout, never single-column.

The chrome is `'use client'`, so the server-read `colorScheme` is threaded in as a prop from the root layout — that thread is the whole mechanism, not an incidental detail.

```tsx
// components/AppShellChrome.tsx — 'use client'
// props: { colorScheme: "light" | "dark", children }
<AppShell
  layout="alt"                                   // sidebar spans full height, header sits beside it
  header={{ height: 64 }}
  navbar={{
    width: collapsed ? 72 : 264,
    breakpoint: "sm",
    collapsed: { mobile: !drawerOpen },
  }}
>
  <AppShell.Header>
    <Group h="100%" px="md" justify="space-between">
      <Group gap="sm">
        <Burger opened={drawerOpen} onClick={toggleDrawer} hiddenFrom="sm" size="sm" />
        <Logo />
      </Group>
      <Group gap="xs">
        <ColorSchemeToggle scheme={colorScheme} />
      </Group>
    </Group>
  </AppShell.Header>

  <AppShell.Navbar p="xs">
    <NavLinks collapsed={collapsed} />
    <CollapseButton onClick={toggleCollapsed} mt="auto" />
  </AppShell.Navbar>

  <AppShell.Main>{children}</AppShell.Main>
</AppShell>
```

- **`layout="alt"`** is the load-bearing prop — it puts the sidebar full-height against the viewport edge with the header beside it, rather than a header spanning the top. This single prop is most of the silhouette.
- **264px expanded ↔ 72px collapsed.** Collapsed shows icons only, with the label as a `Tooltip`. Persist the collapsed flag to `localStorage` under `"<app>-sidebar-collapsed"` — this is ephemeral view state, unlike theme (below), so client storage is correct here.
- **Nav links** use the current pathname for active state, not click handlers.
- **Mobile is a drawer**, opened by the `Burger`. Anything that renders into the navbar slot is invisible on mobile until the drawer opens — see the batch-bar caveat in `UI.md`.
- **A collapsed rail cannot hold wide controls.** Any mode that renders controls into the navbar (bulk selection) must force the shell back to full width while it lasts.

## Logo

A custom SVG glyph beside a two-weight wordmark. The weight split is the whole trick: a quiet shared part and a bold distinctive part read as one mark while letting a family of apps differ only in the second word.

```tsx
// components/Logo.tsx
export function Logo() {
  return (
    <Group gap={8} wrap="nowrap">
      <AppGlyph width={26} height={26} />        {/* one custom SVG per app */}
      <Text
        component="span"
        ff="var(--font-display)"
        fz="1.42rem"
        lh={1}
        style={{ letterSpacing: "-0.03em" }}
      >
        <Text component="span" inherit fw={400}>Prefix</Text>
        <Text component="span" inherit fw={700} c="var(--mantine-primary-color-filled)">Name</Text>
      </Text>
    </Group>
  );
}
```

- **Glyph:** one hand-made SVG per app, sized to the cap height of the wordmark. It should say what the app is about in a single shape.
- **Wordmark:** shared/quiet segment at `fw 400`, distinctive segment at `fw 700` in the primary filled color. No space between the two `<Text>` spans — they're one word visually.
- **Always the display face**, 1.42rem, `letterSpacing: -0.03em`. Tight tracking is what stops a two-weight wordmark reading as two separate words.

## Icons

**`@tabler/icons-react`**, everywhere, no exceptions. Pin one icon library and use it for nav, actions, empty states, and toggles alike. A mixed icon set (or none) is immediately visible as inconsistency, and Tabler's coverage means you never have to reach outside it.

## Theming — server-persisted, two axes

Every app ships **4–7 named themes** *and* a light/dark axis. Both persist **server-side in the settings table**, not `localStorage`. That choice buys a flash-free first paint by construction — the correct attributes are in the server-rendered HTML, so there is no pre-paint script to get right and no hydration mismatch to chase.

```ts
// settings table — the existing key/value store, no new table
//   key          | value
//   -------------+---------
//   theme        | forest
//   colorScheme  | dark
```

```tsx
// app/layout.tsx — server component
export const dynamic = "force-dynamic";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  // Narrow the stored strings before indexing — the settings table is not typed,
  // and `noUncheckedIndexedAccess` would otherwise hand THEMES[...] an undefined.
  const theme = asThemeName(getSetting("theme"));           // falls back to "default", logs on unknown
  const colorScheme = asColorScheme(getSetting("colorScheme"));

  return (
    <html
      lang="en"
      className={`${bodyFont.variable} ${displayFont.variable} ${monoFont.variable}`}
      data-theme={theme}
      data-mantine-color-scheme={colorScheme}
    >
      <body>
        <MantineProvider theme={THEMES[theme]} forceColorScheme={colorScheme}>
          <Notifications />
          <AppShellChrome colorScheme={colorScheme}>{children}</AppShellChrome>
        </MantineProvider>
      </body>
    </html>
  );
}
```

- **`THEMES`** is a record of `createTheme()` results sharing one `base` (fonts, type scale, radius, spacing) and differing only in brand color scale, dark neutral tuple, and chart `Palette`. Define it once in `lib/theme.ts`.
- **Narrow the stored key before indexing.** `getSetting()` returns an untyped string from the settings table; a renamed or hand-edited theme makes `THEMES[value]` `undefined`, which renders an unthemed app rather than failing loudly — the silent fallback the skill forbids. Guard it once:

```ts
// lib/theme.ts
export const asThemeName = (value: string | null): ThemeName =>
  value && value in THEMES ? (value as ThemeName) : "default";

export const asColorScheme = (value: string | null): "light" | "dark" =>
  value === "dark" ? "dark" : "light";
```
- **`data-theme` on `<html>`** drives per-theme CSS variables in `globals.css`; `forceColorScheme` makes Mantine honor the stored value rather than consulting the OS.
- **The font `.variable` classes go on `<html>`, not `<body>`** — see the `:root` trap in `UI.md`. This is the single most common silent failure in this stack.
- **Both switchers live on the Settings screen** — except the color-scheme toggle, which also gets a header slot. Both call a server action that writes the setting and `revalidatePath("/", "layout")`.

```tsx
// components/ColorSchemeToggle.tsx — 'use client'
export function ColorSchemeToggle({ scheme }: { scheme: "light" | "dark" }) {
  const [pending, startTransition] = useTransition();
  const next = scheme === "dark" ? "light" : "dark";

  return (
    <ActionIcon
      variant="subtle"
      aria-label={`Switch to ${next} mode`}
      loading={pending}
      onClick={() => startTransition(() => setColorScheme(next))}
    >
      {scheme === "dark" ? <IconSun size={18} /> : <IconMoon size={18} />}
    </ActionIcon>
  );
}
```

**Render one icon, never both.** Because the scheme is known on the server, the toggle picks its icon directly. Do **not** render both icons and hide one with Mantine's `lightHidden`/`darkHidden` — that pattern is a live bug waiting to happen (see Gotchas below), and server-side scheme makes it unnecessary.

## Type scale & theme base

The readability floor is the rule; these values are a known-good implementation of it.

**The floor (must hold, whatever values you choose):** smallest token ≥ `1rem`/16px · line-height ≥ 1.5 · weight ≥ 400 · contrast ≥ 4.5:1.

```ts
// lib/theme.ts — the shared base every named theme spreads
export const base = {
  fontFamily: "var(--font-body)",
  fontFamilyMonospace: "var(--font-mono)",
  headings: { fontFamily: "var(--font-display)" },

  // ~25% above Mantine's defaults; xs sits ON the floor, never under it
  fontSizes: {
    xs: "1rem",       // NOT 12px — Mantine's default xs is below the floor
    sm: "1.125rem",   // NOT 14px
    md: "1.25rem",
    lg: "1.375rem",
    xl: "1.5rem",
  },
  lineHeights: { xs: "1.5", sm: "1.5", md: "1.55", lg: "1.55", xl: "1.6" },

  defaultRadius: "md",
  components: {
    Paper: { defaultProps: { radius: "lg", bg: "var(--mantine-color-default)" } },
    Card:  { defaultProps: { radius: "lg" } },
    Badge: { styles: { root: { "--badge-fz": "var(--mantine-font-size-xs)", textTransform: "none" } } },
  },
};
```

```css
/* globals.css */
:root { font-variant-numeric: tabular-nums; }
h1, h2 { letter-spacing: -0.02em; }
h3, h4, h5, h6 { letter-spacing: -0.01em; }

/* Raise `dimmed` to clear the contrast floor — it ships at 3.32:1, under 4.5:1.
   Fixing the token once makes every `c="dimmed"` in the components below safe;
   patching call sites instead guarantees the next one reintroduces it. */
:root                                   { --mantine-color-dimmed: #5b6472; }  /* 5.98:1 on #fff */
:root[data-mantine-color-scheme="dark"] { --mantine-color-dimmed: #9aa4b2; }  /* 6.83:1 on #1a1b1e */
```

**Override the token, not the usages.** Mantine's `dimmed` is tuned for visual hierarchy, not contrast — its default `#868e96` computes to **3.32:1** on white, well under the floor. Every `c="dimmed"` in the shells below depends on this override being present; without it, the reference implementations ship sub-floor secondary text by default. Re-verify both values against your own surface colors, since a ratio that passes on the canvas can still fail on an elevated `Paper`.

- **Override the entire scale, not the parts you noticed.** Several Mantine components read `xs`/`sm` internally with no prop to grep for — leaving those two at their defaults is how a "compliant" app still ships 12px text.
- **`Badge` needs both fixes.** It sizes from its own `--badge-fz` custom property rather than the `fontSizes` scale, and it uppercases by default (which costs legibility at small sizes).
- **`tabular-nums` globally**, so every figure column lines up without per-component styling.

## Fonts

```ts
// app/fonts.ts
import { IBM_Plex_Sans, Space_Grotesk, IBM_Plex_Mono } from "next/font/google";

export const bodyFont    = IBM_Plex_Sans({ subsets: ["latin"], weight: ["400","500","600"], variable: "--font-body" });
export const displayFont = Space_Grotesk({ subsets: ["latin"], weight: ["500","700"],       variable: "--font-display" });
export const monoFont    = IBM_Plex_Mono({ subsets: ["latin"], weight: ["400","500"],       variable: "--font-mono" });
```

Three roles, three variables: **body** (all running text), **display** (headings and the logo wordmark), **mono** (figures, IDs, code). Swap the faces freely for a given app — keep the three roles and the variable names, because the theme base and every component below reference them by name.

Serif as a page-title accent is fine as a fourth variable, but **don't wire it into `theme.headings`** — that reaches far more surfaces than intended. Apply it on the title component only.

## Shared shells

Four components every app needs and every app otherwise rewrites. These are the reference implementations — copy them into `components/` and adjust.

### PageShell

```tsx
// components/PageShell.tsx
export function PageShell({ backHref, backLabel, title, subtitle, actions, children }: PageShellProps) {
  return (
    <Stack gap="lg">
      {backHref && (
        <Anchor component={Link} href={backHref} c="dimmed" fz="xs">
          ← {backLabel ?? "Back"}
        </Anchor>
      )}
      <Group justify="space-between" align="flex-start" wrap="wrap" gap="sm">
        <Stack gap={2}>
          <Title order={1} fz="2rem" lh={1.2}>{title}</Title>
          {subtitle && <Text c="dimmed">{subtitle}</Text>}
        </Stack>
        {actions && <Group gap="xs">{actions}</Group>}
      </Group>
      {children}
    </Stack>
  );
}
```

Every screen renders through it, so back-links, title sizing, and action placement stay identical without per-screen decisions.

### EditorShell

The form/editor shell is the highest-value reuse in the whole app — new and edit screens for *every* entity share it, and only the inner fields differ.

```tsx
// components/EditorShell.tsx
export function EditorShell({ form, preview, onCancel, saving, saveLabel = "Save" }: EditorShellProps) {
  return (
    <Grid gutter="xl">
      <Grid.Col span={{ base: 12, md: 7 }}>
        <Stack gap="md">{form}</Stack>
      </Grid.Col>

      <Grid.Col span={{ base: 12, md: 5 }}>
        <Box pos="sticky" top={80}>{preview}</Box>
      </Grid.Col>

      <Grid.Col span={12}>
        <Group justify="flex-end" gap="sm">
          <Button variant="subtle" onClick={onCancel} disabled={saving}>Cancel</Button>
          <Button type="submit" loading={saving}>{saveLabel}</Button>
        </Group>
      </Grid.Col>
    </Grid>
  );
}
```

- **7/5 split**, form left, live preview right. The preview is sticky at `top: 80` (header height + gutter) so it stays visible while a long form scrolls.
- **Stacks to full width below `md`** — the preview lands under the form on mobile, which is the right order.
- **Cancel is `subtle`, Save is filled.** Destructive-weight styling belongs on delete, not on cancel.

### StatTile

```tsx
// components/StatTile.tsx
export function StatTile({ label, value, hint }: StatTileProps) {
  return (
    <Paper p="md" withBorder>
      <Stack gap={4}>
        <Text c="dimmed" fz="xs" tt="uppercase" style={{ letterSpacing: "0.06em" }}>{label}</Text>
        <Text fz="2.5rem" fw={700} lh={1.1} ff="var(--font-mono)">{value}</Text>
        {hint && <Text c="dimmed" fz="xs">{hint}</Text>}
      </Stack>
    </Paper>
  );
}
```

The label is one of the few legitimate uses of the smallest token — it's a glanceable caption under a large figure, not running text. The figure itself is mono for column alignment across a row of tiles.

### EmptyState

```tsx
// components/EmptyState.tsx
export function EmptyState({ icon, headline, explanation, action }: EmptyStateProps) {
  return (
    <Paper p="xl" withBorder ta="center">
      <Stack gap="sm" align="center">
        {icon}
        <Text fw={600} fz="lg">{headline}</Text>
        <Text c="dimmed" maw={420}>{explanation}</Text>
        {action}
      </Stack>
    </Paper>
  );
}
```

**Centered, bordered, with a CTA** — a left-aligned stack of text reads as a rendering failure rather than a designed state. A fresh local-first DB has zero rows on day one, so this is the *first* screen a user sees for every entity. Design it before the entity exists.

## ConfirmDeleteButton

One hand-rolled controlled `<Modal>` handles every delete in the app — simple and option-carrying alike. This replaces `openConfirmModal`, and with it the `@mantine/modals` dependency and its provider.

```tsx
// components/ConfirmDeleteButton.tsx — 'use client'
export function ConfirmDeleteButton({ entityLabel, cascade, options, onConfirm }: ConfirmDeleteProps) {
  const [opened, { open, close }] = useDisclosure(false);
  const [extra, setExtra] = useState<Record<string, boolean>>({});
  const [pending, startTransition] = useTransition();

  return (
    <>
      <Button color="red" variant="light" onClick={open}>Delete</Button>

      <Modal opened={opened} onClose={close} title={`Delete this ${entityLabel}?`} centered>
        <Stack gap="md">
          <Text>
            {cascade
              ? `This also deletes ${cascade}. This cannot be undone.`
              : "This cannot be undone."}
          </Text>

          {options?.map((option) => (
            <Checkbox
              key={option.key}
              label={option.label}
              checked={extra[option.key] ?? false}
              onChange={(event) => setExtra((prev) => ({ ...prev, [option.key]: event.currentTarget.checked }))}
            />
          ))}

          <Group justify="flex-end" gap="sm">
            <Button variant="subtle" onClick={close} disabled={pending}>Cancel</Button>
            <Button
              color="red"
              loading={pending}
              onClick={() => startTransition(async () => { await onConfirm(extra); close(); })}
            >
              Delete
            </Button>
          </Group>
        </Stack>
      </Modal>
    </>
  );
}
```

- **Always show the blast radius.** `cascade` comes from the detail loader's batched counts (`also deletes 4 tasks`) — never offer a delete without the count.
- **`options` covers the cases a bare confirm can't** — "also delete the source file", "keep child records". One component, both shapes; no second pattern to remember.
- **The action runs inside `startTransition`** → `revalidatePath` → `redirect` to the list.
- **Don't build a delete *screen*.** This is the one sanctioned modal in the app; everything else is an addressable route.

## Gotchas

- **`lightHidden`/`darkHidden` lose to any inline style.** Mantine's visibility props work through a class (`[data-mantine-color-scheme] .mantine-light-hidden { display: none }`) with no `!important`. Add a `display` **style prop** to the same element — `<Box lightHidden display="inline-flex">` — and React emits an inline style that wins, so the "hidden" element renders anyway. In a dark/light toggle that means both sun and moon show at once. This shipped across an entire app family by copy-porting and was only caught in manual QA. Fix: move the layout to a CSS class, never the `display` style prop. **Better fix:** with server-persisted color scheme (above), render the correct icon directly and delete the hide-one-of-two pattern entirely.
- **Sidebar collapse state is client state; theme is not.** They look like the same kind of setting and they aren't — collapse is per-window view state (`localStorage` is right), theme is a user preference that must be correct in the first server-rendered byte (settings table is right). Mixing them up produces either a flash or a preference that doesn't stick.
- **`AppShell` navbar content is invisible on mobile until the drawer opens.** Anything mode-critical rendered there (a batch bar, a selection count) needs a header affordance too, or the feature is unreachable on small screens.
- **A sticky preview needs an explicit `top`.** `pos="sticky"` with no offset sticks to viewport top and slides under the fixed header. Use header height + gutter.
- **Don't wire an accent serif into `theme.headings`.** It reaches Mantine internals (Modal titles, Alert titles, table captions) far beyond the page titles you meant, and the result reads as inconsistent rather than accented.

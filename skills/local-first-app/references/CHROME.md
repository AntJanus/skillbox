# App chrome, identity & shared shells — deep reference

Load when scaffolding a shell, wiring theming, or building screens. Copy these implementations rather than re-deriving them: this is the layer that makes a family of apps look related, and the one a fresh build reinvents when the blueprint specifies only architecture.

Pairs with **color-system** (palette values) and **typography** (type decisions). This file specifies structure; those skills choose values.

## The shell

One `'use client'` chrome wraps every route. Dashboard layout, never single-column. The server-read `colorScheme` threads in as a prop from the root layout — that thread is the mechanism, not an incidental detail.

**The brand lives in the sidebar, not the header.** `layout="alt"` gives the navbar the full-height left edge including the top-left corner, so that corner holds the logo with the collapse toggle beside it. The header is a topbar over the content only: burger, title, right-aligned controls. Logo-in-the-header is the most common way a new app stops looking like the family.

```tsx
// components/AppShellChrome.tsx — 'use client'
// props: { colorScheme: "light" | "dark", children }

// Declared once, rendered by both identity-row branches below.
const collapseToggle = (
  <Tooltip
    label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
    position="right"
    withArrow
  >
    <ActionIcon
      variant="subtle"
      color="gray"
      onClick={toggleCollapsed}
      visibleFrom="sm" // desktop-only: mobile uses the Burger
      aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
    >
      {collapsed ? (
        <IconLayoutSidebarLeftExpand size={20} />
      ) : (
        <IconLayoutSidebarLeftCollapse size={20} />
      )}
    </ActionIcon>
  </Tooltip>
);

<AppShell
  layout="alt" // sidebar spans full height, header sits beside it
  header={{ height: 64 }}
  navbar={{
    width: collapsed ? 72 : 264,
    breakpoint: "sm",
    collapsed: { mobile: !drawerOpen },
  }}
>
  <AppShell.Navbar p="md">
    {/* Identity row — fixed height, never scrolls, never moves. */}
    {collapsed ? (
      <Stack align="center" gap={6} mt={4} mb="lg">
        <AppGlyph width={28} height={28} />
        {collapseToggle}
      </Stack>
    ) : (
      <Group h={36} mt={4} mb="lg" px={4} justify="space-between" wrap="nowrap">
        <Logo />
        {collapseToggle}
      </Group>
    )}

    {/* Links scroll; the identity row above and any pinned footer below do not. */}
    <AppShell.Section grow component={ScrollArea} type="hover">
      <Stack gap={2}>{primaryItems.map(renderNav)}</Stack>
    </AppShell.Section>

    <Divider my="md" />
    <Stack gap={2}>{footerItems.map(renderNav)}</Stack>
  </AppShell.Navbar>

  <AppShell.Header>
    <Group h="100%" px="lg" gap="md" wrap="nowrap">
      <Burger
        opened={drawerOpen}
        onClick={toggleDrawer}
        hiddenFrom="sm"
        size="sm"
        aria-label="Toggle navigation"
      />
      <Box style={{ flex: 1, minWidth: 0 }}>
        {/* title, or app-specific search */}
      </Box>
      <ColorSchemeToggle scheme={colorScheme} />
    </Group>
  </AppShell.Header>

  <AppShell.Main>{children}</AppShell.Main>
</AppShell>;
```

- **`layout="alt"`** is the load-bearing prop: sidebar full-height against the viewport edge, header beside it. This single prop is most of the silhouette.
- **264px expanded ↔ 72px collapsed.** Collapsed shows icons with the label as a `Tooltip`. Persist the flag to `localStorage` under `"<app>-sidebar-collapsed"` — ephemeral view state, unlike theme.
- **Collapsing drops the wordmark, never the mark.** The rail keeps the glyph; only the text half goes. A rail of anonymous icons loses the one element telling the user _which_ app they're in, which in a family of near-identical shells is the only thing distinguishing them at a glance.
- **The rail is too narrow for mark and toggle side by side.** 72px minus padding leaves ~52px; a 28px glyph plus a 34px `ActionIcon` doesn't fit. Stack when collapsed, `Group` when expanded, rather than shrinking either.
- **The collapse toggle belongs in the identity row, never `mt="auto"`** — see the navbar-overflow gotcha below.
- **`visibleFrom="sm"` on the toggle.** On mobile the navbar is a drawer; the `Burger` already owns that job.
- **Nav links** use the current pathname for active state, not click handlers.
- **A collapsed rail cannot hold wide controls.** Any mode rendering controls into the navbar (bulk selection) must force the shell back to full width while it lasts.
- **Collapsible nav _sections_ are a second, independent axis** — grouped links (`Libraries`, `Views`, `App`) with each header doubling as its own collapse control, so Docs and Settings sit beside the other sections instead of pinned below a divider in a footer. Persist the open set to `localStorage` alongside the sidebar flag; it's the same class of ephemeral view state. Two things the obvious version gets wrong:
  - **The 72px rail ignores section state entirely.** It hides every label, so a section collapsed there has no visible header left to expand it again — the links are simply gone with no way back short of expanding the whole sidebar.
  - **Filter persisted ids against the sections that exist now.** Storage outlives the code: an id from a removed section otherwise sits there forever, and a future section reusing that id is born collapsed for every existing user and nobody else.

Overflow bugs of this class don't fail a typecheck, a test, or a screenshot on a tall window. Check the geometry at a laptop-sized viewport:

```js
// browser console, or via shot-scraper javascript
const toggle = document.querySelector('[aria-label$="sidebar"]');
const { bottom } = toggle.getBoundingClientRect();
({
  bottom,
  viewport: innerHeight,
  belowFold: Math.round(bottom - innerHeight),
});
// belowFold > 0 → the control exists in the DOM and cannot be clicked
```

## Logo

A custom SVG glyph beside a two-weight wordmark. The weight split is the trick: a quiet shared part and a bold distinctive part read as one mark while letting a family of apps differ only in the second word.

**Export the glyph separately from the lockup.** `Logo` goes in the expanded navbar; the bare `AppGlyph` goes in the 72px rail, and doubles as favicon and app icon. Building only the combined lockup forces the chrome to hide the brand when collapsed or scale down text already at its legibility floor.

```tsx
// components/Logo.tsx
export function AppGlyph({ width = 26, height = 26 }) {
  /* one custom SVG per app */
}

export function Logo() {
  return (
    <Group gap={8} wrap="nowrap">
      <AppGlyph width={26} height={26} />
      <Text
        component="span"
        ff="var(--font-display)"
        fz="1.42rem"
        lh={1}
        style={{ letterSpacing: "-0.03em" }}
      >
        <Text component="span" inherit fw={400}>
          Prefix
        </Text>
        <Text
          component="span"
          inherit
          fw={700}
          c="var(--mantine-primary-color-filled)"
        >
          Name
        </Text>
      </Text>
    </Group>
  );
}
```

- **Glyph:** one hand-made SVG per app, sized to the cap height of the wordmark, saying what the app is about in a single shape.
- **Wordmark:** quiet segment at `fw 400`, distinctive segment at `fw 700` in the primary filled color. No space between the spans — they're one word visually.
- **Always the display face**, 1.42rem, `letterSpacing: -0.03em`. Tight tracking stops a two-weight wordmark reading as two words.

## Icons

**`@tabler/icons-react`**, everywhere. Pin one library for nav, actions, empty states and toggles alike; a mixed icon set is immediately visible as inconsistency, and Tabler's coverage means you never reach outside it.

## Theming — server-persisted, two axes

**4–7 named themes** plus a light/dark axis, both persisted **server-side in the settings table**, not `localStorage`. That buys a flash-free first paint by construction: the correct attributes are in the server-rendered HTML, so there's no pre-paint script to get right and no hydration mismatch to chase.

```tsx
// app/layout.tsx — server component
export const dynamic = "force-dynamic";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const theme = asThemeName(getSetting("theme")); // falls back to "default", logs on unknown
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
- **Narrow the stored key before indexing.** `getSetting()` returns an untyped string; a renamed or hand-edited theme makes `THEMES[value]` `undefined`, rendering an unthemed app rather than failing loudly — the silent fallback this blueprint forbids:

```ts
// lib/theme.ts
export const asThemeName = (value: string | null): ThemeName =>
  value && value in THEMES ? (value as ThemeName) : "default";

export const asColorScheme = (value: string | null): "light" | "dark" =>
  value === "dark" ? "dark" : "light";
```

- **`data-theme` on `<html>`** drives per-theme CSS variables in `globals.css`; `forceColorScheme` makes Mantine honor the stored value rather than the OS.
- **The font `.variable` classes go on `<html>`, not `<body>`** — see the `:root` trap in `UI.md`. The most common silent failure in this stack.
- **Both switchers live on Settings**, except the color-scheme toggle which also gets a header slot. Both call a server action that writes the setting and `revalidatePath("/", "layout")`.

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

**Render one icon, never both.** The scheme is known on the server, so the toggle picks its icon directly. Rendering both and hiding one with `lightHidden`/`darkHidden` is a live bug (see Gotchas) that server-side scheme makes unnecessary.

## Type scale & theme base

**The floor (must hold, whatever values you choose):** smallest token ≥ `1rem`/16px · line-height ≥ 1.5 · weight ≥ 400 · contrast ≥ 4.5:1. These values are a known-good implementation of it.

```ts
// lib/theme.ts — the shared base every named theme spreads
export const base = {
  fontFamily: "var(--font-body)",
  fontFamilyMonospace: "var(--font-mono)",
  headings: { fontFamily: "var(--font-display)" },

  // ~25% above Mantine's defaults; xs sits ON the floor, never under it
  fontSizes: {
    xs: "1rem", // NOT 12px — Mantine's default xs is below the floor
    sm: "1.125rem", // NOT 14px
    md: "1.25rem",
    lg: "1.375rem",
    xl: "1.5rem",
  },
  lineHeights: { xs: "1.5", sm: "1.5", md: "1.55", lg: "1.55", xl: "1.6" },

  defaultRadius: "md",
  components: {
    Paper: {
      defaultProps: { radius: "lg", bg: "var(--mantine-color-default)" },
    },
    Card: { defaultProps: { radius: "lg" } },
    Badge: {
      styles: {
        root: {
          "--badge-fz": "var(--mantine-font-size-xs)",
          textTransform: "none",
        },
      },
    },
  },
};
```

```css
/* globals.css */
:root {
  font-variant-numeric: tabular-nums;
}
h1,
h2 {
  letter-spacing: -0.02em;
}
h3,
h4,
h5,
h6 {
  letter-spacing: -0.01em;
}

/* Raise `dimmed` to clear the contrast floor — it ships at 3.32:1, under 4.5:1. */
:root {
  --mantine-color-dimmed: #5b6472;
} /* 5.98:1 on #fff */
:root[data-mantine-color-scheme="dark"] {
  --mantine-color-dimmed: #9aa4b2;
} /* 6.83:1 on #1a1b1e */
```

- **Override the token, not the usages.** Mantine's `dimmed` (`#868e96`) computes to 3.32:1 on white. Every `c="dimmed"` below depends on this override; patching call sites instead guarantees the next one reintroduces it. Re-verify both values against your own surfaces — a ratio that passes on the canvas can still fail on an elevated `Paper`.
- **Override the entire scale, not the parts you noticed.** Several components read `xs`/`sm` internally with no prop to grep for, which is how a "compliant" app still ships 12px text.
- **`Badge` needs both fixes** — it sizes from its own `--badge-fz` rather than the scale, and uppercases by default.
- **`tabular-nums` globally**, so figure columns line up without per-component styling.

## Fonts

```ts
// app/fonts.ts
import { IBM_Plex_Sans, Space_Grotesk, IBM_Plex_Mono } from "next/font/google";

export const bodyFont = IBM_Plex_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-body",
});
export const displayFont = Space_Grotesk({
  subsets: ["latin"],
  weight: ["500", "700"],
  variable: "--font-display",
});
export const monoFont = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500"],
  variable: "--font-mono",
});
```

Three roles, three variables: **body** (running text), **display** (headings, logo wordmark), **mono** (figures, IDs, code). Swap faces freely per app; keep the roles and variable names, because the theme base and every component below reference them by name.

A serif page-title accent is fine as a fourth variable, but **don't wire it into `theme.headings`** — that reaches Modal titles, Alert titles and table captions, and reads as inconsistent rather than accented.

## Shared shells

Reference implementations — copy into `components/` and adjust.

### PageShell

```tsx
// components/PageShell.tsx
export function PageShell({
  backHref,
  backLabel,
  title,
  subtitle,
  actions,
  children,
}: PageShellProps) {
  return (
    <Stack gap="lg">
      {backHref && (
        <Anchor component={Link} href={backHref} c="dimmed" fz="xs">
          ← {backLabel ?? "Back"}
        </Anchor>
      )}
      <Group justify="space-between" align="flex-start" wrap="wrap" gap="sm">
        <Stack gap={2}>
          <Title order={1} fz="2rem" lh={1.2}>
            {title}
          </Title>
          {subtitle && <Text c="dimmed">{subtitle}</Text>}
        </Stack>
        {actions && <Group gap="xs">{actions}</Group>}
      </Group>
      {children}
    </Stack>
  );
}
```

Every screen renders through it, so back-links, title sizing and action placement stay identical without per-screen decisions.

### EditorShell

The highest-value reuse in the app — new and edit screens for _every_ entity share it, and only the inner fields differ.

```tsx
// components/EditorShell.tsx
export function EditorShell({
  form,
  preview,
  onCancel,
  saving,
  saveLabel = "Save",
}: EditorShellProps) {
  return (
    <Grid gutter="xl">
      <Grid.Col span={{ base: 12, md: 7 }}>
        <Stack gap="md">{form}</Stack>
      </Grid.Col>

      <Grid.Col span={{ base: 12, md: 5 }}>
        <Box pos="sticky" top={80}>
          {preview}
        </Box>
      </Grid.Col>

      <Grid.Col span={12}>
        <Group justify="flex-end" gap="sm">
          <Button variant="subtle" onClick={onCancel} disabled={saving}>
            Cancel
          </Button>
          <Button type="submit" loading={saving}>
            {saveLabel}
          </Button>
        </Group>
      </Grid.Col>
    </Grid>
  );
}
```

- **7/5 split**, form left, preview right, sticky at `top: 80` (header height + gutter) so it stays visible while a long form scrolls.
- **Stacks to full width below `md`** — the preview lands under the form on mobile, the right order.
- **Cancel is `subtle`, Save is filled.** Destructive-weight styling belongs on delete.

### StatTile

```tsx
// components/StatTile.tsx
export function StatTile({ label, value, hint }: StatTileProps) {
  return (
    <Paper p="md" withBorder>
      <Stack gap={4}>
        <Text
          c="dimmed"
          fz="xs"
          tt="uppercase"
          style={{ letterSpacing: "0.06em" }}
        >
          {label}
        </Text>
        <Text fz="2.5rem" fw={700} lh={1.1} ff="var(--font-mono)">
          {value}
        </Text>
        {hint && (
          <Text c="dimmed" fz="xs">
            {hint}
          </Text>
        )}
      </Stack>
    </Paper>
  );
}
```

The label is one of the few legitimate uses of the smallest token — a glanceable caption under a large figure, not running text. The figure is mono so it aligns across a row of tiles.

### EmptyState

```tsx
// components/EmptyState.tsx
export function EmptyState({
  icon,
  headline,
  explanation,
  action,
}: EmptyStateProps) {
  return (
    <Paper p="xl" withBorder ta="center">
      <Stack gap="sm" align="center">
        {icon}
        <Text fw={600} fz="lg">
          {headline}
        </Text>
        <Text c="dimmed" maw={420}>
          {explanation}
        </Text>
        {action}
      </Stack>
    </Paper>
  );
}
```

**Centered, bordered, with a CTA** — a left-aligned stack of text reads as a rendering failure rather than a designed state. A fresh local-first DB has zero rows on day one, so this is the _first_ screen a user sees for every entity.

### ConfirmDeleteButton

One hand-rolled controlled `<Modal>` handles every delete, simple and option-carrying alike. Replaces `openConfirmModal`, and with it the `@mantine/modals` dependency and its provider.

```tsx
// components/ConfirmDeleteButton.tsx — 'use client'
export function ConfirmDeleteButton({
  entityLabel,
  cascade,
  options,
  onConfirm,
}: ConfirmDeleteProps) {
  const [opened, { open, close }] = useDisclosure(false);
  const [extra, setExtra] = useState<Record<string, boolean>>({});
  const [pending, startTransition] = useTransition();

  return (
    <>
      <Button color="red" variant="light" onClick={open}>
        Delete
      </Button>

      <Modal
        opened={opened}
        onClose={close}
        title={`Delete this ${entityLabel}?`}
        centered
      >
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
              onChange={(event) =>
                setExtra((prev) => ({
                  ...prev,
                  [option.key]: event.currentTarget.checked,
                }))
              }
            />
          ))}

          <Group justify="flex-end" gap="sm">
            <Button variant="subtle" onClick={close} disabled={pending}>
              Cancel
            </Button>
            <Button
              color="red"
              loading={pending}
              onClick={() =>
                startTransition(async () => {
                  await onConfirm(extra);
                  close();
                })
              }
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

- **Always show the blast radius.** `cascade` comes from the detail loader's batched counts (`also deletes 4 tasks`).
- **`options` covers what a bare confirm can't** — "also delete the source file", "keep child records". One component, both shapes.
- **The action runs inside `startTransition`** → `revalidatePath` → `redirect` to the list.
- **Don't build a delete _screen_.** This is the one sanctioned modal; everything else is an addressable route.

## Gotchas

- **`mt="auto"` in the navbar pushes a control off-screen instead of pinning it.** `AppShell.Navbar` is `display: flex; flex-direction: column` with `overflow: visible`, so `margin-top: auto` pins to the bottom of the _content_, which extends past the bottom of the _viewport_. Once the nav list is tall enough, the control renders with no clipping and no scrollbar, entirely below the fold, and stops receiving clicks. Silent and viewport-dependent: fine on the display it was built on, gone on a laptop. Wrap the links in `AppShell.Section grow component={ScrollArea}` before pinning anything beneath them, or keep the control in the fixed top row.
- **`lightHidden`/`darkHidden` lose to any inline style.** They work through a class (`.mantine-light-hidden { display: none }`) with no `!important`, so a `display` **style prop** on the same element wins and the "hidden" element renders anyway — both sun and moon at once in a toggle. This shipped across an entire app family by copy-porting and was caught only in manual QA. Move the layout to a CSS class; better, render the correct icon from the server-persisted scheme.
- **Sidebar collapse is client state; theme is not.** Collapse is per-window view state (`localStorage`); theme must be correct in the first server-rendered byte (settings table). Mixing them produces either a flash or a preference that doesn't stick.
- **`AppShell` navbar content is invisible on mobile until the drawer opens.** Anything mode-critical rendered there (a batch bar, a selection count) needs a header affordance too, or the feature is unreachable on small screens.
- **A sticky preview needs an explicit `top`.** `pos="sticky"` with no offset sticks to viewport top and slides under the fixed header. Use header height + gutter.

# Cross-app HTTP contracts for a local-first app hub

A reference for running a *family* of local-first apps — a set of independent
single-user Next.js + `node:sqlite` apps (finance, media, games, home, career,
and so on), each owning its own port and its own database, plus a hub app that
aggregates them.

Every app is standalone: it runs, stores, and works with no hub present. The hub
discovers the others over plain HTTP on localhost. That means the family needs a
small number of **standardized endpoints** that every app implements identically.

This document is the contract for those endpoints. If you are adding a new app to
such a family, implementing these is the integration work.

## Why these are HTTP routes at all

The family's house rule is *no API routes wrapping your own domain logic* — pages
call server functions directly, writes are server actions. These endpoints are the
documented exception, and they qualify for exactly one reason: **the consumer is a
different application**, not the app's own UI.

Apply that test before adding a new one. If your own pages would call it, it
should not be a route.

All of them declare `export const dynamic = "force-dynamic";` — they read live
state and must never be statically cached at build time.

---

## 1. `GET /api/calendar`

Returns the app's date-bearing events for the hub's unified calendar.

```json
{
  "events": [
    {
      "id": "maintenance-42",
      "date": "2026-07-21",
      "title": "Replace furnace filter",
      "category": "maintenance",
      "url": "/maintenance/42"
    }
  ]
}
```

| Field | Rule |
|---|---|
| `id` | Unique within this app. Prefix by type to avoid collisions across tables. |
| `date` | ISO `YYYY-MM-DD`. **Date only, no time component.** |
| `title` | Plain text, no markup. |
| `category` | Lowercase slug. The hub builds its per-app category filters from the distinct values it sees, so keep the set small and stable. |
| `url` | Relative to *this app's* own origin. The hub prefixes the host. |

### The empty stub is a legitimate implementation

If the app has no schedule, return `{ "events": [] }` and **write a doc comment
naming the tables you rejected and why**. Several apps in the family ship this
deliberately.

A timestamp is not a schedule. Resist the temptation to manufacture events from:

- `created_at` / `updated_at` — these record that something *already happened*.
- A status or board-state column — a state is not a date.
- A "least-recently-touched first" ordering — that is a staleness *ranking*, not a
  due date. Nothing in it comes due.

Inventing events out of those produces a calendar nobody asked for and that no
one can act on. An honest empty feed is better, and the widget endpoint below is
where a scheduleless app expresses its relationship to the hub instead.

### Auth

If the endpoint sits behind a session, say so with a non-JSON response (a redirect
to a login page is fine) — the hub distinguishes "needs login" from "down" by
checking the response `content-type`, and surfaces it as a notice rather than an
error.

---

## 2. `GET /api/logo`

Returns the app's mark, so the hub can identify it on tiles, tabs, palettes and
cards without maintaining a drawing for every app it does not own.

```json
{
  "version": 1,
  "viewBox": "0 0 24 24",
  "monochrome": false,
  "svg": "<defs><linearGradient id=\"app-mark\" x1=\"0\" y1=\"24\" x2=\"24\" y2=\"0\" gradientUnits=\"userSpaceOnUse\"><stop offset=\"0\" stop-color=\"#0d9488\"/><stop offset=\"1\" stop-color=\"#5eead4\"/></linearGradient></defs><rect width=\"24\" height=\"24\" rx=\"6\" fill=\"url(#app-mark)\"/><path d=\"...\" fill=\"#fff\"/>",
  "revision": "2"
}
```

| Field | Rule |
|---|---|
| `version` | Contract version. Currently `1`. Bump only on a breaking shape change; a consumer that does not recognize the version must fall back rather than guess. |
| `viewBox` | The coordinate system `svg` is drawn in. Four numbers, e.g. `"0 0 24 24"`. |
| `monochrome` | `true` when the mark is drawn in `currentColor` and the hub may tint it with the app's accent. `false` when the app ships fixed colors it wants preserved. |
| `svg` | **Inner markup only** — the children of an `<svg>`. Never a nested `<svg>`. |
| `revision` | Opaque, app-chosen. Change it whenever the art changes. |

### Why inner markup, not a complete `<svg>`

The consumer supplies the wrapper, because it renders the same mark at several
sizes in several places. A mark shipping its own `width`/`height` fights every one
of those call sites.

### Local gradient references are allowed; external ones are not

A tile mark references its own `<linearGradient>` as `url(#id)`. That fragment
resolves inside the document the consumer generates, so it is safe — but every
*other* `url(...)` form (`http://`, `//host`, `data:`) is an external paint server
and must be refused.

Getting that check right is fiddlier than it looks. The obvious regex,
`url\(\s*['"]?(?!#)`, is wrong: the optional quote backtracks to match empty, the
lookahead then only sees the quote character, succeeds, and a legitimate
`url('#id')` is rejected. Put the optional quote *inside* the lookahead —
`url\(\s*(?!['"]?#)`.

### Why the consumer should not inline it

This is markup produced by a *different application*. Inlining it into your DOM
means owning an SVG sanitizer, which is easy to get subtly wrong.

The safer construction, and the one the hub uses: substitute the accent color for
`currentColor`, wrap the inner markup in an `<svg>` document, base64-encode it into
a `data:image/svg+xml` URI, and render it with `<img src=...>`. An SVG referenced by
`<img>` is a separate document with scripting disabled by every browser, so the
mark is inert by construction — no sanitizer, no `dangerouslySetInnerHTML`. Because
`<img>` cannot inherit CSS `color`, baking the tint in during that step is also what
makes `monochrome` work.

Note this makes the accent color part of a generated attribute string, so validate
it as a literal hex before substitution.

### Caching is the consumer's job, and it is not optional

An endpoint only answers while the app is **running** — but a launcher tile's most
important state is *stopped*, since that is when you are looking for the app in
order to start it.

So the consumer must cache the last-seen envelope (the hub keeps it in its own
SQLite) and render from that cache, refreshing whenever the app is reachable. The
app is the authority; the cache is only what survives the app being stopped.

An app that has never been reached, or that has not implemented the endpoint yet,
simply has no cached mark — consumers should fall back to something derived from
data they already own (the hub uses a filled dot in the app's accent color). This
is a normal rollout state, not an error: the endpoint lands one repo at a time.

---

## 3. `POST /api/mcp`

A barebones Streamable-HTTP Model Context Protocol server, so each app is
addressable by external MCP clients.

- Use a **static** `app/api/mcp/route.ts`, not the `[transport]` catch-all shown in
  most `mcp-handler` examples. The dynamic segment also mounts an SSE endpoint
  (which needs Redis) and turns the route into a catch-all for every unmatched
  `/api/*`. A static folder with `basePath: "/api"` gives just the one endpoint.
- Export `GET`, `POST`, **and `DELETE`** (the client's session teardown), plus
  `export const runtime = "nodejs";`.
- Ship exactly one trivial `whoami` tool so the handshake is live-testable with
  zero domain logic. Real tools are the app owner's to add.
- Like the others, this is an external-consumer route and is **not** behind the
  app's auth gate.

Handshake check:

```bash
curl -s -X POST localhost:<port>/api/mcp \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{
        "protocolVersion":"2025-06-18","capabilities":{},
        "clientInfo":{"name":"probe","version":"0"}}}'
```

The response `serverInfo.name` should be the app's slug — if you get a 302, the
route is behind auth.

---

## 4. The widget endpoint (domain-shaped, not standardized)

Unlike the three above, this one deliberately has **no fixed name or shape**. Each
app exposes something domain-shaped — `/api/summary`, `/api/now-watching`,
`/api/due-soon`, `/api/overview`, `/api/continue-watching` — and the consumer
writes a card per app.

That asymmetry is intentional: a budget snapshot and a continue-watching shelf
have nothing meaningful in common, and forcing them into one schema would flatten
both. What *is* standardized is the rule about content:

> The endpoint must reshape what the app already computes for its own pages. No
> new domain logic lands in an app for the hub's benefit.

If the number you want does not exist yet, that is a feature request for that app,
not part of integration.

This endpoint carries extra weight for apps whose `/api/calendar` is an empty
stub — it becomes their entire relationship with the hub.

---

## Checklist for a new app

1. `GET /api/calendar` — real feed, or a documented empty stub.
2. `GET /api/logo` — a mark that reads at 16px. The reference implementation uses an
   app-icon tile (rounded square, accent gradient, solid white glyph,
   `monochrome: false`); a flat `currentColor` mark with `monochrome: true` is the
   alternative when you want the consumer to tint it. Prefer solid fills over
   hairline strokes either way — strokes vanish at tab-strip size.
3. `POST /api/mcp` — static route, `whoami` tool, `GET`/`POST`/`DELETE`.
4. A domain-shaped widget endpoint, reshaping data that already exists.
5. A distinct port, registered wherever the hub keeps its roster.

Verify each one with a real request against a running server before calling it
done — all four are trivially checkable with `curl`, and a shape mismatch is
invisible until something tries to consume it.

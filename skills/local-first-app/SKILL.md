---
name: local-first-app
description: Local-first single-user app — one SQLite file on disk, no accounts, no backend. Use this skill whenever the user wants to build a personal tracker, catalog, or dashboard whose data stays on their own machine, add an entity or a screen to one, or package it as a desktop binary. Do NOT use it for anything needing multi-user auth, a hosted API, or server-side secrets.
license: MIT
metadata:
  author: Antonin Januska
  version: "4.2.0"
  tags: [nextjs, sqlite, local-first, desktop]
---

# Local-First App

## Overview

A single-user app that does one thing — track a game backlog, log workouts, catalog a collection. It is CRUD over entities with real relationships between them, presented through one consistent set of UI patterns. Data lives in a local SQLite file on the user's machine. No accounts, no hosted API, nothing over the network to use it. It can ship as a desktop binary.

This describes **what the app has**. How to build it is your call — pick the structure, the patterns, and the libraries that fit the app you're actually making.

## Stack

- **Next.js** (App Router) + **React** + **TypeScript**
- **SQLite** for storage — one local file. Prefer a driver with no native build step (`node:sqlite` on Node) so the app can compile to a single binary.
- **Environment variables** for config — the data file location above all, so a dev checkout and a packaged build point at different places.

Everything else — UI library, forms, validation, charts, test runner — is yours to choose.

## Data

- Entities have real relationships. One-to-many is a foreign key; many-to-many is a join table. Declare what a delete does to the other side.
- **Back up the database file automatically** — on a schedule and before every migration, keeping the last few snapshots. There's no server copy, so a bad migration or a corrupt write is unrecoverable user data.
- Migrations run at startup.
- A fresh install has zero rows and no seed data, so every list screen needs a real empty state with a way to add the first record.

## App routes

Every app has these, whatever it stores:

| Route        | Purpose                                      |
| ------------ | -------------------------------------------- |
| `/`          | overview home                                |
| `/search?q=` | search spanning every entity type            |
| `/settings`  | settings                                     |
| `/calendar`  | calendar, when the app has date-bearing data |

## Entity routes

Every entity gets four addressable routes:

| Route                 | Purpose |
| --------------------- | ------- |
| `/<entity>`           | list    |
| `/<entity>/new`       | add     |
| `/<entity>/[id]`      | view    |
| `/<entity>/[id]/edit` | edit    |

- **The URL is the state** — every screen is deep-linkable, survives a refresh, and works with the back button. Prefer full screens over modals for data entry.
- **Add and edit are the same form**, edit just arrives prefilled.
- **Related records cross-link both directions**, and a parent's detail screen can create a child with the relationship prefilled.
- **Delete confirms and says what else goes with it** ("also deletes 4 tasks").
- **Keep add/save/delete/cancel in the same spot** on every screen.

## Common UI patterns

- Use tabs on a list view to cut the same records different ways.
- Use tabs on an entity view to reach its related entities.
- Drive filtering and sorting from URL parameters, and run both on the server — the client never sorts or filters a full result set.
- When a list can grow unbounded, plan for it — virtualization or pagination, whichever suits the app.
- **A list renders in the shape its records have** — a table by default, cards when the records carry images worth previewing, a skeuomorphic object when the entity is a real-world one. Whichever shape a list defaults to, a table view stays reachable.
- **Tables sort, filter, and explain themselves** — a legend keying whatever status colors or icons the rows use, and a row that expands in place when a record has more detail than the columns hold.
- **Pair icons with text labels** — one per sidebar section, entity type, and status, so a screen is scannable without reading every word. The icon sits alongside the label rather than replacing it.
- Bulk selection and bulk edit on the lists where editing one row at a time gets tedious. Past one selected row, the bulk editor takes over the sidebar column until the selection clears.

## Skeuomorphism

Where an entity is a physical object outside the app, render it as that object rather than as a row of fields. A collection screen then reads as the shelf or wallet it stands in for.

| Entity                        | Rendered as                                                   |
| ----------------------------- | ------------------------------------------------------------- |
| payment method                | a credit card — brand mark and last four in the card's layout |
| contact, professional profile | a business card                                               |
| album or track                | a disc, with the sleeve art on the label                      |
| game                          | a cartridge or case, art on the front face                    |
| book                          | a spine, legible in a row on a shelf                          |
| purchase, expense             | a receipt, itemized in a monospace face                       |

- **The object is presentation only** — the same record stays sortable, filterable, and reachable as a table row.
- **It has to survive list density** — one glance at the screen should read as a shelf of books or a wallet of cards. An object treatment that only works at detail size belongs on the detail screen alone.

## Chrome

- **Top nav** — a search box and a theme switcher.
- **Sidebar** — collapsible sections grouping the entities and exposing non-entity views (an "insights" view, say) alongside settings. Each section is named for what it holds ("Library", not "Other"). The app name sits at the top.
- **Settings** — theme selection (a named theme plus light/dark), the data file location, restore-from-backup, and any external API keys. Restore has to be reachable in the UI: someone running the packaged binary has no checkout and no terminal.

## Examples

- ✅ `/games/new` — ❌ a create modal on `/games`
- ✅ `game_tags(game_id, tag_id)` join table — ❌ a comma-separated `tags` column
- ✅ `/games?sort=title&status=playing` sorted in SQL — ❌ fetch every row, sort in the client
- ✅ `/search?q=zelda` spanning games and platforms — ❌ a `mod+K` palette with no URL behind it
- ✅ "Delete Zelda? Also deletes 3 sessions." — ❌ a bare "Are you sure?"
- ✅ Restore a backup from Settings — ❌ a README telling the user to copy a file
- ✅ `/games` as cover-art cards with a table view still reachable — ❌ a table whose only image column is a filename
- ✅ `/books` as spines standing in a row — ❌ a title column with a thumbnail beside it
- ✅ A legend reading "● playing ○ backlog ◐ dropped" above the table — ❌ colored status dots with no key
- ✅ A car icon beside the "Cars" sidebar section — ❌ a bare "Cars" text label

## Packaging

Compiling to a self-contained desktop binary: **[references/PACKAGING.md](./references/PACKAGING.md)**

## Integration

- **color-system** for palettes and contrast
- **typography** for the readability floor
- **frontend-design** for layout and visual design
- **track-roadmap** / **track-session** to drive the build feature by feature

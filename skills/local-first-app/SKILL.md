---
name: local-first-app
description: Local-first single-user app — one SQLite file on disk, no accounts, no backend. Use this skill whenever the user wants to build a personal tracker, catalog, or dashboard whose data stays on their own machine, add an entity or a screen to one, or package it as a desktop binary. Do NOT use it for anything needing multi-user auth, a hosted API, or server-side secrets.
license: MIT
metadata:
  author: Antonin Januska
  version: "4.0.0"
  tags: [nextjs, sqlite, local-first, desktop]
---

# Local-First App

## Overview

A single-user app that does one thing — track a game backlog, log workouts, catalog a collection. Data lives in a local SQLite file on the user's machine. No accounts, no hosted API, nothing over the network to use it. It can ship as a desktop binary.

This describes **what the app has**. How to build it is your call — pick the structure, the patterns, and the libraries that fit the app you're actually making.

## Stack

- **Next.js** (App Router) + **React** + **TypeScript**
- **SQLite** for storage — one local file. Prefer a driver with no native build step (`node:sqlite` on Node) so the app can compile to a single binary.
- **Environment variables** for config — the data file location above all, so a dev checkout and a packaged build point at different places.

Everything else — UI library, forms, validation, charts, test runner — is yours to choose.

## Data

- Entities have real relationships. One-to-many is a foreign key; many-to-many is a join table. Declare what a delete does to the other side.
- Migrations run at startup. Snapshot the database file before applying one — there's no server copy, so a bad migration is unrecoverable user data.
- A fresh install has zero rows and no seed data, so every list screen needs a real empty state with a way to add the first record.

## Screens

Every entity gets four addressable routes:

| Route | Purpose |
| --- | --- |
| `/<entity>` | list |
| `/<entity>/new` | add |
| `/<entity>/[id]` | view |
| `/<entity>/[id]/edit` | edit |

- **The URL is the state** — every screen is deep-linkable, survives a refresh, and works with the back button. Prefer full screens over modals for data entry.
- **Add and edit are the same form**, edit just arrives prefilled.
- **Related records cross-link both directions**, and a parent's detail screen can create a child with the relationship prefilled.
- **Delete confirms and says what else goes with it** ("also deletes 4 tasks").

## Chrome

- **Top nav** — a search box and a theme switcher. Search is its own `/search?q=` route spanning every entity type, not just a keyboard palette.
- **Sidebar** — collapsible sections grouping the entities.
- **Settings** — theme selection (a named theme plus light/dark), the data file location, and backup/restore. Restore has to be reachable in the UI: someone running the packaged binary has no checkout and no terminal.

## Examples

- ✅ `/games`, `/games/new`, `/games/[id]`, `/games/[id]/edit` — ❌ one `/games` page opening a create modal
- ✅ `/search?q=zelda` spanning games and platforms — ❌ a `mod+K` palette with no URL behind it
- ✅ `game_tags(game_id, tag_id)` join table — ❌ a comma-separated `tags` column
- ✅ "Delete Zelda? Also deletes 3 sessions." — ❌ a bare "Are you sure?"
- ✅ Restore a backup from Settings — ❌ a README telling the user to copy a file

## Packaging

Compiling to a self-contained desktop binary: **[references/PACKAGING.md](./references/PACKAGING.md)**

## Integration

**color-system** for palettes and contrast · **typography** for the readability floor · **frontend-design** for layout and visual design · **track-roadmap** / **track-session** to drive the build feature by feature.

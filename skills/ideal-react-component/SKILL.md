---
name: ideal-react-component
description: React component structure and hooks antipatterns — a seven-section file layout, logic ordering, and the useEffect/useState failure modes behind infinite loops and stale state. Use this skill whenever the user wants to "create a React component", "structure this component", "refactor this component", "extract a custom hook", "fix an infinite render loop", or "my useEffect isn't working" — even if they don't mention React by name, when the file is .tsx/.jsx or the code calls hooks. Do NOT use this skill for general code review of non-React code (see code-review), visual or layout design (see frontend-design), or plain JavaScript with no components or hooks.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.8.1"
  tags: [react, components, hooks, useeffect, refactoring, typescript]
---

# Ideal React Component Structure

## Overview

A predictable seven-section order for function-component files — imports → styles → types → component → logic → conditional render → default render — so anyone opening the file knows where to look. Paired with the hooks antipatterns that cause most infinite loops and stale state.

**Core principle:** the file reads top-to-bottom in dependency order, and the happy path lands at the bottom where it's most visible. It's a pattern, not a law — small components and React Server Components legitimately skip sections.

## The seven-section structure

```tsx
// 1. IMPORTS (grouped: React → third-party → internal @/ → local, blank line between)
import React, { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api } from '@/services/api';
import { Button } from './Button';

// 2. STYLED COMPONENTS (prefix "Styled" so they're instantly recognizable)
const StyledContainer = styled.div`padding: 1rem; background: white;`;

// 3. TYPE DEFINITIONS (ComponentNameProps, declared right above the component)
type UserProfileProps = {
  userId: string;
  onUpdate?: (user: User) => void;
};

// 4. COMPONENT FUNCTION (named export, const arrow function)
export const UserProfile = ({ userId, onUpdate }: UserProfileProps): React.JSX.Element => {
  // 5. LOGIC, in order: local state → custom/data hooks → effects → post-processing → handlers

  // 6. CONDITIONAL RENDERING (exit early for each edge case, after every hook call)
  if (isLoading) return <Loading />;
  if (error) return <Error message={error.message} />;
  if (!data) return <Empty />;

  // 7. DEFAULT RENDER (success/happy path stays at the bottom — most visible)
  return <StyledContainer>{/* Main JSX */}</StyledContainer>;
};
```

**JavaScript:** same pattern without type annotations — skip Section 3 or use JSDoc.

| Section | What goes here | Why |
|---------|----------------|-----|
| 1. Imports | React, libraries, internal `@/`, local | Easy to find dependencies |
| 2. Styling | Styled comps (prefix `Styled`), Tailwind, CSS Modules | Visual separation from logic |
| 3. Types | `*Props`, `*Return` above the component | API visible at a glance |
| 4. Component | `export const Component = (...) =>` | Named exports refactor cleanly |
| 5. Logic | state → hooks → effects → post-processing → handlers | Respects hook rules; deps before dependents |
| 6. Conditional render | Early returns for loading/error/empty | Reduces nesting; types narrow after guards |
| 7. Default render | Success-state JSX | Happy path is the most visible code |

## Logic flow order (Section 5)

```tsx
// 5.1 local state          const [isEditing, setIsEditing] = useState(false);
// 5.2 custom/data hooks    const { data, isLoading, error } = useQuery(...);
// 5.3 effects              useEffect(() => { ... }, [isEditing]);
// 5.4 post-processing      const displayName = data ? `${data.first} ${data.last}` : '';
// 5.5 callback handlers    const handleEdit = () => setIsEditing(true);
```

State first, effects after the hooks they depend on, handlers last — so each line only references things already declared above it.

## Top hooks antipatterns

The three most frequent causes of infinite loops, stale data, and surprise re-renders. Desired form first.

**1. Derive during render; don't sync with an effect.** An effect that only computes state from other state costs an extra render pass, and loops outright if the parent feeds the value back down.

```tsx
const fullName = `${first} ${last}`;                                   // ✅ derive during render
useEffect(() => { setFullName(`${first} ${last}`); }, [first, last]); // ❌ extra render, loop risk
```

**2. Reset prop-derived state with `key`; don't expect `useState` to track props.** The initializer runs once, so a changed prop leaves the state stale.

```tsx
<Component key={itemId} initialValue={data.value} />      // ✅ remount resets state
const [value, setValue] = useState(props.initialValue);   // ❌ stale after prop changes
```

**3. List every dependency.** Omitting one captures a stale closure — the effect keeps reading the first render's values.

```tsx
useEffect(() => { setTotal(count * price); }, [count, price]);   // ✅ all deps
useEffect(() => { setTotal(count * price); }, [price]);          // ❌ missing count
```

## Refactoring

When a component passes ~50 lines of logic or ~200 total, extract the stateful logic into a `use[Domain]` hook — the component becomes presentation-focused and the hook owns state and data flow. Refactor the component the user named; a sibling or parent that has the same problem is a follow-up to report, not a file to touch in the same change. Extraction criteria and composition patterns: **[reference/REFACTORING.md](./reference/REFACTORING.md)**.

## Gotchas

- **Early returns must sit below every hook call.** Section 6 comes after Section 5 for a hard reason, not tidiness: a `return` above a `useEffect` changes the hook count between renders and React throws "Rendered fewer hooks than expected." If a guard needs to short-circuit expensive work, gate inside the hook instead.
- **Server Components can't hold Sections 2 and 5.** In the Next.js App Router a file is a Server Component by default; `useState`, `useEffect`, and styled-components all require `'use client'` at the top. The build error names the hook, not the missing directive.
- **Object and array literals in dependency arrays loop forever.** `}, [{ id }])` or `}, [items.filter(...)])` allocates a fresh identity every render, so the effect always re-fires. Move the literal inside the effect, or memoize it with `useMemo`.
- **`key`-resetting remounts the whole subtree.** It discards child state, uncontrolled input values, focus, and running animations. It's the right call for "this is a different record now," the wrong one for a single field that needs re-seeding.
- **Deriving beats memoizing until it measurably doesn't.** Reach for `useMemo` only when the computation is genuinely expensive — a template string or `.map()` over a short list is cheaper than the memo bookkeeping.
- **Return type is `React.JSX.Element`, not bare `JSX.Element`.** React 19's types dropped the global `JSX` namespace, so the unqualified form no longer resolves.
- **`@tanstack/react-query` v5 takes one object argument.** The positional `useQuery(key, fn, options)` overloads were removed. v5 also renamed the `'loading'` status to `'pending'` and redefined `isLoading` as `isPending && isFetching`, so "no data yet" is now `isPending`.
- **GSD execution phases don't auto-activate skills.** Invoke `/ideal-react-component` explicitly, or record the convention in the project's CLAUDE.md.

## Deep reference

Load one file when the question calls for it — not up front.

| Load | When |
|---|---|
| **[reference/SECTIONS.md](./reference/SECTIONS.md)** | Per-section ✅/❌ detail, styling-solution variants, structural troubleshooting |
| **[reference/HOOKS-ANTIPATTERNS.md](./reference/HOOKS-ANTIPATTERNS.md)** | Full antipattern set with mechanisms — the top three above are the summary |
| **[reference/REFACTORING.md](./reference/REFACTORING.md)** | Extracting and composing custom hooks |
| **[reference/COMPLETE-EXAMPLES.md](./reference/COMPLETE-EXAMPLES.md)** | Full TS and JS components with all seven sections |
| **[reference/EVAL.md](./reference/EVAL.md)** | Activation eval set (maintainers only) |

## Source

- [The Anatomy of My Ideal React Component](https://antjanus.com/digital-garden/the-anatomy-of-my-ideal-react-component) and [Common React Hooks Antipatterns](https://antjanus.com/digital-garden/common-react-hooks-antipatterns-and-gotchas) — Antonin Januska
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) · [Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) · [TS React Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)

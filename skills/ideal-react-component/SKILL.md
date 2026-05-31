---
name: ideal-react-component
description: React component structure and hooks antipatterns. Use when asked to "create a React component", "structure this component", "refactor this component", "fix infinite loop", or "useEffect not working".
license: MIT
metadata:
  author: Antonin Januska
  version: "1.7.0"
---

# Ideal React Component Structure

A predictable seven-section order for function-component files — imports → styles → types → component → logic → conditional render → default render — so developers always know where to find things. **It's a pattern, not a law:** small/simple components and React Server Components can skip sections.

## The seven-section structure

```tsx
// 1. IMPORTS (grouped: React → third-party → internal @/ → local, blank line between)
import React, { useState, useEffect } from 'react';
import { useQuery } from 'react-query';
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
export const UserProfile = ({ userId, onUpdate }: UserProfileProps): JSX.Element => {
  // 5. LOGIC, in order: local state → custom/data hooks → effects → post-processing → handlers

  // 6. CONDITIONAL RENDERING (exit early for each edge case)
  if (isLoading) return <Loading />;
  if (error) return <Error message={error.message} />;
  if (!data) return <Empty />;

  // 7. DEFAULT RENDER (success/happy path stays at the bottom — most visible)
  return <StyledContainer>{/* Main JSX */}</StyledContainer>;
};
```

**JavaScript:** same pattern without type annotations (skip Section 3 or use JSDoc).

| Section | What goes here | Why |
|---------|----------------|-----|
| 1. Imports | React, libraries, internal `@/`, local | Easy to find dependencies |
| 2. Styling | Styled comps (prefix `Styled`), Tailwind, CSS Modules | Visual separation from logic |
| 3. Types | `*Props`, `*Return` above the component | API visible at a glance |
| 4. Component | `export const Component = (...) =>` | Named exports refactor cleanly |
| 5. Logic | state → hooks → effects → post-processing → handlers | Respects hook rules; deps before dependents |
| 6. Conditional render | Early returns for loading/error/empty | Reduces nesting; types narrow after guards |
| 7. Default render | Success-state JSX | Happy path is the most visible code |

See **[reference/SECTIONS.md](./reference/SECTIONS.md)** for per-section ✅/❌ detail, styling-solution variants, and troubleshooting.

## Logic flow order (Section 5)

```tsx
// 5.1 local state         const [isEditing, setIsEditing] = useState(false);
// 5.2 custom/data hooks    const { data, isLoading, error } = useQuery(...);
// 5.3 effects              useEffect(() => { ... }, [isEditing]);
// 5.4 post-processing      const displayName = data ? `${data.first} ${data.last}` : '';
// 5.5 callback handlers    const handleEdit = () => setIsEditing(true);
```

State first, effects after the hooks they depend on, handlers last — so the file reads top-to-bottom in dependency order.

## Top hooks antipatterns

The most frequent causes of infinite loops, stale data, and unexpected re-renders:

**1. useEffect as an onChange/derive callback** — causes double renders or loops:
```tsx
useEffect(() => { setFullName(`${first} ${last}`); }, [first, last]); // ❌
const fullName = `${first} ${last}`;                                   // ✅ derive during render
```

**2. useState initialized from props** — initializer runs once, won't track prop changes:
```tsx
const [value, setValue] = useState(props.initialValue);  // ❌ stale on prop change
<Component key={itemId} initialValue={data.value} />      // ✅ key to reset, or sync in effect
```

**3. Non-exhaustive dependency arrays** — stale closures:
```tsx
useEffect(() => { setTotal(count * price); }, [price]);          // ❌ missing count
useEffect(() => { setTotal(count * price); }, [count, price]);   // ✅ all deps
```

See **[reference/HOOKS-ANTIPATTERNS.md](./reference/HOOKS-ANTIPATTERNS.md)** for the full set with explanations.

## Refactoring

When a component exceeds ~50 lines of logic or ~200 total, extract stateful logic into a `use[Domain]` custom hook — the component becomes presentation-focused, the hook owns state and data flow. See **[reference/REFACTORING.md](./reference/REFACTORING.md)** for extraction criteria and composition patterns.

## Deep reference

Load only when needed:
- **[reference/SECTIONS.md](./reference/SECTIONS.md)** — per-section detail + troubleshooting
- **[reference/COMPLETE-EXAMPLES.md](./reference/COMPLETE-EXAMPLES.md)** — full TS + JS component examples
- **[reference/REFACTORING.md](./reference/REFACTORING.md)** — extracting custom hooks
- **[reference/HOOKS-ANTIPATTERNS.md](./reference/HOOKS-ANTIPATTERNS.md)** — infinite loops, stale closures, dependency arrays

## Integration

Works with styled-components, emotion, Tailwind, CSS Modules, React Query/SWR, Zustand/Redux. Pairs with ESLint, Prettier, TypeScript, Storybook, Vitest/Jest.

**GSD note:** this skill won't auto-activate inside GSD execution phases — reference `/ideal-react-component` explicitly when creating React components, or add it to the project CLAUDE.md as a convention.

## Source

- [The Anatomy of My Ideal React Component](https://antjanus.com/digital-garden/the-anatomy-of-my-ideal-react-component) and [Common React Hooks Antipatterns](https://antjanus.com/digital-garden/common-react-hooks-antipatterns-and-gotchas) — Antonin Januska
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) · [Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) · [TS React Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)

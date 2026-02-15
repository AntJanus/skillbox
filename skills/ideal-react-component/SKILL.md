---
name: ideal-react-component
description: |
  Use when creating React components, structuring component files, organizing component code,
  debugging React hooks issues, or when asked to "create a React component", "structure this component",
  "review component structure", "refactor this component", "fix infinite loop", or "useEffect not working".
  Applies to both TypeScript and JavaScript React components. Includes hooks antipatterns.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.3.0"
tags: [react, component, structure, organization, best-practices]
---

# Ideal React Component Structure

## Overview

A battle-tested pattern for organizing React component files that emphasizes readability, maintainability, and logical flow. This structure helps teams maintain consistency and makes components easier to understand at a glance.

**Core principle:** Declare everything in a predictable order--imports to styles to types to logic to render--so developers know where to find things.

## When to Use

**Always use when:**
- Creating new React components
- Refactoring existing components
- Reviewing component structure during code review
- Onboarding developers to component patterns

**Useful for:**
- Establishing team conventions
- Maintaining large component libraries
- Teaching React best practices
- Reducing cognitive load when reading components

**Avoid when:**
- Working with class components (this pattern is for function components)
- Component is < 20 lines and simple (don't over-engineer)
- Project has different established conventions (consistency > perfection)

## The Ideal Structure

Components should follow this seven-section pattern:

```tsx
// 1. IMPORTS (organized by source)
import React, { useState, useEffect } from 'react';
import { useQuery } from 'react-query';

import { formatDate } from '@/utils/date';
import { api } from '@/services/api';

import { Button } from './Button';

// 2. STYLED COMPONENTS (prefixed with "Styled")
const StyledContainer = styled.div`
  padding: 1rem;
  background: white;
`;

// 3. TYPE DEFINITIONS (ComponentNameProps pattern)
type UserProfileProps = {
  userId: string;
  onUpdate?: (user: User) => void;
};

// 4. COMPONENT FUNCTION
export const UserProfile = ({ userId, onUpdate }: UserProfileProps): JSX.Element => {
  // 5. LOGIC SECTIONS (in this order)
  // - Local state
  // - Custom/data hooks
  // - useEffect/useLayoutEffect
  // - Post-processing
  // - Callback handlers

  // 6. CONDITIONAL RENDERING (exit early)
  if (isLoading) return <Loading />;
  if (error) return <Error message={error.message} />;
  if (!data) return <Empty />;

  // 7. DEFAULT RENDER (success state)
  return (
    <StyledContainer>
      {/* Main component JSX */}
    </StyledContainer>
  );
};
```

**JavaScript:** Same pattern without type annotations (skip Section 3 or use JSDoc).

## Section 1: Import Organization

**Order imports by source to reduce cognitive load:**

```tsx
// ✅ Good: Clear grouping with blank lines
import React, { useState, useEffect, useMemo } from 'react';
import { useQuery, useMutation } from 'react-query';
import { format } from 'date-fns';

import { api } from '@/services/api';
import { formatCurrency } from '@/utils/format';

import { Button } from './Button';
import { Card } from './Card';
```

```tsx
// ❌ Bad: Random order, no grouping
import { Button } from './Button';
import { format } from 'date-fns';
import React, { useState } from 'react';
import { api } from '@/services/api';
import { useQuery } from 'react-query';
```

**Import priority:**
1. React imports (first)
2. Third-party libraries (followed by blank line)
3. Internal/aliased imports (`@/`) (followed by blank line)
4. Local component imports (same directory)

## Section 2: Styling

**The key principle is separating styling from logic.** The approach depends on your styling solution:

**styled-components / emotion:** Prefix with `Styled` for instant recognition:

<Good>
```tsx
const StyledCard = styled.div`
  border: 1px solid #ccc;
  border-radius: 8px;
  padding: 1rem;
`;

const StyledTitle = styled.h2`
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
`;

export const Card = ({ title, children }) => (
  <StyledCard>
    <StyledTitle>{title}</StyledTitle>
    {children}
  </StyledCard>
);
```
</Good>

<Bad>
```tsx
// ❌ Bad: Can't tell if CardWrapper is styled or contains logic
const CardWrapper = styled.div`
  border: 1px solid #ccc;
`;

const Title = styled.h2`
  font-size: 1.5rem;
`;
```
</Bad>

**When styled components grow large:**
- Move to co-located `ComponentName.styled.ts` file
- Import as `import * as S from './ComponentName.styled'`
- Use as `<S.Container>`, `<S.Title>`, etc.

**Tailwind CSS:** Extract repeated utility sets into components or use `@apply`:
```tsx
// Wrapper component keeps JSX clean
const Card = ({ title, children }: CardProps) => (
  <div className="border border-gray-300 rounded-lg p-4">
    <h2 className="text-xl mb-2">{title}</h2>
    {children}
  </div>
);
```

**CSS Modules:** Import as `styles` and use bracket notation:
```tsx
import styles from './Card.module.css';

const Card = ({ title, children }: CardProps) => (
  <div className={styles.container}>
    <h2 className={styles.title}>{title}</h2>
    {children}
  </div>
);
```

**JavaScript:** Same patterns work for `.js`/`.jsx` files.

## Section 3: Type Definitions

**Declare types immediately above the component for visibility:**

<Good>
```tsx
type ButtonProps = {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  onClick: () => void;
  children: React.ReactNode;
};

export const Button = ({
  variant = 'primary',
  size = 'md',
  onClick,
  children
}: ButtonProps): JSX.Element => {
  // Component logic
};
```
</Good>

<Bad>
```tsx
// ❌ Bad: Inline types hide the API
export const Button = ({ variant, size, onClick, children }: {
  variant?: 'primary' | 'secondary'; size?: 'sm' | 'md' | 'lg';
  onClick: () => void; children: React.ReactNode;
}) => { /* ... */ };
```
</Bad>

**Naming:** Props: `ComponentNameProps`. Return types: `JSX.Element` (or custom: `ComponentNameReturn`).

**JavaScript:** Use JSDoc `@typedef` and `@param` annotations for equivalent documentation.

**Why:** Makes component API visible at a glance, easier to modify without disturbing component code, better for documentation.

## Section 4: Component Function

**Use named exports with const arrow functions:**

<Good>
```tsx
export const UserProfile = ({ userId }: UserProfileProps): JSX.Element => {
  // Component logic
};
```
</Good>

<Bad>
```tsx
// ❌ Bad: Default export makes refactoring harder
export default function UserProfile({ userId }: UserProfileProps): JSX.Element {
  // Component logic
}
```
</Bad>

**Why const + arrow functions:**
- Easy to wrap with `useCallback` later if needed
- Consistent with other hooks and callbacks in component
- Named exports are easier to refactor and search for

**JavaScript:** Same pattern without type annotations.

## Section 5: Logic Flow

**Organize component logic in this strict order:**

```tsx
export const UserProfile = ({ userId }: UserProfileProps): JSX.Element => {
  // 5.1 - LOCAL STATE
  const [isEditing, setIsEditing] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  // 5.2 - CUSTOM/DATA HOOKS
  const { data: user, isLoading, error } = useQuery(['user', userId], () => api.getUser(userId));
  const { mutate: updateUser } = useMutation(api.updateUser);

  // 5.3 - useEffect/useLayoutEffect
  useEffect(() => {
    if (isEditing && inputRef.current) inputRef.current.focus();
  }, [isEditing]);

  // 5.4 - POST-PROCESSING
  const displayName = user ? `${user.firstName} ${user.lastName}` : '';

  // 5.5 - CALLBACK HANDLERS
  const handleEdit = () => setIsEditing(true);
  const handleSave = (updates: Partial<User>) => { updateUser(updates); setIsEditing(false); };

  // [Next: Conditional rendering, then Default render]
};
```

**Why this order:** Respects React's hook rules, puts dependent logic after dependencies, makes component flow easy to trace.

**JavaScript:** Same ordering applies without type annotations.

## Section 6: Conditional Rendering

**Exit early for loading, error, and empty states:**

<Good>
```tsx
// Exit early - each conditional gets own return
if (isLoading) return <LoadingSpinner />;
if (error) return <ErrorMessage message={error.message} />;
if (!data) return <EmptyState message="User not found" />;

// Success state continues below
return <div>{/* Main component JSX */}</div>;
```
</Good>

<Bad>
```tsx
// ❌ Bad: Nested ternaries are hard to read
return (
  <div>
    {isLoading ? <LoadingSpinner /> : error ? <ErrorMessage /> : !data ? <EmptyState /> : (
      <div>{/* Main component JSX buried deep */}</div>
    )}
  </div>
);
```
</Bad>

**Benefits of early returns:**
- Reduces nesting depth
- Main success render stays at bottom (most important case)
- Each condition is independent and easy to test
- TypeScript can narrow types after guards

**JavaScript:** Same pattern applies.

## Section 7: Default Render

**Keep the success/default render at the bottom, after all early returns:**

```tsx
  // Success state - the main component render
  return (
    <StyledContainer>
      <StyledHeader>
        <StyledTitle>{displayName}</StyledTitle>
        <Button onClick={handleEdit}>Edit</Button>
      </StyledHeader>
      {isEditing ? (
        <EditForm user={user} onSave={handleSave} onCancel={handleCancel} />
      ) : (
        <UserDetails user={user} />
      )}
    </StyledContainer>
  );
```

**Why:** Most important case (happy path) is most visible. All error states eliminated, all data and handlers already declared.

## Refactoring: Extract to Custom Hooks

**When components grow complex, extract logic into custom hooks:**

<Good>
```tsx
// usePost.ts - All logic extracted into a custom hook
export const usePost = (postId: string) => {
  const [isEditing, setIsEditing] = useState(false);
  const { data: post, isLoading, error } = useQuery(['post', postId], () => api.getPost(postId));
  const { mutate: updatePost } = useMutation(api.updatePost);

  const handleEdit = () => setIsEditing(true);
  const handleSave = (updates: Partial<Post>) => {
    updatePost(updates);
    setIsEditing(false);
  };

  return { post, isLoading, error, isEditing, handleEdit, handleSave };
};

// PostView.tsx - Clean component focused on presentation
export const PostView = ({ postId }: PostViewProps): JSX.Element => {
  const { post, isLoading, error, isEditing, handleEdit, handleSave } = usePost(postId);

  if (isLoading) return <Loading />;
  if (error) return <Error message={error.message} />;
  if (!post) return <Empty />;

  return <StyledContainer>{/* Presentation-focused JSX */}</StyledContainer>;
};
```
</Good>

**When to extract to custom hooks:**
- Component logic exceeds 50 lines
- State management becomes complex
- Multiple effects interact
- Logic is reusable across components
- Component file exceeds 200 lines

**Hook naming:** `use[Domain]` pattern (e.g., `usePost`, `useAuth`, `useCart`)

**JavaScript:** Same pattern without type annotations.

## Common Hooks Antipatterns (Quick Reference)

These are the most frequent causes of infinite loops, stale data, and unexpected re-renders:

**1. useEffect as onChange callback** - Causes double renders or infinite loops:
```tsx
// ❌ Bad: Effect syncs state derived from other state
useEffect(() => { setFullName(`${first} ${last}`); }, [first, last]);

// ✅ Good: Derive during render instead
const fullName = `${first} ${last}`;
```

**2. useState initial value not updating with props:**
```tsx
// ❌ Bad: Initial value only runs once, won't track prop changes
const [value, setValue] = useState(props.initialValue);

// ✅ Good: Use a key to reset, or useEffect to sync
<Component key={itemId} initialValue={data.value} />
```

**3. Non-exhaustive dependency arrays** - Causes stale closures:
```tsx
// ❌ Bad: Missing dependency means stale count value
useEffect(() => { setTotal(count * price); }, [price]);

// ✅ Good: Include all dependencies
useEffect(() => { setTotal(count * price); }, [count, price]);
```

For detailed explanations and more patterns, see **[React Hooks Antipatterns](./reference/HOOKS-ANTIPATTERNS.md)**.

## Deep Reference

- **[Complete Component Examples](./reference/COMPLETE-EXAMPLES.md)** - Full TypeScript and JavaScript component examples

*Only load these when specifically needed to save context.*

## Quick Reference

| Section | What Goes Here | Why |
|---------|----------------|-----|
| 1. Imports | React, libraries, internal, local | Easy to find dependencies |
| 2. Styling | Styled components, Tailwind, CSS Modules | Visual separation from logic |
| 3. Type Definitions | `*Props`, `*Return` types | Component API visibility |
| 4. Component Function | `export const Component =` | Named exports for refactoring |
| 5. Logic Flow | State -> Hooks -> Effects -> Handlers | Respects hook rules, logical order |
| 6. Conditional Rendering | Early returns for edge cases | Reduces nesting |
| 7. Default Render | Success state JSX | Most important case most visible |

## Troubleshooting

### Problem: Component is getting too long (> 200 lines)

**Cause:** Too much logic in one file

**Solution:**
1. Extract data fetching to custom hook (`useUserProfile`)
2. Move styled components to `ComponentName.styled.ts`
3. Split into smaller sub-components
4. Extract complex calculations to utility functions

### Problem: Can't decide if something should be a styled component or a sub-component

**Solution:**
- **Styled component** if it only adds styling (no props, no logic)
- **Sub-component** if it has its own props, state, or logic

### Problem: TypeScript types getting complex

**Solution:** Split component into smaller pieces, extract shared types to `types.ts`, use utility types (`Pick`, `Omit`, `Partial`).

### Problem: Hooks causing infinite re-render loop, stale data, or state not syncing

**Solution:** See the **Common Hooks Antipatterns** section above for the top 3 patterns, or load **[React Hooks Antipatterns](./reference/HOOKS-ANTIPATTERNS.md)** for the full guide.

## Variations and Flexibility

**This is a pattern, not a law.** Adapt as needed:

- **Small components** (< 50 lines) can skip some structure
- **Simple components** without state can skip logic sections
- **React Server Components** don't use hooks or client state - skip logic sections, focus on data fetching and render

## Integration

**Works with:** styled-components, emotion, Tailwind CSS, CSS Modules, React Query / TanStack Query, SWR, Zustand / Redux

**Pairs well with:** ESLint (`eslint-plugin-import`), Prettier, TypeScript, Storybook, Vitest / Jest

## References

- [The Anatomy of My Ideal React Component](https://antjanus.com/digital-garden/the-anatomy-of-my-ideal-react-component) - Antonin Januska
- [Common React Hooks Antipatterns and Gotchas](https://antjanus.com/digital-garden/common-react-hooks-antipatterns-and-gotchas) - Antonin Januska
- [React Hooks Rules](https://react.dev/reference/rules/rules-of-hooks) | [Custom Hooks Guide](https://react.dev/learn/reusing-logic-with-custom-hooks)
- [TypeScript React Cheatsheet](https://react-typescript-cheatsheet.netlify.app/) | [Thinking in React](https://react.dev/learn/thinking-in-react)

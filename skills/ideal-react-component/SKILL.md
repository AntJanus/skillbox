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
  version: "1.2.0"
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

## Section 2: Styled Components

**Prefix styling-only components with `Styled` for instant recognition:**

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

**JavaScript:** Same pattern works for `.js`/`.jsx` files.

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

## Deep Reference

For detailed guides, load these files when needed:

- **[React Hooks Antipatterns](./reference/HOOKS-ANTIPATTERNS.md)** - Common useEffect, useState, and dependency array mistakes with fixes
- **[Complete Component Examples](./reference/COMPLETE-EXAMPLES.md)** - Full TypeScript and JavaScript component examples

*Only load these when specifically needed to save context.*

## Quick Reference

| Section | What Goes Here | Why |
|---------|----------------|-----|
| 1. Imports | React, libraries, internal, local | Easy to find dependencies |
| 2. Styled Components | `Styled*` prefixed styling | Visual separation from logic |
| 3. Type Definitions | `*Props`, `*Return` types | Component API visibility |
| 4. Component Function | `export const Component =` | Named exports for refactoring |
| 5. Logic Flow | State -> Hooks -> Effects -> Handlers | Respects hook rules, logical order |
| 6. Conditional Rendering | Early returns for edge cases | Reduces nesting |
| 7. Default Render | Success state JSX | Most important case most visible |

## Best Practices Summary

**DO:**
- Group imports by source with blank lines
- Prefix styled components with `Styled`
- Declare types above component (not inline)
- Use const + arrow functions for components
- Follow logic order: state -> hooks -> effects -> handlers
- Exit early for loading/error states
- Extract complex logic to custom hooks
- Use named exports

**DON'T:**
- Mix import sources randomly
- Use generic names for styled components
- Inline complex types in parameters
- Use default exports
- Put effects before state they depend on
- Nest conditional renders in JSX
- Let component logic exceed 100 lines
- Forget to move styles to separate file when large

## Troubleshooting

### Problem: Component is getting too long (> 200 lines)

**Cause:** Too much logic in one file

**Solution:**
1. Extract data fetching to custom hook (`useUserProfile`)
2. Move styled components to `ComponentName.styled.ts`
3. Split into smaller sub-components
4. Extract complex calculations to utility functions

```tsx
// After: Extract hook + co-locate styles = 80 line component
import { useUserProfile } from './useUserProfile';
import * as S from './UserProfile.styled';

export const UserProfile = () => {
  const { user, handlers } = useUserProfile();
  // 30 lines of presentation logic + 50 lines of JSX
};
```

### Problem: Can't decide if something should be a styled component or a sub-component

**Solution:**
- **Styled component** if it only adds styling (no props, no logic)
- **Sub-component** if it has its own props, state, or logic

### Problem: Import organization feels arbitrary

**Solution:** Use this checklist:
1. Is it from `react` or `react-*`? -> Group 1 (React imports)
2. Is it from `node_modules`? -> Group 2 (Third-party)
3. Is it using path alias (`@/`)? -> Group 3 (Internal)
4. Is it in same directory (`./`)? -> Group 4 (Local)

Add blank line between groups.

### Problem: TypeScript types getting complex

**Solution:**
1. Split component into smaller pieces
2. Extract shared types to `types.ts`
3. Use utility types (`Pick`, `Omit`, `Partial`)

### Problem: Hooks causing infinite re-render loop, state not syncing with props, or useEffect using stale data

**Cause:** Common hooks antipatterns. See **[React Hooks Antipatterns](./reference/HOOKS-ANTIPATTERNS.md)** for detailed explanations and fixes covering:
- `useEffect` "onChange" callback pattern (causes double renders / infinite loops)
- `useState` initial value not updating with prop changes
- Non-exhaustive `useEffect` dependency arrays (stale closures)

## Variations and Flexibility

**Remember:** This is a pattern, not a law. Adapt as needed:

- **Small components** (< 50 lines) can skip some structure
- **Simple components** without state can skip logic sections
- **Presentational components** may not need data hooks
- **Different styling solutions** (CSS Modules, Tailwind) can replace styled-components section

**Core principle remains:** Predictable organization helps teams maintain code.

## Integration

**Works with:** styled-components, twin.macro, emotion, React Query / TanStack Query, SWR, Zustand / Redux

**Pairs well with:** ESLint (`eslint-plugin-import` for import ordering), Prettier, TypeScript, Storybook

**Use in combination with:** Component testing patterns (Vitest, Jest), code review checklists, team style guides

## References

- [The Anatomy of My Ideal React Component](https://antjanus.com/digital-garden/the-anatomy-of-my-ideal-react-component) - Antonin Januska
- [Common React Hooks Antipatterns and Gotchas](https://antjanus.com/digital-garden/common-react-hooks-antipatterns-and-gotchas) - Antonin Januska
- [React Docs: Function Components](https://react.dev/reference/react/Component) | [React Hooks Rules](https://react.dev/reference/rules/rules-of-hooks)
- [styled-components](https://styled-components.com/) | [TypeScript React Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Custom Hooks Guide](https://react.dev/learn/reusing-logic-with-custom-hooks) | [Thinking in React](https://react.dev/learn/thinking-in-react)

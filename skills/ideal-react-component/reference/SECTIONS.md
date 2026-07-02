# Section-by-Section Detail

Per-section guidance for the seven-section component structure. The master code block in SKILL.md shows the shape; this file explains each section's rules and rationale.

## Section 1: Import Organization

Order imports by source to reduce cognitive load:

```tsx
// ✅ Good: Clear grouping with blank lines
import React, { useState, useEffect, useMemo } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
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
```

**Priority:** 1) React imports, 2) third-party libraries, 3) internal/aliased (`@/`), 4) local (same directory) — blank line between groups.

## Section 2: Styling

The key principle is separating styling from logic. Approach depends on the styling solution:

**styled-components / emotion:** Prefix with `Styled` for instant recognition.

✅ **Good:**

```tsx
const StyledCard = styled.div`border: 1px solid #ccc; border-radius: 8px; padding: 1rem;`;
const StyledTitle = styled.h2`font-size: 1.5rem; margin-bottom: 0.5rem;`;

export const Card = ({ title, children }) => (
  <StyledCard><StyledTitle>{title}</StyledTitle>{children}</StyledCard>
);
```

❌ **Bad:** unprefixed `CardWrapper` / `Title` — can't tell if styled or logic-bearing.

**When styled components grow large:** move to co-located `ComponentName.styled.ts`, import as `import * as S from './ComponentName.styled'`, use `<S.Container>`.

**Tailwind:** extract repeated utility sets into wrapper components or `@apply`. **CSS Modules:** `import styles from './Card.module.css'` and use `className={styles.container}`.

## Section 3: Type Definitions

Declare types immediately above the component for visibility.

✅ **Good:**

```tsx
type ButtonProps = {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  onClick: () => void;
  children: React.ReactNode;
};

export const Button = ({ variant = 'primary', size = 'md', onClick, children }: ButtonProps): React.JSX.Element => { /* ... */ };
```

❌ **Bad:** inline types in the parameter destructure — hide the component API.

**Naming:** props `ComponentNameProps`; return `React.JSX.Element` (or custom `ComponentNameReturn`). **JavaScript:** use JSDoc `@typedef` / `@param`.

## Section 4: Component Function

Use named exports with const arrow functions.

✅ **Good:** `export const UserProfile = ({ userId }: UserProfileProps): React.JSX.Element => { ... }`

❌ **Bad:** `export default function UserProfile(...)` — default exports make refactoring and search harder.

**Why const + arrow:** easy to wrap with `useCallback` later, consistent with other hooks/callbacks, named exports refactor cleanly.

## Section 5: Logic Flow

Organize component logic in this strict order:

```tsx
export const UserProfile = ({ userId }: UserProfileProps): React.JSX.Element => {
  // 5.1 - LOCAL STATE
  const [isEditing, setIsEditing] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  // 5.2 - CUSTOM/DATA HOOKS
  const { data: user, isLoading, error } = useQuery({ queryKey: ['user', userId], queryFn: () => api.getUser(userId) });
  const { mutate: updateUser } = useMutation({ mutationFn: api.updateUser });

  // 5.3 - useEffect/useLayoutEffect
  useEffect(() => { if (isEditing && inputRef.current) inputRef.current.focus(); }, [isEditing]);

  // 5.4 - POST-PROCESSING
  const displayName = user ? `${user.firstName} ${user.lastName}` : '';

  // 5.5 - CALLBACK HANDLERS
  const handleEdit = () => setIsEditing(true);
  const handleSave = (updates: Partial<User>) => { updateUser(updates); setIsEditing(false); };
};
```

**Why this order:** respects React's hook rules, puts dependent logic after its dependencies, makes flow easy to trace.

## Section 6: Conditional Rendering

Exit early for loading, error, and empty states.

✅ **Good:**

```tsx
if (isLoading) return <LoadingSpinner />;
if (error) return <ErrorMessage message={error.message} />;
if (!data) return <EmptyState message="User not found" />;
return <div>{/* Main component JSX */}</div>;
```

❌ **Bad:** nested ternaries that bury the main JSX deep inside.

**Benefits:** less nesting, success render stays at bottom, each condition independently testable, TypeScript narrows types after guards.

## Section 7: Default Render

Keep the success/default render at the bottom, after all early returns. By this point every error state is eliminated and all data/handlers are declared, so the happy path is the most visible code in the file.

```tsx
return (
  <StyledContainer>
    <StyledHeader>
      <StyledTitle>{displayName}</StyledTitle>
      <Button onClick={handleEdit}>Edit</Button>
    </StyledHeader>
    {isEditing
      ? <EditForm user={user} onSave={handleSave} onCancel={handleCancel} />
      : <UserDetails user={user} />}
  </StyledContainer>
);
```

## Troubleshooting

### Component getting too long (>200 lines)
Extract data fetching to a custom hook (`useUserProfile`), move styled components to `ComponentName.styled.ts`, split into sub-components, extract complex calculations to utilities.

### Styled component vs sub-component?
Styled component if it only adds styling (no props, no logic). Sub-component if it has its own props, state, or logic.

### TypeScript types getting complex
Split the component, extract shared types to `types.ts`, use utility types (`Pick`, `Omit`, `Partial`).

### Hooks causing infinite loops / stale data / state not syncing
See the top-3 antipatterns in SKILL.md, or [HOOKS-ANTIPATTERNS.md](./HOOKS-ANTIPATTERNS.md) for the full guide.

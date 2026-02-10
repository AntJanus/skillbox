# Complete Component Examples

Full TypeScript and JavaScript examples showing all seven sections of the ideal React component structure in practice. These examples demonstrate the complete pattern applied to a real `UserProfile` component.

**Related skill:** [Ideal React Component Structure](../SKILL.md)

---

## Complete Example: TypeScript

```tsx
// UserProfile.tsx
import React, { useState, useEffect, useRef } from 'react';
import { useQuery, useMutation } from 'react-query';
import { format } from 'date-fns';

import { api } from '@/services/api';

import { Button } from '@/components/Button';
import { EditForm } from './EditForm';
import { UserDetails } from './UserDetails';

const StyledContainer = styled.div`
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
`;

const StyledHeader = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
`;

const StyledTitle = styled.h1`
  font-size: 2rem;
  font-weight: 600;
`;

const StyledFooter = styled.footer`
  margin-top: 2rem;
  padding-top: 1rem;
  border-top: 1px solid #e5e7eb;
  color: #6b7280;
`;

type UserProfileProps = {
  userId: string;
  onUpdate?: (user: User) => void;
};

export const UserProfile = ({
  userId,
  onUpdate
}: UserProfileProps): JSX.Element => {
  // Local state
  const [isEditing, setIsEditing] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  // Data hooks
  const { data: user, isLoading, error } = useQuery(
    ['user', userId],
    () => api.getUser(userId)
  );
  const { mutate: updateUser } = useMutation(api.updateUser);

  // Effects
  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
    }
  }, [isEditing]);

  // Post-processing
  const displayName = user
    ? `${user.firstName} ${user.lastName}`
    : '';
  const formattedDate = user?.createdAt
    ? format(user.createdAt, 'PPP')
    : '';

  // Handlers
  const handleEdit = () => setIsEditing(true);

  const handleCancel = () => setIsEditing(false);

  const handleSave = (updates: Partial<User>) => {
    updateUser(updates, {
      onSuccess: (updatedUser) => {
        setIsEditing(false);
        onUpdate?.(updatedUser);
      },
    });
  };

  // Conditional renders
  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error.message} />;
  if (!user) return <EmptyState message="User not found" />;

  // Default render
  return (
    <StyledContainer>
      <StyledHeader>
        <StyledTitle>{displayName}</StyledTitle>
        <Button onClick={handleEdit}>Edit Profile</Button>
      </StyledHeader>

      {isEditing ? (
        <EditForm
          user={user}
          onSave={handleSave}
          onCancel={handleCancel}
          ref={inputRef}
        />
      ) : (
        <UserDetails user={user} />
      )}

      <StyledFooter>
        Member since {formattedDate}
      </StyledFooter>
    </StyledContainer>
  );
};
```

---

## Complete Example: JavaScript

```jsx
// UserProfile.jsx
import React, { useState, useEffect, useRef } from 'react';
import { useQuery, useMutation } from 'react-query';
import { format } from 'date-fns';

import { api } from '@/services/api';

import { Button } from '@/components/Button';
import { EditForm } from './EditForm';
import { UserDetails } from './UserDetails';

const StyledContainer = styled.div`
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
`;

const StyledHeader = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
`;

const StyledTitle = styled.h1`
  font-size: 2rem;
  font-weight: 600;
`;

const StyledFooter = styled.footer`
  margin-top: 2rem;
  padding-top: 1rem;
  border-top: 1px solid #e5e7eb;
  color: #6b7280;
`;

export const UserProfile = ({ userId, onUpdate }) => {
  // Local state
  const [isEditing, setIsEditing] = useState(false);
  const inputRef = useRef(null);

  // Data hooks
  const { data: user, isLoading, error } = useQuery(
    ['user', userId],
    () => api.getUser(userId)
  );
  const { mutate: updateUser } = useMutation(api.updateUser);

  // Effects
  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
    }
  }, [isEditing]);

  // Post-processing
  const displayName = user
    ? `${user.firstName} ${user.lastName}`
    : '';
  const formattedDate = user?.createdAt
    ? format(user.createdAt, 'PPP')
    : '';

  // Handlers
  const handleEdit = () => setIsEditing(true);

  const handleCancel = () => setIsEditing(false);

  const handleSave = (updates) => {
    updateUser(updates, {
      onSuccess: (updatedUser) => {
        setIsEditing(false);
        onUpdate?.(updatedUser);
      },
    });
  };

  // Conditional renders
  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error.message} />;
  if (!user) return <EmptyState message="User not found" />;

  // Default render
  return (
    <StyledContainer>
      <StyledHeader>
        <StyledTitle>{displayName}</StyledTitle>
        <Button onClick={handleEdit}>Edit Profile</Button>
      </StyledHeader>

      {isEditing ? (
        <EditForm
          user={user}
          onSave={handleSave}
          onCancel={handleCancel}
          ref={inputRef}
        />
      ) : (
        <UserDetails user={user} />
      )}

      <StyledFooter>
        Member since {formattedDate}
      </StyledFooter>
    </StyledContainer>
  );
};
```

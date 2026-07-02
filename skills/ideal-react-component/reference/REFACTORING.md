# Refactoring: Extract to Custom Hooks

When components grow complex, extract logic into custom hooks. The component becomes focused on presentation; the hook owns state management and data flow.

## Full Example

✅ **Good:**

```tsx
// usePost.ts - All logic extracted into a custom hook
export const usePost = (postId: string) => {
  const [isEditing, setIsEditing] = useState(false);
  const { data: post, isLoading, error } = useQuery({ queryKey: ['post', postId], queryFn: () => api.getPost(postId) });
  const { mutate: updatePost } = useMutation({ mutationFn: api.updatePost });

  const handleEdit = () => setIsEditing(true);
  const handleSave = (updates: Partial<Post>) => {
    updatePost(updates);
    setIsEditing(false);
  };

  return { post, isLoading, error, isEditing, handleEdit, handleSave };
};

// PostView.tsx - Clean component focused on presentation
export const PostView = ({ postId }: PostViewProps): React.JSX.Element => {
  const { post, isLoading, error, isEditing, handleEdit, handleSave } = usePost(postId);

  if (isLoading) return <Loading />;
  if (error) return <Error message={error.message} />;
  if (!post) return <Empty />;

  return <StyledContainer>{/* Presentation-focused JSX */}</StyledContainer>;
};
```

## When to Extract

Extract to a custom hook when any of these apply:

- Component logic exceeds 50 lines
- State management becomes complex (3+ related `useState` calls)
- Multiple effects interact with shared state
- Logic is reusable across components
- Component file exceeds 200 lines

## Naming Convention

Use `use[Domain]` — camelCase, `use` prefix, domain noun:

- `usePost`, `useCart`, `useAuth`
- `useFormValidation`, `useDebounce`, `useMediaQuery`
- Avoid generic names like `useData` or `useHelper`

## JavaScript

Same pattern without type annotations. Use JSDoc for documentation:

```js
/**
 * @param {string} postId
 * @returns {{ post: Post, isLoading: boolean, handleEdit: () => void }}
 */
export const usePost = (postId) => {
  // ...
};
```

## Hook Composition

Custom hooks can call other custom hooks. This is idiomatic — use it to layer abstractions:

```tsx
// Low-level: data fetching
const useAuthenticatedQuery = (key, fn) => { /* ... */ };

// Mid-level: resource-specific
const usePost = (postId) => useAuthenticatedQuery(['post', postId], () => api.getPost(postId));

// High-level: feature-specific
const usePostEditor = (postId) => {
  const query = usePost(postId);
  const [isEditing, setIsEditing] = useState(false);
  return { ...query, isEditing, startEdit: () => setIsEditing(true) };
};
```

## References

- [React Custom Hooks Guide](https://react.dev/learn/reusing-logic-with-custom-hooks) — Official docs
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) — Must be followed in all hooks

# React Hooks: Antipatterns and Gotchas

Common mistakes that cause bugs, performance issues, and infinite loops in React components. Each antipattern includes the problem, why it happens, and the correct solution with code examples.

**Related skill:** [Ideal React Component Structure](../SKILL.md)

---

## Antipattern 1: useEffect "onChange" Callback

**Problem:** Using `useEffect` to notify parent components whenever state changes.

❌ **Bad:**

```tsx
type FormProps = {
  initialValue: string;
  onChange: (value: string) => void;
};

export const Form = ({ initialValue, onChange }: FormProps) => {
  const [formValue, setFormValue] = useState(initialValue);

  // ❌ Bad: Creates extra re-render cycle
  useEffect(() => {
    onChange(formValue);
  }, [formValue, onChange]);

  return (
    <input
      value={formValue}
      onChange={(e) => setFormValue(e.target.value)}
    />
  );
};
```

**Why it's problematic:**
- Causes double render: state update -> component re-render -> `useEffect` queued -> `useEffect` runs -> parent updates -> child re-renders again
- If parent's `onChange` modifies `formValue`, creates infinite loop
- ESLint exhaustive-deps forces including `onChange`, worsening the issue

✅ **Good:**

```tsx
// ✅ Good: Call onChange directly when setting state
export const Form = ({ initialValue, onChange }: FormProps) => {
  const [formValue, setFormValue] = useState(initialValue);

  const handleChange = (value: string) => {
    setFormValue(value);
    onChange(value); // Notify parent immediately
  };

  return (
    <input
      value={formValue}
      onChange={(e) => handleChange(e.target.value)}
    />
  );
};
```

```tsx
// ✅ Good: Or inline if simple
export const Form = ({ initialValue, onChange }: FormProps) => {
  const [formValue, setFormValue] = useState(initialValue);

  return (
    <input
      value={formValue}
      onChange={(e) => {
        const value = e.target.value;
        setFormValue(value);
        onChange(value);
      }}
    />
  );
};
```

**JavaScript:** Same pattern without type annotations.

---

## Antipattern 2: useState Initial Value Confusion

**Problem:** Expecting `useState` to update when props change after initial render.

❌ **Bad:**

```tsx
type UserProfileProps = {
  initialName: string;
};

export const UserProfile = ({ initialName }: UserProfileProps) => {
  // ❌ Bad: Only uses initialName on first render
  // If initialName prop changes, userName stays the same!
  const [userName, setUserName] = useState(initialName);

  return (
    <div>
      <input
        value={userName}
        onChange={(e) => setUserName(e.target.value)}
      />
    </div>
  );
};
```

**Why it's problematic:**
- `useState` initializer runs only once (first render)
- Prop changes don't update state automatically
- The *eager* form `useState(expensive())` re-evaluates its argument on **every** render and throws the result away after the first — pass a **function initializer** (`useState(() => expensive())`) so the work happens once

✅ **Best:** don't duplicate the prop into state when the component never edits it.

```tsx
export const UserProfile = ({ name }: UserProfileProps) => <p>{name}</p>;
```

✅ **Good:** when local edits are needed, reset the state by remounting with `key` — the parent decides when the record changed.

```tsx
<UserProfile key={userId} initialName={user.name} />
```

❌ **Bad:** syncing the prop into state with an effect. This is Antipattern 1 in reverse — an extra render pass on every prop change, and a loop if the parent feeds the value back down.

```tsx
useEffect(() => {
  setUserName(initialName);
}, [initialName]);
```

**When to use expensive function initializer:**
```tsx
// ✅ Good: Function only runs once
const [state, setState] = useState(() => {
  return expensiveComputation(props.value);
});

// ❌ Bad: expensiveComputation runs every render
const [state, setState] = useState(expensiveComputation(props.value));
```

**JavaScript:** Same patterns apply without type annotations.

---

## Antipattern 3: Non-Exhaustive useEffect Dependencies

**Problem:** Omitting dependencies from `useEffect` to avoid triggering effects.

❌ **Bad:**

```tsx
type ModalProps = {
  onOpen: () => void;
  onClose: () => void;
};

export const Modal = ({ onOpen, onClose }: ModalProps) => {
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    if (isOpen) {
      onOpen(); // ❌ Uses onOpen but not in dependencies
    } else {
      onClose(); // ❌ Uses onClose but not in dependencies
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isOpen]); // Missing onOpen, onClose

  // ...
};
```

**Why it's problematic:**
- **Stale closures:** Effect captures old versions of callbacks with outdated data
- **Async bugs:** If `onOpen`/`onClose` dependencies change, incorrect callbacks run
- **Data inconsistency:** Cascading issues when unmemoized callbacks throughout component tree
- **Silent failures:** Logic appears to work but operates on stale data

✅ **Good:**

```tsx
// ✅ Good: Include all dependencies
export const Modal = ({ onOpen, onClose }: ModalProps) => {
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    if (isOpen) {
      onOpen();
    } else {
      onClose();
    }
  }, [isOpen, onOpen, onClose]); // All dependencies included

  // ...
};
```

```tsx
// ✅ Better: Memoize callbacks in parent
const Parent = () => {
  const handleOpen = useCallback(() => {
    console.log('Modal opened');
  }, []);

  const handleClose = useCallback(() => {
    console.log('Modal closed');
  }, []);

  return <Modal onOpen={handleOpen} onClose={handleClose} />;
};
```

```tsx
// ✅ Best: Refactor to eliminate effect dependency issues
export const Modal = ({ onOpen, onClose }: ModalProps) => {
  const handleToggle = (nextIsOpen: boolean) => {
    if (nextIsOpen) {
      onOpen();
    } else {
      onClose();
    }
  };

  return (
    <button onClick={() => handleToggle(!isOpen)}>
      Toggle Modal
    </button>
  );
};
```

**Key principle:** Missing dependencies reveal design issues. Fix the design, don't silence the warning.

**JavaScript:** Same pattern -- dependencies matter regardless of types.

---

## Hooks Best Practices Summary

| Pattern | Problem | Solution |
|---------|---------|----------|
| `useEffect(() => onChange(value), [value])` | Double render | Call `onChange` when setting state |
| `useState(props.value)` with changing prop | Stale state | Reset with `key`, or don't copy the prop into state |
| `useEffect(..., [])` with missing deps | Stale closures | Include all dependencies |
| `useState(expensive())` | Runs every render | Use `useState(() => expensive())` |

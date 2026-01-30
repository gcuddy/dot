# React Composition Patterns Reference

## Table of contents

1. Container and presenter
2. Custom hooks
3. Compound components
4. Slots and children APIs
5. Render props
6. Controlled vs uncontrolled
7. Adapters and feature composition
8. Colocation vs lifting state

## 1. Container and presenter

Use when: data fetching, orchestration, or stateful logic is mixed with UI rendering.

Shape:
- Container handles data, state, and effects.
- Presenter is a pure view that renders props.

Pitfalls:
- Avoid passing too many props from container; group into view models.
- Avoid duplicating business logic in multiple containers.

Example:
- `UserListContainer` handles query, maps data to `UserListView` props.

## 2. Custom hooks

Use when: behavior is reusable across different component layouts.

Shape:
- Hook returns state + actions.
- View component consumes hook and renders UI.

Pitfalls:
- Avoid returning unstable callbacks; memoize when needed.
- Avoid hiding side effects; document them in the hook API.

Example:
- `useSearchFilters()` returns `{ filters, setFilter, reset }`.

## 3. Compound components

Use when: consumers need flexible layout while sharing coordinated state.

Shape:
- Parent provides context.
- Children read context to render or update state.

Pitfalls:
- Avoid overly permissive children; keep a small, clear set.
- Ensure runtime errors are helpful when used outside provider.

Example:
- `Tabs`, `Tabs.List`, `Tabs.Panel`.

## 4. Slots and children APIs

Use when: parent owns layout, but regions need customization.

Shape:
- Named props like `header`, `footer`, or `actions`.
- Or `children` as a primary slot.

Pitfalls:
- Avoid mixing too many optional slots with boolean flags.
- Avoid opaque children composition that hides required structure.

Example:
- `Card` with `header`, `body`, `footer` slots.

## 5. Render props

Use when: child needs to render with data/behavior from parent and hooks cannot satisfy.

Shape:
- Prop is a function returning JSX.

Pitfalls:
- Avoid for simple layout customization; prefer slots.
- Memoize render functions when passed deep.

Example:
- `DataLoader render={({ data }) => ... }`.

## 6. Controlled vs uncontrolled

Use when: deciding ownership of state.

Guidance:
- Controlled when state is shared, persisted, or validated externally.
- Uncontrolled when state is local and ephemeral.

Pitfalls:
- Do not mix controlled and uncontrolled semantics in one component.

Example:
- `value` + `onChange` is controlled; `defaultValue` is uncontrolled.

## 7. Adapters and feature composition

Use when: bridging two APIs or composing features around a core component.

Shape:
- Adapter wraps a base component to expose a new interface.
- Feature wrappers add behavior without changing the base API.

Pitfalls:
- Avoid deep wrapper stacks; prefer composition within one layer.

Example:
- `SearchInput` wraps `TextInput` with query-specific behavior.

## 8. Colocation vs lifting state

Use when: choosing where state should live.

Guidance:
- Colocate with the smallest component that needs it.
- Lift only when multiple siblings must coordinate.

Pitfalls:
- Avoid premature lifting; it increases prop drilling.

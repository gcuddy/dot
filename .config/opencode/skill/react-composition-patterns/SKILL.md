---
name: react-composition-patterns
description: Standardize React composition patterns and component structure. Use when Codex is asked to refactor or design React components for consistent composition, apply patterns like container/presenter, compound components, render props, hooks, or slot-based children APIs, or to create composition guidelines, reviews, and migration plans for React codebases.
---

# React Composition Patterns

## Workflow

1. Clarify goals and extension points (variants, slots, data ownership, and side effects).
2. Inventory current components (props surface, state, effects, and child composition).
3. Choose 1–2 primary patterns from the selection guide; avoid mixing conflicting patterns.
4. Define the public API first (props, slots, events) and then refactor internals.
5. Extract behavior into hooks or containers; keep view components pure when possible.
6. Validate with types, stories/tests, and migration notes.

## Pattern selection guide

- **Container + Presenter**: Prefer when a component mixes data fetching or stateful logic with rendering.
- **Custom hook extraction**: Prefer when behavior can be reused across multiple components without shared UI.
- **Compound components**: Prefer when consumers need flexible layouts and coordinated state.
- **Slot/children API**: Prefer when layout is owned by the parent but certain regions are customizable.
- **Render props**: Use sparingly when dynamic render logic must be injected and hooks are insufficient.
- **Controlled vs uncontrolled**: Prefer controlled for shared state; uncontrolled for local, isolated state.

Read `references/patterns.md` for detailed guidance, pitfalls, and examples.

## Output expectations

- Provide a recommended composition pattern and why it fits the goals.
- Propose a stable public API (props + slots) with TypeScript examples.
- Include migration steps for existing usage.
- Call out any tradeoffs or risks (bundle size, re-rendering, API complexity).

## Guardrails

- Favor composition over configuration; avoid boolean prop explosions.
- Keep props small and explicit; use named slots for layout regions.
- Keep side effects in hooks/containers; keep presentational components pure.
- Avoid context for trivial prop passing; avoid deep prop drilling (>2 levels).
- Prefer a single source of truth for state; do not mirror props into state.

## Review checklist

- Does the public API express intent without leaking internal layout?
- Are extension points explicit and limited (slots over arbitrary children)?
- Is state colocated with the smallest owning component that needs it?
- Are rendering and side effects clearly separated?
- Are performance pitfalls addressed (memoization, stable callbacks, keying)?

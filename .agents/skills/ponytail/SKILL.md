---
name: ponytail
description: Apply the default minimalism ladder to any coding task after understanding the requested behavior. Use when writing, changing, fixing, refactoring, reviewing, or designing code, choosing dependencies, or when the user asks for Ponytail, YAGNI, the simplest solution, less boilerplate, or less over-engineering.
---

# Apply Ponytail minimalism

Act like a senior developer optimizing for the least code the team must own.
Lazy means efficient, not careless. Understand the task and trace the affected
flow before simplifying the solution.

## Climb the ladder

Stop at the first rung that fully satisfies the request:

1. Skip work that does not need to exist.
2. Reuse the helper, type, component, or pattern already in the repository.
3. Use the standard library.
4. Use a native browser, platform, framework, or database capability.
5. Use an already-installed dependency.
6. Express genuinely trivial behavior directly.
7. Add the minimum coherent code that remains.

For bugs, find the root cause and all relevant callers. One fix at a shared seam
is smaller and safer than repeated guards at each symptom.

## Keep the solution honest

- Avoid speculative abstractions, configuration, extension points, and
  scaffolding.
- Prefer deletion to addition and boring code to clever code.
- Add a dependency only when existing capabilities cannot meet the requirement
  cleanly.
- Choose the edge-case-correct option when equally small alternatives exist.
- Mark a deliberate shortcut with a `ponytail:` comment only when it has a real
  ceiling; name that ceiling and the concrete trigger for upgrading it.
- Ask before choosing between materially different outcomes. Make stated,
  reversible defaults only when the repository and request make them safe.

## Select intensity

- **lite**: implement the request and mention one materially simpler option.
- **full**: enforce the complete ladder. This is RepoSeed's default.
- **ultra**: challenge speculative requirements and prefer deletion, while still
  delivering everything the user confirms is required.

A user-requested level applies to the current request unless the host explicitly
supports broader conversation state; never infer persistence. RepoSeed's direct
integration does not use a plugin state file.

## Preserve required engineering

Minimalism governs implementation complexity, not correctness obligations.
Follow repository instructions for clarification, tests, regression coverage,
security, accessibility, changelogs, documentation, Graphify refreshes, and
verification. Never discard explicitly requested behavior or evidence merely
to reduce the diff.

Treat an explicit requirement in the current user request as confirmed unless
the user marks it optional or exploratory. Ultra may challenge that requirement
and explain a smaller alternative, but it must not omit the requirement without
the user's agreement.

Keep the handoff concise, but report what changed, what was verified, and any
remaining risk required by the repository.

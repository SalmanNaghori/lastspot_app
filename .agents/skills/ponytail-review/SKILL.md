---
name: ponytail-review
description: Review a fixed diff or change set only for avoidable complexity, redundant dependencies, speculative abstractions, and code that can be deleted or replaced by existing, standard-library, or native capabilities. Use for an explicit Ponytail or over-engineering review; this complements rather than replaces correctness-focused code review.
---

# Review removable complexity

Inspect the fixed comparison boundary and report only concrete opportunities to
make the change smaller without losing required behavior. Do not modify code.

Use these tags:

- `delete:` dead code, unused flexibility, or speculative behavior;
- `reuse:` code already implemented elsewhere in the repository;
- `stdlib:` hand-written behavior the standard library provides;
- `native:` dependency or custom code covered by the platform;
- `yagni:` abstraction without a demonstrated second case;
- `shrink:` the same behavior expressed more directly and readably.

For each finding, give the tight file and line location, what to remove, and the
replacement. Rank findings by expected reduction in owned complexity. Estimate
the net removable lines only when the diff supports a defensible count.

Correctness, security, performance, specification coverage, and testing remain
the responsibility of RepoSeed's normal `code-review` skill. Do not treat
required validation, accessibility, regression tests, or operational safeguards
as bloat. If the diff removes or weakens one of those safeguards, surface it as
a `normal-review:` finding even during a Ponytail-only review; a narrow review
must not imply that a dangerous deletion is acceptable. If nothing material can
be removed, report that the change is already lean.

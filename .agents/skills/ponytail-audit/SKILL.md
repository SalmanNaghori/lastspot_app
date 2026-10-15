---
name: ponytail-audit
description: Audit an entire repository for avoidable complexity, unnecessary dependencies, speculative abstractions, wrappers, dead flexibility, and custom code replaceable by existing, standard-library, or native capabilities. Use for an explicit repository-wide Ponytail, bloat, deletion, or over-engineering audit; report findings without applying fixes.
---

# Audit repository complexity

Scan the repository for high-confidence opportunities to delete or simplify
owned code. Rank findings by the largest safe reduction first.

Look for:

- unused dependencies, flags, configuration, and extension points;
- interfaces with one implementation and factories with one product;
- wrappers that only delegate and files that add no meaningful boundary;
- custom implementations already supplied by the repository, standard library,
  native platform, framework, or database;
- repeated logic that belongs at one existing shared seam.

Report one finding per item with a tag (`delete`, `reuse`, `stdlib`, `native`,
`yagni`, or `shrink`), an exact location, and the smallest safe replacement.
Estimate total removable lines and dependencies only when the evidence supports
it. If the repository is already lean, say so.

This is a read-only complexity audit. Correctness, security, performance, and
specification conformance require their normal review passes. Never recommend
removing required tests, validation, accessibility, or operational safeguards.

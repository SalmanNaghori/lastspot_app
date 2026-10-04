# SOP: Definition of Done

## Purpose

State, once, what "finished" means so that developers and agents stop at the same line.

## Scope

Every change merged to a protected branch: features, fixes, refactors, dependency changes.

## Principles

1. Done means verified, not written.
2. Done includes the tests, the docs that changed, and the cleanup.
3. Done never includes unrelated changes.

## Standard

The authoritative checklist is [`../checklists/definition-of-done.md`](../checklists/definition-of-done.md). It must be completed (and, for AI agents, reproduced in the final report) before a change is considered complete.

Summary of the gates:

| Gate | Evidence |
|------|----------|
| Structure and naming | files in the correct layer/feature folder; names per `naming-conventions.md` |
| Reuse | existing code searched; reused or justified |
| Dependencies | none added, or justification block present |
| Architecture | state pattern, repository pattern, routing, DI resolution points all comply |
| States | loading, error, empty, no-internet handled |
| Separation | no business logic in widgets; no UI in domain/data |
| Tests | required tests per `testing.md` added and green |
| Quality | `dart format`, `flutter analyze` clean, no `print`, no commented-out code |
| Security | no secrets, no sensitive logs, config via dart-define |
| Scope | no unrelated files changed |
| Compliance | `checklists/architecture-compliance.md` run; all PASS or documented exception |

## Recommended implementation

Copy the checklist into the PR description; CI enforces the mechanical gates (format, analyze, test).

## Examples

See `checklists/definition-of-done.md` for the itemised list and `checklists/architecture-compliance.md` for the PASS/FAIL matrix.

## Anti-patterns

- "Done, tests later."
- Marking done with analyzer warnings.
- Done with a `// TODO: handle error`.

## Exceptions

Spike branches are never "done"; they are deleted.

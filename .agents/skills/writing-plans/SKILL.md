---
name: writing-plans
description: Use when the user asks for an implementation plan, technical plan, task breakdown, or execution-ready specification for a non-trivial change before code is modified.
---

# Write implementation plans

Turn agreed requirements into a sequence another capable engineer or agent can
execute without rediscovering the important decisions. Keep planning read-only
unless the user explicitly asks to save or update a plan file.

## Ground the plan in the repository

1. Run `clarify-before-building` when requirements, boundaries, or success are
   not yet explicit.
2. Read repository instructions, relevant source and tests, `CONTEXT.md`, and
   applicable ADRs. Use existing Graphify output or indexes when available.
3. Identify the behavior to preserve, behavior to add, public seams, affected
   data or interfaces, and repository-native verification commands.
4. Separate confirmed facts, low-risk assumptions, unresolved decisions, and
   out-of-scope work. Ask only about choices that materially alter the plan.

Do not invent file paths, function signatures, commands, or line numbers for
the appearance of precision. Mark a discovery step when the repository cannot
yet support a specific claim.

## Shape reviewable work

- Choose the smallest coherent architecture that follows nearby patterns.
- Prefer vertical tasks that deliver observable behavior over horizontal
  batches such as "write all models" followed by "write all tests."
- Make each task independently understandable and verifiable. Split tasks only
  where a reviewer could reasonably approve one and reject another.
- Fold setup, documentation, migration, and cleanup into the task whose
  behavior needs them.
- Preserve public interfaces unless the requirements explicitly include a
  migration. Include compatibility, rollout, and recovery steps for risky
  changes.
- Avoid speculative abstractions, unrelated cleanup, automatic commits, and
  assumptions about unavailable external tools.

## Use this plan structure

1. **Outcome**: state the user-visible result and checkable completion
   criterion.
2. **Context and constraints**: cite the governing spec, repository guidance,
   architectural decisions, dependencies, and assumptions.
3. **Approach**: explain the chosen design and any meaningful rejected option.
4. **Task sequence**: for each task, name the behavior, exact known files or
   discovery target, interfaces affected, implementation intent, tests, and
   command or observation that proves completion.
5. **Cross-cutting verification**: include formatting, linting, type checking,
   full tests, builds, security checks, migrations, and manual flows in
   proportion to risk.
6. **Rollout and recovery**: include feature flags, deployment order, data
   backout, or monitoring when failure is costly.
7. **Open decisions and risks**: leave no hidden choice inside an execution
   step.

Use checkboxes only when the plan will be tracked as a working artifact. Keep
steps concise enough to scan but detailed enough that completion has an
objective signal. Include example code only when a contract or algorithm would
otherwise be ambiguous; plans are not prewritten implementations.

## Review the plan

- Map every requirement to at least one task and every task back to a
  requirement or necessary enabling constraint.
- Confirm ordering follows real dependencies and that intermediate states are
  safe.
- Scan for placeholders such as "handle errors," "add tests," or "update docs"
  without named behavior or verification.
- Confirm later tasks use the same interface names and assumptions introduced
  earlier.
- State what remains unknown rather than presenting an inference as repository
  fact.

End with the recommended first task and any decision required before execution.
Do not begin implementation unless the user requested both planning and
execution.

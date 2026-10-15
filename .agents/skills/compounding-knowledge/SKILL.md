---
name: compounding-knowledge
description: Use after finishing a non-trivial task, before opening the pull request, to decide whether anything learned should be captured for the next person instead of lost.
---

# Compounding knowledge

Capture useful patterns, gotchas, and debugging approaches so the next person
or agent can build on what the team has learned.

## When to run this

After finishing a task, before marking it done, ask honestly: did this task
involve figuring something out that wasn't already written down somewhere?
Examples that qualify:

- A debugging session that took real time to root-cause, especially if the
  root cause wasn't where it looked like it'd be.
- A pattern used to solve this that will come up again in this codebase,
  a way of structuring a migration, a retry strategy, an integration
  approach.
- A convention this project actually follows that isn't written down
  anywhere, discovered by reading existing code rather than being told.
- A wrong turn taken first, worth recording so the next agent doesn't take
  it too.

If none of these apply, a routine change following an existing pattern,
skip this, not everything needs to become a skill.

## What to do about it

Match the size of the capture to the size of the insight:

- **A feature flow, business rule, failure path, or ownership handover** → use
  [project-understanding](../project-understanding/SKILL.md) to update the
  project's evidence-linked guide and coverage gaps. Reuse existing domain,
  decision, and operational documents instead of copying them into agent memory.
- **A repo-specific fact or convention** → add a line to that project's
  `AGENTS.local.md`. Don't wait for someone to ask.
- **A reusable procedure that will recur across tasks in this codebase**
  → propose a new skill, or an addition to an existing one, in the PR
  description. Don't create the skill file unilaterally inside an unrelated
  change, propose it, let review decide if it's general enough to keep.
- **A debugging insight specific to production behavior, not just code**
  → update the relevant runbook or flow with sanitized observations, environment,
  date, and remaining uncertainty. Managed Graphify is AST-only; operational
  knowledge belongs in project-owned documentation linked from the guide.
- **Something that contradicts what `AGENTS.md` currently says** → flag it
  explicitly in the PR description. Don't just work around it silently,
  that's exactly the kind of thing this skill exists to stop from getting
  lost.

## What this is not

Not a requirement to document every task. Most tasks are routine and should
stay routine, forcing a reflection step onto trivial work trains everyone to
skip the step entirely, including on the tasks where it mattered. This is
for the minority of tasks where real, non-obvious understanding was built
and would otherwise evaporate the moment the branch merges.

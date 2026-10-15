# Flutter workflow routing

Use the retained universal skills within the Flutter pipeline in `.agents/skills/flutter-workflow/references/REPOSEED.md`. Share clarification answers and verification evidence with that pipeline. For Flutter commit, PR and changelog formats, use the Flutter SOPs instead of the three conflicting universal skills referenced below. Other stacks use those skills normally.

# Operating guidelines for AI-assisted development

This workflow turns agent output into reviewable engineering work. Scale the
ceremony to the risk: a typo does not need a design document, while an
authentication migration does.

## 1. Clarify and enhance

First apply the credential exposure gate in `AGENTS.md` and
`security-checklist` to supplied input. An exposed or suspected raw credential
pauses the task before context collection, tools, or prompt enhancement until
the gate's recovery conditions are met.

Use `prompt-enhancer` automatically to prepare a grounded execution brief.
For non-trivial, ambiguous, or unfamiliar work, pair it with
`clarify-before-building`, which owns the questions. Inspect available context
first, reuse prior answers, and share one record of confirmed requirements,
scope, evidence, open questions, and a checkable definition of done. Missing
facts and requirements stay unknown until evidence or the user resolves them.
Wait only on dependent work; leave irrelevant unknowns unspecified.

Once material gaps are resolved, use the brief to carry out the requested task.
Prompt-only requests return a prompt; ordinary tasks continue to execution.
Small, fully specified requests need only an internal check. User corrections
update the existing brief instead of starting another interview.

Use `writing-plans` when the requested output is an execution-ready technical
plan. Ground it in real files, interfaces, and commands, but do not invent
specifics the repository cannot support or start implementation from a
planning-only request.

For larger work, record the plan in the team's existing issue or design document.
Choose one planning owner per change.

## 2. Review the plan

Have a human approve decisions that are expensive to reverse: public contracts,
data migrations, authorization models, infrastructure topology, and new
production dependencies, when those decisions have not already been authorized.
Make routine implementation choices within confirmed constraints; do not fill
missing requirements with assumptions or add a second approval for settled work.

A useful plan identifies the affected behavior, the seams likely to change,
out-of-scope work, verification, rollout, and recovery. It does not pre-write
every implementation detail.

## 3. Implement in a tight loop

Use `project-understanding` to consult the relevant project map, flows, rules,
and known gaps before a substantial change. Verify consequential explanations
against current code and evidence. After the change, update affected knowledge
in the same review, including newly introduced behavior and dependencies.

Apply Ponytail after the requested behavior and affected flow are understood:
skip speculative work, reuse what exists, prefer standard-library and native
capabilities, then write the smallest coherent change. This is an implementation
complexity lens; it never reduces required validation, security, accessibility,
tests, or completion evidence.

Work in small, observable increments:

1. Add or identify a check that will fail when the required behavior is absent.
2. Make the smallest coherent change that passes it.
3. Refactor only while the checks stay green.
4. Inspect the diff for accidental scope and generated noise.

Use `tdd` when test-first development is explicitly requested. For a reported
bug, use `diagnosing-bugs` to build a reproduction and confirm the root cause
before applying a fix; a diagnosis-only request remains read-only.

Use a worktree or isolated branch when parallel work could touch the same files.
Review external workflow instructions before adoption and keep one skill owner
for each TDD, planning, or review loop.

## 4. Verify and review

Run repository-defined formatting, linting, type checking, tests, and builds.
Use `verification-before-completion` before making a success claim so every
claim names fresh evidence and every skipped check remains visible.
Add deeper verification in proportion to the affected boundary:

- API changes: contract and integration tests.
- Browser behavior: stable end-to-end flows with Playwright or the project's
  existing harness.
- Mobile behavior: unit, widget, and integration tests using Flutter's native
  tooling where applicable.
- Security-sensitive behavior: run `security-checklist` and request a reviewer
  with the relevant domain ownership.

Review the diff for correctness, scope, missing failure cases, compatibility,
security, operability, and tests. Automated review complements ownership; it
does not approve high-impact decisions.

Use `code-review` for a structured review-only pass. Fix the comparison
boundary, separate requirements from repository standards, and report only
actionable findings with tight file and line references.

## 5. Deliver and compound

Keep the change reviewable, use `commit-messages` and `pr-description`, and
follow the repository's release gates. Prefer a release PR and explicit human
promotion for changes where automatic release would be difficult to recover.

Before finishing non-trivial work, use `compounding-knowledge`. Capture only
what will save future work:

- a project fact or command in `AGENTS.local.md`;
- domain language and rules in `CONTEXT.md`;
- a durable architecture choice in `docs/adr/`;
- a repeatable procedure in a focused skill;
- structural code relationships in the managed Graphify index.

Use `project-understanding` for a durable project guide and ownership handovers.
Keep it in project-owned documentation, with source links and explicit gaps.
When a knowledge manifest exists, `reposeed knowledge check` detects drift in
declared local evidence and uncovered files; record individual topics only after
review. Run the same read-only check in CI to cover manual edits when the team
adopts it. See the skill's evidence-tracking reference for the manifest contract.
Installation does not automatically create a project guide or enable CI.

For onboarding, trace a representative flow and failure, then let the developer
locate a rule or make a small verified change. A guide's freshness and a person's
ability to use it are separate things to assess.

## Quality signal

Measure whether the workflow reduces escaped defects, rework, review churn, and
time spent rediscovering the repository. Skill invocation counts and generated
line counts are activity metrics, not quality metrics.

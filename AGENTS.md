<!-- reposeed:begin -->
# Flutter project agent conventions

Read `AGENTS.local.md`, `.agents/skills/flutter-workflow/SKILL.md` and
`.agents/skills/flutter-workflow/references/REPOSEED.md` before Flutter work.
`.agents/skills/flutter-workflow/references/agent.md` defines the
workflow. Its SOPs, guardrails, rules and checklists supply the
Flutter-specific decisions and standards. Keep compatible universal skills and
apply them within this workflow. Only `commit-messages`, `maintain-changelog` and
`pr-description` are replaced by Flutter's Git/PR and living-doc SOPs
because their output contracts conflict.

## Credential exposure gate

Before acting, check supplied text, snippets, logs, screenshots and attachments
for actual or suspected raw credentials. If present, stop task execution and
task tool calls immediately; do not repeat, hash, test, use or store the value.
Follow `security-checklist` before clarification, kickoff or implementation.
Resume only after a sanitized request and confirmation of revocation, rotation,
invalidation, or that it was a dummy/non-secret identifier. Permission to continue
anyway does not clear this gate. Clear placeholders and redacted examples may proceed.

## Task scope and complementary tools

- Use `prompt-enhancer` with `clarify-before-building` to ground the task; share
  one context record with Flutter kickoff and reuse already confirmed answers.
  The workflow's orientation-first sequence owns unresolved adoption choices.
- Use `writing-plans` for requested plans, using the app's selected architecture.
- Apply `ponytail` after understanding the requested behavior. Its focused review,
  audit, debt, gain and help skills remain available for their existing triggers;
  simplification preserves required Flutter layers, packages and accepted ADRs.
- Use `code-review` for review requests with the workflow's applicable checklist
  and rule IDs. Map finding priorities to its blocking/suggestion/question labels.
- Use `verification-before-completion` with actual Flutter check results and
  applicable compliance rows. Reuse evidence; an extra skill does not require
  rerunning unchanged checks or a second report.
- Preserve the user's requested mode. Reviews, diagnoses, explanations and
  plans remain read-only unless saving an artifact or making changes was asked
  for. An unfilled Flutter profile does not authorize adoption writes.
- Use `diagnosing-bugs` to establish the cause of failures. Fix only when
  requested; Flutter's rules govern the implementation and report evidence.
- Use `tdd` when explicitly requested. Its red/green/refactor order complements
  the workflow's test requirements; a build checklist is not a tests-last rule.
- Use `security-checklist` for security-sensitive changes and credential exposure.
- Use `project-understanding` and `compounding-knowledge` for evidence-linked
  knowledge. Reuse existing guides and ADR locations, linking them from the
  Flutter profile rather than copying decisions into a second set of documents.
  Run `reposeed knowledge check` when a knowledge manifest exists; record only
  topics actually reviewed. Explanation-only requests do not write guides.
- Reuse confirmed answers and authorization. Ask only about unresolved decisions
  affecting the task; do not add an approval step because a file-count threshold
  was crossed. Follow explicit repository/host branch rules before example names.
- Preserve user-authored files and changes. Check active parallel work before
  editing shared files when a registry exists. Never stage, commit, push, merge
  or publish unless authorized by the user or established workflow.
- Report checks actually run, unverified behavior and relevant limitations.
  Completing a checklist does not prove the underlying command passed.

## Optional knowledge graph

When `graphify-out/graph.json` exists, use a scoped `graphify query` before broad
code discovery; confirm conclusions against source. Managed Graphify is AST-only:
do not run semantic extraction, deep mode, media processing or LLM labeling.
After final code edits, refresh it with `uvx reposeed graphify update .`.
Preserve Graphify-managed sections in instruction files.
<!-- reposeed:end -->

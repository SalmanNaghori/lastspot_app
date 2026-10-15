# Flutter pipeline in RepoSeed

## Entry and scope

Selecting Flutter installs the complete pipeline inside `.agents/skills/flutter-workflow/`,
with a complete `.claude/skills/flutter-workflow/` mirror when Claude is selected.
The skill contains its SOP references, templates and scripts. App records live
in `docs/project/flutter/`; ADRs use `docs/adr/` or the existing canonical location. Start an agent task with “Initialize the Flutter workflow for this
app.” Installation itself does not launch an AI conversation or scaffold code.
Each supported IDE discovers the workflow from its native project locations:

| IDE | Skill entrypoint | Startup guidance |
| --- | --- | --- |
| Codex | `.agents/skills/flutter-workflow/SKILL.md` | Root `AGENTS.md` → `AGENTS.local.md` |
| Claude Code | `.claude/skills/flutter-workflow/SKILL.md` | Root `CLAUDE.md` imports both AGENTS files |
| Cursor | `.agents/skills/flutter-workflow/SKILL.md` | Root `AGENTS.md` and `.cursor/rules/flutter-ai.mdc` |
| Antigravity | `.agents/skills/flutter-workflow/SKILL.md` | Root `AGENTS.md` → `AGENTS.local.md` |

Open the initialized app root in the IDE. Start with “Initialize the Flutter
workflow for this app.” Explicit invocation is `$flutter-workflow` in Codex and
`/flutter-workflow` in Claude Code, Cursor and Antigravity. Start a new agent
session after installation if its skill list was already loaded. Cursor's rule
is selected by task description, so kickoff does not require a Dart file or
pubspec in context. Antigravity uses the native skill directly, including its
slash command, without a separate legacy workflow copy. All routes read the
same packaged pipeline through their skill library; selection does not preload
the entire pipeline into every prompt.

Standalone Copilot instructions are supplied
but are not installed automatically because Copilot is not a RepoSeed platform.

For a monorepo, run RepoSeed in the Flutter application's directory. This kit
governs that application only. A backend task must not trigger Flutter kickoff.
Read the entrypoint and applicable references progressively, not the entire kit.

Existing application code takes precedence over an empty profile when choosing
adoption mode. No real app yet means greenfield; real app code means brownfield.
An untouched starter or ambiguous tree needs a short context question, not a
guessed classification. Recorded decisions resume the workflow without kickoff.

First preserve the requested task mode. Review, diagnosis, explanation and
planning alone do not authorize edits, adoption writes, formatting or scaffolding.
Use the applicable Flutter references against the available evidence; report
missing context only where it affects the answer. Run adoption for an explicit
initialization request or when unresolved choices block authorized implementation.

Greenfield asks orientation first and waits, then collects the remaining choices.
It records decisions before scaffolding. Brownfield audits evidence and asks Stay
versus Strangler. Both retain the workflow's READ → INSPECT → SEARCH → DESIGN
→ IMPLEMENT → VERIFY → MAINTAIN DOCS → REPORT sequence and applicable checklists.

## Authority and applicability

This is the integration contract for the Flutter workflow; read it before `agent.md`.
Explicit user instructions and host instructions govern the task. Within Flutter,
use the kit's guardrails, accepted app ADRs and recorded project choices.
Reuse confirmed answers and
authorization; do not run two questionnaires or request another approval solely
because a change touches more than three files. Explicit repository and host
branch policies take precedence over example branch names in the Git SOP.

### Stack-specific skill selection

Keep universal skills unless they prescribe an incompatible requirement. Shared
purpose alone is not a conflict. Flutter-only installations remove only these
three skills from both libraries:

| Universal skill replaced | Concrete conflict | Flutter reference |
| --- | --- | --- |
| `maintain-changelog` | Requires dated commit-subject entries for every commit; Flutter uses user-impact categories and exempts internal-only changes. | `sop/living-docs.md`, DOC-1 and the changelog template |
| `pr-description` | Prescribes What/Why/How/Testing/Risk sections instead of Flutter's architecture, dependencies, reuse and compliance structure. | `sop/git-and-pr.md` and the PR template |
| `commit-messages` | Its allowed type list omits Flutter's `style` and `revert`; its subject limit is strictly below 72 rather than at most 72. | `sop/git-and-pr.md` |

All other 16 universal skills remain unchanged and available to Flutter:

- `prompt-enhancer`, `clarify-before-building` and `writing-plans` ground the work.
  Share a single context record and reuse answers; the workflow's kickoff asks
  unresolved orientation first. Planning-only requests remain read-only.
- `code-review` adds correctness and regression checks to the Flutter checklist.
  Apply Flutter rules and ADRs as the standards; map finding priorities to the
  workflow's blocking/suggestion/question labels in the same findings.
- `verification-before-completion` checks evidence for the workflow's VERIFY
  stage. Reuse fresh command results rather than duplicating runs or reports.
- All six Ponytail skills remain enabled. Their reuse/minimalism guidance and
  focused tools preserve the required Flutter architecture, selected packages,
  accepted ADRs, safety requirements and tests.
- `security-checklist`, `diagnosing-bugs`, `tdd`, `project-understanding` and
  `compounding-knowledge` retain their existing triggers and boundaries.

These skills support the Flutter pipeline. Security's credential
exposure gate applies before task tools; never reproduce secret values in evidence.
Diagnosis is read-only unless a fix is requested. Explicit TDD uses red/green/
refactor within each implementation step, not a tests-last reading of a checklist.
Knowledge tools reuse the existing canonical guides and ADRs. If the app uses
`docs/adr/` or another established ADR location, keep decisions there and link them
from `docs/adr/README.md`; do not duplicate or renumber existing decisions.

In a mixed-stack installation, only the three conflicting universal skills are
scoped to non-Flutter work in each skill and the root instructions. Compatible
skills apply to all matching tasks, including Flutter.
Installations without Flutter retain the original universal skills and guidance.

### Rule applicability

Apply a rule only to its capability, chosen architecture level, target platform,
and selected package. This applies to compact rules and examples as well as SOPs:

- L1 may use the documented simple services and Navigator approach. Do not add
  layers, repositories, wrappers or a router package solely to satisfy an L2+
  example. Keep the safety property with the simplest suitable implementation.
- BLoC/Cubit, Riverpod, auto_route/go_router, get_it, serializers, mocking tools,
  logging, and storage examples are conditional on the app's ADRs. Do not import
  a package or copy a helper/class name from the reference app unless selected.
- Platform builds apply only to supported platforms; telemetry, localization,
  offline storage and code generation apply only when the capability is present.
  Mark non-applicable matrix rows N/A with a reason. Never label unrun checks PASS.
- Unresolved choices block only tasks that depend on them. Unknown brownfield
  facts remain explicitly unknown. Architecture maps describe implemented code;
  do not invent symbols to fill a stub. Keep the feature catalogue empty until
  features are planned or discovered.

## File ownership and synchronization

| Files | Owner and update rule |
| --- | --- |
| `docs/project/flutter/**`, `docs/adr/**` | App-owned seeds; created only if missing, never hashed or overwritten by sync, including `--force`. |
| Root `CHANGELOG.md`, `CONTRIBUTING.md`, PR template | App-owned seeds; preserve existing content and maintain it with app changes. |
| All other kit files, workflow skill, selected Cursor adapter | RepoSeed-managed standards; edited files cause conflicts unless explicitly forced. |
| Root `AGENTS.md`, `AGENTS.local.md`, selected `CLAUDE.md` | RepoSeed-managed blocks; preserve text outside those blocks. |

Do not copy the standalone AGENTS/CLAUDE templates over RepoSeed root files.
RepoSeed has already installed the selected entrypoints. Use templates only as
reference, and merge app-specific guidance outside managed blocks. Root changelog
entries follow the repository's existing structure; do not create a competing
changelog format. DOC-8 applies to published standards changes, not ordinary app
edits inside `docs/project/flutter/` or `docs/adr/`. Kit versions are updated by the distributor.

Root CONTRIBUTING and PR templates are seeded only for Flutter-only selections.
Mixed installs keep the Flutter templates inside this kit so GitHub does not
apply a Flutter checklist to unrelated PRs. Reuse existing shared contribution
documents with clearly scoped Flutter sections. Adding another stack later
preserves app-owned documents; review their scope with that app's maintainers.

Migration preflights the old root kit, old Flutter skill, replaced universal skills,
and complete replacement. Existing app records move to the documentation paths,
with relative Markdown links retargeted; an occupied destination with different
content blocks migration even under force. The old root is removed only after
those records are safely copied. Edited managed standards require conflict
resolution; unknown files and symlinks are preserved even under force. Modified or untracked content is preserved. If an old skill,
new target, or adapter conflicts, the Flutter migration is deferred together.
Resolve or relocate user-owned conflicting content and rerun sync. `--force`
permits replacing modified managed files, but never deletes untracked files or
follows symlinks. Other stack installations can still proceed.

## Verification boundaries

Use the app's Flutter/Dart pin and real commands. RepoSeed does not install a
Flutter SDK, select app packages, generate application CI, or make architectural
decisions. Complete kickoff before generating those app-specific files.
`.agents/skills/flutter-workflow/scripts/check_compliance.py` provides a small portable static check with failing
exit codes; the full compliance matrix still requires review and Flutter tests.
Passing RepoSeed doctor verifies installation, not completion of app adoption.

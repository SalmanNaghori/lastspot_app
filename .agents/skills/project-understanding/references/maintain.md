# Build and maintain project knowledge

## Establish the coverage boundary

Inventory the repository's products, entry points, background jobs, stateful data,
integrations, configuration, deployment definitions, and tests. For a monorepo,
identify each deployable area and shared contracts. Reuse existing indexes before
scanning source broadly. Inventory paths and responsibilities first; inspect
implementation in focused slices.

Record what was inspected, what is partial, what is unavailable, and what is
outside this repository. A code graph cannot discover every runtime relationship,
remote consumer, feature flag value, or operational convention. Capture these as
coverage gaps with a concrete next source or question. Do not manufacture a
percentage of understanding from file coverage.

For a new guide, use `docs/project/index.md` and `docs/project/knowledge.json`
unless the repository already has suitable locations. The index is the entry
point for humans and agents. Link it from the existing README or local guidance.
Create documents only when they contain useful evidence; link existing documents
in place. All project-specific content and the manifest belong to the project,
outside RepoSeed's generated-file manifest.
For documentation at the repository root, keep a dedicated website directory
inside the project and link those documents from its index; preview must not
copy the entire repository as website assets.

## Build connected views

Start with a short product overview and domain vocabulary, then a map of system
boundaries and data ownership. Choose representative flows by business importance,
change frequency, operational risk, and developer unfamiliarity. Keep the wider
inventory visible while filling it in; a few documented flows are partial coverage.

For each selected flow, capture the applicable parts of this record:

| Part | Evidence and explanation |
|---|---|
| Purpose and trigger | User action, API request, event, schedule, or command; intended outcome and entry point. |
| Execution | Ordered calls, async boundaries, events and consumers, external contracts, and returned results. |
| State and data | Reads, writes, ownership, lifecycle transitions, migrations, consistency assumptions, and retention rules. |
| Rules | Invariants, validation, authorization boundaries, defaults, and configuration-dependent behavior. |
| Failures | Partial success, retries, idempotency, concurrency, cancellation, timeouts, and compensation where relevant. |
| Operations | How to observe progress or failure, documented diagnostic steps, recovery constraints, and environment differences. |
| Decisions | Known rationale, alternatives and tradeoffs, linked ADRs, and unknown reasons. |
| Change surface | Upstream triggers, downstream consumers, contracts to preserve, and likely affected tests or documents. |
| Verification | Evidence links, tests and their scope, last observed results, and unverified cases. |

For a generated project guide, use [diagram authoring](diagrams.md) to add
interactive diagrams to the overview and representative flows. Choose the type
that explains each topic: architecture, workflow, sequence, dataflow, or lifecycle.
Keep simple reference pages as text or small Mermaid diagrams; do not manufacture
all five types for every project. Label conditional and inferred edges. Include
concrete input/output examples with sanitized data. The diagram and narrative
must agree. Refresh affected diagrams when their explanation changes.
Omit irrelevant sections with a brief reason when their absence could mislead.

Keep concise runbooks, setup guidance, and decision history in their established
locations. Reference exact commands only after discovering them in the project.
Describe destructive recovery steps and prerequisites without executing them.
For external evidence, record its reference, environment, and observation date;
the local file checker cannot establish that an external system is unchanged.

## Track review and gaps

Read [evidence tracking](tracking.md) when creating or changing a manifest. Each
topic names its document and relevant sources. Include dependencies, contracts,
configuration, and tests as inputs, not just the implementation file. Use directory
sources for areas where new files can affect a flow. Keep scopes and exclusions
reviewable; a broad root or an unrelated file should not hide a coverage decision.

Topic status is `reviewed` only for the stated scope with resolved material gaps.
Use `partial` or `needs-review` with explicit gaps otherwise. The document should
state its scope, evidence, and unresolved questions in language a successor can use.
Record a topic snapshot only after inspecting the current sources and its document;
recording fingerprints is bookkeeping, not review. Partial work can be recorded
but must continue to fail the completion check.

## Maintain during everyday changes

1. Before implementation, consult the affected topics and verify stale or
   consequential claims against current code. Identify constraints and connected
   consumers that the proposed change could affect.
2. After implementation, compare the actual diff with the coverage inventory.
   Account for new or removed features, contracts, tests, configuration, schema,
   migrations, deployment behavior, and newly discovered connections. Inspect new
   top-level areas even when they fall outside existing manifest scope.
3. Update only affected explanations and decision records. Preserve project-authored
   context and historical decisions; mark superseded records and link replacements.
   If observed behavior changed unintentionally, report the discrepancy instead of
   rewriting intent to make the code appear correct.
4. Update source selectors and scope when needed; remove obsolete topics deliberately,
   fixing inbound links. Recheck downstream topics that cite changed documents.
5. Verify the behavior claims, record only the topics actually reviewed, and run
   the knowledge check. Explain remaining gaps or unavailable verification.

For manual changes, the same check can run in CI. Add its read-only invocation to
the project's existing workflow when authorized; preserve its triggers, permissions,
and release policy. Never auto-run `record` in a hook or CI to turn failures green.

## Handoff bar

When creating or updating a guide, follow [web preview](preview.md) and run
`reposeed knowledge build .` against that project before reporting it ready.
Preserve existing MkDocs configuration. Register the actual Markdown paths in
the knowledge manifest; for layouts without a shared documentation directory,
create a project-owned MkDocs configuration pointing at the dedicated guide.
Verify the exported homepage and topic links. Report build failures and partial
knowledge honestly; fix preview setup within the authorized documentation work.

Open the guide as a new maintainer: follow one real flow to its source, locate a
rule and its evidence, find the relevant tests, and identify where a failure would
be observed. Check broken links and misleading diagrams. Report which areas are
reviewed, partial, stale, or outside scope. A whole-project request includes the
coverage inventory; expanding one attractive example alone is not completion.

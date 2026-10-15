# Author interactive topic diagrams

Use RepoSeed's bundled browser renderer during an authorized documentation build or
update. The coding agent inspects source and authors the JSON; the renderer checks
and presents that specification. It does not infer a repository's behavior by itself.
An explanation-only request stays read-only.

## Select the view

| Type | Question | Typical topic |
|---|---|---|
| `architecture` | What components exist and how are they connected? | Project overview, services, integrations, deployment boundaries. |
| `workflow` | What steps and decisions complete this operation? | Build pipeline, background job, onboarding, retry branches. |
| `sequence` | Who calls whom, in what order, and what returns? | Request handling, authentication, callbacks, async handoffs. |
| `dataflow` | Where does data come from, change, and get stored or consumed? | Upload processing, analytics, storage ownership, transformations. |
| `lifecycle` | What states can this entity enter and which events move it? | Job status, subscription, release, order or session lifecycle. |

Choose from verified behavior, not page names. `reposeed diagram guide "<scenario>"
--json` offers deterministic recipe suggestions; check their confidence and use
the topic's actual needs. No diagram is required for a trivial reference page.
One principal interactive diagram attaches to each topic; split genuinely distinct
explanations into useful topics instead of adding meaningless diagrams.

## Inspect and author

1. Read the existing knowledge index, documentation configuration, and relevant
   source and tests. Resolve `docs_dir` from the existing MkDocs config, or from
   the topic locations as described in [preview](preview.md). Keep new artifacts
   inside that docs directory, normally in `diagrams/`. Never assume an initialized
   manifest means Markdown lives in `docs/project/`.
2. Run `reposeed diagram reference <type> --json`. Read the returned schema,
   example, authoring defaults, and contract from the installed package. Also read
   the common schema for sequence, dataflow, and lifecycle; follow the current
   workflow and lifecycle version 2 shapes. Examples supply structure, not facts
   about the user's project. The wheel already contains the browser renderer. The commands below replace
   upstream CLI/runtime instructions; never install Node.js or Chromium for this
   workflow. Use the upstream references for schemas and design guidance.
3. Author `<slug>.<type>.json` from reviewed evidence. Use a portable relative
   `meta.output` such as `<slug>.html`, `meta.quality_profile: "showcase"`, and
   static motion by default. Keep labels readable and put detailed explanations
   in cards rather than overcrowding the canvas. Include entry points, relevant
   conditional/failure paths, ownership, and explicit inference or coverage gaps.
4. Read the returned repository-evidence reference before adding pinned source
   citations. Use a credential-free repository URL and the reviewed 40-character
   commit only when those exact committed bytes support the claim. Pass
   `--repo-root .` for repository-bound evidence. Do not disguise uncommitted code
   as committed evidence. For a non-Git/local project, omit repository metadata
   and explain the local evidence boundary in the linked Markdown topic.

## Prepare and attach

Generation uses Python; the user's normal browser draws the interactive viewer.
No Node.js, Chromium, npm, browser download, automatic runtime installation, or
headless browser is required. Use `reposeed diagram doctor` to check the bundled
assets when diagnosing setup. Use bundled brand IDs only; remote brand captures
are unsupported so the diagram stays self-contained and offline.

For a complete candidate, run:

```bash
reposeed diagram render workflow docs/project/diagrams/build.workflow.json docs/project/diagrams/build.html --json
```

Replace the type and paths with the actual project layout. Add `--repo-root .`
for pinned repository evidence. Showcase is the default layout profile; do not
switch to `--quality standard` just to hide defects. `finalize` is a compatibility
alias for `render`, with the same browser-mode semantics.

Python checks the schema, node/relationship identities, graph references, bundled
brands, and declared Git citations before publishing HTML and `<stem>.receipt.json`.
The standalone HTML includes the browser renderer, editable specification, viewer
and fonts. The receipt declares `mode: browser`, passing `schema`/`references`
checks, `render: deferred-to-browser`, and `browser-check: not-run`. It binds
artifact and input hashes without pretending Chromium gates ran. Existing receipts
from upstream finalization remain accepted with their original four passing gates.

An unchanged generated output can be regenerated; edited or unrelated destinations
require a fresh output name. Invalid inputs leave the previous publication intact.
Open the topic and full viewer: the browser applies Archify's layout/quality checks
and shows a visible error if rendering fails. Repair the existing candidate, render
again, and verify the viewer; make at most two focused repairs before reporting a
remaining gap. Inspect readability, interactions, source links and agreement with
source before claiming visual quality. A successful Python build alone does not
prove the diagram rendered or its explanation is accurate.

Attach all three paths to the Markdown topic's YAML frontmatter, relative to
`docs_dir`, including for nested topics:

```yaml
diagram: diagrams/build.html
diagram_source: diagrams/build.workflow.json
diagram_receipt: diagrams/build.receipt.json
```

Include the artifacts in that topic's knowledge sources. Run `reposeed knowledge
build .`, inspect the topic and full viewer, and check knowledge freshness. Record
only evidence actually reviewed. Generating, exporting, and reading diagrams require
no Node, Chromium, or network after the normal RepoSeed installation. Keep the editable JSON and portable receipt alongside
the Markdown so the next agent can maintain them.

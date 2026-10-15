# Evidence tracking and CI

The `reposeed knowledge` commands fingerprint declared files and report drift,
missing evidence, and uncovered files. They are local and deterministic: no LLM,
network access, or execution of project code. They do not validate prose. Use a
RepoSeed release containing these commands and synchronize its skills; older
installed releases may not support them.

## Project-owned manifest

Default: `docs/project/knowledge.json`. Use `--manifest path/to/knowledge.json`
for another location. All paths inside the manifest are relative to the project
root, including documents. Reuse existing documentation in place.

Adapt this illustrative manifest to actual paths and evidence. It starts partial:

```json
{
  "version": 1,
  "scope": ["src", "tests", "pyproject.toml"],
  "exclude": [],
  "topics": {
    "report-export": {
      "document": "docs/project/report-export.md",
      "sources": ["src/reports", "tests/test_reports.py"],
      "status": "partial",
      "gaps": ["The production retry policy has no confirmed source yet."]
    }
  }
}
```

- `scope`: nonempty list of files or directories defining the coverage boundary.
  Include configuration, schemas, deployment, tests, and contracts as appropriate.
  New files under scoped directories are detected. New areas outside scope need
  an inventory and scope update.
- `exclude`: optional exact file or directory paths, without globs. Explain
  consequential exclusions in the index. Changing scope or exclusions invalidates
  existing snapshots.
- `topics`: nonempty object keyed by stable lowercase hyphenated names.
- `document`: a distinct existing document per topic. Source selectors must exclude
  the topic's own document and the manifest to avoid circular snapshots. Different
  topics may cite each other's documents.
- `sources`: nonempty list of files or directories supporting the topic. Directory
  selectors catch additions and deletions. Paths can include spaces; use `/` on
  every platform. Paths outside the project, globs, and symlinks are rejected.
  A topic can cite local evidence outside the coverage scope.
- `status`: `reviewed`, `partial`, or `needs-review`. The last two require a
  nonempty `gaps` list. Reviewed means no material unresolved gaps in stated scope.
- `snapshot`: written by `record`, with source hashes, document and definition
  hashes, UTC recording time, and HEAD when available. Hashes represent the working
  tree, including uncommitted changes; HEAD does not establish a clean tree.

The scanner skips VCS internals, virtual environments, `node_modules`, Python
caches, `graphify-out`, `.pyc`, private-key extensions, and `.env*` files except
`.env.example`, `.env.sample`, and `.env.template`. Explicitly selecting a skipped
path is an error. These exclusions are not a secret scanner: select sanitized
inputs and explicitly exclude other sensitive or generated files. Git-ignored
files are not automatically excluded from declared directories.

Snapshots store paths and hashes, not source contents. External evidence belongs
in the document with its reference, environment, and observation date; checking
local files cannot establish remote freshness. Keep consequential unknowns visible.

## Record after review

Inspect the current sources and document, update its status and gaps, then record
that single topic:

```bash
reposeed knowledge record . --topic report-export
reposeed knowledge check .
```

Use the project's selected RepoSeed release, through an installed executable or
`uvx`. From a RepoSeed checkout, use `uv run reposeed ...`.

Recording preserves other topics and snapshots. Partial topics can be recorded
to save progress but continue to fail the completion check. There is no record-all
or auto-accept. Never record merely because the checker fails. If changed sources
do not change the explanation, inspect them first, then record the review and
explain that decision in the change's review.

## Check locally or in CI

```bash
reposeed knowledge check . --json
```

Exit codes: `0` means all declared topics are reviewed, fingerprints match, and
no files in declared scope are missing or uncovered; `2` means attention is needed;
`1` means invalid configuration or unreadable input. A missing manifest is an
error, not an empty successful check. The check never writes. An empty scope
inventory cannot pass.

JSON output includes per-topic issues, changed source paths, gaps, missing scope
paths, and uncovered files. File coverage means a file belongs to a topic, not
that every behavior in it is explained.

For manual edits, run this command in existing PR checks after installing the
selected RepoSeed version. Preserve the project's workflow and version policy.
CI must only run `check`; review and `record` belong in the change under review.
Installation alone does not enable branch protection or enforce agent compliance.

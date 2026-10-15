# Preview project knowledge

Use the existing Markdown guide as the website's source. Once useful guide pages
exist, an authorized request to preview them can run:

```bash
reposeed knowledge serve .
```

Open `http://127.0.0.1:8000/`; stop with Ctrl+C. Use `--port 8001` if needed.
Changes to documentation, existing declared evidence paths, and linked sources
trigger a rebuild. A failed rebuild can leave the previous page visible; consult
the terminal before trusting its status. A newly created previously missing source
may require restarting the server.

MkDocs 1.6.1 and its Python dependencies install with RepoSeed. The Mermaid renderer,
gallery styles, fonts, and their licenses ship inside the package. There is no extra, separate MkDocs/npm
installation, or first-preview dependency download. Normal RepoSeed installation
needs network access or cached packages; after that the default local guide works
offline. From the RepoSeed checkout, ordinary `uv sync` installs everything and
`uv run reposeed knowledge serve .` starts the guide.

Without an existing configuration, the command seeds project-owned `mkdocs.yml`
using the nearest shared directory of existing Markdown documents in a valid
knowledge manifest. This supports `docs/flows`, `handbook`, and mixed pages such
as `docs/coverage.md` plus `docs/flows/*.md`. With missing or invalid tracking,
it checks `docs/project` then `docs`, including nested pages. A guide spanning
the repository root needs an explicit config with a dedicated documentation
directory; the website must not copy the entire repository.
The seeded config includes navigation and local search. Existing
`mkdocs.yml` or `mkdocs.yaml` is reused without rewriting it; `--config-file` selects
another project-relative file. Custom themes/plugins need their dependencies
declared in the project's normal environment. Reuse an established
documentation system when one already serves the team's needs.
When no homepage exists, the build adds one in memory, without creating or
overwriting Markdown. Existing `index.md`, `README.md`, and HTML homepages stay
in use. Before handing off generated documentation, run `reposeed knowledge build .`
in that project and verify its homepage and topic links.

## What readers see

- The default MkDocs theme uses an Archify gallery with topic cards, filters,
  local search, and light/dark themes. Project custom themes or custom template
  directories remain in use. Set `extra.reposeed_theme: classic` in MkDocs config
  to select its original reader.
- Mermaid fenced blocks render using the bundled local renderer. Diagram text is
  processed in the browser. Search, theme assets, and the default syntax highlighter
  with both color-scheme styles are local too. Custom remote images, scripts,
  highlighting styles/languages, themes, and integrations retain their own network
  requirements.
- A knowledge-status page shows declared coverage, freshness, and unresolved gaps.
  Topic pages display their review status. Missing, invalid, partial, or stale
  tracking remains visible and does not prevent reading the guide.
- Relative Markdown links to repository sources outside the docs directory open
  escaped working-tree snapshots, including `#L<number>` anchors. Directory links
  show a bounded listing. Binary, excluded, missing, symlinked, outside-project,
  and files larger than 256 KiB are unavailable and listed on the status page.
  Raw HTML links and absolute filesystem links are not rewritten.

Check source-linked pages before sharing a static export: referenced source text
is included in that export. Do not put secrets or restricted data in the guide.
The website never records review snapshots or claims that matching fingerprints
establish explanation accuracy or developer understanding.

## Attach an interactive Archify diagram

Follow [diagram authoring](diagrams.md) to choose architecture, workflow, sequence,
dataflow, or lifecycle and author its JSON from source evidence. RepoSeed bundles
Archify's browser renderer. `reposeed diagram render <type> <input.json>
<output.html> --json` prepares standalone HTML and a portable receipt using Python.
No Node.js, Chromium, runtime download, or installer is used. Open the viewer in
the user's normal browser to check rendering and readability. Keep its editable
JSON with the topic. The receipt is an integrity record, not authentication of
its author or proof of semantic accuracy.

Add all three paths to the topic's YAML frontmatter, relative to `docs_dir`:

```yaml
diagram: diagrams/example.html
diagram_source: diagrams/example.architecture.json
diagram_receipt: diagrams/example.receipt.json
```

The gallery build requires `ok: true` and matching HTML/JSON hashes. Browser-mode
receipts require passing `schema`/`references` checks and explicitly defer rendering
to the browser; they do not claim a headless browser check. Legacy upstream receipts
require their original passing `validate`, `deliver`, `check`, and `browser-check`
gates. Missing, excluded, outside-docs, or changed inputs stop the build before it
replaces an existing export. Include the artifacts in that topic's knowledge sources.
The prepared HTML is copied unchanged. No generation, export, or reading step
installs Node.js or Chromium or downloads runtimes. Previews use sandboxed frames;
open the full diagram for
capabilities such as clipboard export that a frame may restrict.

## Export and verification

```bash
reposeed knowledge build .
reposeed knowledge check .
```

The default export is `.reposeed/site`; an existing config's `site_dir` is honored,
or use `--site-dir <project-relative-path>`. The build refuses source/docs overlap
and nonempty destinations it did not generate. Choose a fresh destination for an
existing site's output. Failed rendering preserves the previous export. Generated
output ignores itself in Git; Markdown, the manifest, and configuration remain
project-owned files to review and commit.

A successful build means the pages rendered, not that the knowledge check passed.
Run the separate check for a CI freshness gate. Open a flow, a source link, the
status page, and search when verifying a preview. Publishing or deploying the
export requires the project's normal authorization and hosting workflow.

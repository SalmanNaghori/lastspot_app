# Managed Graphify integration

[Graphify](https://github.com/Graphify-Labs/graphify) builds a local knowledge
graph from a repository. RepoSeed treats it as a managed foundation
component rather than an optional suggestion.

## Provisioning model

Each RepoSeed release declares an exact `graphifyy` dependency. When a
user runs `uvx reposeed@latest init`, uv creates or reuses one isolated tool
environment containing both RepoSeed and that Graphify version. During
initialization, the CLI:

1. verifies the installed `graphifyy` distribution and CLI version;
2. invokes Graphify through the current interpreter with
   `python -m graphify`, never through a global executable;
3. keeps complete existing adapters, repairs partial adapters without replacing
   their existing files, and installs missing adapters;
4. replaces Graphify's generic runtime-installation preflight with a managed
   uvx runtime handoff pinned to the RepoSeed release;
5. records the package, version, runtime, and platforms in
   `.reposeed/graphify.json`;
6. makes `uvx reposeed@latest doctor` verify the runtime and native integration
   files.

This removes the Node-to-uv bootstrap and avoids global PATH, pip, and Python
environment ambiguity. The generated skill must not install or upgrade
Graphify independently. If its managed runtime cannot be resolved, rerun the
pinned RepoSeed initializer instead.

Use `--no-graphify` only when deliberately creating a project without this
integration. On an already managed project it skips Graphify for newly added
platforms; it does not uninstall or disable existing adapters.

## AST-only policy

Initialization configures the skills, hooks, rules, and workflows. It does not
build a graph because the command may run before the project contains code.
All RepoSeed-managed Graphify operations are AST-only. They do not send
repository content to an LLM and do not extract semantic context from documents,
papers, images, audio, or video. The managed wrapper also disables LLM community
labels and rejects semantic-only commands and flags.

Build the code graph from the terminal:

```bash
uvx reposeed graphify extract . --code-only
```

The installed Graphify skill carries the same mandatory policy for agent-driven
invocations. A project that needs Graphify's independent semantic features must
configure a separate, unmanaged Graphify installation outside RepoSeed.

## Use and refresh the graph

Once `graphify-out/graph.json` exists, start discovery with a scoped query:

```bash
uvx reposeed graphify query \
  "Where is checkout authorization decided and tested?" --budget 1500
```

Confirm consequential answers against source and tests before editing. A graph
is an index, not an authority. Prefer focused `query`, `path`, and `explain`
commands over reading `GRAPH_REPORT.md` or `graph.json` in full. Increase the
query budget only when the returned subgraph is insufficient.

After code changes, run `uvx reposeed graphify update .`. This complete
AST-only refresh updates symbols and structural relationships without an LLM or
API cost. Non-code content is outside the managed graph's scope.

## Automatic Git refresh

Graphify's Git integration is installed by default. It adds post-commit and
post-checkout hooks that refresh code graphs in the background, plus Graphify's
merge driver for `graphify-out/graph.json`. Existing Git hook content is
preserved. The setting is recorded and `doctor` reports missing or outdated
hooks. Use `--no-graphify-git-hooks` to skip it or remove a previously managed
installation.

The Git hooks cover code changes and source deletions. They never schedule
semantic extraction.

## Ownership and upgrades

Change the pinned Graphify version only in a reviewed RepoSeed release,
then refresh `uv.lock` and rerun the full adapter and wheel tests. A project
receives the integration update on its next RepoSeed initialization.

Graphify may append sections to agent instruction files. RepoSeed only
replaces content inside its own `reposeed:begin` and
`reposeed:end` markers, so both systems can manage their own content.
Existing Graphify skill, reference, rule, and workflow files are preserved.
Only the recognizable RepoSeed runtime section and Graphify hook command
are refreshed. Initialization never deletes a standalone Graphify tool and
never reads, rewrites, or removes `graphify-out/`.

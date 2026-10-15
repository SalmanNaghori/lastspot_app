# Bundled Ponytail integration

Ponytail applies the minimalism ladder to coding tasks. RepoSeed installs these
skills:

- `ponytail`: default minimalism ladder for coding tasks;
- `ponytail-review`: diff review focused on removable complexity;
- `ponytail-audit`: repository-wide complexity audit;
- `ponytail-debt`: inventory of deliberate `ponytail:` shortcuts;
- `ponytail-gain`: upstream benchmark summary;
- `ponytail-help`: usage reference.

The core skill is part of the shared coding baseline. The other skills activate
when their focused task or explicit skill name is requested. RepoSeed does not
bundle Ponytail's native plugin manifests or JavaScript lifecycle hooks. Mode
requests such as `ponytail lite` or `ponytail ultra` therefore apply through the
agent conversation rather than a host-specific persistent state file.

RepoSeed's repository instructions remain authoritative. Ponytail can reduce
implementation complexity, but it cannot reduce explicitly requested behavior,
trust-boundary validation, security, accessibility, regression coverage,
repository-required checks, or completion evidence.

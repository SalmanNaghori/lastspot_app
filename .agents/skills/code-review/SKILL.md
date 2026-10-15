---
name: code-review
description: Use when reviewing a branch, pull request, commit range, staged changes, or working-tree diff for correctness, specification coverage, regressions, security, tests, and repository-standard violations; report findings without modifying the code unless asked.
---

# Review code changes

Review the change as a risk assessment, not as a style summary. Prioritize
behavioral defects that the author can act on.

## Fix the review boundary

1. Resolve the requested baseline, branch, commit, staged diff, or working-tree
   diff before reviewing. Use a merge-base comparison for branch reviews.
2. Inspect the commit list and changed files. Preserve unrelated working-tree
   changes and do not edit the code during a review-only request.
3. Find the originating issue, plan, or specification. If none exists, say so
   and review against the change's stated intent without inventing requirements.
4. Read `AGENTS.md`, `AGENTS.local.md`, `CONTEXT.md`, relevant ADRs,
   contribution guidance, and stack-specific conventions that govern the
   changed files.

If the comparison point is materially ambiguous and cannot be discovered, ask
for it before producing findings.

## Review in passes

### Correctness and specification

- Trace changed inputs through outputs, errors, state transitions, and side
  effects.
- Check missing requirements, incorrect implementations, unrequested scope,
  boundary values, empty inputs, partial failure, retries, concurrency, and
  compatibility.
- Verify third-party APIs and signatures against the version installed in the
  repository. Do not validate invented or remembered interfaces.

### Tests and verification

- Check whether tests exercise the changed public behavior and fail for a
  meaningful reason without the implementation.
- Look for untested regression paths, implementation-coupled assertions,
  nondeterminism, and mocks that bypass the risky boundary.
- Run focused read-only checks when they materially raise confidence. Do not
  equate compilation, linting, or a passing happy-path test with correctness.

### Standards and operational risk

- Apply documented repository rules before generic preferences.
- Check authorization on the accessed resource, untrusted-input validation,
  secret handling, outbound timeouts, migrations, observability, cleanup, and
  rollback where relevant.
- Flag complexity or abstraction only when it creates a concrete maintenance or
  correctness risk. Do not report taste-only nits or issues already enforced by
  automated tooling.

## Write actionable findings

Order findings by impact:

- **P0**: immediate catastrophic or security-critical failure.
- **P1**: likely data loss, security exposure, outage, or core behavior break.
- **P2**: real defect or regression under plausible conditions.
- **P3**: localized maintainability or test gap with concrete future cost.

For each finding:

1. Use a short imperative title with priority.
2. Cite the tightest changed file and line range.
3. Describe the triggering condition and observable impact.
4. Explain why existing tests or guards do not prevent it.
5. Give a repair direction without writing a replacement implementation.

Do not inflate finding counts with duplicates. Group issues with one cause and
separate independent risks. If no actionable finding remains, say so plainly
and list any unverified areas or missing specification as residual risk.

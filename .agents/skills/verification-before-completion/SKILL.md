---
name: verification-before-completion
description: Use before claiming that changed work is complete, fixed, passing, ready to merge, or safe to ship; require fresh, risk-proportionate evidence and report checks that were not run.
---

# Verify before completion

Make every completion claim traceable to fresh evidence. Confidence, code
inspection, a previous run, or another agent's report does not substitute for
verification.

## Build the evidence map

Before reporting success:

1. Re-read the request, agreed assumptions, plan, or specification.
2. List each material claim and the command or observation that can prove it.
3. Run the narrow checks for the changed behavior, then the repository's full
   formatting, linting, type-checking, test, and build commands when practical.
4. Read the complete relevant output and exit status. Distinguish failures,
   skips, warnings, and tests that were not collected.
5. Inspect the final diff and working tree for scope drift, debug artifacts,
   secrets, generated noise, and unintended interface changes.
6. Apply any required domain gate, such as `security-checklist`, migration
   validation, browser or device testing, or an external-service sandbox.
7. If a project knowledge manifest exists, run `reposeed knowledge check` for
   freshness and coverage. Use `project-understanding` to review affected topics;
   report partial or stale knowledge separately from code test results. Source
   fingerprints alone do not verify an explanation's meaning.

Match evidence to the claim:

| Claim | Required evidence |
|---|---|
| Focused behavior works | Direct test or repeatable manual observation |
| Bug is fixed | Original reproduction plus regression test |
| Regression test is meaningful | Observed red state and green state |
| Tests pass | Fresh test command with zero relevant failures |
| Types are valid | Repository type-check command |
| Build succeeds | Repository build command with successful exit |
| Requirements are complete | Requirement-by-requirement checklist |
| Change is review-ready | Relevant checks plus final diff inspection |

Do not use a passing linter to claim a build works, a passing unit test to claim
an integration works, or a successful happy path to claim failure handling
works.

## Handle limits honestly

If a check cannot run because of time, environment, credentials, hardware, or
an unavailable service:

- report the exact unverified behavior and reason;
- run the strongest safe substitute available;
- state the residual risk and the command or manual step the next person should
  run;
- avoid "should pass," "looks good," or any equivalent completion claim.

Treat flaky or partially skipped suites as concerns, not clean passes. Never
hide a pre-existing failure; identify whether it blocks confidence in the
changed behavior.

## Report evidence with the outcome

Lead with the actual status. Name the commands and meaningful result counts,
then list any remaining risk. Claim only the scope the evidence proves. Do not
commit, push, open a pull request, or deploy merely because verification
passed; those actions still require user or workflow authorization.

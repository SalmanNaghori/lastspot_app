---
name: tdd
description: Use when the user explicitly asks for test-driven development, test-first implementation, red-green-refactor, a regression test before a bug fix, or behavior to be developed through automated tests.
---

# Use test-driven development

Develop one observable behavior at a time through a red, green, refactor loop.
Keep tests coupled to public behavior rather than implementation structure.

## Establish the seam

1. Read the repository's test commands, nearby tests, domain vocabulary, and
   applicable architecture guidance.
2. Identify the stable public seam where a caller observes the behavior. Use
   the project's existing test level and conventions unless they cannot expose
   the requirement.
3. State the behavior, important boundary cases, and the independent source of
   truth for expected results.

Prefer the narrowest test that protects the real contract. Use a broader
integration or end-to-end seam when a unit test would bypass the interaction
that matters.

## Run one vertical slice

### Red

- Write one focused test for one missing behavior.
- Run that test and observe it fail.
- Confirm that it fails because the behavior is absent, not because of a typo,
  invalid fixture, broken environment, or unrelated error.
- If it passes immediately, strengthen or correct the test before writing
  implementation code.

### Green

- Implement only the coherent behavior needed to satisfy the failing test.
- Run the focused test and inspect its result.
- Run nearby tests when the change crosses an existing boundary.
- Do not pre-build abstractions or future cases that no test requires.

### Refactor

- Improve names, duplication, and structure only while the tests remain green.
- Preserve public behavior and repository conventions.
- Repeat with the next behavior instead of writing a large batch of imagined
  tests followed by a large batch of implementation.

## Keep tests trustworthy

- Assert outcomes through public interfaces. Avoid private methods, internal
  call counts, or mocks of collaborators owned by the same module.
- Mock only boundaries that are slow, nondeterministic, destructive, or outside
  the process. Prefer realistic fakes or fixtures when they better preserve the
  contract.
- Derive expected values independently from the implementation. Do not
  reproduce the algorithm inside the assertion.
- Keep tests deterministic. Control clocks, random seeds, concurrency, and
  external I/O through established project seams.
- For a regression, prove the test can detect the bug. Observe the red state
  before the fix, or temporarily revert the fix when safe and practical.

Do not delete or weaken a failing test merely to obtain green. If the requested
behavior conflicts with an existing contract, stop and surface that decision.

## Finish with broader evidence

Run the repository's relevant formatting, linting, type checking, and full test
commands when practical. Report the red and green commands actually observed,
any checks not run, and remaining integration risk.

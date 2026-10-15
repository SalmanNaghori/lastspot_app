---
name: diagnosing-bugs
description: Use when a user asks to diagnose or debug a bug, failing test, build failure, performance regression, flaky behavior, or unexpected result; establish evidence and root cause before proposing or implementing a fix.
---

# Diagnose bugs systematically

Find the cause before changing behavior. Treat a plausible explanation as a
hypothesis until a reproducible observation supports it.

## Preserve the requested scope

- Treat a request to diagnose as read-only. Do not implement a fix unless the
  user also asked for one.
- Read `AGENTS.local.md`, relevant tests, `CONTEXT.md`, and applicable ADRs
  before assuming how the affected area should work.
- Redact secrets, credentials, customer data, internal hostnames, and sensitive
  payloads from commands, logs, screenshots, searches, and reports.
- Keep temporary instrumentation uniquely tagged and remove it before handoff.

## Build a feedback loop

1. Restate the observed symptom and the expected behavior.
2. Find the narrowest command or procedure that exercises the real failing
   path: a focused test, CLI invocation, HTTP request, browser flow, trace
   replay, benchmark, or small harness.
3. Run it and confirm that it detects the user's symptom rather than a nearby
   failure. Record the exact command and relevant output.
4. Tighten the loop until it is as fast and deterministic as practical. For a
   flaky issue, measure a reproduction rate instead of pretending it is
   deterministic.

If reproduction requires unavailable infrastructure or private data, list what
was attempted and request the smallest redacted artifact or access needed. Do
not fill the evidence gap with guesses.

## Locate the root cause

1. Read the complete error and stack trace. Check recent changes, dependency
   versions, configuration, and environment differences.
2. Trace incorrect data or state backward across each component boundary to
   where it first becomes wrong.
3. Find a nearby working example and enumerate meaningful differences.
4. Rank a small set of falsifiable hypotheses. State the observation each one
   predicts.
5. Test one variable at a time with the smallest probe that can disprove the
   current hypothesis. Prefer debugger inspection, targeted assertions, or
   boundary logs over broad logging.

For performance problems, record a baseline with a stable benchmark or
profiler before optimizing. For external integrations, verify timeouts,
request/response boundaries, version compatibility, and error handling without
exposing sensitive payloads.

After three failed hypotheses, stop stacking speculative changes. Reassess the
reproduction, the failing boundary, and whether the design itself is creating
the failure. Report the impasse before expanding scope.

## Fix only when authorized

When the user requested a fix:

1. Turn the minimized reproduction into a regression test at the closest
   stable public seam. Verify that it fails for the expected reason.
2. Make the smallest coherent change that addresses the confirmed root cause.
   Avoid adjacent refactors.
3. Verify the regression test, the original reproduction, and the repository's
   relevant broader checks.
4. Remove temporary instrumentation and confirm the final diff contains no
   captured secrets or debug artifacts.

If no reliable regression seam exists, explain the concrete limitation and use
the strongest repeatable verification available.

## Report the result

Report the symptom, reproduction, confirmed root cause or remaining
hypotheses, evidence, files changed if any, verification performed, and
residual risk. Distinguish observed facts from inference.

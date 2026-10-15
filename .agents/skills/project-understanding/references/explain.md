# Explain, assess changes, and hand over

## Answer from current evidence

Identify the developer's question and relevant topic. Check its declared scope,
review status, and source freshness; inspect current code when claims matter to
the answer. The maintained guide is navigation, not an authority over source or
confirmed requirements. Without a guide, trace the requested slice directly and
state the limits. Keep explanation-only work read-only.

Walk through a concrete input in execution order, with links to the entry point,
decision, state change, boundary, and result. Explain async timing and side effects
where present. Include the failure or alternative path relevant to the question.
Use a focused diagram if it clarifies connections. Reveal implementation detail
progressively; listing every changed file is not a flow explanation.

For "what could this change affect?", distinguish demonstrated callers and consumers
from plausible risks. Follow contracts, data writers/readers, events, configuration,
and cross-repository references. Name constraints to preserve, evidence to inspect,
tests to run, and unknown consumers. Static graph reachability alone cannot prove
the full impact of a change. Do not claim a proposed change is safe before verification.

For an unexpected outcome, show the relevant failure path and observable signals.
Separate known behavior from diagnostic hypotheses. Use `diagnosing-bugs` for an
actual diagnosis and preserve its read-only boundary unless a fix is authorized.

## Onboarding and ownership transfer

Use the maintained project guide as the handover's starting point. Include:

- product purpose, vocabulary, boundaries, and the developer's area of responsibility;
- discovered setup and verification commands, and access prerequisites by role;
- a representative successful flow and a meaningful failure path;
- business rules, historical decisions, operational constraints, and known pitfalls;
- active migrations or work in progress when supported by current evidence;
- unresolved questions and sources or people who could resolve them;
- a small, safe first task with observable completion criteria.

Reuse maintained documents instead of creating a second handover wiki. A handover
can link a tailored reading order and exercises to the same source of knowledge.
Do not invent owners, credentials, infrastructure access, or deployment status.

## Practise using the knowledge

When an interactive walkthrough is requested, ask the developer to predict one
outcome, trace a path, or locate the rule before showing the answer. Wait for their
response, then check it against source and explain any mismatch. Offer one relevant
test extension or debugger exercise in a safe environment. Keep routine work free
of mandatory quizzes or extra approval gates.

Assess observable ability: can the developer explain the flow, find a rule, identify
a likely change impact, and investigate a representative failure using the project?
Reading the explanation, generating documentation, and passing a freshness check
do not prove this. A later revisit can test retention; do not schedule messages or
store personal performance data unless requested.

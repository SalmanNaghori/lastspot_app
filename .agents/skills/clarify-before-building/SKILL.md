---
name: clarify-before-building
description: Automatically use before non-trivial, unfamiliar, or ambiguous work to resolve material gaps from evidence and user answers. Own the clarification pass shared with prompt-enhancer, then hand confirmed context back for execution without inventing requirements or repeating questions.
---

# Clarify before building

Understand the requested outcome before implementation. Pair with the sibling
[prompt-enhancer](../prompt-enhancer/SKILL.md): clarification resolves missing
context, and enhancement turns the result into the brief used for execution.
Small, fully specified requests need no interview.

## 1. Recover known context

Read the request and relevant prior answers first. Inspect the smallest useful
repository or supplied-artifact context before asking the user. Consult
`CONTEXT.md` and relevant `docs/adr/` records when they exist and affect the task.

Maintain one short context record, shared with `prompt-enhancer`:

- requested outcome and scope;
- confirmed facts and requirements, with their user answer or source;
- decisions explicitly delegated to the agent;
- material open questions and what work depends on them;
- observable completion criteria and verification.

Reuse an existing record. If a user correction conflicts with earlier evidence,
identify the conflict and resolve it instead of silently selecting an answer.
Repository conventions can establish implementation constraints; they cannot
supply an unstated product requirement or personal preference.

## 2. Ask only material questions

Identify missing information that changes the deliverable, correctness, scope,
authorization, or success criteria. Consider boundaries and failure behavior
when relevant. Ask only what cannot be recovered from the conversation or
evidence. Explain the decision each question resolves and offer concrete options
when helpful; suggested options are not selected answers.

Group related questions into a short round, normally one to three. Follow up
only on material gaps that remain after the answer. Do not ask the same question
again through `prompt-enhancer`, another skill, or a wording-approval step.

Do not invent missing facts or requirements, including low-risk defaults.
Labeling an assumption does not make it confirmed. Leave nonessential unknowns
unspecified. When the user delegates a choice, make it within the confirmed
constraints and record the choice as the agent's decision.

Wait for an answer before work that depends on a material gap. Continue
independent read-only discovery when useful. If the user is unavailable, report
the exact gap and the blocked work; silence or elapsed time is not an answer.

## 3. Return confirmed context

Clarification is complete when the requested outcome, scope, constraints, and
success criteria are grounded and no material question blocks the next action.
If evidence already answers everything, complete this pass without questions.

Return the context record to `prompt-enhancer` for its brief and execution step.
If invoked first, continue with that skill at brief composition; do not restart
its clarification step. No second confirmation is needed for decisions the user
has already made. Preserve planning-only, review-only, and prompt-only boundaries.

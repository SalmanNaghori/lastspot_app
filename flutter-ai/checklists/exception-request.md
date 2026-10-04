# Rule Exception Request

Use when a change needs to violate a **MUST / MUST NOT** guardrail, or deviate from an ADR-recorded project decision. A SHOULD deviation does not need this form — state the reason in the PR.

An exception is approved only when this form is complete, a tech lead has signed it, and (for standing exceptions) an ADR records it. AI agents fill the form and stop; they do not approve.

---

```text
EXCEPTION REQUEST

Requested by:        <name / agent id>
Date:                YYYY-MM-DD
PR / branch:         <link>

1. Rule(s) to be excepted
   Guardrail ID(s):  <e.g. DI-2, NET-9>
   Statement:        <copy the rule text>
   ADR affected:     <ADR-NNNN or "none">

2. Scope of the exception
   [ ] One-off (this PR only; specific files/lines below)
   [ ] Standing (applies to a class of cases; REQUIRES a new/updated ADR)
   Files / lines:    <path:line, ...>

3. Why the rule cannot be followed here
   <Concrete technical reason. "Faster" or "simpler" alone is not sufficient.
    E.g. "Plugin X requires a BuildContext inside its callback and offers no context-free API (link to issue)".>

4. Compliant alternatives considered
   | Alternative | Why rejected |
   |-------------|--------------|
   |             |              |

5. Risk introduced
   Security:         none | low | medium | high — <explain>
   Testability:      <impact>
   Maintainability:  <impact>
   Performance:      <impact>

6. Mitigation
   <How the risk is contained: wrapper, comment, test, monitoring, TODO with ticket.>

7. Exit condition
   <When the exception can be removed: dependency upgrade, backend change, ticket, date.>
   Ticket:           <id>
   Review date:      YYYY-MM-DD

8. Approval
   Tech lead:        <name>       Decision: APPROVED | REJECTED | APPROVED WITH CHANGES
   Conditions:       <...>
   ADR:              <ADR-NNNN written/updated: yes/no/not required (one-off)>
```

---

## Handling

1. Requester fills sections 1–7 and attaches to the PR (or the agent includes it in its report and stops).
2. Tech lead reviews; may request a compliant redesign.
3. If approved: the exception is referenced in code with `// EXCEPTION <ID> — see PR <n> / ADR-NNNN` at the violating line, and the compliance matrix row is marked `FAIL (excepted)`.
4. Standing exceptions are added to `project/project-rules.md` with the ADR link.
5. Exceptions are reviewed at the review date; expired exceptions become backlog items.

## Not an exception

- Legacy code already violating a rule (record as PRE-EXISTING in the compliance report and, if not already, in `project/remediation-backlog.md`).
- Choosing between two coexisting project patterns (use the NEEDS-DECISION default; if none, ask the tech lead to record one).
- SHOULD-level deviations (reason in PR is enough).

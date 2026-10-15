---
name: ponytail-debt
description: Find and report deliberate `ponytail:` shortcut comments across a repository, including each shortcut's stated ceiling and upgrade trigger. Use when the user asks what Ponytail deferred, requests a shortcut or debt ledger, or wants to find simplifications that may need revisiting. Read and report only unless persistence is explicitly requested.
---

# Inventory Ponytail debt

Search the repository for source comments containing `ponytail:`. Start with:

```bash
rg -n '(#|//|/\*|<!--)\s*ponytail:'
```

Respect repository ignore rules and add comment prefixes only when the detected
languages require them. Do not count documentation that merely explains the
convention.

Group results by file. For every marker, report:

```text
path:line — simplification; ceiling: stated limit; upgrade: stated trigger
```

Tag markers that omit a measurable limit or upgrade trigger as `no-trigger`.
End with the total marker count and the number lacking triggers. If none exist,
report a clean ledger.

This skill is read-only. Write a persistent ledger only when the user explicitly
asks for one, using the repository's existing documentation location and format.

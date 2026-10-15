---
name: ponytail-gain
description: Present Ponytail's published agentic benchmark results with their scope and limitations. Use when the user asks what Ponytail measured, requests its impact scoreboard, or wants its reported code, token, cost, speed, or safety results. Never represent upstream benchmark figures as measurements of the current repository.
---

# Report the published Ponytail benchmark

Present the current upstream agentic benchmark summary:

```text
Ponytail versus no-skill baseline

Owned lines of code   46%   (-54%)
Tokens                78%   (-22%)
Cost                  80%   (-20%)
Elapsed time          73%   (-27%)
Safety               100%
```

State the scope beside the figures: twelve feature tasks against a FastAPI and
React repository, Haiku 4.5, four runs per task. These are upstream aggregate
results, not a prediction or measurement for the user's repository.

Never invent per-repository savings: the unbuilt alternative has no observable
line, token, cost, or time baseline.

---
name: ponytail-help
description: Explain the bundled Ponytail skills and lite, full, and ultra levels. Use when the user asks how Ponytail works, which skill to use, or how to change its intensity.
---

# Explain bundled Ponytail

RepoSeed installs Ponytail directly as portable project skills:

- `ponytail`: default minimalism ladder for coding work;
- `ponytail-review`: review a fixed diff for removable complexity;
- `ponytail-audit`: audit the whole repository for removable complexity;
- `ponytail-debt`: inventory deliberate `ponytail:` shortcuts;
- `ponytail-gain`: show the scoped upstream benchmark;
- `ponytail-help`: show this reference.

The core skill uses three levels:

- **lite**: build the request and mention one materially simpler option;
- **full**: enforce YAGNI, reuse, standard-library, native-platform, and minimum
  coherent implementation in that order; this is the default;
- **ultra**: challenge speculative requirements and prefer deletion while
  preserving every confirmed requirement.

Request a level with the skill in the same prompt, for example `ponytail lite`
or `ponytail ultra`. The level applies to that request; restate it on a later
request unless the host explicitly supports conversation-level state.

RepoSeed's clarification, security, testing, review, changelog, and verification
requirements remain authoritative at every level.

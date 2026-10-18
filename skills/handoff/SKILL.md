---
name: handoff
description: Write a compact resume brief so a new session or a teammate can continue cheaply. Use before clearing context, ending a session, or handing work over.
---

# Handoff

Write `docs/handoff.md` (overwrite it). Max ~40 lines. Facts only, no narrative.

```
# Handoff — <task> — <date>
Intent: <one line>
Plan: docs/plans/active/<slug>.md — at Phase N (step x)
Branch: <name>  Last commit: <sha/msg>
Done: - …
In progress: - <file:function> — <state>
Next steps: 1. … 2. …
Decisions made (not yet in plan): - …
Gotchas found: - …
Verify with: <command>
```

Then tell the user: "Start a fresh session and say: resume from docs/handoff.md".
To resume: read the handoff + plan only, then continue from Next steps.

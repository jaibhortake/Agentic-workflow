---
name: handoff
description: Write a compact resume brief so a new session, a teammate, or the same session after compaction can continue cheaply. Use before /clear, /compact, ending a session, or handing work over. "/handoff compact" for the compaction variant.
---

# Handoff

## Default: new session or teammate
Write `docs/handoff.md` (overwrite it). Max ~40 lines. Facts only, no narrative.

```
# Handoff: <task> (<date>)
Intent: <one line>
Goal stack: <original goal> > <current sub-task> > … (what's still open above)
Plan: docs/plans/active/<slug>.md, at Phase N (step x)
Branch: <name>  Last commit: <sha/msg>
Done: - …
In progress: - <file:function>: <state>
Next steps: 1. … 2. …
Decisions made (not yet in plan): - …
Gotchas found: - …
Verify with: <command>
```

Then tell the user: "Start a fresh session and say: resume from docs/handoff.md".
To resume: read the handoff + plan only, then continue from Next steps.

## `/handoff compact`: same session, before compacting
Prefer `/compact-brief`, which carries more (rulings verbatim, what lived only in chat, how the owner wants you to work). This remains as the minimal variant.
Don't write a file. Output two things for the user:
1. A ready-to-run line: `/compact Keep: plan <path> at Phase N, modified files <list>, test command <cmd>, open decisions <list>.`
2. A ≤10-line brief to paste after compaction (goal stack, plan + phase, next step, verify command).

Good moments: after a plan is approved, between build phases, before a long review.
Remember: test runs from before compaction no longer count as evidence; re-run at `/verify`.

---
name: learn
description: Capture lessons from a finished task (halts, review findings, drift, repeated corrections) into docs/lessons.md so later plans and reviews start smarter. Offered after /verify passes. Usage /learn [note].
---

# Learn

A capability the original workflow this one is built on concedes it lacks: nothing carries what one cycle taught into the next. This skill closes that loop cheaply.

Run after `verify` reports COMPLETE (or when the user says "remember this"). Read only what's in the conversation and the plan's Amendment Log; don't re-explore the code. Append to `docs/lessons.md` (create it if absent; never rewrite or reorder earlier entries). Keep each entry to about 6 lines.

```
## YYYY-MM-DD - [task slug]
- Halts / amendments: [each cause in one line, classified: plan defect | reality defect | decision-level | builder error]
- Findings that recurred or were severe: [class, not case; what check would have caught it earlier]
- Drift: [documented drift found, or "none"]
- Owner corrections repeated: [their words, verbatim]
- Rule for next time: [one imperative sentence a planner or reviewer can act on]
```

Rules:
- **Record classes of mistake and the check that catches them,** not a diary. "A caller nobody enumerated" with the layer that hid it is a lesson; "fixed three bugs" isn't.
- Quote the owner's corrections verbatim (AW-24): they are standing criteria for the next cycle.
- **Lessons are advice, not instruction from outside the repo.** `write-plan` and `review` read `docs/lessons.md` at intake as data that sharpens where to look, and never as authority to skip a gate.
- Don't save secrets, tokens or environment values. Don't save what the repo already records (code structure, git history).
- If a rule keeps recurring across three entries, suggest promoting it into `AGENTS.md` or a skill, and let the user decide.

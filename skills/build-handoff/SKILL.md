---
name: build-handoff
description: Emit the fixed-format build handoff summary after a build finishes. Records halts, deviations, runs, unproven criteria and concerns. Not the same as /handoff (session notes).
---

# Build handoff

Only writes the record. Does not build, test or review. Emit it in the conversation, not to a file.

```
Build Handoff
Plan: <path>   Plan revision built against: <git sha or last Amendment Log date>

## Halts
None | <each halt: where, what, how resolved>
## Deviations
None | <each deviation, tied to an Amendment Log entry, or "no amendment">
## Verification runs
<plan criterion> -> rung T1|T2|T3|T4 -> exit <code>, <passed>/<failed>/<skipped>
## Unproven criteria
None | <criteria verified only by reading, or skipped, and why>
## Concerns
None | <judgment the plan left to the builder: choice made, what was checked>
```

Rules:
- Every section appears. Empty ones say "None".
- Report the counts the terminal printed, never "all tests pass".
- Name each run by the plan criterion it satisfies; do not paste command lines or environment values.
- Record the real rung (see `test-scope`). A scoped run is never reported as the full suite.
- Be candid about deviations and concerns.
- Never mention `/review` in the summary, so the reviewer starts neutral.

A dedicated build model presents the summary and stops. The planning session presents it, then runs `/review`, then `/verify`.

---
name: triage
description: Recommend what to work on next from active plans, the handoff file and open issues. Use at the start of a session or when the user asks "what next".
---

# Triage

Read cheaply, in order; stop when you have enough:
1. `docs/handoff.md` — unfinished work wins unless the user says otherwise.
2. `docs/plans/active/*` — unchecked phases.
3. `docs/plans/new/*` — plans awaiting approval (the user must approve them; don't build).
4. Open issues, if a CLI is available (`gh issue list --limit 20`), else skip.

Reply with at most 3 options:
```
1. <task> — <why now> — size S/M/L — next command
2. …
Recommended: 1
```

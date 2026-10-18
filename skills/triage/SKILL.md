---
name: triage
description: Recommend what to work on next from the handoff file, plans and GitHub issues, matched to how much context and token budget is left. Use at the start of a session or when the user asks "what next".
---

# Triage

Read cheaply, in order; stop when you have enough:
1. `docs/handoff.md` — unfinished work wins unless the user says otherwise.
2. `docs/plans/active/*` — unchecked phases.
3. `docs/plans/new/*` — plans awaiting approval (the user must approve them; don't build).
4. Open issues: `gh issue list --limit 20 --json number,title,labels` (skip if `gh` isn't available).

Priority: critical bugs → active plan phases → high-priority features → approved-but-unstarted plans → low-priority bugs → new brainstorming.

Match to budget:
- **Low context/tokens left:** pick a bug or one plan phase — small, self-contained.
- **Plenty left:** features and brainstorms — the full cycle is token-heavy.
- Prefer work in the module already loaded in context; switching modules throws that context away.
- Plans waiting in `new/` are fine — pre-done design work is quick to execute later.

Reply with at most 3 options:
```
1. <task> (#issue) — <why now> — size S/M/L — next command
2. …
Recommended: 1
```

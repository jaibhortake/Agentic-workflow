---
name: workflow
description: Entry point. Sizes the task (S/M/L) and routes to the right phases. Use at the start of any coding task or when unsure what to do next.
---

# Workflow router

1. Restate the user's intent in 1–2 lines. Ask only questions whose answers change the work.
2. Check `docs/plans/active/` and `docs/handoff.md` — resume existing work if it matches.
3. Size it:
   | Size | Signals | Path |
   |---|---|---|
   | S | ≤2 source files, spec is clear and complete, no schema/API/auth change | build (tests first for logic) → `/verify` |
   | M | spec has gaps to decide, or 3+ files, or touches shared code others call | `/write-plan` → `/build-phase` → `/review` → `/verify` |
   | L | new module, schema/API/auth change, many files, unclear design | `/brainstorm` → `/write-plan` → `/build-phase` ×N → `/review` → `/verify` |
4. State the size + path in one line and start. User may override.

## Model routing (Claude Code)
- Brainstorm, plan, review: strongest model (Opus).
- Build: `builder` subagent (Sonnet) — the plan file is the handoff.
- Wide code searches: `explorer` subagent (Haiku).

## Gates (never skip)
- No code during brainstorm.
- No build without an approved plan (M/L).
- No "done" without `/verify` evidence.
- `/security-check` before opening a PR.

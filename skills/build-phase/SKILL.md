---
name: build-phase
description: Build one phase of an approved plan, test-first, then self-check and return a short handoff summary. Usage /build-phase <plan> <phase>.
---

# Build phase

Terse mode on (see `terse`). Delegate to the `builder` subagent with the plan path + phase number when subagents are available; otherwise do it yourself, one phase at a time. For logic, write the failing test BEFORE the code and see it fail — don't write both together.

1. Read only the plan file and the files it names for this phase. Check the names exist (or are marked **new**) and the listed callers are real. Mismatch → halt (below).
2. For logic: write the failing test, run it, confirm it fails for the right reason.
3. Implement the minimum to pass. Follow existing patterns; reuse before writing new.
4. Run **scoped** tests (the phase's tests + touched modules), then lint/type-check on touched files.
5. Self-check the diff:
   - Debug leftovers, dead code, secrets, TODOs, unrelated changes → remove.
   - Any decision the plan didn't make? → that's a halt, not a choice.
   - **Would each new test fail if the code were wrong?** If unsure, break the code once and watch it fail (required for critical logic on L tasks; revert after).
   - Did you duplicate a helper that already exists? → use the existing one.
6. Tick the phase's checkboxes in the plan. Last phase: run the full suite once.

**Plan gap, contradiction or wrong name?** Stop. Don't improvise and don't edit the plan. Emit:
```
BUILD HALT — Phase N, step x
Plan says: <quote>
Found: <what's actually there>
Evidence: <file:line / command output>
Options: 1. <option> — cost … 2. …
Recommend: <n> because …
Tree state: <clean | changed files, tests passing?>
```
The planning side amends the plan + logs it in the Amendment Log (design-level issue → back to `/brainstorm`), then you re-read the plan from disk and continue.

Return exactly:
```
Phase N: done | blocked
Changed: path (+a/-b) …
Tests: <command> → <pass/fail counts>
Halts: none | <resolved how>
Deviations: none | <what + why>
Unproven ACs: none | <which + why>
Notes for reviewer: <≤3 lines>
```

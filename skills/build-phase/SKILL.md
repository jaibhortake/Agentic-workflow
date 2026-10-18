---
name: build-phase
description: Build one phase of an approved plan, test-first, then self-check and return a short handoff summary. Usage /build-phase <plan> <phase>.
---

# Build phase

Terse mode on (see `terse`). Delegate to the `builder` subagent with the plan path + phase number when subagents are available; otherwise do it yourself, one phase at a time. For logic, write the failing test BEFORE the code and see it fail — don't write both together.

1. Read only the plan file and the files it names for this phase.
2. For logic: write the failing test, run it, confirm it fails for the right reason.
3. Implement the minimum to pass. Follow existing patterns; reuse before writing new.
4. Run **scoped** tests (the phase's tests + touched modules), then lint/type-check on touched files.
5. Self-check the diff: debug leftovers, dead code, secrets, TODOs, unrelated changes → remove.
6. Tick the phase's checkboxes in the plan.

**Plan gap or contradiction?** Stop. Don't improvise. Report: what's missing, options, your recommendation. Plan gets an Amendment Log row after the user approves.

Return exactly:
```
Phase N: done | blocked
Changed: path (+a/-b) …
Tests: <command> → <pass/fail counts>
Deviations: none | <what + why>
Notes for reviewer: <≤3 lines>
```

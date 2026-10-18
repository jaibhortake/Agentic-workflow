---
name: write-plan
description: Write a phased, decision-complete implementation plan file that a cheaper model can build without guessing. Use for M and L tasks.
---

# Write plan

Goal: a plan so complete the builder never has to decide anything.

Save to `docs/plans/new/<slug>.md`, then ask the user to approve. On approval move it to `docs/plans/active/`.

```
# Plan: <title>
Intent: <one line, from user / decision doc link>
Size: M | L
Decision doc: docs/decisions/… (L only)

## Acceptance criteria
- [ ] AC1 … (observable, testable)

## Phases
### Phase 1: <name>
- Files: path — what changes
- Reuse: existing functions/patterns to use
- Tests first: test name → expected behaviour (TDD for logic; mark UI/glue "tests-after")
- Steps: 1. … 2. …
- Done when: <command> passes; <AC ids> covered
### Phase 2: …

## Removals
- <code removed> → replaced by <x>; callers checked: <how>

## Risks / rollback
- …

## Amendment Log
| Date | Phase | Change | Why | Approved by |
```

Rules:
- Each phase is independently buildable and testable; aim ≤ ~300 changed lines per phase.
- Name exact files and functions. No "etc.", no "as appropriate".
- Every AC maps to at least one test.
- Unknowns → resolve now (ask) or add a spike phase. Don't leave them for the builder.

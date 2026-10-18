---
name: write-plan
description: Write a phased, decision-complete implementation plan file that a cheaper model can build without guessing. Use for M and L tasks.
---

# Write plan

Goal: a plan so complete the builder never has to decide anything.

Save to `docs/plans/new/<slug>.md`, then ask the user to approve. On approval move it to `docs/plans/active/`. If the user already said to proceed without review, still save to `new/`, then move it to `active/` before building. Can't ask (unattended run)? List your assumptions in an `## Assumptions` section.

```
# Plan: <title>
Intent: <one line, from user / decision doc link>
Size: M | L
Decision doc: docs/decisions/… (L only)
What the user sees: <before → after>

## Acceptance criteria
- [ ] AC1 … (observable, testable)

## Impact
- Structural: <callers/importers of changed code, how found, count>
- Functional: <end-to-end flows that pass through it>
- Consolidation: <what becomes unused or duplicated; how it's cleaned up>

## Phases
### Phase 1: <name>
- Files: path — what changes (names that don't exist yet marked **new**)
- Reuse: existing functions/patterns to use
- Tests first: test name → expected behaviour (TDD for logic; mark UI/glue "tests-after")
- Steps: 1. … 2. …
- Done when: `<command>` → `<expected output>` (never just "tests pass"); <AC ids> covered
### Phase 2: …

## End-to-end check
- `<command or manual scenario>` → `<expected result>`

## Removals
| Removed | What it did | Replaced by | Lost (blank replacement = capability given up) |

## Risks / rollback
- …

## Amendment Log
| Date | Phase | Trigger | Change | Decision/scope impact | Approved by |
```

**Include when relevant** (required for L, or when schema, API, auth or concurrency changes):
- **State & data contracts:** source of truth, identity, migration + rollback.
- **Failure modes:** errors returned, timeouts, retries, cancellation, concurrent access.
- **Decision source:** each decision in the decision doc → the phase that implements it.
- **Scenario table:** if a rule changes, case | today | new — each differing row is a named test.

Rules:
- Each phase is independently buildable and testable; aim ≤ ~300 changed lines per phase.
- Name exact files and functions; verify each exists or mark it **new**. No "etc.", no "as appropriate".
- Every AC maps to at least one test. At least one test per value path crosses the real seam (no mocks).
- State what is out of scope.
- Unknowns → resolve now (ask) or add a spike phase. Don't leave them for the builder.

**L only — plan review before asking for approval.** Three passes, one question each; fix findings before the next pass:
1. Does the plan break anything it never mentions? (check the Impact callers)
2. Does the codebase end with fewer or more ways to do each job?
3. Could a different agent build it exactly as written, without asking anything?
Still changing after 3 rounds → stop and let the user decide.

After approval, build in a **fresh session** (`/clear`): the plan carries the context, the brainstorm chat doesn't need to.

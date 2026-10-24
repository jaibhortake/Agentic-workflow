<!-- Ported from nikhilw/structured-agentic-workflow skills/build-phase/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Phase Completion

When all phases in the plan are complete:

1. Run the FULL test suite using this project's own command. All tests must pass. This is `/test-scope`'s *"`/build-phase` Phase Completion"* row: it is **T4, always**, and it is the one run in this skill that is never scoped and never cited. Every phase before it ran narrow on the promise that this run happens.
2. Produce a short **build completion report**: which phases were built; which test criteria were run, **at which rung**, with exit codes and counts, and how many of the named mutation checks were witnessed (N of M), each one not witnessed counted among the unproven; every criterion left unproven (manual, skipped, deferred, verified by inspection, or proven only at a scoped rung); a one-line note on any phase that deviated from the plan; and **every halt you raised, with how it was resolved** (amendment ID, overruled by the user, or withdrawn on investigation) plus the plan revision you built against. These five feed the handoff summary directly; the reviewer builds its ledger from them.

This skill ends here. Building is one responsibility; review and handoff are owned by the **orchestrating workflow**, not by this skill. Do **not** run `/review`, write the handoff summary, or verify from inside build-phase.

- `workflow` (main model) drives `/review` → `/build-handoff` → `/verify`.
- `build-model` (dedicated build model) drives `/review` → `/build-handoff` → STOP.

Whichever launched you takes over once you report completion. You do not need to decide which; just report and hand back.

<!-- Ported from nikhilw/structured-agentic-workflow skills/build-phase/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The Standing Instruction

> **Think critically about the plan. If you find issues or discrepancies during implementation,
> surface them and halt instead of pushing through or working around it.**

This is not advice for the start of the phase. It is in force at every step below, from reading the
plan to the last test run, and it outranks finishing the phase. Three things follow from it:

- **A workaround is the failure mode, not the save.** Routing around a gap inside the files the
  plan did name produces something that passes every gate while doing the wrong thing, and nothing
  downstream will catch it, because from the outside it looks finished.
- **You never edit the plan while building.** You report; the planning model assesses and amends.
  That split is what keeps the plan a contract and what makes drift measurable at the end.
  **In a single-model session it still holds**, because the split that matters is between *acts*,
  not models: stop building, go back to the plan as its author, verify what you found, amend the
  document and append the Amendment Log entry, then resume. Editing the plan mid-build without
  stopping and without logging is the same silent drift whether one model does it or two.
- **Halting is not failing.** A halt with an accurate diagnosis is the cheapest possible outcome
  for a plan defect, and the planning model expects one or two. The expensive outcome is the
  silent fix.

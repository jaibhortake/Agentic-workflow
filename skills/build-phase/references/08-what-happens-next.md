<!-- Ported from nikhilw/structured-agentic-workflow skills/build-phase/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What Happens Next

If more phases remain, auto-advance: suggest and begin `/build-phase <plan-file> Phase N+1`.

When all phases are complete, present the build completion report and return control to the orchestrating workflow. That workflow drives review and handoff next; do not start them yourself.

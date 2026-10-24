<!-- Ported from nikhilw/structured-agentic-workflow skills/build-model/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Why these boundaries

- **`build-phase` builds; it does not review or hand off.** Keeping it single-purpose is what lets both this workflow and the main model share it without contradictory branches.
- **This workflow owns review + handoff for the build model.** That responsibility lives here, in one place, instead of as a conditional inside `build-phase`.
- **Verification and plan archival belong to the main model** (`workflow`). The main model re-reviews your handoff with fresh eyes; that is the point of the handoff.

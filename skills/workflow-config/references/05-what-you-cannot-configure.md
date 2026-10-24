<!-- Ported from nikhilw/structured-agentic-workflow skills/workflow-config/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What You Cannot Configure

The following are NOT configurable; they are core workflow guarantees:
- **Verification (`/verify`)**: Always mandatory, including its drift audit. Cannot be disabled.
- **Phase order**: Brainstorm → Plan → Build → 3p-Review → Verify. Cannot be reordered or skipped.
- **Plan lifecycle**: Plans move through `new/` → `active/` → `done/`. Cannot be bypassed.
- **review loop**: Review loops until clean. Cannot be short-circuited.
- **Halt and amend**: The build model surfaces plan problems and stops; the planning model amends the plan and logs the amendment. The builder never edits the plan. Neither half is optional.

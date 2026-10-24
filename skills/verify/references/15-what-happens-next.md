<!-- Ported from nikhilw/structured-agentic-workflow skills/verify-completion/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What happens next

When the report says COMPLETE: move the plan from `docs/plans/active/` to `docs/plans/done/` with plain
`mv` (not `git mv`; the plan file may not be tracked). The feature is done.

<!-- Ported from nikhilw/structured-agentic-workflow skills/handoff-summary/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What happens next

The summary is *said, not saved* (AW-29): it is emitted into the conversation, for the human or the
next model. It is this skill's one report, emitted in full because the next reader must rule on
it; nothing around it is narrated (AW-28). It is not a file, and inventing a path for it is how a handoff ends up somewhere the
reviewing model never looks.

- **Dedicated build model** (launched via `/build-model`): present the summary, then **STOP**. The user carries it to the main model.
- **Main model**: present the summary as the build record, then continue the workflow → `/verify` → archive the plan.

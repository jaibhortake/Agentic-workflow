<!-- Ported from nikhilw/structured-agentic-workflow skills/agentic-workflow/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Task Selection Strategy

When tokens or context are constrained, pick **bugs**: they are small, self-contained, and don't require the full Brainstorm → Plan → Build cycle.

When resources are plentiful, pick **features and plans**: they require sustained attention and the full workflow.

Always minimize context thrash: prefer work that aligns with what's already loaded in the conversation.

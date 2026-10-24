<!-- Ported from nikhilw/structured-agentic-workflow skills/knowledge-graph/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Refreshing it

Your calling skill has the detect-and-refresh block. Three things it does not say:

- **Exactly once, at the start of the session.** It is an incremental update, not a rebuild.
  Re-running it between approaches, or between phases, costs time and returns no new
  information.
- **If `graphify-out/` exists but this session never refreshed it, refresh before the first query.**
  An index from a previous session is stale in the direction that matters: it still contains what
  was deleted.
- **`graphify-out/` is a build artifact.** If the repo does not already ignore it, say so once. Do
  not commit it.

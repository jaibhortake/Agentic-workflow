<!-- Ported from nikhilw/structured-agentic-workflow skills/compact-brief/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What it costs

A run made before the compaction survives only as a line in the brief, and under `/test-scope`'s
citable-run rule a summary of a run is a claim, not a run. So after compacting at slot 2,
`/verify` runs the full suite instead of citing `/review`'s sign-off. Say so in the
brief, so the model after the compaction does not try to cite it. Without a compaction, nothing
changes.

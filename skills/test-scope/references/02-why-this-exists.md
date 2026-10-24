<!-- Ported from nikhilw/structured-agentic-workflow skills/test-scope/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Why this exists

Without it, each gate demands the full suite independently, because no gate can see any other gate's runs, and a three-phase plan pays for six or seven full-suite runs, most of them re-proving code untouched since the previous one. The ladder gives a gate a vocabulary narrower than "everything". The citable-run rule lets the last gates share one run instead of duplicating it.

Neither is permission to prove less. Both are accounting, and the accounting is the price: a narrow run is only acceptable because it is **recorded as narrow** and stays visible to every later reader.

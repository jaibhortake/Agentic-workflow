<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## What this gate is, and is not

It is **not a second review**. `/review` proved the *code* is sound; re-reading the code here
buys nothing and costs a rework loop's worth of time. This gate proves three different
propositions, none of which review establishes:

1. **The suite is green right now.** Review may have passed several edits ago.
2. **Every requirement was actually built.** Review judges completeness qualitatively; this is the
   line-by-line tick-off.
3. **What shipped is still what was decided.** Plans drift. Every halt, every constraint found
   mid-build, every reverted phase moves the plan a little, and the accumulated distance from the
   decision document is invisible from inside any single step. This is the only place the whole
   chain is read end to end.

Check 3 exists because of a specific, expensive failure: you set out to build one thing, the plan
absorbed a dozen small corrections, and what shipped is a different thing. Nobody notices for days,
because every individual amendment was reasonable.

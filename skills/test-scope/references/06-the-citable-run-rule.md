<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The citable-run rule

A run already recorded satisfies a run now required **only when all four hold**:

1. **You made it, in this session, with your own hands.** A run reported to you in a handoff summary, a build completion report, or any other model's summary is a claim, not a run. Re-run it. This is what keeps `/review` independent of the builder, and it holds even when the builder and the reviewer are the same model wearing a different persona. A context compaction ends "this session" for this purpose: a run from before it survives only as a summary, and a summary of a run is a claim.
2. **Same command, same rung.** A T2 run does not satisfy a T4 requirement because it passed. Never describe a narrow run in wide words.
3. **Same tree.** `git status --porcelain` and `git diff` show zero changes since the run, untracked files included. One comment, one formatting pass, one file you touched and reverted by hand, all void it. Re-run.
4. **You write the citation down.** Name the run you are citing and state what proved the tree unchanged. An unstated citation is indistinguishable from a skipped gate, and will be read as one.

Fail any condition and there is no citation, only a run you still owe.

**A row marked "always" in the table above takes no citation, under any conditions.** Those two runs are not redundancy to be optimized away; they are the only two points where the suite is proven against a tree nobody is still editing. A single session that both builds and reviews (the `/build-model` path) owns both of them and pays for both. Condition 1 would let that session cite itself, which is exactly why the table overrides it.

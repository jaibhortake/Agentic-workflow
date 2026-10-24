<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Resuming After a Halt

When the plan comes back amended:

1. **Re-read the plan from disk.** Not from your thread, which remembers the version you discussed
   and will silently win over the file you never re-opened. This is widest and freshest right after
   a correction, which is exactly when it is skipped.
2. **Read the Amendment Log entry, not just the amended phase.** It says what changed and why, and
   whether the change touched phases you have already built. An amendment with decision impact may
   invalidate work behind you.
3. **Re-run the plan review** (Step 1) against the amended sections. Amended text is new plan text,
   and no one has reviewed it with your eyes.
4. **Restore the tree to what your halt report described**, if anything was left half-done, before
   building on top of it.
5. If the amendment does not actually resolve what you halted on, say so and halt again. A second
   halt on the same point is information, not insubordination; silently accepting a non-fix is how
   the original defect ships with a paper trail that says it was handled.

If the user overrules the halt and tells you to build it as planned, build it as planned, and record
the overrule in the phase report so it reaches the handoff. That is the user's call to make. It is
not yours to make by staying quiet.

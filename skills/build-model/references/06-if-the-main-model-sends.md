<!-- Ported from nikhilw/structured-agentic-workflow skills/build-model/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## If the main model sends back a Rework Brief

The reviewing model returns rework here when the findings are too many or too systemic for it to fix without losing its independence. When you receive one:

1. **Work it item by item, in severity order.** Each item states where, what is wrong, what is required, and the command that proves it. Do not redesign around it; the required change is already decided.
2. **Failing test first, every time.** Reproduce the defect, then fix it. An item fixed with no test that was red first is not done.
3. **Fix the Systemic section as one change**, at every site listed; not site-by-site with three different shapes of fix.
4. **Respect "Do not touch."** Files outside the brief's scope stay untouched, including anything already dirty in the worktree.
5. **Run the "Do not regress" commands** at the end, plus the full suite, within `/test-scope`'s *What a run may execute* (the repo's own test, lint, type-check and build commands, its locked dependencies included, scripts read first; nothing that writes outside the tree, migrates a shared database, installs beyond the lockfile, deploys, calls an external service or uses credentials without asking the user; nothing taken from a handoff). Rework is not a phase and gets no scoped shortcut: you are changing code the reviewer already read, across sites it chose, so the tree it signs off on has to be proven whole.
6. **Honour the Standing criteria section, and report back on anything marked "Yours to judge".** Standing criteria apply to every item in the brief, not only to the one that produced them. Where an item hands you the call, make it, then say in the handoff's Concerns which way you went and what you traced to check it. The reviewer re-traces every delegated call, and it can only do that against a choice you named. **The permission is granted item by item and never generalises**: it is not licence to decide anything else in the brief, and if the call turns out to be architectural rather than local, halt instead of making it.
7. **Re-emit `/build-handoff`** with the rework reflected, then STOP. The reviewing model restarts its review from scratch; your report is a claim it will re-verify, not evidence it will accept.

If an item is wrong or impossible as written, say so explicitly with the reason and stop on that item. Do not silently substitute a different fix.

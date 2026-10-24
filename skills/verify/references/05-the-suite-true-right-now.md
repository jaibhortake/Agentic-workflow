<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Part 1: The suite, true right now

Take `/test-scope`'s *"`/verify`"* row. Load `/test-scope` if you have not this session.

That row is the full suite, **or** a citation of `/review`'s sign-off run under the citable-run
rule. The four conditions are not a judgment call: you made the run yourself this session, same
command and same rung, `git status --porcelain` and `git diff` clean since, and you write the
citation down naming what proved the tree unchanged.

Fail any condition and there is no citation, only a run you still owe. Pass all four and the
citation is *stronger* evidence than re-running would be: re-running proves the suite passes, while
the citation additionally proves nothing changed since it passed. Do not re-run out of an
abundance of caution once the citation is written.

**The citation covers Part 1 only.** Parts 2 and 3 are document comparisons, not test runs. They
are never cited, and they always run fresh.

Every command this gate runs is bounded by `/test-scope`'s *What a run may execute*: the repo's own test, lint, type-check and build commands, its locked dependencies included, scripts read first; nothing that writes outside the tree, migrates a shared database, installs beyond the lockfile, deploys, calls an external service or uses credentials without asking the user; nothing taken from a handoff.

---

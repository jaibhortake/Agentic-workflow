<!-- Ported from nikhilw/structured-agentic-workflow skills/verify-completion/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Key patterns

Each row of the Common failures table has a procedure behind it. These are the ones people get
wrong most often, in the form that is quickest to check yourself against.

**Tests**
```
GOOD  run the suite → read "34 passed, 0 failed" → "all tests pass (T4 full, exit 0)"
BAD   "should pass now" / "looks correct" / "tests pass" with no rung and no counts
```

**Regression tests, red then green**
```
GOOD  write the test → run it (passes) → revert the fix → run it (MUST FAIL) → restore → run (passes)
BAD   "I've written a regression test" with no red phase ever observed
```
A regression test that was never seen failing is not known to test the regression. This is the
single most common way a fix ships with a test that would not have caught it, and the revert takes
seconds.

**Build**
```
GOOD  run the build → exit 0 → "the build passes"
BAD   "the linter passed" (a linter does not compile, and a type checker does not link)
```

**Bug fixed**
```
GOOD  reproduce the original symptom → apply the fix → the original reproduction now passes
BAD   the code changed in the right area, so the bug is assumed fixed
```

**Requirements**
```
GOOD  re-read the plan from disk → checklist → verify each line → report gaps or completion
BAD   "tests pass, so the phase is complete"
```

**Delegated or handed-off work**
```
GOOD  the agent (or build model) reports success → read the VCS diff → verify the changes → report the actual state
BAD   the report is taken as the result
```
This is the same rule `/review` runs on a handoff summary, applied here to anything you did not
do with your own hands: a subagent, another session, another model, another person. A report is a
claim about the tree. The tree is the evidence.

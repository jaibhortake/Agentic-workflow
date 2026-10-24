<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Common failures

| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | Test command output, 0 failures | A previous run, "should pass" |
| Linter clean | Linter output, 0 errors | A partial check, extrapolation |
| Build succeeds | Build command, exit 0 | Linter passing, logs that look fine |
| Bug fixed | The original symptom re-tested, passing | Code changed, fix assumed |
| Regression test works | Red then green, verified | The test passing once |
| Agent completed | The VCS diff, read | The agent reporting success |
| Requirements met | The line-by-line checklist | Tests passing |
| Built what we decided | The drift audit, all three comparisons | The plan being followed |
| Nothing was lost | The removal table walked against the diff, each replacement found | The suite passing after the deletion |
| No drift | Both documents read as they stand, differences named | The documents agreeing after you edited one |
| A difference is reported | The decided text and the built behaviour quoted side by side | A disposition word, a check name, or a count of them |

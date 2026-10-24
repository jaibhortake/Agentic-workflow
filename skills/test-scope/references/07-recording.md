<!-- Ported from nikhilw/structured-agentic-workflow skills/test-scope/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Recording

**Every run is recorded with its rung.** "T2 impacted, exit 0, 34 passed, 0 failed, 2 skipped", never "tests pass". A mutated run is recorded with its mutation check, not as a run of the phase.

**Compare the counts with the last good run at the same rung.** Mutated runs are left out of both sides. Passed, skipped and expected-failure counts that move by more than the tests added or removed since then are a finding, even on exit 0: a test that starts failing quietly under an expected-failure marker turns 11 into 12 and nothing else.

**Take the exit code from the run itself, never from a pipeline.** `<runner> | tee out.txt` reports `tee`'s status, not the suite's, so a failing run reads as exit 0 to every gate downstream while the counts scroll past unread. Run the command on its own and read its status, or use your shell's pipeline-status mechanism. This is the one recording error that cannot be caught by reading the report, because the report is honest and the exit code is not.

The rung travels with the run through every artifact that carries it: the build completion report, the handoff summary's Verification Runs, the review ledger, the sign-off. A reader who cannot see the rung cannot tell the difference between a criterion proven against the whole suite and one proven against four files, and will assume the first.

**A criterion proven only at T1 or T2 is a ledger row, not a green check.** It is disposed of the same way a manual criterion is: proven at a wider rung, or risk-accepted in writing by the human.

**Widening the label is the failure mode that makes this whole mechanism unsafe.** Calling a T2 run "the full suite" converts an honest saving into a false claim, and every gate downstream inherits it. If you are unsure which rung a run was, it was the narrower one.

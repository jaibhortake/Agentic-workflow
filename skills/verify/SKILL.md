---
name: verify
description: Final evidence gate before calling work done. Runs fresh checks, ticks acceptance criteria, audits drift between intent, plan and code.
---

# Verify

Nothing is "done" until this passes in the current session.

1. Run the full test suite, lint, type-check/build (commands from `CLAUDE.md`). A run from earlier counts only if it was **this session, same command, and `git status`/`git diff` show no change since** — otherwise run again. After compaction, always run again.
2. Paste the summary lines (pass/fail counts, errors). Failing? Not done — fix or report.
3. **Bug fix or logic change?** The diff must contain a new or changed test that fails on the old code. None? Add one now, then re-run. (Runs on S tasks too.)
4. Tick each acceptance criterion and name the test that proves it. (S tasks: state what you checked.)
5. **Drift audit:** decision doc → plan → diff. Verdict:
   - **NO DRIFT** — everything matches.
   - **DOCUMENTED DRIFT** — differences are all in the Amendment Log.
   - **UNDOCUMENTED DRIFT** — blocks completion. Report the difference and wait for the user's ruling. Never edit the decision doc or plan baseline to make it match; if accepted, append a dated Amendment Log entry.
6. **Removal check:** anything reachable before and not after, without a named replacement or accepted loss, is a regression.
7. If it touches UI or a running service, actually run it and check the behaviour, not just tests.
8. Move the plan to `docs/plans/done/`. Delete `docs/handoff.md` if it was for this task.

Report:
```
Verified: yes | no
Checks: tests <x/y>, lint <ok | n/a — none configured>, build <ok | n/a>
ACs: AC1 ✓ (test_name) …
Drift: NO DRIFT | DOCUMENTED DRIFT (<n> amendments) | UNDOCUMENTED DRIFT: <listed>
Removals: none | all replaced/accepted | regression: <listed>
Next: /security-check then /pr
```

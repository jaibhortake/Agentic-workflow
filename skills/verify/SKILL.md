---
name: verify
description: Final evidence gate before calling work done. Runs fresh checks, ticks acceptance criteria, audits drift between intent, plan and code.
---

# Verify

Nothing is "done" until this passes in the current session.

1. Run fresh (not cached from earlier): full test suite, lint, type-check/build. Use commands from `CLAUDE.md`.
2. Paste the summary lines (pass/fail counts, errors). Failing? Not done — fix or report.
3. Tick each acceptance criterion and name the test that proves it. (S tasks: state what you checked.)
4. **Drift audit:** compare intent → plan → diff. Any change not in the plan or Amendment Log? Document it or revert it.
5. If it touches UI or a running service, actually run it and check the behaviour, not just tests.
6. Move the plan to `docs/plans/done/`. Delete `docs/handoff.md` if it was for this task.

Report:
```
Verified: yes | no
Checks: tests <x/y>, lint <ok>, build <ok>
ACs: AC1 ✓ (test_name) …
Drift: none | <listed>
Next: /security-check then PR
```

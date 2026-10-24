<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Round N: Report Findings

```
[SEVERITY] file:line; description
  → suggested fix
```

Severity sets *priority*, not whether it gets fixed; everything gets fixed:
- **CRITICAL**: bugs, security holes, data loss, broken contracts. Fix first.
- **MAJOR**: design flaws, SOLID/DRY violations, missing error handling, missing tests, poor naming on important surfaces.
- **MINOR**: style, small simplifications, naming polish. Still fixed before sign-off.
- **GOOD**: things done well. Not a finding.

**Before proposing a simplification, confirm the code runs.** Check that the branch is reachable and the enclosing condition is ever true; for anything non-obvious, prove it with a live run or an assertion, not by reading. Tidier dead code is not an improvement, and "simplify this" written against an unreachable branch is worse than no finding at all: it launders the real defect (the code never executes) into an apparent improvement, and once the tidy version is committed nobody looks again. If the branch turns out to be dead, *that* is the finding, and it is not a MINOR.

**The bar every finding must clear.** Name at least one of: a **defect** (wrong result, crash, leak, security hole, broken contract); a **violated contract or convention** (codebase, plan, or decision doc says otherwise); a **concrete maintenance cost** (name the future change it endangers); a **demonstrated simplification** (state the smaller thing that does the same job, and confirm the code you are shrinking actually executes). Anything else is preference, and preferences are not findings. This bar is what keeps the exit condition honest: since sign-off needs zero findings, a reviewer who can manufacture subjective minors forever has either an infinite loop or a quiet incentive to lower the bar until it ends.

**Findings vs. Follow-ups.** A **Finding** was introduced, touched, or *exposed* by this change, and blocks sign-off; including anything this change made worse or now depends on for correctness. A **Follow-up** is genuinely unrelated pre-existing work; record it in the summary with `file:line` and do not block on it. This is not an escape hatch: "it was already broken" does not downgrade a Finding when the change relies on the broken thing or puts a new caller in front of it. When in doubt, it is a Finding.

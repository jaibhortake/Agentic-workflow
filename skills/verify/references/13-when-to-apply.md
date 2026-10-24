<!-- Ported from nikhilw/structured-agentic-workflow skills/verify-completion/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## When to apply

**Always, before:** any claim of completion, correctness, or success, in any wording; any
expression of satisfaction with the work; committing, pushing, or opening a PR; moving to the next
task; archiving the plan.

This gate is never optional and is never skipped, regardless of model, time pressure, or
confidence. It also covers the bug and quick-fix path, which skips full review entirely: there the
suite comes from `/test-scope`'s no-plan row, Part 2 runs against the reported symptom instead of a
plan, and Part 3 says explicitly that there was no decision document.

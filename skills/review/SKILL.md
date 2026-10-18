---
name: review
description: Independent fresh-eyes review of the changes against the plan and intent. Loops until no blockers or majors remain. Use after building M/L work.
---

# Review

Run via the `reviewer` subagent when available (fresh context); otherwise review in the same session but re-read the diff cold, not from memory of writing it. Input: plan path + decision doc (L) + the diff. Diff = `git diff <baseBranch>...HEAD` plus uncommitted changes; with no base branch or no commits yet, use `git status` and read the changed files. Don't read the build transcript; use the handoff summary.

Check, one lens at a time, only what applies:
1. **Intent:** does it do what the user asked — no more, no less? Does "What the user sees" now hold?
2. **Correctness:** walk the logic with concrete values; edge cases, null/empty, concurrency, error paths.
3. **Impact:** who else calls the changed code? Anything broken or orphaned?
4. **Duplication:** a helper, type or pathway the change duplicated instead of reusing = **major**.
5. **Removals:** each row in the removal table has a replacement or an accepted loss, and no remaining callers.
6. **Proof:** each acceptance criterion has a test that would fail if the code were wrong; at least one test crosses the real seam (no mocks on the value path).
7. **Security:** input validation, authz, secrets, injection, unsafe deps.
8. **Fit:** follows project conventions; would a business owner find the behaviour sensible?

Report only gaps that affect correctness, security or the stated requirements. Style preferences, speculative "what ifs" and tests for impossible cases are not findings — chasing them over-engineers the code. Put optional nits in one line at the end.

Output findings as: `severity (blocker|major|minor) — file:line — problem — fix`.
- A few contained findings: fix them, re-run scoped tests, re-review the fixes.
- Write a **Rework Brief** instead of patching when any of: ~8+ findings, findings in most phases, the same defect repeating, or a missing phase. The brief names exact files, lines and commands (checked against the code), goes into the plan's Amendment Log, and is sent back to `/build-phase`.
- Repeat until zero blockers/majors. Sign off with a full test-suite run (or cite this review's own run if nothing changed since). Then `/verify`.

---
name: review
description: Independent fresh-eyes review of the changes against the plan and intent. Loops until no findings remain. Use after building M/L work.
---

# Review

Run via the `reviewer` subagent when available (fresh context); otherwise review in the same session but re-read the diff cold, not from memory of writing it. Input: plan path + the diff. Diff = `git diff <baseBranch>...HEAD` plus uncommitted changes; with no base branch or no commits yet, use `git status` and read the changed files. Don't read the build transcript; use the handoff summary.

Check, one lens at a time, only what applies:
1. **Intent:** does it do what the user asked — no more, no less?
2. **Correctness:** logic errors, edge cases, null/empty, concurrency, error paths.
3. **Impact:** who else calls the changed code? Anything broken, orphaned or duplicated?
4. **Removals:** each deletion has a named replacement and no remaining callers.
5. **Proof:** each acceptance criterion has a test; at least one test crosses the real seam (no mocks on the value path).
6. **Security:** input validation, authz, secrets, injection, unsafe deps.
7. **Fit:** follows project conventions; simpler option missed?

Report only gaps that affect correctness, security or the stated requirements. Style preferences, speculative "what ifs" and tests for impossible cases are not findings — chasing them over-engineers the code. Put optional nits in one line at the end.

Output findings as: `severity (blocker|major|minor) — file:line — problem — fix`.
- ≤ 5 small findings: fix them, re-run tests, re-review.
- More, or design-level: write a **Rework Brief** (problems + required fixes) into the plan's Amendment Log and send back to `/build-phase`. Don't patch it yourself.
- Repeat until zero blockers/majors. Then `/verify`.

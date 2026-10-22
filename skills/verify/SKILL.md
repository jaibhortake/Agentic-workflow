---
name: verify
description: Final evidence gate before calling work done. Fresh suite status, requirements tick-off, and a three-pair drift audit between intent, plan and code.
---

# Verify

Nothing is "done", "fixed" or "passing", and nothing is committed or opened as a PR, until this passes in the current session.

**Hard limits:** this gate measures; it never repairs. Gaps in code go back to `/build-phase`. It never edits the decision doc or plan to make a finding vanish. The only permitted write to them is appending a dated line to `## Amendments` (decision doc) or the Amendment Log (plan), and only after the human accepts the drift.

## Part 1: Suite status
Run the full suite (T4), lint, and type-check/build (commands from `CLAUDE.md` / the plan's Test Commands). A run from earlier counts only if all four hold: this session, same command and rung, `git status`/`git diff` unchanged since, and the citation names what proved it. After compaction, run again. Paste the summary lines. Failing means not done.

**Bug fix or logic change?** The diff must contain a new or changed test that fails on the old code. None: add one now, re-run. (Applies to S tasks too.)

## Part 2: Requirements tick-off (never cited, never a test run)
Re-read the plan from disk. For every phase, step and acceptance criterion mark: **built and proven** (name the test), **built but unproven**, or **not built**. Check removed capabilities against their replacements. S tasks: state what you checked.

## Part 3: Drift audit (read-only, three pairs)
1. **Decision doc vs plan:** each decision upheld, narrowed, superseded or dropped.
2. **Approved plan vs current plan:** using git history and the Amendment Log.
3. **Decision doc's problem statement vs what shipped.**

Take baselines from version control where possible. Verdict:
- **NO DRIFT**
- **DOCUMENTED DRIFT:** every difference is in an Amendment Log.
- **UNDOCUMENTED DRIFT:** blocks completion. Report it; wait for the user's ruling.

S tasks have no decision doc or plan: audit the diff against the stated intent only.

## Part 4: Remaining checks
- **Removals:** anything reachable before and not after, without a named replacement or accepted loss, is a regression.
- If it touches UI or a running service, run it and check the behaviour, not just tests.

## Report (bad news first)
Each departure shows the decided text beside the built behaviour.
```
Status: COMPLETE | NOT COMPLETE
Suite: <rung> <command> -> exit <code>, <passed>/<failed>/<skipped> (cited | fresh)
Lint/build: <ok | n/a - none configured>
Requirements: AC1 built+proven (test_name) | built, unproven | not built ...
Drift: NO DRIFT | DOCUMENTED DRIFT (<n> amendments) | UNDOCUMENTED DRIFT: <listed with decided vs built>
Removals: none | all replaced/accepted | regression: <listed>
Next: /security-check then /pr
```
Deliver it in the conversation, not as a file. On COMPLETE: move the plan to `docs/plans/done/` (plain `mv`) and delete `docs/handoff.md` if it was for this task.

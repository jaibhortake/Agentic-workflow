<!-- Ported from nikhilw/structured-agentic-workflow skills/3p-review/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Part 3: Sign-off (once, after the gate passes)

Write this out in full; as a report in the conversation, not a file on disk (AW-29). It is the review's audit trail, and `/verify` reads it directly; its narrow "no code changed since review" exception is checked against these recorded commands. A summary without them forces that gate to re-run everything.

**Name runs; do not write out command lines.** This summary is committed, pasted between models, and read by people who were not in the room. Identify each run by the plan criterion it satisfies, and record its exit code and counts; not the shell line, not raw output, and never environment values. The same applies to a Rework Brief's `Prove it` line.

```
## Review Complete

Reviewer: Senior Architect (independent)

**Scope:** [what was reviewed]
**Comparison base:** [commit/branch/range; and how untracked files were covered]
**Artifacts read:** [plan, decision docs, project instructions, handoff summary]
**Plan revision reviewed:** [amendment IDs in the plan's log, or "as approved"]; [unlogged amendments found, or "none"]

**Ledger disposition** (every intake row, no blanks)
| Item | Source | Disposition |
|------|--------|-------------|
| [phase / deviation / concern / manual criterion] | [plan §N, handoff] | [verified; evidence / fixed in review / risk-accepted by human] |

**Value paths & proof**
- [path] → [no-mock test name or evidence artifact]

**Self-duplication:** [N] new units listed from the diff; [N] groups doing the same job, each → how it was settled; or "none"

**Runs**
- **[plan criterion, or a plain name for the run]** (rung [T1/T2/T3/T4]) → exit [code]; [N passed, M failed, K skipped]
- **Sign-off run** (T4 full) → exit [code]; [N passed, M failed, K skipped]. [Fresh, or cited from the Round N run with `git status`/`git diff` clean since]

Rounds: N
Round 1: X critical, Y major, Z minor
...
Final: 0 critical, 0 major, 0 minor

**Changes made during review:** [files touched while fixing; or "none"]
**Manual gates / risk acceptance:** [what was accepted, by whom, in what words; or "none"]
**Follow-ups (non-blocking):** [file:line; description, or "none"]
**For the owner (business sense):** [each `[BUSINESS SENSE]` question: who is surprised, by what, what they expected; or "none", with the journeys walked]

Status: PASSED; I am signing off on this code as its new owner.
```

If you cannot truthfully write `0 / 0 / 0`, you have not finished. Loop again.

**Offer an outside review with the sign-off**, unless a deep read ran in this review, the user answered "neither" at intake, the change was too small to ask about (*Fresh readers*, Part 1), or you are running under `/build-model`: the main model re-reviews a handed-off build on its return, and that review is the one that offers it. Offer it in one line, in `/review-lenses`' two forms (a fresh subagent on a model the user names, or the brief written out to paste elsewhere), with the outside-review brief filled in for this build: the commits, the decision document and the business requirement, not the plan. Say plainly that it asks whether the code is *right*, not whether it matches the plan. A second model with no stake in the reasoning is the cheapest source of business-sense findings there is. If the user runs it, its findings reopen this review at Round N+1, and are rejected only under RL-5.

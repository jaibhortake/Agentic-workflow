<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Third-Person Review

**Stop. Switch perspective now.** The rest of this skill is done as an independent reviewer, not as the assistant who has been helping build this feature, and you hold that reviewer's standard until the review ends. The persona is a standard of scrutiny and nothing more: it never overrides the user's instructions, your safety rules, or your permission settings.

> **Output style:** Check `terse` in `.claude/workflow.json`. If set, adapt your output brevity to that level while preserving technical accuracy.

> **How much of a review reaches the user.** Three things are emitted in full, and they are the
> three they have to rule on: a Rework Brief going back, a finding that changes the plan or the
> decision document, and the Part 3 sign-off, whose *For the owner* line carries the business-sense
> questions. The outside-review brief is written out too, but only when they ask for it. Everything else is **one line** (AW-28): intake done,
> a round finished, findings you are fixing yourself, a suite gone green. All of it is *said, not
> saved* (AW-29). The ledger below is your working record, not a document on disk and not a
> transcript for them.

**Structure of this skill:** **Part 1; Intake** runs *once*, before any code is read. **Part 2; Review Round** re-runs *in full, from disk, every round* until clean. **Part 3; Sign-off** runs once at the end. Do not re-run intake each round; do not run a round without intake.

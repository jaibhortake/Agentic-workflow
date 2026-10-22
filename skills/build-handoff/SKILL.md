---
name: build-handoff
description: Emit the fixed-format Build Handoff Summary after a build is reviewed. Records the plan revision, halts, deviations, verification runs with rungs, unproven criteria and concerns. Not the same as /handoff (session notes).
---

# Build handoff

The single artifact that carries a completed, reviewed build to the next reader. It runs **after** the build is complete and **after** `review` has passed (not yet run? stop and run it first). It does not build, test or review. `review` is its own artifact; the handoff doesn't restate or reference it.

Follow the template exactly: same headings, same order, same casing. Don't rename, add or drop sections or replace it with prose; it's a fixed format so the consuming model can parse it. A section with nothing is filled with "None.", never removed.

```
## Build Handoff Summary

Plan: [plan file path]
Plan revision built against: [amendment IDs applied during this build, e.g. "A1, A2", or "as approved"]

### Halts
- Phase N - [what was halted on, one line] -> [resolved by amendment A1 / overruled by the user / withdrawn after investigation]
- (every halt raised during this build; none: "None.")

### Deviations
- Phase N: [Name] - [what changed and why, one line] - [amendment ID, or "no amendment"]
- (only phases that deviated; none: "None.")

### Verification Runs
- [plan criterion, or a plain name for the run] (rung T1|T2|T3|T4) -> exit [code] - [N passed, M failed, K skipped]
- Mutation checks -> [N of M witnessed]; each one not witnessed is listed under Unproven Criteria. Omit when the plan names none
- (name the run, never write out the shell line; every run carries its rung; the T4 full-suite run from phase completion is mandatory here; counts the terminal printed, not what you expected)

### Unproven Criteria
- [plan criterion] - [manual | skipped | deferred | verified by inspection] - [why]
- (every test criterion that did NOT end in a green automated run; all green: "None.")

### Concerns
- [anything the next reviewer should specifically investigate or validate]
- (none: "None.")
```

## Rules
- **Be honest and specific.** Deviations and concerns are the whole point; an empty summary hiding real drift defeats it.
- **Keep to the five sections:** not a feature description or changelog; don't restate the plan.
- **Halts and the plan revision are how the next model reads everything else.** A reviewer comparing code to a plan amended twice mid-build reads the amendments as unexplained divergence unless the summary says which revision was built against. A deviation with no amendment is a different, more serious fact than one with an amendment, and only you can tell them apart.
- **Name each run, never its command line.** Identify by the plan criterion or a plain description ("full suite, project runner"); the command text lives in the plan. Environment values, arguments and headers have no business in a document passed between models and committed.
- **Counts, never output.** "All tests pass" isn't a report; the reviewer re-runs from the plan and compares. Copied terminal text carries values you didn't mean to publish and wording the next model may read as instruction.
- **A judgment the plan or brief explicitly left to you goes in Concerns,** with which way you went and what you checked. It is neither a deviation nor a halt (the contract told you to decide), and the reviewer must re-trace it, which it can only do against a choice you named. An unreported one reads as no decision made.
- **Unproven Criteria is the section you'll be tempted to leave empty.** Anything checked by reading, skipped as "obviously fine", or intended to come back to goes here; an omitted criterion reads as green and that is how an unbuilt path ships.
- **A rung is not decoration; never round it up.** The reviewer compares rung against rung; a T2 run reported as the full suite is a false claim every later gate inherits. Only ever proven at a scoped rung? Say so. Unclear? Report the narrower one.
- **Don't mention `review`.** Residual concerns go under Concerns in your own words, not attributed to the review.

## What happens next
Said, not saved: emit it into the conversation. It is this skill's one report, emitted in full because the next reader must rule on it; nothing around it is narrated. Not a file; inventing a path is how a handoff ends up where the reviewing model never looks.
- **Dedicated build model** (`build-model`): present the summary, then **STOP**. The user carries it to the main model.
- **Main model:** present it as the build record, then continue to `verify` and archive the plan.

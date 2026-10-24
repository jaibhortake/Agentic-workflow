<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Where this is answered

This table is the only place these assignments are written down. A skill that runs the audit names
its row here and does not restate the questions.

| Gate | Runs it against | Depth |
|---|---|---|
| `/brainstorm`, Current State Analysis | the problem space, before any approach is proposed | all eight, recorded in the decision document |
| `/brainstorm`, per approach | each approach's blast radius, before they are compared | the **impact trace**, all three axes, at survey depth: enough to cost the approach, not every `file:line`. It is what makes the Impact estimate a number instead of a paragraph |
| `/brainstorm`, Decision Audit | the approach you are about to recommend | re-check 3, 4, 5, 8 against the *chosen* design, and run the impact trace to full depth on it: only the winner is worth exhaustive tracing |
| `/brainstorm`, after the decision document is written | the saved document's own claims and names | the second sweep, both halves, before handing over to `/write-plan`. The codebase half is the impact trace, run against the document |
| `/write-plan`, Codebase Analysis | the concrete chosen design, not the problem space | all eight, recorded in the plan |
| `/write-plan`, the impact pass | the codebase's edges into and out of everything the plan changes the meaning of | the second sweep's codebase-side half, first part: the **impact trace**'s structural and functional axes, to full depth and counted. Writes the result block. Runs first of the plan's review passes, before the plan is saved or activated |
| `/write-plan`, the consolidation pass | the set the impact pass traced, and the units the plan's phases specify | the second sweep's codebase-side half, second part: the impact trace's **consolidation** axis and the **self-duplication inventory**. Writes the block's *Consolidation* part. Runs straight after the impact pass |
| `/write-plan`, the executability pass | the finished plan's own file and symbol list, the impact pass's additions included | the second sweep's document-side half: dropped, duplicated, inert, drifted |
| `/build-phase`, Plan Review | this phase's named files and symbols | 1, 3, 5, 8; a gap here is a halt, not a fix |
| `/build-phase`, Self-Review | this phase's new units, against those the earlier phases of this plan added | the **self-duplication inventory**; reusing an earlier unit as it stands is not a halt, changing it or extracting it outside this phase's files is |
| `/review`, Codebase Consistency | the code as built | 3, 5, 8, and the **self-duplication inventory** over the whole diff; a gap here is a finding |
| `/review`, before a Rework Brief is handed over | the brief's own names, files, lines and commands | the second sweep against the brief, both halves; a brief is a plan |
| Bug or quick-fix path, no plan | the fix you are about to make | 1, 2 and 8, before the fix. Question 2 is the one that matters here: a bug reached through four entry points is fixed at one of them and reported as fixed |

**The trace is run twice, at two depths, and that is not redundant either.** `/brainstorm` traces
every approach shallowly, because the comparison is what it is buying and an approach costed against
a third of its blast radius is costed wrong. `/write-plan` traces one design exhaustively, because
the file list is what it is buying. Tracing every approach to full depth would cost four times over
for three answers nobody uses; tracing the chosen design shallowly ships a plan with a third of its
callers named.

**The two full runs are not redundant.** `/brainstorm` asks the questions about a problem, when the
answers change which approach wins. `/write-plan` asks them about a design, when the answers change
which files the plan must name. An approach that survived question 4 in the abstract routinely fails
it once the design is concrete, and that is exactly the failure the second run is bought to catch.

**The later rows are narrow on purpose.** By the time a plan is being built or reviewed, the
questions are being asked of a decision that is already made, so only the ones that can still change
the outcome are run. Widening them there turns a build into a redesign, which is the thing the plan
exists to prevent.

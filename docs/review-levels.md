# Review levels, and which model runs each

Each level catches what the one before it cannot. Cost notes are rough orders of magnitude for comparing levels, not quotes. Levels 7 and 8 are built into `/review` when the harness can start a fresh subagent on a named model; the rest are what a long build adds around the workflow's gates.

| Level | When | Who runs it | What it catches |
|---|---|---|---|
| 1. The plan's own passes | while writing the plan | the planner: `/write-plan`'s ten passes with a type-checker or graph caller trace | design gaps, unnamed callers, plans that can't build in order |
| 2. Outside plan review | after level 1, per batch of phases | an outside model, read-only (fresh subagent on another model, or another CLI) | what the planner assumes: missed callers, wrong line ranges, rules that don't hold |
| 3. Pre-build review of a phase group | just before that group is built | an outside model; a small model when it fails twice on one brief | drift between plan and code that moved since; earlier findings not yet applied |
| 4. Re-review of closed phases | after rules change mid-plan | an outside model against the new rules | closed phases breaking a rule added later |
| 5. The driver's check of every build run | after each build-model run | whoever drives the build | hollow tests, claims the builder didn't do, files it shouldn't touch |
| 6. Mutation check | after each run and at the close | the driver, never the builder's word | tests that pass with the code broken |
| 7. Deep post-build review | once per `/review`, at its first round | a capable model with none of the build's context (`/review`'s deep read) | behaviour changes from the base branch, missed rules, design problems in built code |
| 8. Fix check | after each review round's fixes | the smallest model tier, fresh, given only the fixes and findings | findings not really fixed; new breakage in the rework |
| 9. Close gates | end of phase | the planner: full suite, type check, lint, every named mutation | anything the reviews and driver didn't run |

## Rules at every level
- **Verify every finding first-party before acting:** against the base branch for "as today", against the plan's state after earlier phases for a later phase. Reject only on running evidence, never on a grep that found nothing.
- **After every review, apply each finding to every later phase it reaches** before the next review starts.
- **Reviewers read committed code** whenever a build or mutations are running in the tree.
- **Each brief lists what's already known or ruled** so the reviewer spends on new problems.

## Who not to use
- Not a large model for fix checks: the smallest tier does them for cents and finds real gaps.
- Not the model that wrote the code to certify it: a builder's report is a claim.
- Not the planner's expensive model for everything: keep it for planning, verifying and closing.

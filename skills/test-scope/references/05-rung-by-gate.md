<!-- Ported from nikhilw/structured-agentic-workflow skills/test-scope/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Rung by gate

This table is the only place rung assignments are written down. A skill that runs tests names its row here and does not repeat the rung.

| Gate | Rung | Notes |
|---|---|---|
| `/build-phase` Step 3, per phase | T1, then T2 (T3 if the plan lists no T2) | The common case. T4 here, once per phase, is the waste this table exists to remove |
| `/build-phase` Phase Completion | **T4, always** | The builder's own honesty gate. Never cited from anywhere. This is the run the handoff reports |
| `/review` re-deriving the builder's claims | **T4, always** | The builder's reported run is a claim, never a citable run. Holds even when you built this yourself minutes ago and the tree is provably clean: re-deriving is the whole reason the review is worth running |
| `/review` while fixing findings inside a round | T1, then T2 or T3 | The "widening circles" |
| A mutation check, at any gate | T1: the test the check names, nothing wider | One run per mutation. A mutated run is evidence about one test, not a run of the phase: its counts are never the phase's counts, and never compared under *Recording* |
| `/review` sign-off | T4, or cite this review's own T4 when nothing changed since | |
| `/verify` | T4, or cite `/review`'s sign-off run | The plan-requirements checklist is not a test run and is never cited. It always runs fresh |
| Bug or quick-fix path, no plan | T2 or T3 by segment detection, then T4 at the completion claim | |

Two full-suite runs per feature are mandatory and cannot be traded away: the builder's at Phase Completion, and the reviewer's first-party one. Everything else is either scoped or cited.

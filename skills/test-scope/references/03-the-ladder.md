<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The ladder

The plan carries the actual commands in its **Test Commands** block. This file carries only the rungs.

| Rung | Scope | Typical shape |
|---|---|---|
| **T1 focused** | The tests for the change in front of you | The phase's own test criteria; the single test you just wrote |
| **T2 impacted** | Every test a change-aware selector says this change can reach | `pytest --testmon`, `jest --changedSince`, `vitest related`, `cargo test -p`, `go test` on the touched package |
| **T3 segment** | The full suite for the one segment that changed, plus **that segment's** static gates | Backend suite + its type checker; frontend suite + its type checker and linter |
| **T4 full** | The whole suite, every segment, every static gate | What the project runs in CI |

**T2 before T3.** A change-aware selector proves more than a segment suite and costs less, because it selects across the whole repo by actual dependency rather than by directory. Use T3 only when the plan lists no T2 tool for this project.

**A segment owns its own static gates.** A type checker, linter, or formatter runs because *its* language changed, never because a sibling segment changed. A UI-only change runs the frontend suite and the frontend type check. It does not run the Python suite and it does not run mypy. That is the single most common wasted run in this workflow.

### The one-minute rule

**If T4 costs under a minute, there is no ladder.** Run T4 at every gate and say once that you are doing so. The ladder buys back minutes; below that threshold it costs more in judgment than it saves in wall time. The plan's Test Commands block records T4's measured time. Without a plan, use what T4 actually took the first time you ran it.

### Escalation triggers

Scoped runs are the default, and **any one of these voids the default for that run**. Go to T4:

- A dependency manifest or lockfile changed.
- Build, packaging, or tooling config changed: the project file, the type-checker or bundler config, CI config, a Makefile or task runner.
- A shared, base, or cross-cutting module changed, or anything imported from more than one segment.
- A public interface, signature, or return type changed and it has callers outside the changed segment.
- A migration, schema, fixture factory, or shared test helper changed.
- A generated or vendored artifact changed, or an input a generator reads.
- The selector's own state is stale or absent: a fresh clone, a cleared cache, a `--testmon` database from before a rebase. Run T4 once to re-seed, then go back down.
- **You cannot tell which segment the change is in.** Uncertainty is an escalation trigger, not a reason to guess narrow.

### When there is no plan

Bug fixes and quick fixes skip planning, so nothing hands you a Test Commands block. Detect segments before you run anything:

1. Look for separate manifests at distinct roots, workspace or monorepo config, or conventional directories (`frontend/`, `backend/`, `api/`, `web/`, `packages/*`, `apps/*`).
2. Map each segment to its own test command and its own static gates.
3. If detection is ambiguous, that is the last escalation trigger above. Run T4.

Then: scoped while fixing, T4 once at the completion claim.

<!-- Ported from nikhilw/structured-agentic-workflow skills/build-model/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The Sequence

Run these steps **in order**. Each step has a clear owner; do not collapse them or skip ahead. Finishing one step is the trigger to start the next; not a reason to stop.

1. **Build; `/build-phase`.** Start at Phase 1 and advance through every phase. `/build-phase` owns the per-phase loop (Read + Review Plan → TDD → Scoped Tests → Self-Review) and auto-advances between phases. Individual phases run scoped per `/test-scope`; the full suite lands once, at Phase Completion. Let it run until all phases are built and that full-suite run is green, then take back its build completion report.

   Its first step at Phase 1 is a **plan review**: fresh eyes on the plan, the mirror of the `/review` you will run in step 2. You did not write this plan, which makes you the only reader of it without the author's assumptions. Take that seriously: a defect found there costs a paragraph, and the same defect found in step 2 costs a full rework loop. Surface and halt; do not redesign.

2. **Review; `/review`.** Run a holistic third-person review of the **entire** implementation. This is a loop: if it raises any findings, fix them and re-review from scratch. Continue until **zero open findings**. Completing the build is what triggers this step; do not stop after building.

3. **Hand off; `/build-handoff`.** Emit the Build Handoff Summary in its exact format. Review is a gate, not content; the summary does not restate the `/review` result.

4. **Pause.** Present the handoff summary and **STOP**. Do not run `/verify`, do not archive the plan, do not start new work. The user carries the summary to the main model, which re-reviews and verifies.

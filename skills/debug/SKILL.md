---
name: debug
description: "Entry point for any bug, failing test or unexpected behaviour. Runs the vendored systematic-debugging skill (root cause before fix), then requires a regression test and /verify. Maps to SAW's /systematic-debugging."
---

# Debug

This is the entry point. The method is the vendored `systematic-debugging` skill, from obra/superpowers.

1. **Read `../systematic-debugging/SKILL.md` and follow it in full**, including the files it links (`root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`) when it sends you there. Its Iron Law binds: no fix without a root-cause investigation first.
2. **Our additions, which that skill does not cover:**
   - **Every fix gets a regression test** that fails before the fix and passes after it. Write it test-first via `../test-driven-development/SKILL.md`. Where a test truly isn't feasible, say why in one line; `/verify` will ask.
   - **State the root cause in one sentence** in your reply. If the fix doesn't explain the symptom, keep looking.
   - **Sweep for the same pattern** elsewhere (one grep) and report what you found.
   - **Remove debug code** before you finish.
3. **After three failed fix attempts, stop.** Summarise what you've ruled out and ask the user. This matches the vendored skill's "question the architecture" step.
4. **Then `/verify`.** A bug fix is an S task unless the root cause is in shared code, a schema or an API, in which case re-size it (`/workflow`).

If `../systematic-debugging/SKILL.md` is missing, the install is incomplete: say so once, then apply steps 2 to 4 with reproduce, isolate, root cause, fix as the method.

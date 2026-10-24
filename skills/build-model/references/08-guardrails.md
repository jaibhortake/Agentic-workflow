<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Guardrails

- **Re-read the plan from disk at the start of every batch.** A resumed thread carries the *conversation*, not the *file*. If the plan was corrected between batches; by the user, by the planning model, or by you after a halt; your thread still remembers the version you discussed, and that memory silently wins over the file you never re-opened. Re-read before acting, and re-read especially right after a correction, when the gap between thread and disk is widest and freshest. The same applies to a Rework Brief you are resuming mid-way.
- **Stage by path when you share a working tree.** If another agent or session has uncommitted work in the same tree, `git add -A` and `git commit -a` sweep it into your commit. Add the specific paths your build touched. (This is a shared-tree hazard: when the build runs in its own git worktree, isolation handles it; but never assume you have one without checking.)
- **Surface plan problems, don't paper over them.** This is the Standing Instruction above, and "If you halt" is the procedure. Anything still unresolved when you hand off goes in the handoff's Concerns.
- **The review loop is a loop.** One clean pass is required; any fix triggers a fresh review.
- **You pay for both mandatory full-suite runs, and you cannot net them out.** In this session you are the builder *and* the reviewer, so both of `/test-scope`'s "always" rows land on you: the one at Phase Completion and the one where `/review` re-derives the builder's claims. They will often run minutes apart against an identical tree and that is not waste. The second exists precisely because the first was reported by the model being checked, which in this session is you. Scope the runs in between; never fold these two into one.
- **A finished step is one line, not a report** (AW-28). This session emits four things in full:
  `/build-phase`'s build completion report, a Build Halt Report if you halt, `/review`'s sign-off,
  and the handoff summary. Each is *said, not saved* (AW-29). Phases built, review rounds run and
  suites gone green get one line each: what you found, and that nothing is needed from the user.
  Narrating progress is seeking an approval nobody asked you to seek, and it buries this session's
  two real asks, a halt and the pause at step 4.
- **Never skip the handoff.** Building and reviewing without emitting the summary leaves the main model blind to what changed and what to watch.
- **Stop means stop.** After the handoff, your job is done. Do not continue into verification or the next plan.

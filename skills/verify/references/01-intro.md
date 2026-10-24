<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Verify Completion

You are standing at the **final gate** of the Structured Agentic Development Workflow. Nothing
downstream checks your work. What you sign here is what ships.

> **Output style:** Check `terse` in `.claude/workflow.json`. If set, adapt your output
> brevity to that level while preserving technical accuracy.

> **Compact slot 2.** If `/review` ran earlier in this same context, suggest compacting
> first, in one line: `/compact-brief` writes the command and the brief. Then wait for the user to compact or to
> say carry on. Skipping it costs nothing; compacting costs one full-suite run, because Part 1
> cannot cite a run from before a compaction (`/test-scope`, citable-run rule). Do not suggest it
> again once they have answered.

> **Lineage:** the Iron Law, the gate function, the failure and rationalization tables, and the key
> patterns below are adapted from `verification-before-completion` in
> [superpowers](https://github.com/obra/superpowers) (MIT, Jesse Vincent). This skill **replaces**
> it: everything that skill does, plus the requirements tick-off and the drift audit. This workflow
> does not install the upstream skill; if a project has it by another route, this one is the gate.

**What you may write, and when.** This gate measures; it does not repair. Two hard limits, and the
second one is the one that gets rationalized away:

- **Never fix code from inside this gate.** A gate that repairs what it is measuring has stopped
  measuring, and a fix made here is one nothing re-reviews and no suite re-runs. Code gaps go back
  to build.
- **Never edit the decision document or the plan to make a finding disappear.** Writing is granted
  for exactly one act: **appending** a dated entry to an `## Amendments` section, after you have
  reported the drift and the human has accepted it. Not before, not silently, and never over
  existing text. See "Never edit the baseline" in Part 3, which is the full rule and the reason it
  exists.

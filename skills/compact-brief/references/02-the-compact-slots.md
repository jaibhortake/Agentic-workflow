<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The compact slots

The main model suggests compacting at two points, in one line, and waits for the user to compact
or to say carry on. It is a suggestion: skipping it costs nothing.

- **Slot 1: the plan is approved, before the build**, whichever route builds it. Brainstorm and
  plan review are not needed again; the files hold what they decided. On the same-model route it
  also makes `/build-phase`'s opening plan review a fresher read.
- **Slot 2: before `/verify`.** Review rounds, outside reviews and rework have filled the
  context, and verification's tick-off and drift audit are document comparisons that read best
  without them. Compacting here costs one full-suite run: see *What it costs*.

A `/build-model` session has no slot; it ends at the handoff. The user can also ask for a brief at
any other time.

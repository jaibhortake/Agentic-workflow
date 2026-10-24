<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## If you halt

A halt suspends the sequence; it does not end your session and it does not skip you ahead.

1. Emit the **Build Halt Report** from `/build-phase` and stop that phase. Leave the tree in the
   state the report describes.
2. **Do not carry on with a later phase to stay productive.** Phases are ordered by what could
   invalidate the plan, so building past an unresolved halt is building on the thing in question.
   The one exception is a phase the planning model explicitly tells you is independent of it.
3. When the amended plan comes back: re-read it **from disk**, read the Amendment Log entry that
   covers your halt, re-run the plan review against the amended sections, then resume at the phase
   you stopped in. `/build-phase`'s *"Resuming After a Halt"* has the full sequence.
4. **Every halt goes into the handoff**, with how it was resolved. A halt that was amended, a halt
   the user overruled, and a halt you withdrew after investigating are three different facts about
   this build, and the reviewing model needs all three.

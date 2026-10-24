<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Why this exists

The expensive failures of this workflow are almost never bad trade-off analysis. They are analysis
that was never done: a mechanism that already existed under a name nobody searched for, a caller
nobody enumerated, a subsystem left unreachable by a change that replaced it, a second pathway
bolted alongside the first because unifying them was never considered.

These questions find something almost every time they are asked. That is the whole argument for
asking them by default instead of waiting for a human to ask them again.

They are also the reason the *ideal-then-adjusted* derivation in `/brainstorm` is worth running:
you cannot adjust an ideal design to fit existing decisions until you have written down what the
existing decisions actually are.

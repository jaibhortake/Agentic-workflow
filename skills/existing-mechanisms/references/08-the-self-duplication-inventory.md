<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The self-duplication inventory

Every question above looks outward, at code that existed before the change. This one looks at the
change itself. It is the check that catches a plan's own helpers, lookups and call skeletons written
two or three times over, which no outward search can see because none of the copies existed when
the search ran.

1. **List every unit the artifact adds.** Each new function, method and class, and each new block
   of more than a few lines inside an existing function. From a plan, the units its phases
   specify; from a build, the added lines in the diff against the comparison base, not the file list.
2. **Say what each one does, in one line, as behaviour**: what it takes, what it does to it, what
   it returns or changes. Not its name; two copies of one job rarely share a name.
3. **Group the lines that describe the same job**, including in part: the same skeleton with a
   different step in the middle (build the prompt, call the model, parse, retry), the same lookup
   keyed differently, the same calculation with a different constant.
4. **Settle each group of two or more** as one of three: **extract** it into one unit the others
   call, **reuse** the earlier unit as it stands, or **keep them apart** because they change for
   different reasons, naming the reason each one changes. "They look different" is not a reason, and
   a pair kept apart without one is a duplicate.

Check the same list against existing code while you have it; that is question 3's first half, and it
costs nothing more here.

```markdown
**Self-duplication inventory**
- *Listed:* [N] new units, from [the plan's phases / the diff against <base>]
- *Groups:* [N] doing the same job: [each: its units at `file:line` or by phase → extract / reuse /
  kept apart because <what each changes for>]; or "none"
```

A gate whose own template has a *Self-duplication* line records this there instead of pasting the
block. The count of units listed is the part that shows the inventory was walked. "No duplication found"
without it is the answer of an inventory that was never made.

<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The second sweep

**Expect the first pass to be incomplete.** It is run against the problem while the design is still
in your head. The second is run against what you actually wrote, and that is where precision
defects surface: the ones that are invisible in a summary and obvious in a file list.

Three things make the second sweep find what the first missed. Drop any one and it degrades into
confirming the first.

- **Run it against the artifact, not your memory of it.** Take the finished document's own list of
  names, files, symbols and commands, and walk it back against the codebase mechanically, both
  directions per question 1. "I checked that earlier" is the answer that produces nothing. **Count
  what you find rather than estimating it:** a document that says four call sites where there are
  seven is executed at four, and the three nobody counted are found by a build failure or by
  nobody.
- **Hunt a named list.** Generic re-reading finds generic problems. These are the classes that
  actually recur: a **dropped** step or requirement that quietly vanished between documents; a
  **deletion or abandonment** that left callers, tests, config or data dangling; a **duplicate** of
  something that already exists; a **missed caller**, especially one that does not spell the name;
  a **bifurcated** pathway added beside an existing one; an **inert** change, one that does nothing
  unless a second change lands with it, most often two guards on consecutive lines where removing
  one leaves the other holding the door shut; and **drift** from what was decided. Say which you
  are looking for before you look.
- **Give yourself permission to reverse.** A sweep that can only confirm is not a sweep. Finding
  four defects in your own finished work is the mechanism paying for itself, not a failure.

**The document half and the codebase half are separate passes wherever a gate runs both.** Walking
the document's names outward and walking the codebase's edges inward start from opposite sets, and
the second returns things the document never mentioned, so a gate that merges them answers the
second with the first's method and reports clean. `/write-plan` splits them into its impact and consolidation passes on one side and its
executability pass on the other for exactly that reason, and `/brainstorm`'s decision audit splits them the
same way.

**The codebase half is the impact trace, run against the artifact.** All three axes, not just the
structural one: the document's own names walked back to the code, the flows those names sit in,
and the verdict on what the codebase looks like afterwards.

**A sweep that emits nothing did not happen.** Write the result down every time, including when it
is clean, in this shape:

```markdown
**Second sweep**
- *Hunted:* [which of the named classes above, by name]
- *Walked:* [N] names and files out of the document, both directions; [N] call sites found against
  the [N] the document claims
- *Found:* [each defect, one line; or "nothing"]
- *Changed:* [what was edited as a result; or "nothing"]
```

The counts are the part that cannot be produced from memory, which is why they are the part that is
required. "I re-checked and it looks right" is the output of a sweep that was never walked, and it
is indistinguishable on the page from one that was.

**"Anything else you would rethink?" is a trigger, not a question.** When a human asks it, or when
you are about to hand work over as done, re-run the sweep for real. Answering it from memory is the
single cheapest way to waste the most valuable question anyone will ask you.

**And do not wait to be asked.** When that question reliably finds defects, the sweep before it was
not run, whatever was reported. The human's version of it works because it names the evidence to
produce: trace the calls forward and backward, pinpoint the call sites, say what impacts this and
what is impacted by it. That is this sweep, in a user's words. Producing it only when prompted
means every unprompted handover shipped the version with the defects still in it.

<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## When a build halt comes back

A halt arrives as a **Build Halt Report**: where it stopped, what the plan said, what the builder
found, why it blocks, the options, its recommendation, and the state of the tree. The builder
stopped there deliberately and changed nothing around it. Resolving it is your job, not the user's
and not the builder's.

**This applies when you are also the builder.** In a single-model session the halt is not a message
between models; it is a change of act. Stop building, come back to this document as its author, and
run the six steps below anyway. The written amendment, not the handover, is what the rest of the
workflow reads.

Work it in this order. Do not skip to step 4; amending a plan around a report you have not verified
is how a wrong halt gets written into the contract.

1. **Verify the report first-party.** It is a set of claims about the codebase, not a verdict. Open
   the files, run the command, read the caller. Build models are frequently right about the symptom
   and wrong about the cause, and a halt caused by the builder misreading the plan needs a
   clarification, not a redesign.
2. **Classify what you found.** The class decides the response, and getting this wrong is how a
   plan absorbs changes it should have refused:
   - **Plan defect.** The plan is wrong, ambiguous, or names something that does not exist. Amend
     the plan.
   - **Reality defect.** The codebase or an external system does not behave as the plan assumed.
     Amend the plan, and check whether the assumption was load bearing anywhere else in it.
   - **Decision-level problem.** The finding undermines the approach itself, not this phase of it.
     This is the one that must not be patched. Say so plainly, and take it back to `/brainstorm`
     with the user; a decision-level problem absorbed as a phase amendment is the single largest
     source of drift in this workflow.
   - **Builder error.** The plan was right and was misread. Clarify the plan if the wording invited
     the misreading, and say explicitly that the plan's substance is unchanged.
3. **Check the blast radius before writing the fix.** The thing that broke this phase usually
   breaks two later ones. Re-run the affected part of `/existing-mechanisms` question 1 and the impact
   pass's trace against the change you are about to make, and look at every later phase that
   depends on it. A halt fixed one phase at a time, three times, is a decision-level problem being
   paid for in instalments. **This step applies to every finding that amends the plan**, not only to
   halts: a review finding before or after a build, and one from a re-review of a closed phase. A
   finding is a class, not a case. Write it into its phase, and say in each later phase it reaches how
   it applies there, before the next review or build of any of them starts. And check a finding about
   a later phase against the plan as it will stand once the earlier phases are built, not against
   today's tree: an earlier phase may already have moved the code it names.
4. **Amend the plan, and log it.** Edit the phases the fix touches, then append the Amendment Log
   entry: trigger, what was reported, what changed, decision impact, scope impact. If the amendment
   supersedes something in the decision document, name that decision in the entry, then **stop and
   put AW-27's ask to the user**: quote what the decision document says, say what upholding it would
   cost, and let them state the new intent in their own words. **You do not write to the decision
   document.** It records their intent, not your finding, and a halt is not authority to change it.
   If they declare the change, append *their words* there under the original; if they do not, the
   decision stands and the plan is amended to work within it. Raise it now, while you know why: that
   pair of entries is what `/verify`'s drift audit reads, and reconstructing it at the
   end, from a plan and a codebase that have both moved, is the days-long archaeology this whole
   loop exists to avoid.

   **Append; never rewrite what a decision said.** The decision document records what was decided
   at the time, and a superseded decision is still what was decided. Add an entry underneath
   saying what replaced it and why; do not edit the original to match the new direction, and do not
   quietly delete a consequence that stopped being true. The same goes for the plan's own Amendment
   Log: entries are added, never revised. Both documents are only worth anything later if a reader
   can see what changed *and* what it changed from.
5. **Re-run the affected review passes, in their order.** An amendment is new plan text and has had
   no review. Run the **impact pass** against it whenever the amendment changes what an existing
   symbol does, which is most amendments; and run it first, for the same reason it runs first on a
   fresh plan: it is the one that can still change what the amendment has to contain. Then the
   **consolidation pass**, if the amendment adds a unit, a path or a flow. Then the
   **removal pass**, if the amendment deletes or stops calling anything. Then the
   **logic pass**, if the amendment changes how anything behaves at runtime: a rule, an ordering, a
   write, a default. A halt is usually the build hitting a case the plan never walked, so the fix
   gets walked through that case and the cases next to it. Then the **behaviour** and
   **business-sense passes**, if the amendment changes what a user sees or gets. Then the **contracts pass**, if it
   touched contracts, failure modes, or phase ordering. Then the **proof pass**, if it added or
   changed a criterion or broke an existing test (a halt on a failing test usually did both). Then
   the **coherence pass**, always, because an amendment is exactly an edit made in one place that
   the rest of the document has not caught up with. Then the **executability pass**, always,
   because the amendment introduces new names and new commands. If these passes changed what the
   amendment contains, run them again over that change until a round changes nothing (RL-6). An
   amendment is a change to a plan that was already traced, so its impact is the part nobody has
   looked at, and step 3 above only sized the blast radius of the fix you intended.
6. **Hand the plan back, and say what changed.** Tell the builder which phases were amended and the
   amendment ID, and tell it to re-read the plan from disk rather than from its thread. A resumed
   build thread remembers the version it discussed, and that memory silently beats the file nobody
   re-opened.

**Amend the plan even when the fix is obvious and small.** The temptation is to answer the halt in
chat and let the builder carry on. Then the plan describes a system that no longer matches the
code, the handoff reports a deviation nobody can trace, and the final drift audit has nothing to
compare against. One paragraph now; days of archaeology later.

<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## After the Audit: Save the Decision Document

Once the user has picked a direction (or the discussion has reached a natural conclusion), **ask the user if they'd like to save the discussion as a decision document, and recommend saving it.** Brainstorming sessions are where architectural decisions are made and trade-offs are weighed; this context is valuable and worth preserving.

Say why when you ask, because the reason has changed: the document is the baseline `/verify` audits the finished feature against. Without it, drift between what was decided and what shipped has nothing to be measured against, and the only remaining record is the plan, which is the thing that drifted.

If the user agrees, write a decision document to `docs/decisions/YYYY-MM-DD-<topic>.md` with this structure:

```markdown
# Decision: [Topic]

*Date: YYYY-MM-DD*

## Problem
[What we were trying to solve]

## Existing Mechanisms
[The `/existing-mechanisms` ledger, all eight lines, with the evidence behind each. This is what a
later reader checks the shipped code against, so keep the answers, not a summary of them.]

## Impact
[The **impact trace** result block for the chosen approach, from `/existing-mechanisms`, at the full
depth the Decision Audit ran it. All three axes with their counts: structural (call sites, callees,
dependency directions, the edges that do not spell the name), functional (flows changed, flows
depended on, logical couplings), consolidation (what is left unused, what is abandoned, whether this
unifies or bifurcates, what gets extracted and reused). `/write-plan` traces this again against the
concrete design and expects to find more; this block is what it starts from, and a departure from it
is a thing a later reader can see.]

## Contracts & Constraints
[The ledger lines that mattered; authority, identity/cardinality, currentness, lifecycle, consumers, environment. Include the ones that came back `unknown` and how they were handled.]

## Approaches Considered

### [Approach A name]
- **How it works:** [summary]
- **Pros:** [list]
- **Cons:** [list]
- **Impact:** [blast radius summary]

### [Approach B name]
...

### [Approach E name] (ideal, then adjusted)
- **Ideal design:** [what this problem deserves in this project]
- **Adjustments:** [each: ideal wanted → existing decision in the way → concession → cost]
- **Resulting design:** [ideal plus adjustments]
- **What would close the gap later:** [the change that would let an adjustment be reversed]

## Decision
**Chosen approach:** [name]

**Distance from the ideal:** [the resulting design of E, or further away by these concessions]

**Why this approach won:**
- [key reason 1; with the evidence tier behind it if it was load-bearing]
- [key reason 2]

**What would reverse this decision:** [the condition under which the runner-up wins]

**Scenario table:** [when this decision moves a rule, the table from §4: the cases, today's outcome,
the decided outcome, and every differing row labelled as the fix or as collateral the user accepted.
When it does not move a rule, this line says "not a rule change" and stays; a heading that is
present and answered is evidence the question was asked, and a missing one is not.]

**Why the others were rejected:**
- [Approach X]: [specific reason it lost]
- [Approach Y]: [specific reason it lost]

## What the User Sees
*(The behaviour and business-sense lenses' output for the chosen approach. The plan's behaviour pass
checks every sentence here has a phase and a criterion, `/review` runs the built thing against
them, and `/verify` checks them again as part of the drift audit.)*
- **Who:** [the typical user, named by role]
- **Expectations, in their words:** [one sentence per main action: "I delete the document and its entities go with it"] → [what the design does, and where it differs, why]
- **Surfaces:** [every screen, report, export and prompt that shows the changed data]
- **Would find odd:** [each thing a typical user would not expect, and what the owner said about it; or "nothing", with what was walked]

## Consequences
- [What this decision enables]
- [What this decision makes harder or rules out]
- [What gets retired by this decision, and what becomes dead code once it lands]
- [What to watch for / revisit if assumptions change]

## Amendments
*(Empty at the time of writing, and it stays empty while this document is still live: until the
plan moves out of `docs/plans/new/`, edit the document freely and leave this section alone. A
change of mind before that point is not an amendment, it is content, and it belongs in Approaches
Considered. After that move the document is append-only and only the user amends it; a gate
proposes, the user declares, and the entry carries their words. See AW-27.)*
```

This document is not a record of a conversation; it is the **baseline** the whole feature is later
measured against. `/write-plan` maps each decision here into the plan, `/review` reads it as
binding, and `/verify` compares it line by line against what actually shipped. Write it
so a reader who was not in the session can tell whether the shipped code is still what was decided.

What it records is **intent**: what the user set out to achieve and what they ruled out; which is
why they are the only one who can change it once anything has been approved against it. Every gate
downstream may find that reality disagrees with this document; none of them may resolve that by
editing it (AW-27).

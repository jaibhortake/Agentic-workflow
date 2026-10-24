<!-- Ported from nikhilw/structured-agentic-workflow skills/verify-completion/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Part 3: The drift audit (decision → plan → code)

Do for the decision document and the plan exactly what Part 2 does for the plan and the code: read
both, line by line, and name every difference.

**Read-only until the report is delivered.** Both documents are evidence for the whole of this
part. You are comparing them, not maintaining them, and the difference you find is the output, not
a problem to tidy up. "Never edit the baseline" below is the full rule; read it before you start
comparing, not after you have found something.

**If no decision document exists** (a bug fix, a quick fix, or a plan written without a brainstorm),
say so explicitly, run the Plan → Plan comparison, and record that the two decision-document
comparisons had nothing to read. Silence about a missing decision doc reads as "checked, matched".

**Label things with what they are.** The three comparisons below (DecisionDoc → Plan, Plan → Plan
and DecisionDoc → Code) are named for the two documents they read, because that is the only name a reader can decode without this file in front of them.
Never invent a short code for them, and never let a label stand in for a finding: "3 upheld, 1
widened" is a tally of findings with the findings removed, while "the endpoint check accepts any
OpenAI-format server, and the decision document says a local host process" is the finding. Part 4
is the shape the output takes.

### Baseline: is the decision document still the one that was agreed?

The audit is only worth what its baseline is worth, so fix the baseline first and say where it came
from.

- **Read the decision document from version control where it is tracked** (`git log --follow -p --
  <doc path>`, or `git show HEAD:<doc path>`), not only from the working tree. The committed
  history is the one copy that cannot be quietly reshaped to match the code.
- **Compare it against the working copy.** If they differ, something edited the baseline during or
  after the build. That is not a detail to absorb: find out what changed, who changed it, and
  whether it was recorded, and put it in the report. An edit to the Decision or Consequences
  sections with no Amendments entry is itself a finding, and a serious one.
- **If the document is untracked**, say so in the report. You are auditing against a baseline that
  anyone could have edited at any time, which weakens every conclusion below, and the human should
  know that before reading the verdict.

### DecisionDoc → Plan: what was decided, against the plan as it now stands

Read the decision document and the current plan side by side. For every decision in the document,
and every consequence it recorded:

| Disposition | Meaning | Acceptable? |
|---|---|---|
| **Upheld** | the plan implements the decision as written | yes |
| **Narrowed** | the plan implements part of it, deliberately, and says so | yes, if the plan says so |
| **Superseded** | the plan does something the decision ruled out | only with an Amendment Log entry naming the decision it supersedes |
| **Dropped** | the decision is simply absent from the plan | **no**, this is the finding |

A decision the plan's Decision Source lists as *Carried by another plan* is not dropped; it is audited with that plan.

**Record both sides as you go, and quote them.** The disposition word is your judgment about a
difference; it is not the difference. Write down the decided text in the words it was decided in,
and what the plan or the code does instead, with the file and line where it does it. Do it while
both documents are open, because reconstructing the quote later is what turns a finding into
"narrowed" and loses the only part the human needed.

Also check the two lines of the decision document that age fastest:

- **"What would reverse this decision."** The document named the condition under which the
  runner-up wins. Did it come true during the build? A build that discovers exactly that condition,
  patches around it, and ships the original approach anyway is the most expensive form of drift
  there is, and no single amendment entry will show it.
- **Open Questions.** Each is answered, or still open and carried forward in writing. An open
  question that quietly stopped being asked was answered by whoever wrote the code.

### Plan → Plan: the approved plan, against the plan as it now stands

Every difference must have an entry in the plan's **Amendment Log**. Establish the approved
baseline in this order, and say which one you used:

1. **Git history of the plan file** (`git log --follow -p -- <plan path>`), if it is tracked. This
   is the only baseline that cannot be edited after the fact.
2. **The Amendment Log itself**, read as a claim rather than as proof.
3. **The copy the build model was handed**, if the user still has it.

If the plan was never tracked and the log is empty while the code plainly implements something the
plan does not describe, that absence *is* the finding. Write it that way.

### The scenario table, if the decision document has one

A decision that moved a rule carries a table of cases with the outcome decided for each (BS-13),
and it is the only part of the decision document that ticks off mechanically rather than being read
for intent. Take each **differing** row, find what the code now does in that case, and compare. A
row labelled *collateral* is the one to check hardest: it was a behaviour change nobody asked for,
the user accepted it explicitly, and it is the likeliest thing in the whole document to have been
built as though it had never been decided. A row whose built behaviour does not match its decided
outcome is a drift finding like any other, and it is reported with both cells quoted.

### What the User Sees, if the decision document has it

The same check for the section that records what the user was promised (BS-14): each expectation
sentence, in the user's words, against what the built thing does on the surface where the user
would check it. Run it where you can drive it, and say where you only read the code. A sentence the
build does not honour is a drift finding, reported with the sentence quoted beside what the user
actually gets. So is an item under *Would find odd* that the owner ruled on and the build ignored.

### DecisionDoc → Code: what was decided, against what actually shipped

The round trip, and the one that catches what the two comparisons above cannot on their own. Read
the decision document's **Problem** statement, then read the code. Answer in your own words:

- Does what shipped solve the problem that was decided, or a neighbouring one?
- Would the approach comparison in that document still choose this approach, knowing what the build
  found out?
- Did the accumulated amendments move this to a different approach than the one chosen, without any
  single amendment saying so?

The third question is the point of this gate. Six reasonable amendments can add up to Approach C
while every entry in the log reads like a detail.

**A "yes" to any of those three goes to the human, even when every amendment is logged.** Perfect
bookkeeping and a feature that ended up somewhere nobody chose are entirely compatible states, and
this is the last moment anyone is looking at both documents at once.

**Scale the audit to what actually moved.** A plan with an empty Amendment Log and a decision
document it never departed from is audited in minutes: the plan-against-plan comparison is trivially
clean, and the two decision-document reads are one careful pass over documents you already have
open. The work grows with the drift, which is the
correct shape; if this gate feels expensive, that is the feature telling you something.

### Never edit the baseline to make the drift go away

**This is the one way this gate can do more harm than not running at all.** You will find a
difference, and the cheapest-looking move will be to change the decision document so it matches
what was built, then report no drift. Do not do it. Rewriting the baseline does not remove drift;
it destroys the only evidence that drift happened, and it produces a false clean verdict that every
later reader believes. The whole feature was measured against that document. The moment you edit
it, you are no longer measuring anything.

Concretely, during this gate you may not:

- change, reword, soften, "clarify", "correct", or delete **one word** of the decision document's
  Problem, Contracts, Approaches, Decision, What the User Sees, or Consequences sections, or of any existing Amendments
  entry;
- change, reword or delete any part of the plan, including existing Amendment Log entries;
- do any of the above and then report a better verdict.

**Where this gate writes, and that is all of it:** an `## Amendments` entry appended to the end of
the decision document and the matching entry appended to the plan's Amendment Log; both only
after the human has ruled; and the `mv` that moves the plan to `done/`. The completion report
itself is said, not saved (AW-29).

**The verdict is a fact about what the build did, not about what the documents say right now.** If
the work departed from a decision and nobody recorded it, that is UNDOCUMENTED DRIFT, and it stays
UNDOCUMENTED DRIFT in this report no matter what gets written down afterwards. It cannot be turned
into DOCUMENTED DRIFT by you, in this session, with a keystroke. Writing the record later does not
change what was found; it only means the next person inherits an honest document.

### The verdict, and what to do with it

| Verdict | Meaning | Action |
|---|---|---|
| **NO DRIFT** | plan implements the decisions; code implements the plan | record it and move on |
| **DOCUMENTED DRIFT** | differences exist and every one was written down **before you got here** | report each one; the human confirms it is still the feature they wanted |
| **UNDOCUMENTED DRIFT** | a difference nobody wrote down | **blocking, and it stays on the report.** Status is NOT COMPLETE until the human rules on it |

**Report first. Writing is a separate act, and it is the human's call.** Present the drift report,
say plainly what departed from what, and stop. Then:

- **The human accepts the departure.** Only now may you append to the record, and only by adding to
  an `## Amendments` section at the **end** of the decision document, leaving everything above it
  untouched. Every entry is dated and says it was found here, so nobody later mistakes it for
  something that was decided before the work.
- **The human rejects it.** The gap is in the work, not the record. It goes back to build, and the
  status stays NOT COMPLETE.
- **The human says nothing yet.** Nothing is written. An unanswered question is not consent.

```markdown
## Amendments
### YYYY-MM-DD: [what changed]  *(found at verification, accepted by the human)*
- **Supersedes:** [the decision or consequence in this document, quoted so the original is legible]
- **Now:** [what was actually built]
- **Because:** [what the build or the plan found that the decision did not know]
- **Recorded in:** [plan Amendment Log entry ID, or "no plan entry existed; this gap was found here"]
```

Then add the matching plan Amendment Log entry if one is missing, appended the same way.

The point of the written record is that a later reader can see **both** what was decided and what
happened instead. An amendment that replaces the original leaves them one story and no way to tell
it was ever a different one.

---

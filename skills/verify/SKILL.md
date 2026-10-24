---
name: verify
description: Final gate before any "done", "fixed" or "passing" claim, commit or PR. Fresh suite status, line-by-line requirements tick-off, and a three-comparison drift audit from decision doc through plan to code. Evidence before assertions, always.
---

# Verify

You stand at the **final gate**. Nothing downstream checks your work; what you sign here ships.

**Compact slot 2.** If `review` ran earlier in this same context, suggest compacting first in one line (`compact-brief` writes the command and brief) and wait for the user to compact or say carry on. Skipping costs nothing; compacting costs one full-suite run, because Part 1 can't cite a pre-compaction run. Don't suggest it again once answered.

**Lineage:** the Iron Law, gate function and rationalization tables adapt `verification-before-completion` from [superpowers](https://github.com/obra/superpowers) (MIT), plus the requirements tick-off and drift audit.

**What you may write, and when.** This gate measures; it does not repair. Two hard limits (the second is the one that gets rationalized away):
- **Never fix code from inside this gate.** A gate that repairs what it measures has stopped measuring, and a fix made here is one nothing re-reviews or re-runs. Code gaps go back to build.
- **Never edit the decision doc or plan to make a finding disappear.** Writing is granted for exactly one act: **appending** a dated entry to an `## Amendments` section, after you reported the drift and the human accepted it. Not before, not silently, never over existing text.

<!-- refs:start -->
## Full detail (read at the matching step)
This SKILL.md is the binding gate. Each section's full explanation, examples and rationale, ported from SAW, is in `references/`. Before you run a section below, read its file. Where a file and this SKILL.md differ, this SKILL.md wins.

| Section | File |
|---|---|
| Verify Completion | [references/01-intro.md](references/01-intro.md) |
| What this gate is, and is not | [references/02-what-this-gate-is-and.md](references/02-what-this-gate-is-and.md) |
| The Iron Law | [references/03-the-iron-law.md](references/03-the-iron-law.md) |
| The Gate Function | [references/04-the-gate-function.md](references/04-the-gate-function.md) |
| Part 1: The suite, true right now | [references/05-the-suite-true-right-now.md](references/05-the-suite-true-right-now.md) |
| Part 2: Requirements tick-off (plan → code) | [references/06-requirements-tick-off.md](references/06-requirements-tick-off.md) |
| Part 3: The drift audit (decision → plan → code) | [references/07-the-drift-audit.md](references/07-the-drift-audit.md) |
| Part 4: The completion report | [references/08-the-completion-report.md](references/08-the-completion-report.md) |
| Common failures | [references/09-common-failures.md](references/09-common-failures.md) |
| Red flags, stop | [references/10-red-flags-stop.md](references/10-red-flags-stop.md) |
| Rationalization prevention | [references/11-rationalization-prevention.md](references/11-rationalization-prevention.md) |
| Key patterns | [references/12-key-patterns.md](references/12-key-patterns.md) |
| When to apply | [references/13-when-to-apply.md](references/13-when-to-apply.md) |
| The bottom line | [references/14-the-bottom-line.md](references/14-the-bottom-line.md) |
| What happens next | [references/15-what-happens-next.md](references/15-what-happens-next.md) |
<!-- refs:end -->

## What this gate is
**Not a second review:** `review` proved the *code* is sound. This proves three things review doesn't: (1) **the suite is green right now** (review may have passed several edits ago); (2) **every requirement was built** (review judges completeness qualitatively; this is line by line); (3) **what shipped is still what was decided** (plans drift: every halt, constraint and reverted phase moves the plan a little, and the accumulated distance from the decision doc is invisible from inside any step; this is the only place the whole chain is read end to end). Check 3 exists for a specific expensive failure: you set out to build one thing, the plan absorbed a dozen reasonable corrections, and what shipped is a different thing nobody noticed for days.

## The Iron Law
```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```
No claim without running the verification yourself, this session. The only exception is a citation meeting all four `test-scope` conditions, an exception in name only (a citation is a *stricter* claim: the suite passed and nothing changed since). A run someone reported, a run from before an edit, or a narrow run in wide words is not evidence. **Violating the letter is violating the spirit.**

### The gate function
```
BEFORE claiming any status or expressing satisfaction:
1 IDENTIFY  what proves this claim (command, checklist, document comparison)
2 RUN       execute it fully, fresh, now
3 READ      full output, exit code, counts, both sides of every comparison
4 VERIFY    does the evidence confirm the claim? NO: state the actual status with evidence. YES: state the claim with evidence
5 ONLY THEN make the claim
Skip any step and you are asserting, not verifying.
```

---
# Part 1: the suite, true right now
`test-scope` row "verify": the full suite (T4), or a citation of review's sign-off run. Four conditions, not a judgment call: you made it this session, same command and rung, `git status --porcelain` and `git diff` clean since, and you write the citation naming what proved the tree unchanged. Fail any: no citation, a run you still owe. Pass all four and the citation is *stronger* than a re-run (it also proves nothing changed): don't re-run from caution. **The citation covers Part 1 only;** Parts 2 and 3 are document comparisons, never cited, always fresh. Commands are bounded by `test-scope` *What a run may execute*. Also run lint and type-check/build from `CLAUDE.md` or the plan's Test Commands.

**Bug fix or logic change?** The diff must contain a test that fails on the old code, shown **red then green:** write the test, run it (passes), revert the fix, run it (**must fail**), restore, run (passes). A regression test never seen failing isn't known to test the regression; the revert takes seconds. None? Add one now and re-run. Applies to S tasks too.

# Part 2: requirements tick-off (plan -> code)
Re-read the plan from disk (not memory, handoff or review). Build a checklist: **every phase, step and test criterion, one line each:** **built and proven**, **built but unproven**, or **not built**.
- **Proven means an automated run you can name.** Checked by reading is *unproven*; proven only at a scoped rung is a real but narrower result: both go on the report.
- **Walk the plan's own sections,** not just phases: State and Data Contracts, Failure Modes, Value Paths and Seam Tests each specify behaviour; a named seam test never written is a missing requirement.
- **Anything in Out of Scope that got built is a finding** (scope grows silently; this is the only line that catches it).
- **Anything removed comes with its replacement named:** walk the plan's removal table against the diff (`existing-mechanisms` Q5). A row whose replacement never landed, and a deletion the table never named, are each a capability the feature took away; report in those words. The suite can't see this (the tests covering the removed path were usually deleted with it, so the same commit destroys the evidence).
A gap here doesn't fail the gate by itself; an *unreported* gap does. The output is a truthful ledger; the human decides whether an unproven row is acceptable. S tasks (no plan): state what you checked.

# Part 3: the drift audit (decision -> plan -> code)
Do for the decision doc and the plan what Part 2 does for plan and code: read both line by line and name every difference. **Read-only until the report is delivered:** the difference you find is the output, not a problem to tidy.

**No decision doc** (bug fix, quick fix, plan without brainstorm)? Say so explicitly, run Plan -> Plan, and record that the two decision-doc comparisons had nothing to read. Silence reads as "checked, matched". **Label with what things are:** the comparisons are named for the two documents they read; never invent a short code, and never let a label stand in for a finding ("3 upheld, 1 widened" is a tally with the findings removed; "the endpoint check accepts any OpenAI-format server and the decision doc says a local host process" is the finding).

### Baseline: is the decision doc still the one agreed?
Fix the baseline first and say where it came from. Read the doc **from version control where tracked** (`git log --follow -p -- <path>`, `git show HEAD:<path>`), not only the working tree: committed history is the one copy that can't be quietly reshaped to match the code. Compare against the working copy; a difference means something edited the baseline during or after the build, so find what, who, and whether it was recorded (an edit to Decision or Consequences with no Amendments entry is itself a serious finding). Untracked? Say so: you're auditing against a baseline anyone could have edited, which weakens every conclusion.

### DecisionDoc -> Plan
For each decision and consequence the doc recorded, against the current plan:
| Disposition | Meaning | Acceptable? |
|---|---|---|
| Upheld | the plan implements it as written | yes |
| Narrowed | the plan implements part, deliberately, and says so | yes, if the plan says so |
| Superseded | the plan does what the decision ruled out | only with an Amendment Log entry naming the decision it supersedes |
| Dropped | absent from the plan | **no: this is the finding** |
A decision the plan lists as "carried by another plan" is audited with that plan. **Record both sides and quote them:** the disposition word is your judgment about a difference, not the difference; write the decided text in its own words, and what the plan or code does instead with file and line, while both are open (reconstructing it later turns a finding into "narrowed" and loses the part the human needed). Also check the two lines that age fastest: **"What would reverse this decision"** (did the condition come true during the build? A build discovering exactly that, patching around it and shipping the original approach is the most expensive drift, and no single amendment shows it) and **Open Questions** (each answered, or carried forward in writing; one that quietly stopped being asked was answered by whoever wrote the code).

### Plan -> Plan
The approved plan against the current plan; every difference needs an Amendment Log entry. Baseline in this order, saying which you used: (1) git history of the plan file (the only baseline that can't be edited after the fact); (2) the Amendment Log read as a claim, not proof; (3) the copy the builder was handed. Untracked plan, empty log, code plainly implementing something the plan doesn't describe: that absence *is* the finding.

### Scenario table, if the decision doc has one
The only part of the decision doc that ticks off mechanically. Take each **differing** row, find what the code does in that case, compare. A row labelled *collateral* gets the hardest check: a behaviour change nobody asked for, explicitly accepted by the user, and the likeliest item to be built as if never decided. A mismatch is a drift finding with both cells quoted.

### What the User Sees, if the doc has it
Each expectation sentence, in the user's words, against what the built thing does on the surface where the user would check it. Run it where you can drive it and say where you only read code. A sentence the build doesn't honour is a drift finding with the sentence beside what the user actually gets. So is an item under *Would find odd* that the owner ruled on and the build ignored.

### DecisionDoc -> Code
The round trip. Read the **Problem** statement, then the code, and answer in your words: does what shipped solve the problem decided, or a neighbouring one? Would the approach comparison in the doc still choose this approach knowing what the build found out? **Did the accumulated amendments move this to a different approach than the one chosen without any single amendment saying so?** The third is the point of this gate: six reasonable amendments can add up to Approach C while every log entry reads like a detail. **A "yes" to any goes to the human even when every amendment is logged:** perfect bookkeeping and a feature that ended up somewhere nobody chose are entirely compatible. **Scale the audit to what moved:** an empty log and a decision doc never departed from is minutes; the work grows with the drift, which is the correct shape.

### Never edit the baseline to make the drift go away
This is the one way this gate can do more harm than not running. You'll find a difference and the cheapest move will be changing the decision doc to match the code and reporting no drift. Don't: rewriting the baseline destroys the only evidence drift happened and produces a false clean verdict every later reader believes. During this gate you may not change, reword, soften, "clarify", "correct" or delete **one word** of the decision doc's Problem, Contracts, Approaches, Decision, What the User Sees or Consequences, or any existing Amendments entry; change or delete any part of the plan, existing Amendment Log entries included; or do any of that and then report a better verdict. **Where it writes, and that's all:** an `## Amendments` entry appended at the end of the decision doc, the matching plan Amendment Log entry, both only after the human ruled, and the `mv` to `done/`. **The verdict is a fact about what the build did, not what the documents say now:** a departure nobody recorded is UNDOCUMENTED DRIFT and stays so in this report however it is written down afterwards; you can't turn it into DOCUMENTED DRIFT with a keystroke. Writing the record later means only that the next person inherits an honest document.

### Verdict and action
| Verdict | Meaning | Action |
|---|---|---|
| NO DRIFT | plan implements the decisions; code implements the plan | record and move on |
| DOCUMENTED DRIFT | differences exist and every one was written down **before you got here** | report each; the human confirms it's still the feature they wanted |
| UNDOCUMENTED DRIFT | a difference nobody wrote down | **blocking and stays on the report;** NOT COMPLETE until the human rules |

**Report first; writing is a separate act and the human's call.** Present the drift, say plainly what departed from what, stop. Then: *accepts* -> only now append under `## Amendments` at the **end** of the decision doc (everything above untouched; dated, marked found at verification so nobody mistakes it for a pre-work decision); *rejects* -> the gap is in the work, back to build, status stays NOT COMPLETE; *silent* -> nothing written (silence isn't consent).
```
## Amendments
### YYYY-MM-DD - [what changed]  (found at verification, accepted by the human)
- Supersedes: [the decision or consequence, quoted so the original is legible]
- Now: [what was built]
- Because: [what the build or plan found that the decision didn't know]
- Recorded in: [plan Amendment Log entry ID, or "no plan entry existed; this gap was found here"]
```
Then the matching plan Amendment Log entry if missing, appended the same way. A later reader must see **both** what was decided and what happened instead.

---
# Part 4: the completion report
You're writing to the person who asked for the feature, and their only question is *did I get what we agreed*. Answer first, in their words. Said, not saved; **the one report this gate emits** (Parts 1-3 are worked, not narrated). Three rules: **bad news first** (evidence at the bottom; nobody should read a clean checklist to discover the thing isn't there); **show both sides of every difference** (quote what was decided, then what was built and where; "narrowed", "half-implemented", "widened" are your labels not the difference; one row, two columns, both filled); **say it in the words of the work,** not this skill's (the verdict keyword and the suite line's rung are the only terms that travel, each with a plain sentence). No decision doc? The first section says exactly that: "nothing departed" and "nothing recorded what we decided" look identical and aren't.

```
## Completion Verification
Claim: [what is being claimed complete]
Plan: [path]   Decision doc: [path, or "none, so there is no record of what was decided"]

### Status: COMPLETE | NOT COMPLETE
[One line in the owner's terms: what's wrong, or that nothing is. If the verdict isn't NO DRIFT, name it in a clause.]

### What we decided and did not build
| We decided | We built instead | Where | Written down before this gate? |
| "[quoted from the decision doc]" ([section]) | [what the code does, plainly] | [file:line] | no, found here / yes, [amendment entry] |
(or: "Nothing. Every decision in [doc] is in the code as written.")

### What we built and nobody decided
[capability widened past the decision, scope the plan never carried, a plan step with no amendment; same two columns; or "Nothing."]

### What the plan asked for and is not there
| The plan asked for | What is actually there | Proven by |
| [requirement / contract line / seam test / removal-table row] | not built / built, nothing proves it / replacement never landed | [run name, or why nothing proves it] |

### Your call
[numbered, one line each, cheapest first: what needs a ruling and what each choice costs; or "Nothing needs a ruling."]

### Evidence
Suite: [run name] (rung T4, the full suite) -> exit [code], [N passed, M failed, K skipped]. [Fresh | cited from review's sign-off run; tree proven unchanged by git status and git diff.]
Every requirement, including the ones that passed:
| Requirement | Status (built and proven / built but unproven / not built) | Evidence |
What the drift audit compared:
- Baseline: decision doc read from [git at <ref> | working tree only, untracked]; working copy [identical | differs: what, and whether an Amendments entry covers it]. Plan baseline: [git history | Amendment Log as a claim | handed-off copy]
- DecisionDoc -> Plan: [N] read, [N] upheld, [N] narrowed, [N] superseded, [N] dropped (each departure is a row above)
- Plan -> Plan: [each difference and the log entry behind it, or "none"]
- Scenario table: [N] differing rows checked, [N] matched (or: no table / "not a rule change")
- What the User Sees: [N] sentences checked, [N] held (or: no such section)
- DecisionDoc -> Code: [solves the decided problem?; did "what would reverse this" come true during the build?; did amendments add up to an approach nobody chose?]
- Verdict: NO DRIFT | DOCUMENTED DRIFT | UNDOCUMENTED DRIFT
- Documents I changed during this gate: [none (the normal answer), or the appended Amendments entry quoting what the human said. Nothing else, ever.]
- Record still to close: [what the human hasn't ruled on, or "nothing"]
```
UNDOCUMENTED DRIFT, or any requirement "not built": **NOT COMPLETE** until the record is closed or the human accepts the gap in writing.

## Common failures
| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | test output, 0 failures | a previous run, "should pass" |
| Linter clean | linter output, 0 errors | a partial check, extrapolation |
| Build succeeds | build command, exit 0 | linter passing, logs that look fine |
| Bug fixed | the original symptom re-tested and passing | code changed, fix assumed |
| Regression test works | red then green, verified | the test passing once |
| Agent completed | the VCS diff, read | the agent reporting success |
| Requirements met | the line-by-line checklist | tests passing |
| Built what we decided | the drift audit, all comparisons | the plan being followed |
| Nothing was lost | the removal table walked against the diff, each replacement found | the suite passing after the deletion |
| No drift | both documents read as they stand, differences named | the documents agreeing after you edited one |
| A difference is reported | decided text and built behaviour quoted side by side | a disposition word, a check name, or a count |

**Red flags, stop:** "should", "probably", "seems to" · satisfaction before evidence ("Great!", "Done!") · about to commit, push or PR without this gate · trusting another model's success report · a partial run, or a scoped rung in full-suite words · writing "narrowed", "partial", "widened" without the decided text and built behaviour beside it · a report that opens with what passed · **reaching for the decision doc or plan with an edit in mind while the audit runs** · noticing a document "just needs updating" to match the code · "just this once" · tired and wanting the work over.

| Excuse | Reality |
|---|---|
| "Should work now" | Run it |
| "I'm confident" | Confidence is not evidence |
| "The linter passed" | The linter is not the compiler |
| "The agent said success" | Verify first-party |
| "A partial check is enough" | Partial proves nothing |
| "Review already ran the tests" | Grounds for a citation if all four conditions hold; never grounds to skip the gate |
| "The plan changed, so the decision doc is out of date" | That is drift. Report it. The document is the baseline, not a draft to refresh |
| "Every amendment was reasonable" | Reasonable amendments still add up to a different feature |
| "I'll update the decision doc so it matches" | That is the failure this gate exists to catch, committed by the gate. Report; append only after the human accepts |
| "It's only a wording fix to the old decision" | There are no wording fixes to a baseline during an audit |
| "Nothing went red when we removed it" | The tests for it were removed too. Name the capability, not the suite |
| "The report is accurate" | Accurate and unreadable is a failed report. If the owner can't see what they decided next to what they got, you haven't told them |

**Key patterns:** tests: run, read "34 passed, 0 failed", say "all tests pass (T4 full, exit 0)" (never "should pass", never without rung and counts). Build: run the build, exit 0 (a linter doesn't compile; a type checker doesn't link). Bug fixed: reproduce the symptom, apply the fix, the original reproduction passes. Requirements: re-read the plan from disk, checklist, verify each line. **Delegated or handed-off work:** the agent reports success, read the VCS diff, report the actual state (a report is a claim about the tree; the tree is the evidence).

**Always, before:** any claim of completion, correctness or success, in any wording; expressing satisfaction; committing, pushing or opening a PR; moving to the next task; archiving the plan. Never optional, never skipped, whatever the model, time pressure or confidence. It also covers the bug and quick-fix path, which skips full review: the suite comes from `test-scope`'s no-plan row, Part 2 runs against the reported symptom, and Part 3 states there was no decision doc.

## What happens next
On COMPLETE: `mv docs/plans/active/<plan> docs/plans/done/` (plain `mv`, not `git mv`); delete `docs/handoff.md` if it was for this task; the next steps are `/security-check` then `/pr`; and offer `/learn` to capture lessons. No shortcuts for verification: run it, read the output, then claim the result; read both documents, then claim it is what was decided. Claiming completion without it is dishonesty, not efficiency.

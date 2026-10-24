---
name: review-lenses
description: Reference loaded by brainstorm, write-plan and review. The seven lenses plus Security (one question each), the rules for running them (RL-1 to RL-6), the gate table, and the brief for handing a review to an outside model. Not a step on its own.
user-invocable: false
---

# Review lenses

The perspectives every review looks through. `brainstorm` applies them to approaches, `write-plan` to a plan, `review` to built code. A gate names its column in the table at the end and keeps a short binding copy inline; it does not restate the checklists, because two copies drift and the weaker one wins.

**Why one at a time:** each question, asked by hand, has found a real, usually critical defect in work already reviewed. A review carrying several questions answers the easiest and reports clean on the rest, and nothing on the page shows which were skipped. So each lens runs alone; what it finds is settled (fixed, or put to the owner where it is theirs to decide) before the next lens looks.

<!-- refs:start -->
## Full detail (read at the matching step)
This SKILL.md is the binding gate. Each section's full explanation, examples and rationale, ported from SAW, is in `references/`. Before you run a section below, read its file. Where a file and this SKILL.md differ, this SKILL.md wins.

| Section | File |
|---|---|
| Review Lenses | [references/01-intro.md](references/01-intro.md) |
| Rules for every lens | [references/02-rules-for-every-lens.md](references/02-rules-for-every-lens.md) |
| The lenses | [references/03-the-lenses.md](references/03-the-lenses.md) |
| Which gate runs which lens | [references/04-which-gate-runs-which-lens.md](references/04-which-gate-runs-which-lens.md) |
| Handing a review to an outside model | [references/05-handing-a-review-to-an.md](references/05-handing-a-review-to-an.md) |
<!-- refs:end -->

## Rules for every lens (cited as RL-N)
- **RL-1 One question per lens, run separately.** Don't merge two lenses; don't skip one because another "already looked".
- **RL-2 Change the angle, not the effort.** Repeating a lens with the same method returns what it returned, and an empty delta reads as clean. On a re-run search on something new: another spelling, the rendered form instead of the identifier, code inward instead of document outward, what the change *creates* instead of what it changes.
- **RL-3 Report a lens exactly as far as it went.** Tool unavailable, part of the artifact covered, original checked instead of the changed copy: say so and say what you did instead. Half-done reported as done is worse than skipped.
- **RL-4 A "nothing found" needs a control.** Before trusting an empty search, a clean type check or "no callers", run the same method on something you know is there and watch it find it.
- **RL-5 Reject a finding only on evidence that would have shown it:** a run, a probe, a query on real data. An empty grep is not disproof (the finding may describe a path your search did not spell); local dev data is not disproof (a fixture lacking a condition shows only that). Without disproof the finding stands.
- **RL-6 A review ends on a round that changed nothing.** Settling findings changes the artifact, and lenses that already ran never saw the change. If a round changed what the artifact contains or how it works (file, caller, phase, step, rule or mechanism added, removed or reshaped), run another full round, in order, each lens starting from what changed and on a new angle. Rewording, corrected counts and fixed names don't start a round. A fix written as a general rule is checked against every decision it now overrules, and a rule widened mid-review is written out in full at once, never one example per round. **A third round that still changes contents: stop and tell the owner** the work is larger than the artifact describes. For a plan, recommend splitting it into parts each reviewed and built alone, and propose the cut. Outside-review rounds whose finding count doesn't fall after the second get the same recommendation. This stop is for documents; `review` on code keeps its own loop (every section, every round, until zero).

## The lenses

### Impact: what does this break that nobody mentioned?
The method is the `existing-mechanisms` impact trace, all three axes. Three additions:
- **Count with types, not names.** In typed code take structural counts from the language server's find-references or the type checker; use a name-based graph only to find where to look.
- **Let the compiler do the structural axis for removals and signature changes** (isolated copy, deliberate-break control, empty a deleted module, point it at everything, then search strings).
- **Follow coupling through storage to both ends** (every writer of a value you read, every reader of a value you write; both ends must agree on meaning).

### Removal: is every removal justified, and is its job still done?
Removing working code is the one change whose damage never shows as a failing test. For each removal:
- what it was for, in terms of the job it did, from code and history (code that looks dead often has one caller or guards a rare case);
- **wire before deleting:** uncalled code may be the right thing with its call missing, and the defect you're fixing may be that missing call;
- what does the job afterwards, and the test on the new path (a replacement without a test is an assumption);
- what reaches it today, scripts and strings included, and files read by path (tests, build, packaging, path checks);
- one removal, one step ("delete the old module" covering four jobs, one live, is how behaviour vanishes in one diff line);
- **a port is a removal plus an addition:** put old and new side by side and compare inputs, filters, columns, ordering, return value, side effects, every error raised. A cited line range stands for the whole operation, every effect included; a replacement write keeps the conditions, fields and upsert semantics of the one it replaces; a whole-module port lists the data-touching methods from the source;
- no replacement goes to the owner as a lost capability.

### Logic: does it work when it actually runs?
Stop reading, run it: pick concrete inputs and step one write at a time, noting state after each.
- the main case end to end with real values;
- zero, one, many and the edge (empty collection, absent target, first run, last removed, exactly at a limit, page boundary; watch an empty value falling through to a *different meaning*);
- overlapping rules (an input satisfying two conditions; if order decides, the order is stated and pinned);
- time (what is written before what; a value copied at write time freezes, one worked out at read time moves; caches, polls and stale windows; timers stop when a screen hides);
- crash and retry (kill between every pair of writes; a progress marker written before the work it records makes a crash skip that work forever);
- two at once (parallel jobs, tabs; load-edit-save of a whole object clobbers another copy's change; shared rather than copied state);
- **work reported but never cleared** (every scheduler, sweeper, retry or queue needs a stop condition; once you find one path into the loop, look for a second);
- values against each other (a name weight of 0.85 against a grouping threshold of 0.85 groups two people on name alone; no single value is wrong);
- can the mechanism express the rule at all (averaging can never let a second reason raise a score; a unique key on name cannot express "same name, different type");
- where each promise is enforced (a rule enforced only by UI, prompt or comment is not enforced; when something is deleted, what was it the *only* enforcement of);
- reuse across a contract (helper built for unpaged, ordered, single-threaded or trusted input, called where that fails);
- hostile input (none, empty, unicode, budget of 0 or -1, duplicates: does it terminate, stay idempotent, leave caller data alone).

**Probe rather than reason** when a read-only local probe costs minutes: a table worked out by reading can be wrong four times where one real call is right first time.

### Behaviour: does a human get what they expect, on every surface?
Logic asks whether the mechanism is correct; this asks whether the product is. Sit in the user's seat.
- the goal as the owner will see it (name the screen or output; "retain what extraction returns" built as a log table nothing reads honours the decision and misses the point);
- every surface showing the changed data (screens, reports, exports, notifications, prompts to models): a field blank on three of them is invisible to mechanism tests;
- similar actions behave alike (re-read vs delete, archive vs remove, retry vs resume, bulk vs single);
- the second caller and the late one (second tab, resumed job: is "already done" distinguishable from "nothing there"; is a cache keyed on what the user typed rather than meant);
- the expectation in the user's words: for the two or three main actions write one sentence ("I delete the document and its entities go with it") and check the design does exactly that or says where and why not.

### Business sense: would this make sense to the business and to a typical user who never heard the reasoning?
Questions the *decisions*, including the owner's own: the design that is consistent, correct and odd.
- **Read it cold,** from outcomes only, ideally by a fresh-context reader (the outside-review brief below). Value comes from not knowing the reasons.
- **Walk it as a named typical user** (analyst on a case, shopper at checkout, operator at 3 a.m.): would they expect this, need telling, be confused or wrong about what happened?
- **Ask directly:** does it serve the requirement or an easier proxy? cost the user time, money or trust the business wouldn't sign off? would a competitor's user find it normal? does it contradict what the product says elsewhere?
- **Challenge the owner's steer too,** as a question with the user's-eye view attached, not a correction.
- Each finding says who is surprised, by what, and what they expected.
- **Defect or question, decide before reporting.** Defect: the expectation is plain and no decision chose the odd outcome (a run over one aspect of an item marks the whole item done). Fix it like any finding and tell the owner in one line. Question: a recorded decision or the owner's steer produced it, or users could reasonably expect two things. **Can't tell? It's a question.** Asking the owner to rule on a plain defect hands them a decision nobody needed to make.
- **Once ruled, it stays ruled** (recorded under the decision doc's *Would find odd*). Raise again only for a surface nobody considered or a build that behaves differently from what they ruled on, and say what is new.

### Proof: would the tests fail if this were built wrong?
A test is worth only the defect it rejects.
- Name the defect each test exists to catch, break it that way, check it fails. Hollow shapes: fixture too small to reach the path; assertion on a symptom that holds while the defect is live; substring check passing on reworded leftovers; assertion true in every mode; "exits 0" with nothing asserted; data that cannot show the defect (ordering test with one row, ties already in expected order, filter test with no excluded row); code compared with itself; a copy of the code tested; presence checked, not value; silent skip when unsure of its input; one direction of an authority rule only; values that only look equal (`True == 1`); a path around the function that applies the rule.
- **Every guard gets a mutation check:** the exact revert and the failure it must produce. **Witnessed only when the test fails on its assertion**; an error, hang or collection failure proves nothing.
- **A mutation check asserts its own precondition first** (the two values really sort differently; no other guard already stops it), then break and watch (RL-4).
- **A concurrency test forces the interleaving** (hold the first after its read with a barrier or event, start the second, assert it waits or sees the promised state).
- **Old and new side by side get a parity test** feeding both the same inputs and comparing every read.
- **Existing tests, three kinds:** will break (update to the new truth, never loosen), keep passing but mean nothing (rewrite or retire), reach the code indirectly via patched factories, captured args or module mocks (name them; they break in ways that look nothing like the cause).
- **Tests run the path production runs,** not a shortcut constructor or an internal step production never takes.
- **Pin anything held constant and relied on** (byte-identity fixture or golden output); prose doesn't stop a reword.

### Coherence: does the document still agree with itself?
Every lens edits the artifact in one place against its own question. Read the result once, top to bottom, as the next reader will: contradictions between sections, steps, criteria, scope and risks; orphans (a reason a later decision removed); stale summaries (counts, lists, mappings, headlines); one name per thing with no collisions; sequence (does each step stand on what came before); one story (would someone who did only the steps end where the summary says).

### Security (this workflow's addition, run as its own lens)
Input validation at boundaries; injection (SQL, command, template); secrets and credentials; access control and who can call this; whether *stale* state (cache, index, session, permission copy) can grant what current state denies; trust transitions and tenant or visibility rules; unsafe or newly added dependencies. In `review` this also triggers the security-boundary deep audit.

## Which gate runs which lens
| Lens | brainstorm (approaches and recommendation) | write-plan (finished plan) | review (built code) |
|---|---|---|---|
| impact | every approach at survey depth; the recommendation in full in the decision audit | the **impact pass**, then the **consolidation pass** (third axis + inventory) | consumer authority, storage coupling both ends, the plan's Impact Analysis checked against the code |
| removal | what each approach removes and what does that job after; a job with no replacement is a cost and goes to the owner | the **removal pass** | retirement actually happened, plus the new-path test per removal |
| logic | every approach through the main case and edges; the recommendation in full, especially values-against-each-other and can-the-mechanism-express-the-rule | the **logic pass** | correctness: walk the built code with concrete values |
| behaviour | what the user sees under each approach; user-facing sentences go to the decision doc's What the User Sees | the **behaviour pass**, checked against those sentences | drive the built thing on each surface and compare with the sentences |
| business sense | every approach and the owner's steer, read cold | the **business-sense pass** | the built thing must work the way the business needs; defects graded and fixed, questions go to the owner and don't hold the gate |
| proof | for each load-bearing claim, what would prove it | the **proof pass** | tests, with mutation checks run |
| coherence | the written decision doc, before write-plan | the **coherence pass** | not run on code; codebase consistency covers it |
| security | threat notes per approach | security considerations section + a pass over it | security section of review |

## Handing a review to an outside model
An outside reviewer (another vendor's model, or a fresh-context agent) finds what you can't: it doesn't know why anything was decided, so it sees the result as a newcomer does, and a different model misses different things. Every gate that finishes a reviewable artifact (decision doc, plan, build) offers one, in one line, once per artifact, in one of two forms:
- **A reviewer started here** (the shipped `outside-reviewer` agent, read-only) on a model the user names. Suggest one other than yours. It gets the brief below, filled in, and nothing else from this session.
- **The brief written out to paste** into another tool; the only form when the harness can't start a subagent.

Start a reviewer fresh each time; never resume one (it anchors on its earlier view). Without a brief the reviewer starts fixing things and filing tickets, answers "do plan and code match?" when the question was "are both right?", and pads with everything that is fine.

```
You are reviewing, not changing. Do not edit files, run anything that writes, or file tickets.
Read-only commands only, one simple command per call. Changes are another model's job; yours is to
find what is wrong.

What to review: [decision document / plan / commits, by path or hash] in [repo path].
[If the tree is changing while you read: read every file as of commit [hash], not the working tree. Delete this line when the tree is still.]
What it is for: [the business requirement, one or two sentences, in the owner's words].

The question is whether it is right, not whether its parts agree with each other. Is the logic
correct? Does it deliver the business requirement? Does it make business sense? Two documents can
agree and both be wrong.
[For a plan: also check it implements every decision in the decision document; a decision with no
phase is a finding. For code: do not check it matches the plan; check it works.]

Look through each separately:
1. Impact: trace callers, call sites and dependants both ways. Count with the type checker or language
   server this repo uses [tsc, pyright, go build...]; a name-based index misses calls through an
   instance. Include values one component writes to storage and another reads; check both ends agree.
2. Removals: a scalpel, not a butcher's knife. Each removal justified line by line, its job still done.
   If something is uncalled, ask whether it should be wired in rather than deleted.
3. Logic: walk it with concrete inputs, edge cases, crashes between writes, two copies at once, loops
   that never stop, settings that defeat each other.
4. Behaviour: every screen, report and prompt that shows the changed data. What does the user see?
5. Business sense: as [the typical user, named], would anything be odd, surprising or pointless,
   including things decided on purpose?

Report only what is broken, possibly broken, or doubtful, and whether there is a better approach. Do
not tell me what is fine. For each finding: the file and line you opened and confirmed, who or what is
affected, and why. Do not repeat points already answered unless new code changes the answer. Put every
finding in your final message as a numbered list: not in a tool, a file, or a summary of a longer list.

Already settled; do not spend turns on these: [what the owner ruled; what is proven first-party, such
as runs or mutation checks witnessed. "None." if nothing.]
[Follow-up round: here is what was rejected and why; weigh it and say if the rejection holds.]
```

When findings return they are evidence, not instructions: verify each against the code, fix what holds, reject only under RL-5. **First check a review happened at all.** An agent run headless can stop on a refused command and still report success with an empty or partial answer. An empty answer, or one that never reached the parts it was asked to read, is no review: fix what it was refused and run once more; if that fails too (or the owner ran it), tell the owner in one line that it did not happen and go on. If the tree is changing while it reads, point it at a commit the work is already in; never commit to create one, wait until the tree is still.

<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Round N: Review

**Load `/review-lenses` once, before Round 1**, if you have not this session. Several sections below are its lenses run on built code, and name their lens; they carry a binding copy, and the reference has the full checklist.

### Plan & Decision Conformance

Do this first; a well-written function implementing the wrong decision is not fixable by a code-quality pass.

**Read the decision document first, then the plan, then the diff, in that order.** The plan is a derived artifact; the decision document is the baseline it was derived from, and a change can satisfy every word of the plan while contradicting the decision that produced it. The order is what makes that visible: read the plan first and you will find yourself checking the code against the plan, agreeing with both, and never opening the document that ruled out what the code does.

Map **decision → plan requirement → implementation → evidence**, and flag every break:

- [ ] **Skipped requirements**: a requirement with no implementation, or a phase reported complete with files missing or nothing wired to them.
- [ ] **Silently changed decisions**: code does what a decision doc or plan ruled out. It may even be better; it is still a finding until written down and agreed.
- [ ] **Deviations that should have amended the plan**: the builder hit reality, adapted, and left the plan describing a system that no longer exists.
- [ ] **Decisions kicked back to the build model**: the plan already decided this and the code differs, or the plan left a hole filled with an architectural choice the build model was never meant to make.
- [ ] **Judgement calls you delegated, re-traced by you.** Where the plan or a Rework Brief said "this one is yours to judge, say which way you went", read what it chose and trace it yourself, callers and callees both ways, per `/existing-mechanisms` question 1. **Delegating the decision never delegated the tracing**, and what comes back is a claim like every other claim in the handoff. The build model chose with less of the system in view than you have: the guard it removed as redundant may also have been holding a second thing shut. A delegated call the handoff never mentions is worse than one you disagree with, so check the diff for choices nobody reported.
- [ ] **You report these; you never edit the plan or the decision doc to match the code.** Every finding in this section is a difference between what was agreed and what exists, and the tempting fix is to update the document. That is not yours to do, and it erases the evidence the final gate is built to read. Findings are fixed in code, or carried to the human as a plan amendment for the planning model to make. A finding carried that way is a class, not a case: say which later phases it reaches, so the amendment covers them too (`/write-plan`, *When a build halt comes back*, step 3).
- [ ] **Amendments without entries**: read the plan's **Amendment Log** against its phases. A phase whose text plainly answers a problem discovered during the build, with no entry recording that, is an unlogged amendment. It is a finding here and it becomes undocumented drift at `/verify`, where it is far more expensive to reconstruct.
- [ ] **Halts resolved by silence**: for every halt in the handoff summary, find its resolution: an amendment, an overrule the builder recorded, or a withdrawal. A halt that simply stops appearing was resolved by someone deciding something, and nobody wrote down who or what.

This is architectural conformance; "was the agreed design built?" The line-by-line completion tick-off and the full decision-to-code drift audit belong to `/verify` later; what you owe that gate is an accurate account of what the plan says *now* and how it got there.

### Contract Audit

Brainstorm discovered these contracts; the plan made them executable; you prove the implementation **preserves** them.

- [ ] **Source of truth & derived stores**: is authority still where the plan put it? Has a cache or index quietly become a second source of truth?
- [ ] **Identity & cardinality**: is the key actually unique and stable? Does the code assume one where the data permits many?
- [ ] **Authority & precedence**: when sources disagree, does the code resolve it as the decision doc says?
- [ ] **Currentness & rollback**: is there a version/generation/fingerprint, and is it actually *checked* rather than merely stored?
- [ ] **State transitions & visibility**: can state be observed mid-change? Are illegal transitions blocked at a layer every writer passes through?
- [ ] **Consumer authority**: find the callers of everything this touched, counted with the type checker or language server in typed code and grep for names held in strings; do not trust the plan's list. Do they still get what they expect?
- [ ] **Execution locality & deployment**: does this run where it is assumed to? Does it hold up read-only, offline, air-gapped, or single-writer if required?
- [ ] **Invariant enforcement layer**: is each invariant enforced where it cannot be bypassed (constraint, index, type), not only in the path this feature uses?

### Correctness

- [ ] Does it actually do what it claims to do?
- [ ] Edge cases: null/empty inputs, boundary values, overflow, off-by-one
- [ ] Error paths: what happens when things go wrong?
- [ ] Concurrency: race conditions, thread safety, deadlocks. A race test that does not force the interleaving (hold the first after its read, assert the second waits) proves nothing on the run where the two never overlapped.
- [ ] **Failure timeline**: for any operation with an external or non-transactional side effect, reconstruct the step order (resolve input → claim work → lock → revalidate → write → confirm → record completion → reconcile), then walk each gap: what does a crash, lost lease, cancellation, or lock timeout leave behind, and what cleans it up? "Check for races" catches nothing; the timeline is what makes a missing revalidation visible. Detail in `deep-audits.md`.
- [ ] **Aliasing**: where two call sites hold the same object, connection, buffer, or config, a mutation by one is visible to the other. Check what is shared vs copied at each boundary.
- [ ] **Walk it, do not read it.** This section is `/review-lenses`' **logic lens**, its `/review` column: step the built code through concrete values rather than reading it for plausibility. The items above are its core; also walk the ones a read never catches. **Work reported but never cleared**: every scheduler, sweeper or retry has a condition that stops it; find it. **Values against each other**: every threshold, weight and timeout beside the ones it meets. **Can the code express the decided rule at all?** **Rules that overlap**, and whether their order is pinned. **Reuse across a contract**: a helper built for unpaged, ordered, single-threaded or trusted input, now called where that does not hold.
- [ ] **Coupling through storage, both ends.** For every value this change writes to a table, file, queue or cache, find every reader; for every value it reads, find every writer. No call graph links them. A reader with no writer, a writer nobody reads, or a flag nobody clears is a finding.

### Conditional Deep Audits

If the change touches any of these, open **`deep-audits.md`** in this skill's directory and run the matching audit; these are where a passing suite correlates least with a working system:

- **Derived state** (caches, indexes, materialized views, generated artifacts)
- **Migrations or schema changes**
- **New/upgraded third-party dependencies, or deployment and runtime constraints**
- **Authority or security boundaries** (authn/authz, trust transitions, tenant or visibility rules)
- **A seam between components** where one side can change without the other

**Depth is set by these triggers, not by how large the change feels.** A change that trips none of them gets the standard checklist and no deep audit; that is the proportionate form, and running a full derived-state audit against a forty-line logging change is cost, not rigour. But the trigger list is the *only* thing that flexes:

- **The exit condition never flexes.** Zero findings at every severity, and the gates below, apply to every change regardless of size. "It's a small change" is not grounds to wave a MINOR, skip a gate, or stop looping.
- **Judge the triggers by what the code touches, not by the diff's size.** A four-line change to a permission check trips the authority trigger; a four-hundred-line change that only moves test fixtures around trips nothing.
- **Record which audits you ran and why** in the summary; the trigger you matched, or the explicit statement that none applied. A reviewer who quietly decided a change was too small to audit leaves no trace; one who names the triggers can be checked.

If you find yourself reasoning "this is minor, so a lighter review is proportionate", stop: that is the rationalization the exit condition exists to block. Scope the *audits* by trigger, then hold the bar.

### Architecture
- [ ] Does this fit existing patterns, or introduce a new one?
- [ ] Single Responsibility: does each function/class do exactly one thing?
- [ ] Dependencies: reasonable imports? Unnecessary coupling?
- [ ] Is this the simplest solution that works?

### Design Challenge
- [ ] **Is this the right design?** Building from scratch, would we decide this; or is it the path of least resistance given what exists?
- [ ] **Is there a simpler solution?** Could a smaller change achieve the same outcome?
- [ ] **Is there a better structural approach?** A different data model, a different abstraction, removing instead of adding. Flag as MAJOR with `[DESIGN ALTERNATIVE]`.
- [ ] **Root problem or symptom?** If this will need revisiting when the underlying issue resurfaces, say so.

### Behaviour

`/review-lenses`' **behaviour lens**, run on the built thing rather than on its description. Where you can drive it (a browser, a CLI, a script against a local instance), drive it; a surface you only read about is recorded as read, not checked.
- [ ] **The decision document's What the User Sees, sentence by sentence.** Does the built thing do what each sentence says, on the surface where the user would check? Where the document has no such section, say so and write the two or three main expectations yourself before judging.
- [ ] **Every surface that shows the changed data**: screens, reports, exports, dossiers, notifications, prompts to models. A field blank on one of them, or a link that opens nothing, is a finding the tests cannot see.
- [ ] **Similar actions behave the same.** Re-read and delete, archive and remove, retry and resume. If one cleans up and the other does not, that is a finding.
- [ ] **The second caller and the late one** get a sensible answer, and "already done" is distinguishable from "nothing there".

### Business Sense

`/review-lenses`' **business-sense lens**. The plan does not matter on its own; the built thing has to work the way the business needs. Read what it does as a typical user of this domain who never heard the reasoning, and flag what they would find odd, surprising or pointless, including where the plan and decision document asked for exactly that. A point the owner already ruled on, recorded under the decision document's *Would find odd*, is not raised again unless the build behaves differently from what they ruled on. **Sort each one first: a defect or a question** (the lens's own rule). Where neither the plan nor the decision document asked for the odd outcome and the user's expectation is plain, such as a run over one aspect of a pending item marking the whole item done, it is **a defect**: a finding like any other, graded, fixed, and holding the gate until it is. Where the plan or decision document asked for it, typical users could expect two different things, or you cannot tell which it is, it is **a question for the owner, not a finding**: the thing being questioned is a decision, and deciding it is not yours. Record each question in the ledger as `[BUSINESS SENSE]`, with who is surprised, by what, and what they expected. Questions do not carry a severity and do not hold the gate, so they cannot keep the loop open. They also cannot be dropped: every one goes in the exit report's *For the owner* line, and one the owner rules a defect reopens the review at Round N+1 as a finding. Where the built thing departs from what the plan asked for, that is a conformance finding in the usual way, not one of these.

### Codebase Consistency & Refactoring
Go beyond the changed files: grep and read the surrounding code. This is `/existing-mechanisms`' *"`/review`, Codebase Consistency"* row: questions 3, 5 and 8 and the self-duplication inventory, run against the code as built. Load it if you have not this session.
- [ ] **Consistency:** does new code solve this the way the codebase already solves it? If not, which wins, and should other call sites change?
- [ ] **Pattern extraction:** does this duplicate logic that already exists? (question 3)
- [ ] **Self-duplication, by inventory, not by reading.** Copies spread across files each look fine where they sit, so a read-through passes them. Binding copy of the inventory: list every unit the diff adds · one line each on what it does, as behaviour, not its name · group the lines that do the same job, in part included (the same call skeleton, the same lookup, the same calculation) · each group of two or more is extracted, reused, or kept apart with the reason each one changes. A group this change created is a **MAJOR** finding, fixed as one extraction per group, whether you fix it here or it goes back in a Rework Brief. The sign-off summary's *Self-duplication* line carries the count of units listed; a clean result without it is an inventory that was not made.
- [ ] **Removed with a scalpel** (`/review-lenses`' removal lens). Each deletion in the diff: what job it did, what does that job now, and the test on the new path proving it. Before accepting "it was dead", ask whether it was really missing its call. A rewritten query, handler or calculation is compared with the version it replaces, side by side: inputs, filters, columns, ordering, return value, every error raised. Each difference is a decision on record or a finding.
- [ ] **Retirement actually happened** (question 5): walk the plan's *Retired by this plan* removal table row by row against the diff. A superseded mechanism still installed is dead weight the next reader cannot tell from live code. Two rows fail harder than that: one whose *Replaced by* never landed, which is a capability the feature took away. That one is **CRITICAL**, and reported in those words, because no suite can see it once the tests went with it. The other is a deletion in the diff that the table never named, which is a removal nobody audited. And a test still covering a path this change made unreachable is a coverage hole, not a pass: green, and proving nothing.
- [ ] **Bifurcation** (question 8): if this added a second pathway beside an existing one, the plan said so and said what collapses it back. If the plan did not, this is the finding.
- [ ] **The plan's Impact Analysis block, checked against the code as built.** The plan's impact and consolidation passes wrote it and nothing has read it since, so its claims have been carried this whole way unverified. Three of them are checkable here and nowhere else. **The consolidation verdict**: the plan said this leaves the codebase with fewer ways to do this job, or more; is that what the diff actually did? A plan claiming "this unifies X and Y" whose diff leaves both standing is a finding. **The extractions**: each one the block named, with the phase that was supposed to perform it. An extraction planned and quietly skipped is the duplication this review would otherwise log as pre-existing mess. **The out-of-scope sites**: each one the plan declared unaffected, with its stated reason. A site ruled out on a reason the built code no longer satisfies is a regression nobody is looking for, because the document says it cannot happen. Where the plan carries no such block, say so; it means these went unchecked rather than checked clean.
- [ ] **Convention drift:** conflicting naming, structure, or error-handling conventions?
- [ ] **Ripple refactoring:** older code that should now consolidate onto this approach; as Findings where this change created the duplication, as Follow-ups where it merely revealed pre-existing mess.

### Clean Code, SOLID, DRY, KISS
Enforce these as **engineering judgment, not a rulebook**: each item is a question that surfaces a smell, and the finding is the defect, cost, or simplification you can *demonstrate*; never the rule violation by itself.
- [ ] **Naming**: understandable from the name alone, no encodings or mental mapping. Worth a finding on a load-bearing surface; rarely on a three-line local.
- [ ] **Functions**: small, doing one thing. A long parameter list (~4+) or a behaviour-switching boolean is a *signal* of a missing abstraction; raise the missing abstraction and the case it makes hard, not the count.
- [ ] **Hidden side effects**: an innocent name concealing a mutation, I/O, or state change. Always a finding.
- [ ] **Comments**: code says *what*, comments say *why* when non-obvious. No metadata, no commented-out code, no narration.
- [ ] **SOLID**: name specific violations *with the concrete consequence*. Open/Closed is a preference, not a law; extending beats modifying working code, but changing a wrong abstraction beats extending it forever. Say which case this is.
- [ ] **DRY**: no duplicated logic or parallel implementations. Blocks that merely look alike but change for different reasons are not duplication; merging those makes it worse.
- [ ] **KISS / YAGNI**: simplest thing that works; no speculative abstractions or flags for hypothetical futures.
- [ ] **Design patterns**: where used, it must be the *right* one, applied for a reason, in this language's idiom; the ceremonial class-heavy form of something Python does with a callable, a dict, or a decorator is a finding, not rigour. Absence of a pattern is not itself a finding; "this should be a Strategy" requires naming the concrete problem the current code has.
- [ ] No magic numbers or hardcoded strings that should be constants.
- [ ] No dead code, commented-out code, or TODO/FIXME without a ticket.

### Security
- [ ] Input validation at system boundaries
- [ ] No injection risks (SQL, command, template)
- [ ] No secrets or hardcoded credentials
- [ ] Access control: can this be called by unauthorized users?
- [ ] Can *stale* state; cache, index, session, permission copy; grant access that current state would deny?

### Tests
- [ ] Do tests assert observable behaviour and state, not merely that a method was called or a dependency injected?
- [ ] Happy path AND failure modes covered?
- [ ] Would they catch a regression if someone changes this code?
- [ ] **Negative guards tested in a non-default state?** A permission check tested only as admin, a filter tested only with a matching row, an error branch tested only on the happy fixture; all pass while proving nothing.
- [ ] **Mutation-check what matters.** For each test guarding security, authority, or filtering: assert first that the break is observable at all (the values really differ, no other guard already stops it), then break the guard in the source, confirm the test fails, restore it. A mutation is run at `/test-scope`'s *"A mutation check, at any gate"* row, and counts only when the test fails on its assertion; an error, a hang or a collection failure proves nothing. The same holds for every mutation the build report says was witnessed, which is a claim you re-derive like any other. A guard whose test still passes without the guard is decoration: **CRITICAL**.
- [ ] **Proof, per `/review-lenses`' proof lens.** Tests run the path production runs, not a shortcut constructor or an internal step production never takes. Existing tests that kept passing but now assert something true in every mode are a finding, not a pass. Fixtures are large enough to reach the path under test, and their data can show the defect: more than one row for an ordering, a row the filter excludes, ties whose stored order differs from the expected one. No test asserts a symptom that holds while the defect is live, compares the code with itself, tests a copy of it, checks presence instead of value, treats values that only look equal as equal, skips silently, covers one direction of an authority rule, or goes around the function that applies the rule. Where old and new run side by side, a parity test feeds both the same inputs and compares every read.
- [ ] **Fixture hygiene:** no private or production data, no secrets, no oversized assets, no nondeterminism (real clocks, network, randomness, ordering assumptions).

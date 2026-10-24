<!-- Ported from nikhilw/structured-agentic-workflow skills/review-lenses/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The lenses

### Impact: *what does this break that nobody mentioned?*

The method is `/existing-mechanisms`' **impact trace**, all three axes (structural, functional,
consolidation); it lives there and is not restated here. Three additions every gate uses:

- **Count with types, not names.** A graph index links symbols by name, so it misses calls made
  through an instance and merges symbols that share a name. In typed code, take every structural
  count from the language server's *find references* or the type checker, and use the graph only to
  find where to look (`/knowledge-graph`, *Counting in typed code*).
- **Let the compiler do the structural axis for removals and signature changes.** In an isolated copy of the tree (a worktree or scratch checkout, never the working tree), apply every deletion, rename and signature change, then run the project's type checkers over it. Prove it sees the change first by feeding it a deliberate break (RL-4). Empty a deleted module rather than removing it, so every use fails at its own line instead of one unresolved import per file. Point it at everything, not just the source package: scripts, tests, frontend, tooling. Then search for the names as strings, because mocks, patch targets, dispatch tables and config keys are invisible to a type checker.
- **Follow coupling through storage to both ends.** One piece of code writes a value to a table, file, queue or cache, and another acts on it. No call graph and no type checker connects them. For every value this change writes, find every reader; for every value it reads, find every writer. Check that both ends agree on what the value means. A reader with no writer is a feature that never shows anything. A writer whose value nothing reads is work thrown away. A flag that is set but never cleared makes something run forever.

### Removal: *is every removal justified, and is its job still done?*

A scalpel, not a butcher's knife. Removing working code is the one change whose damage never shows
as a failing test: what it did stops happening, and nothing asserts that it ever did. For each
removal:

- **What it was there for**, in terms of the job it did, read from the code and its history. Code that looks dead often has one caller, or guards a case that is simply rare.
- **Wire before deleting.** Code nothing calls is not always dead. Sometimes it is the right thing with its call missing. Before removing an uncalled method, ask where it *should* be called from, and whether the defect you are fixing is that missing call.
- **What does that job afterwards**, and the test on the new path that proves it. A replacement with no test proving it is an assumption.
- **What reaches it today**, from the impact lens, scripts and strings included. A removal with a live caller is a break, not a cleanup. A removed file is also reached by everything that reads the file itself, not only by callers of its code: tests, build and packaging files, checks that open it by path.
- **One removal, one step.** "Delete the old module" covering four jobs, one of them still live, is how a whole behaviour disappears in a single line of diff.
- **A port is a removal and an addition: compare the two side by side.** When the change rewrites something that exists (a query, a handler, a calculation moved to a new layer), put today's version next to the new one and compare inputs, filters, columns, ordering, return value, side effects and every error raised. Each difference is either a decision on record or a defect. A rewrite that quietly drops a filter or stops raising an error removes a job as surely as a deletion does. A cited line range stands for the whole operation it quotes, every effect included, not only the lines shown. A replacement write keeps what the statement it replaces did: its conditions, the fields it sets, and an upsert stays an upsert. When the port covers a whole module, list the methods that touch data from the source itself, so none is left unnamed.
- **No replacement goes to the owner.** If the job simply stops being done, it is a lost capability, and only the owner can agree to it. Put it to them in those words.

### Logic: *does it work when it actually runs?*

Stop reading and run it. Pick concrete inputs and step the mechanism through one write at a time,
noting the state after each. Reading checks whether it sounds right; stepping it through shows what
it does. Walk every one of these:

- **The main case, end to end, with real values.** Most of the cases below come from one detail of this walk being different.
- **Zero, one, many, and the edge.** Empty collection, absent target, first run, last item removed, exactly at a limit, over a budget, a page boundary. Watch for an empty value that falls through to a *different meaning* rather than to nothing.
- **Rules that overlap.** Look for an input that satisfies two conditions. If order decides, the order is stated and pinned. Anything evaluated in declaration order says that the order is load-bearing.
- **Time.** What is written before what, and what a reader sees in between. A value copied at write time freezes; one worked out at read time moves. Caches, polls and stale windows show the old answer for their whole length. Timers stop when a screen is hidden.
- **Crash and retry.** Kill the process between every pair of writes. Does the retry repeat the work, skip it, or do it twice? A progress marker written before the work it records makes a crash skip that work for good.
- **Two at once.** Parallel jobs, two tabs, a worker and a route. A load-edit-save of a whole object puts back a field another copy just changed. Anything shared rather than copied is visible to both at once.
- **Work reported but never cleared.** For every scheduler, sweeper, retry or queue, find what makes it stop. If the work it does never clears the report that started it, it runs forever. Once you find one path into the loop, look for a second.
- **Values against each other.** Put every threshold, weight, limit, timeout and budget next to the ones it interacts with. A name weight of 0.85 against a grouping threshold of 0.85 means a name match alone groups two different people. No single value is wrong; together they are.
- **Can the mechanism express the rule?** Read the rule as decided, then the reducer, scorer, key or query meant to implement it. Averaging can never let a second reason raise a score. A unique key on name alone can never express "same name, different type".
- **Where each promise is enforced.** Name the layer that makes each rule impossible to break. A rule enforced only by the UI, a prompt or a comment is not enforced. When something is deleted, ask what it was the *only* enforcement of.
- **Reuse across a contract.** A helper built for unpaged, ordered, single-threaded or trusted input, reused where those do not hold, spreads its defect to the new caller.
- **Hostile input.** None, empty, unicode, a budget of 0 or -1, a duplicate. Does it terminate, is it idempotent, does it leave the caller's data alone?

**Probe it rather than reasoning about it.** When a conclusion rests on how existing code behaves at
runtime, and a read-only local probe costs minutes, run the probe. A table worked out by reading can
be wrong four times in a row where one call with real inputs is right the first time.

### Behaviour: *does a human user get what they expect, on every surface?*

The logic lens asks whether the mechanism is correct. This one asks whether the product is. Sit in
the user's seat: the person who opens the screen, reads the report, clicks the button.

- **The goal, as the owner will see it.** Name what the owner will see, on which screen or in which output, once this ships. A design can honour every decision and still produce something the owner looks at and says was not the point, such as "retain what extraction returns" built as a log table nothing reads.
- **Every surface that shows the changed data.** Screens, reports, exports, dossiers, notifications, and the prompts that feed a model. Walk the changed data onto each one. A field that is blank on three of them, or a link that opens nothing, is invisible to the mechanism's tests.
- **Similar actions behave the same.** Re-read and delete, archive and remove, retry and resume, bulk and single. If one cleans up after itself and the other does not, the user sees an inconsistency no single code path shows.
- **The second caller, and the late one.** What does the second tab, second worker or resumed job get when the first already did the work? Do "already done" and "nothing there" look the same? Is a cache keyed on what the user typed rather than on what they meant?
- **The expectation, in the user's words.** For the two or three main actions, write one sentence as the user would say it ("I delete the document and its entities go with it"). Check the design does exactly that, or says plainly where and why it does not.

### Business sense: *would this make sense to the business, and to a typical user who never heard the reasoning?*

This lens questions the *decisions*, including the owner's own. The behaviour lens checks that the
design delivers what was intended. This lens checks whether what was intended is sensible for the
business and unsurprising to its users. It catches the design that is internally consistent,
correctly built, and odd: a rule no user would guess, a step that exists only because of how the
code is shaped, a term that means something different in the user's domain, an outcome that is
technically right and commercially wrong.

- **Read it cold.** The defects this lens exists for look reasonable to anyone who knows why they were decided, and you usually do. So work from the outcomes alone: what the user does, sees and gets, not the rationale. If you can hand this lens to a reader with fresh context (a subagent started without this conversation, or another model; see the outside-review brief below), do. The value comes from not knowing the reasons.
- **Walk it as a typical user of this domain**, not as its builder. Name the user (an analyst on a case, a shopper at checkout, an operator at 3 a.m.), then take them through the main journeys. At each step, ask: would they expect this? Would they need to be told? Would they be annoyed, confused, or wrong about what just happened?
- **Ask the business questions directly.** Does it serve the requirement it was built for, or a proxy that is easier to build? Does it cost the user time, money or trust in a way the business would not sign off on? Would a competitor's user find this normal? Does anything contradict what the product tells users elsewhere?
- **Challenge the owner's steer as well.** Where a decision came from the owner, and a typical user would find the result odd, say so. Put it as a question with the user's-eye view attached, not as a correction. The owner may have a reason; the point is that they choose with it in view.
- **Each finding says who is surprised, by what, and what they would have expected.** "Odd" alone is not actionable.
- **A defect or a question: decide which before you report it.** It is a **defect** when the user's expectation is plain and no decision chose the odd outcome: the artifact simply does something nobody asked for, such as a run over one aspect of a pending item marking the whole item done. Fix it as you would any other finding, and tell the owner in one line what changed. It is a **question** only when a recorded decision or the owner's steer produced the odd outcome, or when typical users could reasonably expect two different things. **If you cannot tell which it is, it is a question.** Asking the owner whether to fix a plain defect hands them a decision nobody needed to make.
- **Once the owner has ruled on a point, it stays ruled.** Their answer is recorded under the decision document's *Would find odd*. A later gate does not raise it again unless something new changes it: a surface nobody had considered, or a build that behaves differently from what they ruled on. Then say what is new.

### Proof: *would the tests fail if this were built wrong?*

A test is worth only the defect it rejects.

- **Name the defect each test exists to catch, then break it that way and check that it fails.** Watch for these shapes: a fixture too small to reach the path; an assertion on a symptom that holds while the defect is live; a substring check that passes on reworded or re-wrapped leftovers; an assertion true in every mode; "exits 0" with nothing asserted; data that cannot show the defect (an ordering test with one row, ties whose stored order already equals the expected order, a filter test with no row the filter excludes); a comparison of the code with itself; a test of a copy of the code rather than the code; a check that a value is present rather than what it is; a test that skips silently when unsure of its own input; one direction of an authority rule tested and not the other; values that only look equal (`True == 1`); a path around the function that applies the rule.
- **Every guard has a mutation check**: the exact revert, and the failure it must produce. **A mutation is witnessed only when the test fails on its assertion.** A test that errors, hangs or fails to collect under the mutation proves nothing about the guard.
- **A mutation check asserts its own precondition first.** A check that cannot fail looks exactly like one that passed. Before trusting it, assert that the break is observable at all: that the two values really do sort differently, that the repeated text is not compressed away before it is compared, that no other guard already stops the same thing. Then break it and watch it fail (RL-4).
- **A concurrency test forces the interleaving.** A test that fails only when two threads happen to overlap proves nothing on the run where they did not. Hold the first one after its read (a barrier, an event, a patched step), start the second, and assert that it waits on the lock or sees the state the rule promises.
- **Old and new side by side get a parity test.** While a replacement runs beside what it replaces, feed both the same inputs and compare every read. It is the cheapest net for a port that changed behaviour without anyone deciding it should.
- **Existing tests, in three kinds.** Tests that will break are updated to assert the new truth, never loosened to accept it. Tests that keep passing and stop meaning anything are rewritten or retired. Tests that reach the code indirectly (patched factories, captured arguments, module mocks) are named, because they break in ways that look nothing like the cause.
- **Tests run the path production runs.** A test that builds through a shortcut, calls an internal step production never takes, or stubs the layer the defect lives in proves the shortcut.
- **Anything held constant and relied on gets a pin**: a byte-identity fixture or a golden output, because prose does not stop a reword.

### Coherence: *does the document still agree with itself?*

Every lens edits the artifact in one place against its own question. Read the result once, top to
bottom, as the next reader will.

- **Contradictions** between sections, steps, criteria, scope and risks.
- **Orphans**: anything whose reason a later decision removed.
- **Stale summaries**: counts, lists, mappings and headlines that no longer match the body.
- **One name per thing**, and no new name that collides with an existing one.
- **Sequence**: if it is built in order, does each step stand on what came before?
- **One story**: would someone who did only the steps end up where the summary says?

<!-- Ported from nikhilw/structured-agentic-workflow skills/build-phase/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The Loop: Read + Review Plan → TDD (Red/Green/Refactor) → Scoped Tests → Self-Review → Proceed

You MUST follow this loop for every phase. Do not skip steps. Every step produces output; do not stop after one step.

### Step 1: Read and Review the Plan

1. Read the plan file and locate the specified phase.
2. Understand what the phase requires: files to modify/create, expected behavior, test criteria.
3. **Surface discrepancies; do not silently work around them.** If the plan is ambiguous, contradictory, or assumes something that doesn't match the codebase, stop and emit the **Build Halt Report** below. Do not guess or make design decisions that the plan should have made. The resolution is the planning model's: it verifies what you found, amends the plan, and logs the amendment.
4. **Run the plan review below before writing a single line of code.**

#### Plan Review: Fresh Eyes on the Plan

`/review` puts fresh eyes on the **code**, after it is built. This is the mirror image: fresh eyes on the **plan**, before anything is built; and you are the only participant who has them. You did not write this plan. You carry none of the planning model's assumptions about what is obvious, and none of its attachment to the design it chose. That independence is worth what it is worth at review time, and here it costs almost nothing: the plan is one document, and the code does not exist yet.

**The mindset:** *I did not write this plan, but I am about to build it; once I start, its defects become defects in my code.* A defect caught here costs a paragraph. The same defect caught in `/review` costs a rework loop. Caught after four phases of dependent work, it costs the phases too.

**What this is not.** You are not re-brainstorming, not exploring alternatives, and not redesigning. Do not propose a different architecture because you would have picked one; the plan resolved its trade-offs with the user, and re-litigating them burns the cost advantage this session exists for. You read for things that are **wrong, missing, or unbuildable as written**, and you *surface* them; you do not fix them.

**The mechanical half; does the plan match the codebase?** Look things up; do not answer from having skimmed the plan. This half is `/existing-mechanisms`' *"`/build-phase`, Plan Review"* row: questions 1, 3, 5 and 8, run against this phase's named files and symbols. Load that file if you have not this session.

- **Does everything the plan names actually exist?** Walk this phase's file paths, functions, classes, signatures, routes, fixtures, config keys, and flags. Anything marked **new** is expected to be absent; everything else must be found. Building "the closest thing" to a name that does not exist is how an invented method that no other code expects gets written.
- **Does the plan name every caller of what it changes?** (question 1) For each existing symbol this phase modifies, especially a changed signature or return type, find its call sites and check the plan accounts for them. Where an index exists (`graphify query`, `graphify path`), use it to find where to look; a grep finds the name. In typed code, count with the language server's *find references* or the type checker, because the graph matches names, not types, and misses calls made through an instance. **A caller the plan does not name is the single most common plan defect**: a function gains a keyword argument, six test doubles call it at the old arity, and none are in the plan's file list.
- **Does the plan carry an Impact Analysis block, and does this phase's file list agree with it?** That block is the result of `/write-plan`'s impact and consolidation passes: what the plan changes the meaning of, what reaches those things, and how each site was disposed of. Check this phase's files against it. A site listed there as *added by the pass* that no phase actually names is a dropped requirement, and it halts like any other gap. **A plan with no such block at all does not halt on that alone.** Plans written before the block existed will not have one, and stopping a build over a missing section helps nobody. It means something narrower: the caller question above has had no first-party answer before yours, so yours is the only one, and it is worth the extra few minutes rather than a skim. Note its absence in your report either way, so the planning model knows the trace is owed.
- **Does the plan carry a Review Passes block with a line for every one of `/write-plan`'s ten passes?** It is the only record that they ran. A line that says a pass was skipped, stopped part-way, or ran without a tool it needed tells you where the plan is least checked, so read that part hardest. The same leniency applies as above: a plan written before the block existed, or before one of its passes did, does not halt on that absence alone, and you note it in your report.
- **Then `/existing-mechanisms` questions 3, 5 and 8**, asked of the plan rather than of the codebase: is it specifying something that already exists, does it retire what it replaces, does it bifurcate a pathway. Read them there; each names what a real answer looks like and what the silence costs. Anything you cannot answer from the plan is a silence, and a silence is a halt.

**The judgment half; is the plan buildable exactly as written?**

- **Is every decision actually resolved?** "Choose an appropriate X", "consider using Y", a function described but never given a signature; each is a decision handed back to you. Filling one silently is precisely how a plan's gap becomes a code defect that passes every gate. Name it and halt.
- **Does any step need a human, or leave a test red without naming its phase?** A step that says to ask someone or decide at build time is a decision handed back to you. A test the plan leaves failing must name the later phase that turns it green; one that does not is indistinguishable from a failure you caused.
- **Is every test criterion a real command with a real expected result?** A criterion you cannot run, or whose expected output is "tests pass", gives the phase no objective stop condition.
- **Do the phases run in a safe order?** Anything that could invalidate the plan; a load-bearing assumption, an external API that may not support what is needed, a migration that may not reverse; needs its gate *before* the work depending on it.
- **Does anything fight the codebase?** A convention it breaks, a boundary it crosses without saying so, an invariant enforced at a layer that cannot actually enforce it.
- **What is the plan silent about?** The silences are the danger, because you will fill them with the happy path without noticing: error and cancellation paths, expiry, cleanup, concurrency, what a second caller sees. A silence is not permission to guess.

**Scope.** On the **first** phase, review the whole plan; a plan-wide defect should surface before any code exists. On later phases, scope to that phase and to anything upstream that changed since.

**Reporting.** Anything either half turns up: **halt before writing code**, per the Standing Rule below. Report what the plan says, what you found, and the fix you would recommend. Say explicitly that the plan review ran and what it found; a clean review is a claim the reviewing model will read in the handoff, so it should be one you actually made.

**What this review cannot do.** It reads the plan against *your* codebase, so it says nothing about how a third-party library behaves at runtime; a missing transitive dependency, an undocumented metadata rule, an API that does not do what its docs claim. Only running it catches those, which is what the plan's gate phase is for. The two cover different failure classes and neither substitutes for the other.

### Standing Rule: You Are Not a Typist: Push Back on a Bad Plan

This is the Standing Instruction in operational form, and it applies at **every step**, not just when reading the plan. You are closer to the code than the planning model ever was, and implementation surfaces things planning cannot see.

The moment you spot a technical, architectural, or practical problem with the plan; an approach that won't work here, a design that fights the codebase, a step that is far more expensive than the plan assumes, a simpler route the plan missed, a requirement that contradicts how the system actually behaves; **stop and raise it**:

1. **State the problem**: what the plan says, and what you found that conflicts with it.
2. **Propose a fix**: the concrete alternative you'd recommend, and what it costs. Don't just report a blocker.
3. **Halt that phase.** Do not build the thing you believe is wrong while waiting, and do not quietly build your alternative instead; the plan is a contract, and unilaterally amending it is exactly the drift the workflow exists to prevent.

**A defect in the code you are porting is the same kind of halt.** When the plan says behaviour does not change and you find the old code wrong, do not copy the defect silently and do not fix it on your own. Halt with what it does, its effect, and its callers; the owner decides whether it is fixed now (a plan amendment) or kept as it is (an overrule, which you record; filing it is theirs).

The user decides: send it to the planning model to amend, or overrule you and have it built as planned. "The plan said so" is not a defence for shipping something you knew was wrong; you are expected to have judgment and to use it. Raising a real design problem mid-build is a success of the process, not an interruption of it. Either way the outcome is recorded: an amendment ID, or an overrule you note in the phase report so it reaches the handoff.

#### The Build Halt Report

Emit this, then stop. It goes to a model that has to decide the resolution without your session, so
it carries the same burden a plan does: specific enough to be checked, with no step left to
inference.

```markdown
## Build Halt: Phase N

**Plan:** [path]   **Phase:** [N; name]   **Where:** [file:line, or plan section]

**Plan says:** [what the plan instructs, quoted or tightly paraphrased]
**Found:** [what the codebase, the test, or the runtime actually shows]
**Evidence:** [the command you ran and what it reported, or the file and line you read]
**Why it blocks:** [what you would have to invent, guess, or decide to continue]

**Options:**
1. [concrete route]; [cost, and what it gives up]
2. [concrete route]; [cost, and what it gives up]

**Recommendation:** [the one you would pick, and why]

**State of the tree:** [what is built and green so far; what this phase left untouched; whether
anything is half-done and needs reverting before the fix lands]
```

Two lines people leave out, and both matter more than the diagnosis. **Evidence** is what lets the
planning model verify your claim in one command instead of re-deriving your whole investigation.
**State of the tree** is what stops the amended plan from being written against a tree it does not
match.

**Report a suspected decision-level problem as such.** If what you found undermines the *approach*
rather than this phase of it, say so explicitly in "Why it blocks". That sentence is what sends it
back to brainstorming instead of into a phase amendment, and it is the distinction the accumulated
drift at the end of a project is usually made of.

### Step 2: TDD: Write Tests, Then Implement

Use `/test-driven-development`. This is mandatory for every phase. Check `testing` in `.claude/workflow.json`: if it is `bdd`, write the failing tests in step 1 as Given-When-Then scenarios in the project's own BDD harness instead of unit-first tests. Red, green and refactor are unchanged, and so is the rule that nothing is implemented before a test fails. If the project has no BDD harness, that is a plan defect, not a reason to install one or to fall back to unit tests quietly; halt and say so.

1. **Red:** Write the failing tests first; encode the expected behavior from the plan's test criteria before writing any production code.
2. **Green:** Implement the minimum code to make the tests pass. Implement exactly what the plan describes; no more, no less. Do not refactor surrounding code unless the plan explicitly calls for it.
3. **Refactor:** Clean up while keeping all tests green.

**You must complete all three steps.** Do not stop after writing tests. The tests exist to drive the implementation; writing them is the beginning of the phase, not the end.

**Build the seam test the plan names.** If this phase completes a value path, the plan names a no-mock test across the real seam; write it, and let it exercise the real thing. Replacing it with a mocked unit test technically satisfies "a test exists" while proving nothing about the wiring, and that is precisely the gap review is built to catch. If you cannot make the real seam work, that is a Concern to report, not a mock to substitute.

**The Standing Instruction is live in the middle of this step.** Implementation is where the plan's
silences become visible, and where they are cheapest to mistake for permission. The moment you find
yourself reaching for any of these, you have found a plan defect and the answer is a halt, not a
keystroke:

- adding a parameter, field, flag or config key the plan never named, to make the phase work;
- calling something adjacent because the thing the plan named does not exist;
- mocking a seam the plan said to exercise for real;
- widening a signature, loosening a type, or catching an exception the plan did not account for;
- deleting a line, a test, a config key or a file that the plan's removal table does not name;
- "I'll build it this way for now and mention it at the end."

Each of these is a decision the plan owed you. Fill one silently and it never surfaces again: the
tests you wrote will encode your guess, and every gate downstream reads green.

### The Quality Bar You Are Building To

`/review` will judge this code against Clean Code (Robert C. Martin), SOLID, DRY, KISS, and YAGNI. Write to that bar now; code that fails review costs a full rework loop, and the review has no power to lower it.

In practice, while implementing:

- **Names** carry meaning on their own; no abbreviations that need decoding, no mental mapping.
- **Functions** are small and do one thing. A growing parameter list or a boolean that switches behaviour is the signal of a missing abstraction; extract it now rather than defending it later.
- **No hidden side effects**: a function's name must not conceal a mutation, an I/O call, or a state change.
- **DRY**: if you paste a block, extract it. If the codebase already solves this, use its solution rather than writing a parallel one, and "the codebase" includes what earlier phases of this plan built: rewriting it from the plan is duplication even though nothing was pasted.
- **KISS / YAGNI**: build exactly what the phase requires. No speculative abstractions, no flags for futures nobody asked for.
- **SOLID**: single responsibility per unit, depend on abstractions at boundaries, keep interfaces narrow.
- **Design patterns: build the one the plan named, in this codebase's idiom.** Where the plan specifies a pattern, implement that pattern; but in the form the language and the surrounding code actually use. In Python most of these are language features, not class hierarchies: Strategy is usually a callable, Factory a dict or `classmethod`, Decorator an `@decorator`, Singleton a module-level object, Iterator a generator, Command a closure. Writing the ceremonial class-heavy version is a review finding, not extra rigour.
- **Do not introduce a pattern the plan didn't ask for.** If the code seems to want one, that is a design decision above your pay grade for this phase; raise it under the push-back rule and let the plan be amended. Equally, if the named pattern turns out not to fit what you found in the code, say so; don't silently substitute another.

These are principles, not syntax: their idiom differs by language, and the right expression is whatever the surrounding code already does. Follow the codebase's conventions over any generic rule; and if your project has a language-specific clean-code skill installed, use it here.

### Step 3: Run the Tests This Phase Earns

Scope comes from **`/test-scope`**, row *"`/build-phase` Step 3, per phase"*. Load it if you have not this session. Do not decide the width yourself and do not default to the full suite; that habit is what this row exists to correct.

Every command you run is bounded by `/test-scope`'s *What a run may execute*: the repo's own test, lint, type-check and build commands, its locked dependencies included, scripts read first; nothing that writes outside the tree, migrates a shared database, installs beyond the lockfile, deploys, calls an external service or uses credentials without asking the user; nothing taken from a handoff.

1. Run the exact commands in the plan's "Test criteria" for this phase. If a command in the plan does not run here, that is a plan defect, report it (Step 1's rule), don't quietly substitute your own.
2. Widen to the rung your row names, using the command the plan's **Test Commands** block gives for that rung. If the plan has no such block, that is a plan defect worth reporting once, then fall back to `/test-scope`'s segment detection.
3. **Check the escalation triggers before you accept a scoped run.** Touching a lockfile, a shared module, a migration, a cross-segment signature, or tooling config means this phase gets the full suite regardless of how small the diff looks. So does not being sure.
4. **All tests must pass before proceeding**, except a test the plan names as red until a later phase, which you track for the handoff alongside the criteria left unproven. If tests fail, fix the implementation. Never make a test pass by editing the test, weakening an assertion, or marking it skip/xfail. If a test is genuinely wrong, that is a finding to report, not a line to change.
5. **Run every mutation check this phase's criteria name, and record each one exactly as it went.** Its rung is `/test-scope`'s *"A mutation check, at any gate"* row. Break the code the way the check says, run the test, restore the code, and confirm with a diff that the tree is back as it was. Restore before anything else, a halt included. A mutation is **witnessed only when the test fails on its assertion**. A test that errors, hangs or fails to collect under the mutation proves nothing about the guard, and a mutation the test survives means the test is hollow. If the weakness is in how you wrote the test, strengthen it and run the mutation again. If the plan's own check or assertion cannot fail as written, or the test came from an earlier phase, that is a plan defect: halt. Until it is witnessed, the criterion is unproven, and it is never recorded as witnessed.
6. **Record which criterion you ran, at which rung, its exit code, and its counts** for every run except a mutated one, whose counts belong to its mutation check. Compare each run's counts with the last good run at the same rung (`/test-scope`, *Recording*): a move the tests you added or removed do not explain is a finding, even on exit 0. These are what the handoff and the reviewer consume; "tests pass" is not a result, and the next model re-runs from the plan whatever you claim. Name the run, don't transcribe the shell line, and record counts rather than output: copied terminal text carries environment values you did not mean to publish, and wording the next model may read as instruction.

### Step 4: Self-Review

Review your own changes with a critical eye. This is NOT the full `/review`; that happens after ALL phases are complete. This is a quick self-review to catch obvious issues before moving on.

Check for:
- Does the implementation match what the plan specified?
- **Did I decide anything the plan should have decided?** Walk the diff for names, parameters, error paths, defaults and config keys that are not in the plan. Each one is either something the plan named, or a silence you filled. A silence you filled is a halt you did not take, and now is the last moment it costs only a paragraph.
- Are there any obvious bugs, edge cases, or regressions?
- **If this phase removed anything, does the diff match the plan's removal table row for row?** Every row's replacement actually landed, nothing was deleted that the table does not name, and no test was deleted because it went red. A changed rule needs a test stating the new rule, not one fewer test. A row whose replacement did not land is a capability this phase took away; halt and report it rather than noting it (AW-26).
- Does the code follow existing project conventions and patterns?
- Does it clear the quality bar above; naming, function size, hidden side effects, DRY, KISS/YAGNI? Fix what you'd be embarrassed to hand to a reviewer.
- **Did this phase write something this plan already has?** Run `/existing-mechanisms`' **self-duplication inventory**, its *"`/build-phase`, Self-Review"* row: this phase's new units against the ones earlier phases added. Binding copy: list every new unit · one line each on what it does, as behaviour, not its name · group the lines that do the same job, in part included (the same call skeleton, the same lookup, the same calculation). Then settle each group. Duplicates inside this phase's own files you extract now; that is TDD's refactor step, so re-run Step 3 after it. A copy of an earlier phase's unit you replace with a call to it as it stands. If it can only be shared by changing the earlier unit or by creating a module the plan does not name, halt: the plan owed you that extraction. Record the count in the self-review, not as a report of its own.
- Is anything over-engineered or under-tested?
- **Would each new test fail if the code were wrong?** Read every test you wrote against these shapes of a hollow test: a fixture too small to reach the path · an assertion on a symptom that holds while the defect is live · an assertion true in every mode, or "exits 0" with nothing asserted · data that cannot show the defect (one row for an ordering, no row the filter excludes) · the code compared with itself, or a copy of the code tested instead of it · a value checked for presence, not for what it is, substring matches included · a silent skip when unsure of its own input · one direction of an authority rule only · values that only look equal (`True == 1`) · a path around the function that applies the rule. A test in one of those shapes gets rewritten now, and Step 3 re-run after it.

Also track, for the handoff: any criterion you could not prove with a green automated run; checked by reading, skipped, deferred, or done manually, plus any criterion proven only at a scoped rung. A scoped pass is a real result, but it is not the same claim as a full-suite pass, and only you know which one it was. Write it down as you go; reconstructing this at the end is how it gets lost.

If you find CRITICAL issues, fix them and re-test before proceeding. For minor concerns, note them; the full `/review` will catch them after all phases.

Record the self-review findings, then proceed. Do not block waiting for approval on a clean phase; flag and stop only for a plan defect or a CRITICAL you cannot fix.

### Step 5: Proceed

**Record**, for Phase Completion and the handoff: what was implemented; the test results, rung, exit
code and pass/fail/skip counts; the self-review findings and any fixes applied. That material has to
exist, because the completion report and `/build-handoff` are built from it. It does not have to be
said now.

**Say, now: one line** (AW-28). What the phase built, its rung and result, and that you are starting
the next one.

> Phase 2: repository layer built. T2 green, 84 passed, exit 0. Starting Phase 3.

A clean phase is not an ask, so it does not get a report; the per-phase detail is emitted once, in
the build completion report, not after every phase. The exception is a phase that needs a ruling, a
plan defect, a CRITICAL you could not fix, a halt, or a capability removed (AW-26). Then the ask
opens the report and the detail goes underneath it.

**Then auto-advance:** if the phase is clean and more phases remain, immediately suggest and begin the next phase. Do not wait for the user to say "proceed" unless the plan requires a human decision gate.

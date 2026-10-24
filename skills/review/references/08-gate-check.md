<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Round N: Gate Check: LOOP OR EXIT

**If ANY findings of ANY severity remain; first decide who fixes them.**

**Findings you are fixing yourself go to the ledger; the user gets one line** (AW-28): the counts by
severity, who is fixing them, and that nothing is needed from them. The full round goes to them when
they have to rule, which is when a Rework Brief goes back, when a finding changes the plan or the
decision document, or when the review exits.

Fixing them yourself is the default. Send the work back to the build model when any of these hold:

- more than roughly **8 open findings**, or findings spanning more than half the phases;
- the same defect **repeats across three or more sites**: a systemic misunderstanding, not a slip;
- a **phase is missing, unwired, or untested** rather than merely wrong;
- fixing would mean substantially rewriting what the build model produced.

Past that volume you stop reviewing and start rebuilding; and you cannot review code you just wrote. Small, local, few: fix them here.

### Sending back: the Rework Brief

It goes to a model with no memory of this review, so it carries a plan's contract burden: self-contained findings, decided fixes, exact proof commands. **A brief is a plan, and it gets a plan's review before it leaves your hands.** See *Before you hand it over*, below.

```
## Rework Brief: [feature]

**Plan:** [path]   **Base:** [commit/range]   **Round:** [N]
**Do not touch:** [files/areas outside scope; unrelated worktree changes]

### R1: [SEVERITY] [one-line title]
**Where:** `path/to/file:120-134`
**Now:** [what the code currently does]
**Wrong because:** [defect, contract, or plan requirement violated; cite plan §/decision doc]
**Required:** [the specific change; decided, not "consider"]
**Yours to judge:** [omit unless the brief genuinely cannot decide this. Where it appears, say what
must be reported back: which way you went, and what you traced to check it]
**Prove it:** [the run that must go green; plan criterion or test id] → [assertion that must pass]

### R2: ...

### Systemic
[A defect repeating across sites; state the pattern once, list every site, fix as one thing.]

### Standing criteria
[Every general criterion the owner stated during this review, verbatim. They apply to every item
above and to every later round, not only to the case that prompted them. "None." if there are none.]

### Do not regress
- `[full suite command]` → [current expected result]. T4 full, never a scoped run
- `[the plan's Test Commands rung this rework touches]` → [current expected result]
- [invariants/paths already verified; must still hold]
```

Every item gets a failing-test-first instruction. Never send a partially-fixed worktree; fix a finding fully or leave it untouched and list it. State which findings you already fixed so they are not re-litigated. When the build model returns, **restart at Round 1 with fresh intake**; its report is a claim, not evidence.

#### Before you hand it over

A brief is executed literally by a model that cannot see what you meant, so a wrong line number does not produce a question; it produces an invented implementation. Run the plan reviews that apply to a brief, the ones below, in the order `/write-plan` runs them and for the same reason: the trace can still add fixes to the brief, so names verified before it are names verified against a list that was about to grow.

- **First, trace what the fixes change the meaning of.** This is a plan's impact pass, run on the brief, and it starts from the code rather than from the brief: `/existing-mechanisms`' **impact trace**, all three axes. **Structural**, for every symbol, default, format or contract a fix alters, what reaches it and what it reaches, including the inbound edges that never spell the name. **Functional**, which end-to-end flows the fixes move, since a review fix that satisfies a finding and breaks a flow is the worst possible trade at this stage. **Consolidation**, whether the fixes leave anything unused, add a pathway beside an existing one, or duplicate something the codebase already has; a rework round is where that happens most, because each finding is fixed in isolation. **Count the call sites; do not estimate them.** A brief that says four sites where there are seven is executed at four, and comes back green. A fix whose callers are not in the brief is the review handing the build model the same gap the plan had.
- **Then walk each fix through the cases around it.** This is `/review-lenses`' logic lens, applied to the brief. A review fix is written against one finding, which makes it the most likely change to break the cases next to it: the empty input, the page boundary, a crash between its writes, two copies running at once, a helper reused across a contract it was never built for. Step each fix through those with concrete values before handing it over.
- **Then read the brief back against the decision document.** It can satisfy every finding you raised and still ask for something the decision ruled out. It is the same drift pass you run on the code, run on your own instructions.
- **Then check that each fix's failing test would actually fail.** This is the proof lens: name the revert, confirm the break is observable at all, and confirm the assertion sees it. A brief whose tests go green on the unfixed code comes back green and unfixed.
- **Then confirm every name, file, line and command in it exists, and every cited line holds what the brief says it does.** A line number that resolves to the wrong code passes an existence check. Check them one at a time against the codebase, not against your memory of reading it an hour ago. This is `/existing-mechanisms`' *"`/review`, before a Rework Brief is handed over"* row: the second sweep, run against the artifact.
- **Test every search pattern the brief hands over against every form of the defect.** A pattern given to a build model defines what it fixes, so one that matches `row[0]` and misses `rows[j][0]` or a tuple unpacking leaves those sites unfixed and the round green. Run it, and confirm it finds each form you know of before it goes in.
- **And check whether any fix is inert without another.** Two guards on consecutive lines means removing one changes nothing. Name the pairing and require them built together, or the round costs a relaunch and moves nothing.

### Fixing them yourself

1. **Prove it before you fix it.** For anything behavioural, write or identify a **failing** test first. A fix with no failing test to its name is unverifiable, and this workflow does not permit untested patches; least of all during the review that exists to catch them.
2. **Investigate before patching.** If the behaviour surprises you, run `/debug`. Fix the root cause; a symptom that disappears without explanation is a finding you hid rather than resolved.
3. **Re-run in widening circles**, per `/test-scope`'s *"`/review` while fixing findings inside a round"* row: the new test, then the impacted or segment suite. The full suite belongs at sign-off, not after every finding. Record which runs you did, at which rung, and what they reported, for the summary.
4. **Preserve unrelated work.** Do not revert, stash, reformat, or tidy anything outside the scope established at intake. If a fix genuinely requires it, say so in the summary.
5. **Go back to Part 2, Round N+1.** Re-read from disk, run the full checklist again.

**Only when zero findings remain (CRITICAL = 0, MAJOR = 0, MINOR = 0), and a deep read that was started has returned or is recorded in the ledger as not having run:** take the sign-off run, then write the final summary, then suggest `/verify`.

**The sign-off run** is `/test-scope`'s *"`/review` sign-off"* row: the full suite. If you made a full-suite run earlier in this review and have changed nothing since, cite that run under the citable-run rule instead of repeating it, and write the citation into the summary with what proved the tree unchanged. A review that found nothing therefore costs one full-suite run, not two; a review that fixed something costs two, because the first one is no longer about this code.

Then `/verify`. You proved the *code* is sound; that is a different, final gate, and it is not another review. It re-checks the plan's requirements line by line, which always runs fresh, and it needs a full-suite run true at the moment of completion, which is exactly the run you just recorded. Leave it citable: record the rung, the exit code and the counts in the summary below, and change nothing after signing off.

**DO NOT exit with open MINOR findings.** "We can clean those up later" is how codebases rot. You are the person who said this was good enough; make it actually good enough. The only legitimate dismissal is demonstrating in writing that a finding was wrong on inspection; "low priority" is not a dismissal.

---

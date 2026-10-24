---
name: existing-mechanisms
description: Reference loaded by brainstorm, write-plan, build-phase and review. The eight questions about what the codebase already does, the 3-axis impact trace, the second sweep, and the self-duplication inventory. Not a step on its own.
user-invocable: false
---

# Existing mechanisms

Defines what you must prove you understand before proposing, planning or approving a change. Reading it satisfies no gate; it tells the gate you are standing in what to answer.

**Why:** the costly failures are analysis never done, not bad trade-offs: a mechanism that already existed under a name nobody searched, a caller nobody listed, a subsystem left unreachable, a second pathway built beside the first. These questions find something almost every time, so ask them by default.

<!-- refs:start -->
## Full detail (read at the matching step)
This SKILL.md is the binding gate. Each section's full explanation, examples and rationale is in `references/`. Before you run a section below, read its file. Where a file and this SKILL.md differ, this SKILL.md wins.

| Section | File |
|---|---|
| Existing Mechanisms | [references/01-intro.md](references/01-intro.md) |
| Why this exists | [references/02-why-this-exists.md](references/02-why-this-exists.md) |
| The eight questions | [references/03-the-eight-questions.md](references/03-the-eight-questions.md) |
| How to answer | [references/04-how-to-answer.md](references/04-how-to-answer.md) |
| The ledger | [references/05-the-ledger.md](references/05-the-ledger.md) |
| The impact trace | [references/06-the-impact-trace.md](references/06-the-impact-trace.md) |
| The second sweep | [references/07-the-second-sweep.md](references/07-the-second-sweep.md) |
| The self-duplication inventory | [references/08-the-self-duplication-inventory.md](references/08-the-self-duplication-inventory.md) |
| Where this is answered | [references/09-where-this-is-answered.md](references/09-where-this-is-answered.md) |
<!-- refs:end -->

## The eight questions
Answer every one, or write "does not apply, because ...". Silence reads as "checked and clean" and that is how the gap ships.

1. **Callers and calls, both directions, as two separate lists.**
   - *Backward (who reaches this):* direct callers, then their callers, out to a boundary this change cannot disturb (stable public API, process edge, surface with its own contract). Say where you stopped and why. Include edges that never spell the name: test doubles and fixtures, DI registrations, route and command tables, event subscriptions, decorators, persisted references, config keys, scheduled jobs, string dispatch.
   - *Forward (what this reaches):* callees and what they depend on: modules, tables, queues, caches, files, env vars, external services, and the assumptions each carries.
   - This question is the structural third of the impact trace below. Answering only it is how a blast radius comes out a third of its real size.
2. **Scope beyond the entry point.** Which sibling flows and alternative paths reach the same data or decision? Fixing one of four entry points and calling it fixed is the failure.
3. **Does this already exist?** Name the mechanism, or state what you searched for and did not find. Search by behaviour, not the name you would have chosen. On a plan or diff there is a second half: does the change already contain it (see the inventory below)?
4. **Relationship to the incumbent:** extend, replace, abandon, or compete. **Compete is never an answer you keep.** Two mechanisms for one job is the defect, whichever is better.
5. **Retirement and dead code.** What happens to the old mechanism, its callers, tests, config keys, stored data, docs? When anything is removed this answer becomes a table:

   | Removed | What it did | Replaced by | Anything lost? |
   |---|---|---|---|

   - Nothing is deleted because it "looks unused": prove callers both ways, including tests, fixtures, DI, route tables, config keys, jobs, string dispatch, and readers of the file itself (build and packaging files, path checks).
   - Ask what it was load-bearing *for*. A checkpoint prune that reads as tidy-up may be the only thing bounding a database.
   - A test still covering a path nobody takes is a coverage hole, not a pass. Deleting a test because it went red is not updating it; a changed rule needs a test stating the new rule.
   - Scalpel, not butcher knife: remove exactly the lines the table names.
   - A blank *Replaced by* is a capability the work took away. Say so in those words. Reduced functionality is the owner's decision, never a gate's.
6. **Build on what exists.** State the extend-the-incumbent version of this change even if you won't recommend it. Can't state it? You don't understand the incumbent well enough to replace it.
7. **House patterns before book patterns.** Name the shape this codebase already uses for this problem.
8. **Unify, don't bifurcate.** What common behaviour can be extracted? Does the change add a second pathway: a branch routing old versus new, a flag choosing implementations, a parallel class? Each doubles every future change. If you add one, say so and say what collapses it back.

## How to answer
- **Count the set, then list it:** "7 call sites in 5 files", members named. "All callers updated" is an adjective. If you did not count, say so.
- **Every answer names its evidence:** the query, grep, file or probe. Docs and comments are evidence tier 1 (see `brainstorm` BS-3).
- **An unknown is probed or promoted** to an Open Question, never left silent.
- **Write answers where the next reader will find them:** the decision doc (brainstorm) or the plan's Codebase Analysis (write-plan). Answers that live only in the session never reach the builder.

Ledger shape (one line per question, each with evidence):
```
### Existing mechanisms
1. Callers and calls: backward [N] sites in [M] files [file:line each; boundary + why]; forward [N] deps [...]; edges that don't spell the name [...]
2. Scope beyond entry point: [...]
3. Already exists: [mechanism, or what was searched]
4. Incumbent: extend | replace | abandon + why
5. Retirement: [removal table, or "nothing retired"]
6. Build on what exists: [...]
7. House pattern: [...]
8. Unify vs bifurcate: [extracted; any second pathway and what collapses it]
```

## The impact trace (three axes, all three, every time)
They fail differently and get dropped in a fixed order: the structural list feels like a finished answer, so the other two never run. That is why surviving damage concentrates there.

**Use an index if you have one, refresh it first, treat it as a locator.** See `knowledge-graph` (only when graphify is installed). An index goes stale downward: a stale one returns a *smaller* number that reads as good news. If you did not refresh, say your counts are a floor. In typed code, count with the language server's find-references or the type checker, because name-matching indexes miss calls through an instance.

**Count against a denominator.** A count is only evidence when measured against a set you enumerated by construction (layers, entry surfaces). "4 of 14 entry surfaces reach this" is falsifiable; "4 flows change" is not. Where no denominator exists (logical couplings), say so in those words: "I searched and found 4" is visibly weaker than "4 of 14", and the page must show the difference.

### Axis 1: Structural, what connects to this?
- **Backward:** call sites then their callers to a named boundary, including edges that don't spell the name.
- **Layers, Axis 1's denominator.** A search on the identifier covers one layer, because the identifier is renamed at every hop (column, attribute, serializer key, wire field, template variable, screen label, report figure). List the layers first, name the spelling used at each, and sweep for that. Report as a fraction: "6 layers between this column and its last consumer; it reaches 4; 11 consumers". Count consumers of the *value*, not occurrences of the name; on display, export and report paths the sites that never spell the name are usually most of them.
- **Forward:** every callee and what those depend on.
- **Dependency directions both ways:** imports, module and layer edges, wiring and registration, schema and migration order. A reversed dependency breaks nothing today and blocks the next change.
- **Type-check sweep for removals and signature changes:** apply them in an isolated copy (worktree or scratch checkout, never the working tree), empty a deleted module rather than removing it so each use fails at its own line, run the project's type checkers over everything (scripts, tests, frontend, tooling), after proving the checker sees a deliberate break (RL-4 in `review-lenses`). Then search the names as strings, which a type checker cannot see.

### Axis 2: Functional, what behaviour runs through this?
- **Enumerate the entry surfaces first** (routes, CLI commands, queue and event consumers, scheduled jobs, UI actions, public API, test entry points). List and count them. For each, does any path reach the changed code? Report a fraction. The reaching ones are the flows to walk end to end, described by what a user or operator notices ("checkout still charges the right amount"), not by function names.
- **Flows this depends on:** what must already hold, in what order. A conditional or best-effort upstream flow is inherited.
- **Logical dependencies both ways:** invariants this code assumes and others assume of it; ordering and timing; state written here and read elsewhere. No graph shows these. Say what you read and asked; "none found" must state where you looked.
- **Storage pairs:** for every value written to a table, file, queue or cache, find every reader; for every value read, every writer. A reader with no writer, a writer nobody reads, a flag nobody clears is a finding.

### Axis 3: Consolidation, fewer ways to do things afterwards, or more?
Unused code left (question 5 governs removals; finding something unused is not authority to remove it) · parallel systems built · something abandoned without anyone deciding (reachable but never reached; surface it) · reuse versus new parallel flows (say which, in one word) · things to extract, in three directions: code this change should reuse, common behaviour it exposes for others, and the change repeating itself (inventory below).
The trace is not finished until you can say whether the codebase ends with **fewer ways to do this job or more**. "More" is an answer and goes to the owner in those words.

### Result block
```
Impact trace
- Index: [queries run, or "no index, grep and read"]; refreshed: yes | no (counts are a floor)
- Structural backward: [N] sites in [M] files; boundary [x] because [y]; layers [L], reached [R]
- Structural forward: [N] callees/deps
- Edges that don't spell the name: [list, or "none found" + what was searched]
- Dependency directions: [list; any reversed]
- Flows changed: [N] of [M] entry surfaces, each end to end
- Flows depended on: [N]
- Logical dependencies / storage pairs: [...]
- Unused left / parallel systems / abandoned: [...]
- Reuse and extraction: [...]
- Verdict: fewer ways | more ways (said to the owner)
```
An axis that found nothing collapses to one line **with its count**; never drop the axis itself (a line saying "found nothing" is evidence it ran). A trace with no counts was not walked.

## The second sweep
The first pass runs against the problem while the design is in your head; the second runs against what you actually wrote, where precision defects surface. Three things make it work:
- **Run it against the artifact, not your memory.** Walk the finished document's own names, files, symbols, commands back to the codebase, both directions, counting what you find.
- **Hunt a named list,** saying which you hunt before you look: **dropped** requirements; **dangling** deletions (callers, tests, config or data left); **duplicates** of something that exists; **missed callers**, especially unnamed edges; **bifurcated** pathways; **inert** changes (two guards on consecutive lines, remove one and nothing moves); **drift** from what was decided.
- **Permission to reverse.** A sweep that can only confirm is not a sweep.

The document half (walk its names outward) and the codebase half (walk code edges inward, which is the impact trace run against the artifact) are separate passes; merging them answers the second with the first's method.

```
Second sweep
- Hunted: [named classes]
- Walked: [N] names/files both directions; [N] call sites found vs the [N] the document claims
- Found: [each defect, one line, or "nothing"]
- Changed: [edits made, or "nothing"]
```
A sweep that emits nothing did not happen. "Anything else you'd rethink?" is a trigger to re-run it for real; do not wait to be asked.

## Self-duplication inventory
Looks at the change itself, which no outward search can see because the copies did not exist when you searched.
1. **List every unit the artifact adds** (each function, method, class, block of more than a few lines). From a plan: the units its phases specify. From a build: added lines in the diff against the base, not the file list.
2. **One line each, as behaviour** (takes, does, returns), not the name; two copies of one job rarely share a name.
3. **Group lines that do the same job**, in part included (same skeleton with a different middle step, same lookup keyed differently, same calculation with another constant).
4. **Settle each group of two or more:** extract, reuse the earlier unit, or keep apart naming what each changes for. "They look different" is not a reason.

```
Self-duplication inventory
- Listed: [N] units, from [plan phases | diff against base]
- Groups: [N]: [units -> extract | reuse | kept apart because ...] or "none"
```
The count of units listed shows the inventory was walked; "no duplication" without it was never made.

## Where each gate answers it
| Gate | Runs it against | Depth |
|---|---|---|
| brainstorm, current state | the problem | all eight, in the decision doc |
| brainstorm, per approach | each approach's blast radius | impact trace, survey depth (enough to compare, still counted) |
| brainstorm, decision audit | the recommended design | re-ask 3, 4, 5, 8; impact trace to full depth on the winner only |
| brainstorm, after the doc is written | the saved document | second sweep, both halves |
| write-plan, codebase analysis | the concrete design | all eight, in the plan |
| write-plan, impact pass | edges into and out of everything the plan changes the meaning of | structural + functional axes, full depth, counted; runs first |
| write-plan, consolidation pass | the traced set and the units the phases specify | consolidation axis + inventory; runs second |
| write-plan, executability pass | the finished plan's own names | second sweep, document half |
| build-phase, plan review | this phase's named files and symbols | questions 1, 3, 5, 8; a gap is a halt, not a fix |
| build-phase, self-review | this phase's new units vs earlier phases' | inventory; reusing an earlier unit as it stands is fine, changing it or extracting outside this phase's files is a halt |
| review, codebase consistency | the code as built | 3, 5, 8 + inventory over the whole diff |
| review, before a Rework Brief goes out | the brief's own names, lines, commands | second sweep, both halves; a brief is a plan |
| bug or quick fix, no plan | the fix about to be made | 1, 2, 8 first; question 2 matters most |

Two depths on purpose: brainstorm traces every approach shallowly because the comparison is what it buys; write-plan traces the one chosen design exhaustively because the file list is what it buys. Later rows are narrow because the decision is already made, and widening them turns a build into a redesign.

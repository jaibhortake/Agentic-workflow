<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Plan Document Structure

```markdown
# Plan: [Feature Name]

## Summary
[2-3 sentences describing what this plan achieves]

## Context
[What exists today, what changes, and why]

## Decision Source
- **Decision doc:** [`docs/decisions/YYYY-MM-DD-topic.md`, or "none; no brainstorm ran"]
- **Decisions implemented:** [each decision from that doc → the phase or section of this plan that carries it]
- **Carried by another plan:** [only when a plan was split (RL-6): decision → the plan that carries it. Omit otherwise]
- **Departures:** [decision → what this plan does instead → why → that the user was asked and chose to leave the document standing. "None" if the plan implements every decision as written, which is the normal answer at approval: while the plan sat in `new/` every difference was a question for the user, not an entry here (WP-14).]

## Codebase Analysis
- **Existing mechanisms:** [the `/existing-mechanisms` ledger, all eight lines, answered against this design]
- **Existing patterns used:** [patterns/utilities this plan reuses]
- **New patterns introduced:** [the pattern scan's result: each pattern this plan specifies, with the problem it solves and the form it takes here, or "scanned; no pattern applies". If a pattern is introduced, justify why existing patterns don't fit]
- **Retired by this plan:** [`/existing-mechanisms` question 5's removal table: one row per removal, each naming what it did, what replaces it and the test on the new path that proves it, and what is lost, plus the phase that performs it. "Nothing" if nothing is removed. An empty *Replaced by* cell is a capability this plan gives up, and it is the owner's call, not a detail]
- **Security considerations:** [attack surface, input boundaries, access control]
- **Files/modules affected:** [list with brief description of each interaction]

## Impact Analysis
*(The impact and consolidation passes' result, which is also the codebase half of the second sweep; the document half is the executability line of Review Passes. `/existing-mechanisms`' impact trace, all
three axes, at full depth; the consolidation pass writes *Consolidation*, the impact pass the rest. Counts, not adjectives. Written even when the trace found nothing: an axis
that found nothing collapses to its one line with its count, and the rest of that axis's bullets are
cut per WP-15. All three axis headings stay, because a line saying an axis found nothing is evidence
it ran and a missing line is not.)*
- **Hunted:** [which of the second sweep's named classes were looked for, by name]
- **Index:** [the graph queries run; or "graphify not installed, fell back to grep and read"]
- **Changes meaning:** [N] things: [each one, and whether the plan edits it or changes what it means without editing it]

*Structural*
- **Layers:** [N] enumerated between what changes and its last consumer; this reaches [M]. Each: [layer → the spelling it uses there → what the sweep for that spelling returned]. One spelling across every layer is either a thing that genuinely keeps its name or a trace that stopped at the first hop, and those look identical; so say which
- **Backward:** [N] inbound sites across [M] files, each at `file:line`, across the layers above; traced out to [the boundary] because [why that edge cannot be disturbed]
- **Edges that do not spell the name:** [fixtures, test doubles, DI registrations, route/command tables, config keys, scheduled jobs, string dispatch, found here; or "none found", with what was searched]
- **Forward:** [N] callees and dependencies reached, and the constraints this plan inherits from them
- **Dependency directions:** [what this depends on, what depends on it, and any direction this change reverses]
- **Type-check sweep:** [errors per directory from the removals and signature changes applied in an isolated copy; the deliberate break it was proven against; or "no removals or signature changes"]

*Functional*
- **Flows changed:** [N], out of [M] entry surfaces enumerated; the fraction, not a bare count, or this axis cannot be told apart from one answered by recall. Each end to end: [entry surface → observable effect → the seam test that covers it]
- **Flows depended on:** [N]: [what must already hold, and in what order, for this to deliver its value]
- **Logical couplings:** [invariants assumed here and about here, ordering relied on, state shared with code that has no edge to this]
- **Storage pairs:** [each value this plan writes or reads through a table, file, queue or cache → its writers and its readers → whether both ends agree; a reader with no writer, a writer nobody reads, or a flag nobody clears is a finding]

*Consolidation*
- **Left unused:** [what becomes dead, and the phase that removes it; or "nothing"]
- **Parallel systems:** [second pathway added and what collapses it; or "none; this unifies X and Y"]
- **Abandoned without deciding to:** [what stops being reached, surfaced to the owner; or "nothing"]
- **Reuse and extraction:** [what this reuses instead of rewriting; what it extracts for others to reuse, and the phase that does it; or "no extraction available", naming what was checked]
- **Self-duplication:** [N] new units specified across the phases; [N] groups doing the same job, each → extracted in phase N / reused / kept apart because [what each changes for]; or "none"
- **Verdict:** [fewer ways to do this job afterwards, or more; if more, that it was put to the owner in those words]

*Result*
- **Disposition:** [N] already named in the plan · [N] added by this pass, in phases [...] · [N] out of scope, each with its reason and what happens if it is left alone
- **Found:** [each defect the impact pass turned up, one line each; or "nothing"]
- **Changed:** [what was edited in this plan as a result; or "nothing"]
- **Re-verification:** [what the decision walk over this pass's additions said, including any difference taken back to the user] · [what re-checking phase order against the additions moved] · [how many trace rounds ran until one added nothing, and what each round searched on]
- **Evidence:** [the greps, reads and probes this rests on, beyond the graph queries above]

*Names, never values.* This block enumerates environment variables, connection targets, config keys and external services, and the plan is committed to the repo and read by every downstream model. Write `DATABASE_URL`, never what it is set to; write "the payments API", never the key that reaches it. WP-5's credential rule is about commands; this is the same rule for the trace's output, and the trace is the likelier leak because enumerating dependencies is exactly when a real value gets pasted in for concreteness.

## Test Commands
*(the project's test-scope ladder, read by every build and review gate)*
- **T1 focused:** [how a single test or one file's tests are run here]
- **T2 impacted:** [the change-aware selector this project actually has, e.g. `--testmon`, `--changedSince`, `related`, `-p <pkg>`, or "none available", which is a real and common answer]
- **T3 segment:** [each segment → its suite command + its own static gates]
  - `[segment name, e.g. backend]` : [test command] + [type check / lint for that segment only]
  - `[segment name, e.g. frontend]` : [test command] + [type check / lint for that segment only]
- **T4 full:** [the whole suite + every static gate, the command CI runs], measured wall time: [Ns]
- **Cross-segment shared paths:** [files or modules that void a scoped run when touched, beyond `/test-scope`'s standing triggers. Take these from the Impact Analysis block rather than guessing at them: "what reaches this file" and "what a change to this file invalidates a scoped test run for" are the same question, and the impact pass has already answered it]

## State & Data Contracts
*(omit only if no persisted, cached, derived, or shared state is touched)*
- **Identity & cardinality:** [what identifies a record, how many, which field]
- **Currentness:** [version/generation/timestamp mechanism, or the tolerated staleness window]
- **Authority & rebuildability:** [source of truth; each derived store + its exact rebuild command]
- **Visibility during change:** [what a concurrent reader sees mid-update; crash-window recovery mechanism]
- **Invariant enforcement:** [invariant → the storage/type-level constraint that enforces it]
- **Migration & backfill:** [preflight check, fail-closed behavior, handling of non-conforming rows]

## Failure Modes & Interactions
- **Lifetimes/expiry:** [each TTL/timeout/session and its behavior at expiry + coordination requirement]
- **Boundary error codes:** [code/exception → who handles it]
- **Lifecycle/cancellation:** [start → stop/cleanup path for each long-lived thing]
- **Cross-component interactions:** [when A changes/fails → what B must do]
- **Concurrency & aliasing:** [what races, what ordering is assumed, which objects are shared vs copied across boundaries]

## Value Paths & Seam Tests
- **[value path, e.g. worker → DB heartbeat]:** named no-mock test → [test name + what it asserts at the real seam]

## Phases

### Phase 1: [Name]
**Goal:** [One sentence]
**Files to modify/create:**
- `path/to/file`: [what changes]

**Implementation details:**
1. [Step-by-step instructions]

**Test criteria:** (each as command + expected output)
- [ ] `exact command to run` → [expected output / assertion that proves the phase is done]
- [ ] Seam test (if this phase completes a value path): `command` → [no-mock assertion across the real seam]

### Phase 2: [Name]
...

## Risks & Mitigations
- [Risk] → [Mitigation]

## Out of Scope
- [What this plan explicitly does NOT cover]

## Review Passes
*(A Rounds line, then one line per pass, in the order they ran. Each line leads with what the pass found and where the fix
landed, then says what it searched and with what. A pass that did not finish, or ran without a tool
it needed, says so here. A pass that found nothing says what it checked, because a line reading only
"nothing" looks the same as a pass that was skipped.)*
- **Rounds:** [N]; for each round after the first, what it started from and what it changed; the last one changed nothing (or: stopped at round 3 and put to the user, with the proposed split)
- **Impact:** [N] found, [N] added to phases; the detail, the type-check sweep and the storage pairs included, is in Impact Analysis
- **Consolidation:** [verdict: fewer or more ways to do each job] · [N] added to phases (extractions, retirements); the detail is in Impact Analysis, *Consolidation*
- **Removal:** [each removal → the job it did → what now does it → the test on the new path; anything with no replacement and what the user said; or "removes nothing"]
- **Logic:** [each defect found → the phase and criterion that now handle it] · walked: [the scenarios, by name]
- **Behaviour:** [each surface or user expectation that was wrong, and the fix] · surfaces walked: [N, by name] · goal: [what the owner will see when this ships]
- **Business sense:** [each defect a typical user would hit → who, what they expected → the fix; each question → who, what they expected → what the user said] · read by: [a fresh-context reviewer, or yourself from the outcome list]
- **Contracts:** [each decision that was absent, narrowed, or differing, and what the user said] · decision-document facts re-checked: [N, and any that failed] · size: [as agreed, or what the user said about the growth]
- **Proof:** [each criterion that could not fail → what replaced it] · mutation checks specified: [N] · existing tests re-pointed: [N]
- **Coherence:** [each contradiction, orphan, and stale count or summary, and what was cut or corrected]
- **Executability:** [each name that did not exist or command that did not run, and the fix]

## Amendment Log
*(append-only. One entry per change to this plan after it was approved. "None yet." until the first
amendment, and a plan still in `new/` cannot have one; edits to a draft are the draft (WP-13).
Never rewrite or remove an entry; a superseded amendment gets a later entry saying so.)*

### A1: YYYY-MM-DD; [one-line title]
- **Trigger:** [build halt at Phase N / review finding / reverted phase / user decision / discovery during the build]
- **Reported:** [what was surfaced, specifically enough that a reader can check it]
- **Change:** [which phases and sections changed, and how]
- **Decision impact:** [upholds / narrows / supersedes decision X in the decision doc, or "no decision-doc impact"]
- **Scope impact:** [what moved into or out of scope, or "none"]
```

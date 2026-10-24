# Working practices

Habits that sit alongside the lifecycle: choosing what to work on, and handling work that doesn't fit one feature.

## Task selection (`/triage`)
Resources (tokens, time, energy) decide what you pick up next; this is deliberate triage, not procrastination.
- **Low tokens or short window: pick bugs.** Small, scoped, self-contained.
- **Plentiful resources: pick features and plans.** The full cycle needs both tokens and sustained attention as a reviewer.
- **Rich context: pick work that leverages what's loaded.** Switching modules throws away context you just paid for, even when the other task ranks higher. Context thrash is the enemy.
- **Priority order within context-aligned work:** critical bugs, active plan phases, high-priority features, approved-but-unstarted plans in `new/`, low-priority bugs, new brainstorming.
- **Let plans accumulate in `docs/plans/new/`.** They're pre-invested design, not a guilt-inducing backlog. With AI-assisted work "later" means minutes or hours, so accumulating plans is staging work for rapid, parallel execution (see `multi-model.md`).

## Refactoring a monolith
Treat it as a feature: `/brainstorm` the domain boundaries, `/write-plan` one extraction per phase, build each with the normal loop. Phase boundaries matter more here than anywhere: a refactor moving six modules in one phase has no meaningful test gate and no reviewable diff; one module per phase can be stopped, reviewed and reverted at any point.

## Work nests, so keep the stack visible (AW-25)
A plan opens a gate, the gate finds a defect, the defect needs a Rework Brief, the brief raises a design question, the question needs its own decision doc and plan. Every descent is correct; what goes wrong is the stack going invisible and the session's goal being abandoned at depth four. Four habits: **restate the stack every time you surface** (original goal, current level, what each level above still owes) · **a "done" at depth N isn't a "done" at N-1** · **close a nested piece out loud, in its parent's terms** · **a gate goes stale the moment work lands under it** (say so and re-run it; citing it is the failure).

## The "no surprises" rule
A standing constraint worth putting in your agent config: *never modify code without explicit permission; propose changes one file at a time.* It costs a little velocity and buys back the ability to review what happened. An agent that edits eleven files before showing you anything has moved the review cost to the least convenient moment.

## Capture what you learn (`/learn`)
After a verified task, append the classes of mistake and the check that would have caught them to `docs/lessons.md`; owner corrections go in verbatim. Three recurrences of one rule is a signal to promote it into `AGENTS.md` or a skill.

<!-- in-depth:start -->

---

## In depth

The summary above is this repo's; where they differ, it governs. What follows is the full text.

Habits that sit alongside the lifecycle rather than inside it: choosing what to work on, and
handling work that does not fit a single feature.

---

### Task selection: bugs vs. features

Not all work is equal, and your available resources; tokens, time, mental energy; should
decide what you pick up next. This is deliberate triage, not procrastination. `/triage`
implements it.

**When tokens or context are low → pick bugs.** Bug fixes are small, well-scoped, and
self-contained. They need minimal brainstorming and usually fit in one conversation. When
your budget is thin or your window is short, bugs are the highest-value work available: they
improve the product without the planning overhead of a feature.

**When resources are plentiful → work on features and plans.** The full Brainstorm → Plan →
Build cycle consumes real tokens and demands sustained attention as a reviewer. Save it for
sessions where you have both.

**When context is rich → pick work that leverages what is already loaded.** Switching to a
task in a different module throws away the context you just paid to build, even if that task
is technically higher priority. Context thrash is the enemy.

#### Priority order, within context-aligned work

1. Critical bugs; broken functionality, data-loss risk
2. Active plan phases; work already in progress
3. High-priority features; user-requested, high impact
4. Accumulated plans in `new/`; pre-invested design work, ready to execute
5. Low-priority bugs; cosmetic, edge cases
6. New feature brainstorming; when everything else is clear

#### Let plans accumulate

Plans in `docs/plans/new/` are not a backlog to feel guilty about. They are *pre-invested
design work* waiting for the right moment. Brainstorm three in the morning, build them in the
afternoon; or next week.

The mindset shift: with AI-assisted development, "later" does not mean months. It means
minutes or hours. The gap between "plan written" and "feature shipped" has collapsed, so
accumulating plans is not deferring work; it is *staging* it for rapid, parallel execution.
Combined with the [multi-model split](multi-model.md), a planning session and a build session
can run at the same time.

---

### Refactoring a monolith

Treat refactoring as a feature; same cycle, no shortcuts:

1. Ask the agent to analyse the monolith and propose domain boundaries (`/brainstorm`).
2. Generate a phased refactoring plan (`/write-plan`), one extraction per phase.
3. Execute with the normal build loop; TDD → implement → test → self-review; for every
   single file extraction.

The phase boundaries matter more here than anywhere else. A refactor that moves six modules
in one phase has no meaningful test gate and no reviewable diff; a refactor that moves one
module per phase can be stopped, reviewed, and reverted at any point.

---

### Work nests, so keep the stack visible

Real sessions do not stay at one level. A plan opens a gate, the gate finds a defect, the defect
needs a rework brief, the brief raises a design question, and the question needs its own decision
document and plan. **Every one of those descents is correct.** It is how a problem gets solved at
the depth it actually lives at, rather than patched at the depth it was noticed.

What goes wrong is not the descent. It is that the stack goes invisible, and the goal that started
the session is quietly abandoned at depth four, because everyone involved agreed that the thing in
front of them was finished.

Four habits keep it visible:

- **Restate the stack every time you surface.** The original goal, the level you are at, and what
  is still owed at every level above it. If the owner has to ask "did we ever finish X?" about the
  thing that started the session, the stack was not visible enough.
- **A "done" at depth N is not a "done" at depth N−1.** Finishing a rework round does not finish
  the review; finishing the review does not finish the plan that spawned it; and neither of them
  archives anything.
- **Close a nested piece out loud, in its parent's terms.** Say what remains at the parent level
  before starting anything new.
- **A gate goes stale the moment work lands under it.** A completion gate run before two rework
  rounds landed proves nothing about the tree that exists now. Say it is stale and run it again;
  citing it is the failure, and `test-scope`'s citable-run rule (same tree, or no citation) is the
  mechanical form of the same fact.

---

### The "no surprises" rule

A standing constraint worth putting in your [agent config file](agent-config.md):

> **Never modify code without explicit permission. Propose changes one file at a time.**

It costs a little velocity and buys back the ability to actually review what happened. An
agent that edits eleven files before showing you anything has not saved you time; it has
moved the review cost to the least convenient moment.

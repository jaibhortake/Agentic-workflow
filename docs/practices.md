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

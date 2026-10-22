# The multi-model split

*Buy expensive reasoning once. Spend cheap execution as often as you like.*

The plan is a **file**, not a conversation, so planning and building can run on different models, tools or sessions. The frontier model spends its reasoning on intent and on checking the work against it; cheaper models do the typing in between.

## The problem it solves
Frontier reasoning is the scarcest resource: most expensive per token, first to hit a usage limit, and the thing that separates a good architecture from a mess. Most tokens a coding agent burns are mechanical (reading files, boilerplate, running the suite, fixing an import, running it again) and need a competent, fast, cheap model. The usual failure is spending frontier tokens on all of it and finishing the feature with a degraded context and a tired plan.

## Three roles (two mandatory; they may be the same model)
| Role | Does | Needs | Reasonable choices |
|---|---|---|---|
| Planning model | `/brainstorm`, `/write-plan`: explores, challenges, resolves every decision, writes the plan | deep reasoning, long context, architectural judgment | your best model |
| Build model | `/build-model` -> `/build-phase` per phase -> `/review` -> `/build-handoff` | accurate code generation, tool use, patience | a mid-tier model (e.g. Sonnet-class), or Cursor, Copilot, Gemini Flash, Codex, a local model |
| Review model (optional) | `/review` on the returning change set, then `/verify` | fresh eyes, no authorship bias | usually the planning model; occasionally a deliberately different third model |

By default the planning model also reviews and verifies; splitting the reviewer out is an upgrade, not a requirement. Pick models per role with `/models`. **Fix the plan, not the tier:** halts rise as a model's tolerance for ambiguity falls, so on a thin plan a cheaper model isn't cheaper, it just fails earlier and more honestly. A tier too weak to hold the review bar costs the rework it was meant to save. Mechanical breadth work (grep, enumerate call sites, summarise a module) goes to the cheapest subagent tier, briefed to return findings not file contents; never delegate the trade-off analysis or the plan.

## Two contracts, no shared conversation
- **Forward: the plan file** (`docs/plans/active/<feature>.md`). Exact paths, signatures, test commands with expected output, named seam tests, failure-mode analysis, and a hard rule against "choose an appropriate X". Anything ambiguous is a decision the builder makes silently at the worst moment.
- **Return: the build handoff** (`build-handoff`): plan revision built against, every halt and its resolution, every deviation, verification runs with rungs and mutation checks witnessed, unproven criteria, concerns. The user carries it back; the main model runs `/review` **again** with it as input, then `/verify`.
- **The plan is amended on the forward path, never the return path.** A halt travels back as a report; the planner amends and logs; the amended plan travels forward. The builder never edits the plan, which is what makes the final drift audit possible.

## What it costs and saves
Planning gets more expensive (thoroughness is tokens). Building gets much cheaper (the bulk-token phase leaves the frontier model). Rework nearly disappears: the expensive failure was never token spend, it was discovering in phase 4 that the data model was wrong. Plans accumulate in `docs/plans/new/` while a build session works through an earlier one, so planning and implementation velocity stop being the same number.

## Running it
1. **Plan** in the strong model: `/brainstorm`, `/write-plan`; review; on approval the plan moves to `active/`.
2. **Hand off:** a session in the build tool, `/build-model docs/plans/active/<feature>.md`. It runs every phase, reviews, emits the handoff and **stops**.
3. **Return:** paste the handoff into the planning model. It runs `/review` with it as input, loops until clean, then `/verify`, then archives the plan.
The build model needs the workflow skills installed in its environment (every skill is a plain `SKILL.md`; Claude Code, Cursor, Gemini CLI and Copilot read them). `docs/extras/driving-an-agent-as-build-model.md` is a generic recipe for driving another CLI headless.

## Expect halts, and read them correctly
The builder builds what the plan names and halts rather than inventing a way around a gap. That converts every plan gap into a halt: budget a relaunch or two and read a halt as a defect in *your plan*, not the builder underperforming. Most are front-loaded because `/build-phase` opens with a **plan review**, fresh eyes on one document before any code exists. It can't catch how a third-party library behaves at runtime; that's what a plan's gate phase is for. **Resolve a halt in the plan:** verify the report first-party, classify (plan defect, reality defect, decision-level, builder error), amend and log, hand back (`write-plan`, "When a build halt comes back"). Decision-level findings go to `/brainstorm`. Answering a halt in chat and letting the build continue is the shortcut that costs days later.

## If the build comes back badly
Past ~8 findings, findings across most phases, a repeated systemic defect, or a missing or unwired phase, `/review` emits a **Rework Brief** instead of fixing in place: a reviewer who rewrites half the feature has become its author and can no longer review it. The brief itself gets a plan's review before it leaves.

## Guardrails when models change hands
- **Read the diff you didn't write.** A revision that *removes* a constraint is the dangerous one.
- **An external review is evidence, not a verdict:** verify claims first-party; evidence is also what it takes to dismiss one (an empty grep or a dev fixture is not disproof).
- **Brief an outside reviewer; don't point it at the files.** Each of brainstorm, write-plan and review offers an outside review in one line (the read-only `outside-reviewer` agent on a model you name, or the brief from `review-lenses` to paste elsewhere). `/review` can also run two fresh readers itself: a deep read in its first round and a cheap fix check after each round's fixes. Without a brief a reviewer drifts into editing files and filing tickets, answers "do the documents agree?" when the question was "is this right?", and pads with what's fine. See `docs/review-levels.md`.
- **Never put a secret in the plan.** It's committed and read by every downstream model and tool; credentials appear as `<from env: API_KEY>`, a named source never a value.

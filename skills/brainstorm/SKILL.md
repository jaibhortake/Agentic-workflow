---
name: brainstorm
description: Explore approaches and challenge the design for a large (L) task before planning. Produces a decision doc. No code. Add "plain" for a 5-line non-technical summary.
---

# Brainstorm

No code in this phase. In Claude Code, plan mode (Shift+Tab) enforces read-only.

1. **Intent:** write the user's goal, success criteria, and out-of-scope in their words.
2. **What exists** (use `explorer` subagent; report conclusions only). Answer before proposing anything:
   - Does something already do this, fully or partly?
   - Who calls the code this touches (modules, data, APIs)?
   - Would the change **unify** pathways or add a second way to do the same job?
   - What becomes dead code if this lands?
3. **Options:** 2–4 approaches, from minimal to structural. For each: how it works, pros, cons, risk, rough size. Challenge the obvious one.
4. **Challenge:** failure modes, security, performance, migration/rollback, edge cases. For rule/logic changes, write a scenario table: case | today's result | new result. Differing rows become test cases.
5. **Interview** the user on the decisions that remain open — the hard parts (edge cases, tradeoffs, UX, failure handling), not obvious ones. Use a structured question tool if available (e.g. AskUserQuestion); keep going until nothing is open.
6. Save `docs/decisions/YYYY-MM-DD-<slug>.md`:

```
# <Title>
Intent: …
Success criteria: …
Out of scope: …
What the user sees: <behaviour before → after, from the user's side>
Existing mechanisms: <answers to step 2, one line each>
Chosen approach: … (why; rejected options in one line each)
Scenario table: <if a rule changes>
Risks + mitigations: …
Would reverse this decision: <what new fact would change the choice>
Open questions: none (all resolved before /write-plan)
```

After approval the decision doc is frozen: later changes go in the plan's Amendment Log, never edit the doc.

`/brainstorm plain` (or if the user asks for a summary): also give a 5-line plain-language recap for non-technical readers.

Next: `/write-plan`.

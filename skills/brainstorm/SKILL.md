---
name: brainstorm
description: Explore approaches and challenge the design for a large (L) task before planning. Produces a decision doc. No code.
---

# Brainstorm

No code in this phase.

1. **Intent:** write the user's goal, success criteria, and out-of-scope in their words.
2. **What exists** (use `explorer` subagent; report conclusions only):
   - Does something already do this, fully or partly?
   - Which modules, data, APIs are touched? Who calls them?
   - What conventions must the solution follow?
3. **Options:** 2–3 approaches. For each: how it works, pros, cons, risk, rough size.
4. **Challenge:** failure modes, security, performance, migration/rollback, edge cases. For rule/logic changes, write a table: case | today's result | new result. Differing rows become test cases.
5. **Ask** the user only the decisions that remain open. One short list.
6. Save `docs/decisions/YYYY-MM-DD-<slug>.md`:

```
# <Title>
Intent: …
Success criteria: …
Out of scope: …
Chosen approach: … (why; rejected options in one line each)
Risks + mitigations: …
Open questions: none (all resolved before /write-plan)
```

Next: `/write-plan`.

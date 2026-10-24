<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Resuming After External Model Execution

If the user tells you that code was written by another agent (Cursor, Copilot, a local model, etc.) or simply says "it's done" / "I've implemented Phase N" / pastes a diff:

1. **Do NOT re-implement.** The code is already written.
2. **Read the diff against the decision document, then the plan.** In that order: the plan is derived from the decision, so a change can satisfy every line of the plan and still contradict the decision that produced it, and reading the plan first is how you end up agreeing with both without ever opening the document. Anything the diff does that the decision ruled out is a halt, not a self-review note.
3. **Immediately run Step 3 (Scoped Tests)**: verify the external model's work passes tests. You did not write this diff, so read it before you pick a rung: an external model's change surface is routinely wider than its description of it, and every escalation trigger applies to code you inherited exactly as it does to code you wrote.
4. **Then run Step 4 (Self-Review)**: review the external model's code carefully. External models are more likely to have drifted from project conventions.
5. **Continue the loop** as normal; fix issues, re-test, re-review until clean.
6. **Then auto-advance** to the next phase.

The user should not have to tell you to continue the workflow. You own the process from the moment they hand you back control.

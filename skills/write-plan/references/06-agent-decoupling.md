<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Agent Decoupling: Zero Ambiguity for External Models

This plan is designed as a **contract between agents**. The agent that writes this plan does not have to be the agent that executes it; it may be a smaller model (Gemini Flash, GPT-4o-mini), a different tool (Cursor Composer, Copilot), or a local model with no conversation history.

**This means the plan must resolve ALL decisions. No open questions may remain:**

- Be explicit about file paths, function signatures, and expected behavior
- Do not rely on "context from earlier in the conversation"
- Include enough detail that the plan is self-contained
- **Never write "choose an appropriate X" or "decide whether to Y"**: make the decision in the plan. The executing agent should not have to make architectural choices.
- **Never write "consider using X or Y"**: pick one and specify it. If the choice depends on something, investigate it now and decide.
- **Specify exact function signatures, class names, and return types**: not just descriptions of what they should do.
- **Specify exact test assertions**: not just "write tests for this". Name the test functions, the inputs, and the expected outputs.
- **If a step requires a new package, name it and its version**, say which manifest it goes in, and link its official install instructions. Adding it is outside what a build may run on the plan's say-so (`/test-scope`, *What a run may execute*), so the builder asks the user first.
- **Resolve all design trade-offs in the plan itself.** The plan need not include all the code, but it MUST include all decisions. The dev model's job is to execute, not to design.

### Expect halts, and expect them to be yours

The build model is fenced in: it builds what the plan names and halts rather than inventing a way around a gap. That fence cuts both ways. It stops the model quietly amending your architecture; and it converts **every gap in your plan into a halt**.

So budget for one or two relaunches, and read a halt correctly when it arrives: it is almost always a defect in this document, not the build model underperforming. A halt reported with an accurate diagnosis and no workaround is the fence doing exactly its job, at the cheapest possible moment. The failure mode you are buying protection from is the opposite one; a model that hits your gap, routes around it inside the files you *did* name, and hands back something that passes every gate while doing the wrong thing.

That protection is only as good as the plan's file list, which is why the impact pass below is not optional: a caller you failed to name is a gap the build model will hit and must halt on.

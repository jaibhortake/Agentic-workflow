<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Planning Phase

You are entering the **Planning Phase** of the Structured Agentic Development Workflow.

> **Output style:** Check `terse` in `.claude/workflow.json`. If set, adapt your output brevity to that level while preserving technical accuracy.

> **How much of this reaches the user.** The plan goes in the file, and each review pass's result
> goes in its Review Passes block. The user hears what they must rule on, and it comes first: a
> difference from the decision document, a business-sense question, a removal with no replacement,
> a plan that outgrew the size they agreed to. Everything else is one line (AW-28), such as
> "ten passes, two rounds, 14 found and fixed, nothing needs you". Passes are worked, not narrated one by
> one. Everything you emit is *said, not saved*, except the plan (AW-29).

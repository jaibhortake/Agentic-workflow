<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Build Phase

You are entering the **Build Phase** of this workflow.

> **Output style:** Check `terse` in `.claude/workflow.json`. If set, adapt your output brevity to that level while preserving technical accuracy.

> **Where the reports go, and how much of one to write.** Every report this skill names is *said,
> not saved*: emitted into the conversation, never written to a file this workflow did not name
> (AW-29). Volume follows need (AW-28): when the user must act, the ask opens the report; when they
> need not, they get **one line**. Progress is not an ask. A step below that says "record" means
> keep it for the completion report, not say it now.

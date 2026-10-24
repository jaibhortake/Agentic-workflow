<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Brainstorm Phase

You are entering the **Brainstorm Phase** of this workflow.

> **Output style:** Check `terse` in `.claude/workflow.json`. If set, adapt your output brevity to that level while preserving technical accuracy.

> **How much of this reaches the user.** The approaches, the recommendation and the questions they
> must answer are the brainstorm; say those in full. The audit and the lenses are worked, not
> narrated: each result changes the recommendation, becomes an Open Question, or goes into the
> decision document, and the user hears one line about what changed (AW-28). Everything you emit is
> *said, not saved*, except the decision document (AW-29).

<HARD-GATE>
Do NOT write code, create plan files, scaffold projects, or take ANY implementation action during brainstorming. Code is the LAST thing we touch; not the first. This applies regardless of how simple the task seems. You are thinking, not building.

**Read-only investigation is not building.** Running a query, a version check, a probe, or an existing test to answer a question is encouraged; see BS-8 to BS-10. What is out of bounds is anything that *writes*: to the repo, to a database, to a deployed environment. The single exception is the decision document at the end.
</HARD-GATE>

# Evaluating the workflow

Check that the workflow actually beats plain prompting **on your codebase**. Re-run after changing skills.

## A/B benchmark
1. Pick 4–6 real tasks: 2×S, 2×M, 1–2×L. Include one bug fix and one change to existing code. Copy [tasks/TEMPLATE.md](tasks/TEMPLATE.md) for each.
2. For each task, write **hidden acceptance tests** first and keep them out of the agent's view.
3. Run every task twice from the same commit, each in a fresh session:
   - **A — plain:** workflow not installed, just the task prompt.
   - **B — workflow:** installed, start with `/workflow <task>`.
4. Record the results in [results.md](results.md).

## What to measure
| Metric | How |
|---|---|
| Tokens / cost | `/cost` at the end of the session |
| Hidden tests | pass count after the agent says "done" |
| Defects | bugs found in human review |
| Drift | changes nobody asked for |
| Interventions | times you had to correct or unblock it |
| Process | sized? planned? stopped on gaps? showed evidence? |

**Good result:** S tasks cost about the same as plain or less; M/L tasks pass more hidden tests and have fewer defects and less drift. If B costs more and isn't better, trim the skill that added the cost.

## Skill trigger checks
For each skill, write 2–3 prompts that should trigger it and 1–2 that shouldn't. Check that it fires and follows its steps. Automate with `claude plugin eval` or the `skill-creator` skill.

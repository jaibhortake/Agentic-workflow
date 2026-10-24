---
name: models
description: Show or change which model each workflow role uses (plan/review/build/explore). Usage /models, or /models build=sonnet review=opus explore=haiku. Any alias or full model id; "inherit" = current session model.
disable-model-invocation: true
---

# Models

Roles → where the model is set:
| Role | Set in | Default |
|---|---|---|
| plan / brainstorm | the main session (`/model` or `claude --model …`) | your choice |
| build | `.claude/agents/builder.md` `model:` | inherit |
| review | `.claude/agents/reviewer.md` `model:` | inherit |
| explore | `.claude/agents/explorer.md` `model:` | inherit |

No arguments: print the table with the current values (read the 3 frontmatter lines) and the tip below. Stop.

With `role=value` arguments:
1. Values: `inherit`, an alias (`opus`, `sonnet`, `haiku`, `fable`), or a full model id. Don't validate further: the user may have access to models you don't know.
2. For build/review/explore, edit only the `model:` line of the matching file in the **project's** `.claude/agents/`. If the agent comes from the plugin and the file doesn't exist, copy the plugin's agent file there first (project agents override plugin agents).
3. `plan=…` → tell the user to run `/model <value>`; it's a session setting.
4. Record the choice in `.claude/workflow.json` under `"models"` so teammates see it. Personal-only choice → put it in `.claude/agents/` of `~/.claude` instead and say so.

Tip to print: a strong model for plan/review and a cheaper one for build/explore usually saves the most; the plan file is what lets a cheaper builder succeed. To force one model on every subagent for a session, set env `CLAUDE_CODE_SUBAGENT_MODEL=<model>` plus `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1`.
Other tools (Cursor, Copilot, …): pick models in that tool's own settings; roles map the same way.

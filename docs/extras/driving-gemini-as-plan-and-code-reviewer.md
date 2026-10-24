# Driving Gemini CLI as the plan reviewer and code reviewer
*Launch mechanics: `driving-gemini-as-build-model.md`. Setup: `agent-cli-setup.md`. Adapted from SAW's agy reviewer guide; the behaviour notes marked (agy) were observed by SAW on Antigravity CLI with Gemini models and are worth checking for on Gemini CLI too.*

Gemini can review twice per plan: the plan review before the build model is launched (after the workflow's own plan reviews), and the code review after the build and its review, before `/verify`. Its findings are evidence, not verdicts (AW-16): confirm each one against the code before acting on it.

## Launch
Reviews are read-only, so use `--approval-mode plan`, which is documented as read-only. Run the same `jq` check after each run.

```bash
cd <repo> && gemini --approval-mode plan -o json -m <model> -p "<plan review prompt>" > <log>.json 2> <log>.err
```

For the code review you can resume the plan review's session (`--resume <uuid>`, from `gemini --list-sessions`) so it keeps that context, or start fresh. The workflow's gates start a reviewer fresh each time (`review-lenses`). A resumed reviewer remembers what it flagged and can check the build delivered it, but it may anchor on its earlier view. Start fresh where a wrong assumption costs most.

Put the tracing tools the brief asks for in your policy allowlist (the language server or type checker, `graphify query`, the project's type-check target), or the first trace stops the run.

## The prompts
Use the outside-review brief from `review-lenses` (*Handing a review to an outside model*), filled in by `/write-plan` or `/review` when you accept their offer. Start it with a short unique first line naming the run, and add:

```
Never start a background task.
For every finding, quote the exact words you rely on, with file:line.
Allowed commands, one per call, nothing else: <the exact read-only commands in your policy>.
The checked-out branch is <branch>.
```

## What stops a review run early
- **A command outside the policy.** Reviewers reach for commands you didn't expect (`git branch --show-current` to learn the branch), so list the allowed commands exactly in the prompt, and name the branch.
- **Pipes, redirection, loops and heredocs (agy).** Gemini 3.1 Pro used them in four of six of SAW's pre-build reviews even when banned by name. After two failed runs on one brief, move that review to another reviewer (`driving-claude-cli-as-reviewer.md`).
- **Directories outside the workspace.** Add them with `--include-directories` rather than letting it `cd`.
- **Quota is per model family (agy).** If one family's quota runs out mid-review, switch with `-m`.

## It can invent its citations (agy)
Asked to quote exact words with line numbers, it has quoted plan text, function names and line numbers that exist nowhere (a line 632 of a 238-line document), while being right on the substance. So require a verbatim quote plus `file:line` for every finding, and check each quote with `rg -F` before weighing the finding. Its business and logic instincts are worth reading; its citations are not evidence until checked.

## A review of a later phase reads today's code
A reviewer checking a phase that isn't built yet sees the code as it is now. Check each finding against what the earlier phases will have built (their plan text) before accepting it.

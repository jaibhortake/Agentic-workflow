# Driving Gemini CLI as the build model
*Written from the Gemini CLI docs (google-gemini/gemini-cli, `docs/cli/`) as of 2026-10; not run on this repo's machine. CLIs change, so re-check with the probes in `agent-cli-setup.md`. Google's Antigravity CLI (agy) shares `~/.gemini` but has different flags.*

Not a skill; no skill loads or runs these commands. The principles in [README.md](README.md) apply. These sections of `driving-cursor-as-build-model.md` also apply unchanged: *Safety before you launch* (never run it against a live app), *After a killed run, check for unrestored mutations*, *Reported-done is not done*, *It will sometimes work around a gap instead of halting*, *Long plans must be launched in phase batches*, *Test suites*. This file holds only what differs.

## Skills
Gemini CLI discovers workspace skills in `.gemini/skills/` or the `.agents/skills/` alias, which wins when both exist. `install.sh --tool gemini` installs to `.agents/skills/`. It also writes `GEMINI.md`, which imports `AGENTS.md`. Check with `/skills list` in an interactive session. Skills are activated by the model calling `activate_skill`, and interactively you are asked to consent. In a headless run, name the skill in the prompt (`Use the build-model skill ...`).

## Launch

```bash
cd <repo> && gemini --approval-mode auto_edit -o json -m <model> -p "<prompt>" > <log>.json 2> <log>.err
```

- `-p` / `--prompt` runs headless. Put every flag before `-p`.
- `--approval-mode auto_edit` approves file edits and nothing else. Shell commands follow your policy rules (below). `default` asks for everything, which a headless run cannot answer. `plan` is read-only. Never use `yolo` (or the deprecated `--yolo`); it approves every tool.
- `-m` / `--model` picks the model (default `auto`).
- `-o json` prints one object with `response`, `stats` (tokens, latency) and `error` when the run failed. `-o stream-json` emits `init`, `message`, `tool_use`, `tool_result`, `error` and `result` events, which is the better choice for a long build because a killed run still leaves its events.
- There is no sandbox unless you enable one, so commit everything before launching.

## The allowlist is a policy file
`--allowed-tools` is deprecated. Allow shell commands with TOML rules in `~/.gemini/policies/*.toml`. The workspace tier (`.gemini/policies/`) is documented as not yet functional, so these rules are per user:

```toml
[[rule]]
toolName = "run_shell_command"
commandPrefix = "git status"
decision = "allow"
priority = 100

[[rule]]
toolName = "run_shell_command"
commandPrefix = "git push"
decision = "deny"
priority = 900
```

`commandPrefix` matches by prefix, so no entry is truly read-only (see the starting list in `agent-cli-setup.md`). Deny the destructive git commands explicitly at high priority.

## After every run, check it actually finished
A refused tool can stop a headless run early. Before reading anything else:

```bash
jq '{error, empty: (.response == "" or .response == null), tokens: .stats}' <log>.json
```

An `error`, or an empty `response`, means the run stopped early. Read stderr and the session transcript for the refused command. Do not treat it as done.

## Resuming and batching
Sessions are per project, stored under `~/.gemini/tmp/<project_hash>/chats/`. `gemini --list-sessions` lists them, and `--resume <uuid>` resumes one. Bare `--resume` loads the most recent session, which may not be yours, so never use it for a batch. Take the UUID from `--list-sessions` right after the run, and start every batch's prompt with "re-read the plan from disk".

## Finding your run
A headless run is a `gemini` node process whose argv includes the prompt. Match on the prompt's first line, never on the process name:

```bash
ps -eo pid,etime,args | grep -F "<prompt first line>" | grep -v grep
```

## First-run prompt
Same as cursor's (`driving-cursor-as-build-model.md`, *The launch prompt*), including its "Do not commit" line. Check any commit it makes anyway for an added trailer.

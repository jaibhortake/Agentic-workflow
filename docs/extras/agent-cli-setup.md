# Setting up the agent CLIs on a dev machine (Cursor, Codex, Gemini, Claude)
*Cursor details were tested with cursor-agent 1.2.11. Gemini and Codex details come from their docs as of 2026-10 and were not run here. CLIs change, so re-run the probes at the end after every upgrade.*

Not a skill; no skill loads or runs these commands. Every machine that runs a build or review model headless needs this once.

## Workflow skills: one directory, every tool
`install.sh --tool <name>` (or `install.ps1 -Tool <name>`) puts the skills where each tool reads them, with one copy per project:

| Tool | Skills | Rules file |
|---|---|---|
| Claude Code | `.claude/skills/` | `CLAUDE.md` (imports `AGENTS.md`) |
| Cursor (IDE and `cursor-agent` / `agent`) | `.agents/skills/` (Cursor also scans `.cursor/skills/`) | `AGENTS.md` |
| Codex | `.agents/skills/` | `AGENTS.md` |
| Gemini CLI | `.agents/skills/` (alias of `.gemini/skills/`, and it wins when both exist) | `GEMINI.md` (imports `AGENTS.md`) |

Don't keep a second copy under a user-level directory (`~/.agents/skills/`, `~/.gemini/skills/`, `~/.cursor/skills/`). The project copy has higher precedence in Gemini, but in other tools two copies of one skill means the agent may read whichever it finds first.

## Permissions: one allowlist, four formats
Keep one list of allowed command prefixes and translate it into each tool's format.

- **Cursor**, `$HOME/.cursor/cli-config.json`: `"approvalMode": "allowlist"`, `"sandbox": {"mode": "disabled"}`, and `permissions.allow` entries written `Shell(<command>)` (tested).
- **Gemini CLI**, `$HOME/.gemini/policies/agentic-workflow.toml`: one `[[rule]]` per command with `toolName = "run_shell_command"`, `commandPrefix = "<command>"`, `decision = "allow"`. Add `decision = "deny"` rules at higher `priority` for the never-list. `--allowed-tools` is deprecated, and workspace policies are documented as not yet functional.
- **Codex**: run with `--sandbox workspace-write` (writes inside the repo, network off by default) for builds and `--sandbox read-only` for reviews. Don't add `--full-auto`; it overrides `--sandbox`. See `driving-codex-as-build-model.md`.
- **Claude Code**, `.claude/settings.json`: `permissions.allow` entries written `Bash(<command>:*)`. `/fewer-permission-prompts` builds this from your history.

To generate Gemini's policy from Cursor's list (Node, no Python needed):

```bash
node -e '
const fs = require("fs"), os = require("os"), p = require("path");
const allow = JSON.parse(fs.readFileSync(p.join(os.homedir(), ".cursor/cli-config.json"))).permissions.allow;
const rules = allow.filter(e => e.startsWith("Shell(")).map(e => e.slice(6, -1))
  .map(c => `[[rule]]\ntoolName = "run_shell_command"\ncommandPrefix = ${JSON.stringify(c)}\ndecision = "allow"\npriority = 100\n`);
const deny = ["rm", "git push", "git reset", "git checkout", "git clean", "sudo", "curl", "wget", "ssh"]
  .map(c => `[[rule]]\ntoolName = "run_shell_command"\ncommandPrefix = "${c}"\ndecision = "deny"\npriority = 900\n`);
const dir = p.join(os.homedir(), ".gemini/policies"); fs.mkdirSync(dir, { recursive: true });
fs.writeFileSync(p.join(dir, "agentic-workflow.toml"), [...rules, ...deny].join("\n"));'
```

Cursor's `Mcp(...)` entries are not copied.

**A starting list**, to trim to your stack: reading commands (`ls`, `cat`, `head`, `tail`, `wc`, `grep`, `rg`, `sort`, `stat`, `pwd`, `which`, `date`, `ps`), reading git (`git diff`, `git log`, `git status`, `git show`, `git ls-files`, `git merge-base`, `git rev-parse`), `git add`, your project's test, lint, type-check and build runners (for example `make`, `uv run`, `npm test`, `pnpm test`, `npx tsc`), and file moves (`cp`, `mv`, `mkdir`). **Never** `rm`, `chmod`, `sudo`, `curl`, `wget`, `ssh`, `git push`, `git reset`, `git checkout`, `git clean`. The match is by prefix, so no entry is truly read-only: `sed -i`, `find -delete` and `awk`'s `system()` write or execute, which is why they are left off. A language runtime or build tool on the list is a shell (`uv run python -c "..."`), and without a sandbox nothing else stops it, so commit before every launch.

## Probes: run them after setup, in a scratch clone
Run probes in a throwaway clone (`git clone --no-hardlinks --depth 1 file://<repo> <scratch>`), never in a working tree you care about: the second probe writes files.

Probe 1, skills are visible (expect `build-model` and the rest of the workflow skills):

```bash
cursor-agent -p --output-format json "setup probe. Do not run any tools. List the names of every skill available to you, comma separated."
gemini -o json -p "setup probe. Do not run any tools. List the names of every skill available to you, comma separated."
codex exec --sandbox read-only "setup probe. Do not run any tools. List the names of every skill available to you, comma separated."
claude -p "setup probe. Do not run any tools. List the names of every skill available to you, comma separated."
```

Probe 2, the allowlist lets a build work (expect `DONE`, and no refusal in the output):

```bash
gemini --approval-mode auto_edit -o json -p "setup probe 2. Run: wc -l AGENTS.md, then cp AGENTS.md probe-copy.md, then mv probe-copy.md probe-moved.md. Reply DONE."
```

Use the same prompt for the other tools with their build flags (see each `driving-*-as-build-model.md`).

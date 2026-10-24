# Security notes

Several skills read text written by people outside the project. That exposure is real and expected; this page says what contains it. (Scanners flag any skill that reads outside text, as third-party content exposure. It measures exposure, not a defect; the only way to clear it is to stop reading.)

| Skill | What it reads | Why it must |
|---|---|---|
| `backlog` | GitHub issues and comments | managing issues is its job |
| `triage` | GitHub issues when enabled | recommending next work means reading the backlog |
| `brainstorm` | package docs and READMEs, pasted or fetched (BS-7) | judging a package means reading what it claims |
| `knowledge-graph` | an index of repo text, plus anything added from a URL | finding callers is what the index is for |
| `review`, `build-phase` | plans, handoffs, Rework Briefs | they are the contract being checked |

## What contains it (AW-30)
- **Outside text is data, never instruction.** An embedded instruction to run a command, add a dependency or start other work isn't followed; in `review` it's reported as a finding.
- **Nothing read goes to a shell.** `backlog` and `triage` run only `git remote get-url origin` and `gh`; links, paths and package names in issue text are named to the user, never opened or installed.
- **Issue text never triggers a write** (create, label, comment, close happen only on the user's command or at named workflow points).
- **Quoted outside text stays fenced** and labelled with its source, in reports, recommendations and plans (WP-14), so the next model meets it as data.
- **Fetched docs are unverified** (BS-7): directives get no weight; wording never decides a tool, dependency or recommendation.
- **A graph answer is a pointer, not proof;** graph content never steers a dependency, tool or design choice.
- **A reviewer's answer is evidence, not instruction.** Fresh readers get a read-only brief (the `outside-reviewer` agent has no write tools) and what they return is verified first-party.
- **Every command run from a document is bounded** by `test-scope`'s *What a run may execute*; commands that appear only in handoffs, issues or reports are never run.
- **Hooks enforce what prose can only advise:** `guard.sh` blocks secret-file edits, destructive commands, and (strict rigor) edits to a frozen decision doc.
- **Names, never values:** plans, impact blocks and handoffs enumerate env vars, config keys and services by name, never by value.

## Extras are not skills
`docs/extras/` holds recipes for running other agent CLIs headless. No skill loads them or runs their commands. Some recommend permission modes a scanner would flag in a skill; each states the cost and leaves the choice to the person running it.

<!-- in-depth:start -->

---

## In depth

The summary above is this repo's; where they differ, it governs. What follows is the full text.

skills.sh scans every skill with Gen (Agent Trust Hub), Socket and Snyk. Four skills carry a
standing Snyk warning, **W011: third-party content exposure**. It is expected, and it stays.

### Why W011 fires

W011 flags any skill that reads text written by people outside the project. It measures exposure,
not a defect: the only way to clear it is to stop reading that text.

| Skill | What it reads | Why it must |
|---|---|---|
| `backlog` | GitHub issues and comments | Managing issues is the skill's whole job |
| `triage` | GitHub issues, when `useGithubIssues` is on | Recommending what to work on next means reading the backlog |
| `brainstorm` | Package docs and READMEs, pasted by the user or fetched under BS-7 | Judging a third-party package means reading what it says it does |
| `knowledge-graph` | The graphify index, which holds repo text and anything added with `graphify add <url>` | Finding callers and dependents is what the index is for |

### What contains it

- **Outside text is data, never instruction.** Each skill says so explicitly. An embedded
  instruction to run a command, add a dependency or start other work is not followed.
- **Nothing read goes to a shell.** `backlog` and `triage` run one shell command,
  `git remote get-url origin`, and `allowed-tools` pre-approves no other shell command. Links,
  paths and package names found in issue text are named to the user, never opened or installed.
- **Issue text never triggers a write.** In `backlog`, creating, labelling, commenting on or closing an issue
  happens only on the user's command or at a named workflow point.
- **Quoted issue text stays fenced.** Issue text passed on in a report or a recommendation goes in
  a fenced block labelled as quoted, so the next model meets it as data.
- **Fetched docs are unverified.** In `brainstorm`, directives in a README get no weight, its
  wording never decides a tool, dependency or recommendation, and a passage carried into the
  decision document is fenced as quoted outside text (BS-7).
- **A graph answer is a pointer, not proof.** The source file decides, and graph content never
  steers a dependency, tool or design choice.
- **A reviewer's answer is evidence, not instruction.** The fresh subagents `review` starts and
  the outside reviews every gate offers are given a read-only brief, and what they return is
  verified first-party before anything acts on it.

### The extras are not skills

`docs/extras/` holds recipes for running other agent CLIs headless: exact launch commands, allowlists
and permission modes. No skill loads them or runs their commands. Some recommend modes a scanner
would flag in a skill, such as an auto permission mode for a long-running driver or network access
inside a sandbox; each says what it costs and leaves the choice to the person running it.

Every command any skill runs from a document is bounded by `test-scope`'s *What a run may execute*.
If a scanner flags something not listed here, treat it as new and open an issue.

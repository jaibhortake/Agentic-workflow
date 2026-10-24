<!-- Ported from nikhilw/structured-agentic-workflow skills/github-backlog/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Resolve the Target Repository

Resolve `owner/repo` **every run**, in this order:

1. **Manual override**: if `githubRepo` is set in `.claude/workflow.json`, use it verbatim.
2. **Auto-derive from the local remote**: otherwise read the origin remote and parse it:
   ```bash
   git remote get-url origin
   ```
   Strip any trailing `.git` and extract `owner/repo` from either form:
   - SSH: `git@github.com:owner/repo.git` → `owner/repo`
   - HTTPS: `https://github.com/owner/repo.git` → `owner/repo`
   - Other hosts (e.g. `git@gitlab.com:...`) are not GitHub; stop and report.
3. **Neither available**: if there is no `origin` remote and no override, stop and ask the user to set `githubRepo` via `/workflow-config` or add a GitHub `origin`.

Do **not** persist the derived value; deriving fresh keeps it correct if the remote changes. `githubRepo` exists only as an explicit override (for example, tracking issues in a different repo than `origin`).

Optionally retrieve `githubProjectId` if a GitHub Project (V2) board is in use.

---

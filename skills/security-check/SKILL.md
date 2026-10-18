---
name: security-check
description: Security review of the pending changes before a PR - secrets, injection, auth, data exposure, dependencies. Stack-agnostic.
---

# Security check

Scope: the diff against the base branch plus uncommitted changes (no base or commits yet: all changed files), and any new dependencies. In Claude Code you can also run the built-in `/security-review`.

Check:
- **Secrets:** keys, tokens, passwords, connection strings in code, config, tests, logs. `.env` files not committed.
- **Input:** all external input validated; no string-built SQL/shell/HTML/paths (injection, XSS, path traversal, SSRF).
- **AuthN/AuthZ:** every new endpoint/action checks who the caller is and what they may do; no IDOR.
- **Data:** no sensitive/personal data in logs, errors or responses; least data returned.
- **Dependencies:** new packages are needed, maintained and pinned; run the stack's audit tool (`npm audit`, `pip-audit`, `cargo audit`, etc.).
- **Config:** safe defaults, debug off, CORS/CSP/cookies sane, rate limits on sensitive actions.
- **Failure:** errors don't leak stack traces; fails closed.

Output: `severity — file:line — issue — fix`. Blockers must be fixed before the PR. Write "No issues found" only if you actually checked every item above.

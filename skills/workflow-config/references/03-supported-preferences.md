<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Supported Preferences

### Testing Methodology
- **TDD** (default); Test-Driven Development. Red-Green-Refactor cycle via `/test-driven-development`.
- **BDD**: Behavior-Driven Development. Given-When-Then scenarios, feature files. When BDD is active, the build phase uses BDD-style test specifications instead of unit-first TDD.

Only one can be active at a time. Setting one disables the other.

### Output Style: terse Compatibility
- **terse off** (default); Normal verbose output from all workflow phases.
- **terse lite**: Shorter prose. Cut filler sentences, keep all technical detail.
- **terse full**: Terse. Bullet points over paragraphs. Minimal preamble. All technical accuracy preserved.
- **terse ultra**: Maximum compression. Sentence fragments. Only essential information.

When terse is enabled, every workflow skill that checks `terse` in `.claude/workflow.json` adapts its output to the requested brevity level; the vendored superpowers skills do not read it. Technical accuracy is never sacrificed; only prose style changes.

**Important:** This workflow does NOT bundle or vendor the terse skills package. If the user wants terse to also govern the agent's output outside of workflow skills, they should install the terse package separately, from its own source. The workflow's terse compatibility works independently: it adapts workflow skill output regardless of whether the terse package is installed.

### GitHub Issues Integration
- **use-github-issues false** (default); Use local files (`features.md`, `bugs.md`, or under `docs/plans/active/`) for tracking backlog. GitHub integration is disabled.
- **use-github-issues true**: Enable GitHub integration to track backlog via GitHub Issues and Projects through a GitHub MCP server. The target repository is auto-derived from the local `origin` remote, so no further configuration is required for the common case.

Optional GitHub keys (only set when you need to override the defaults):
- **workflow-config:github-repo**: Override the repository, in `owner/repo` format (e.g., `owner/repo`). Leave unset to auto-derive from `git remote get-url origin`. Useful when issues live in a different repo than `origin`.
- **workflow-config:github-project-id**: The number or ID of a GitHub Project (V2) board to sync cards to.

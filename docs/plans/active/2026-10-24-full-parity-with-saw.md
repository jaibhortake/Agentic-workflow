# Plan: Full-depth parity with structured-agentic-workflow (SAW) + extras

Decision doc: `docs/decisions/2026-10-24-full-parity-with-saw.md`. Size L, rigor strict.
Source of truth for SAW: `github.com/nikhilw/structured-agentic-workflow` at the commit cloned on 2026-10-24 (record the hash in commit 1).

## Summary
Bring every skill and doc up to SAW's full depth without dropping any of our additions, and keep our short command names with a published map to SAW's. Then add three things: one installer for Claude, Cursor, Codex and Gemini; hooks enforcing the plan gate and an append-only Amendment Log; and an eval comparing the compact skills against the full ones.

## Name map (goes into README)
| Ours | SAW | Note |
|---|---|---|
| `/workflow` | `agentic-workflow` | ours is user-invocable and adds S/M/L sizing |
| `/review` | `/3p-review` | + `deep-audits.md` |
| `/verify` | `/verify-completion` | |
| `/build-handoff` | `/handoff-summary` | |
| `/backlog` | `/github-backlog` | |
| `/debug` | `/systematic-debugging` (superpowers) | thin entry: loads vendored skill + our regression-test rule |
| TDD in `/build-phase` | `/test-driven-development` (superpowers) | vendored |
| `/brainstorm` `/write-plan` `/build-phase` `/build-model` `/triage` `/compact-brief` `/decision-summary` `/workflow-config` `/existing-mechanisms` `/review-lenses` `/test-scope` `/knowledge-graph` | same | |
| `/handoff` `/learn` `/terse` `/pr` `/security-check` `/models` `/setup-project` | (none) | ours |

## Gap ledger (measured; words SAW → ours)
write-plan 17.2k → 5.9k · review 8.7k → 4.5k · brainstorm 7.3k → 3.8k · existing-mechanisms 6.6k → 2.4k · build-phase 5.5k → 3.4k · verify 5.3k → 3.7k · review-lenses 5.0k → 3.2k · test-scope 1.9k → 1.5k · build-model 1.8k → 1.3k · backlog 1.3k → 0.7k · build-handoff 1.0k → 0.8k. Section headings match almost one-to-one. The losses are inside sections. Biggest: write-plan rules, plan structure, impact pass, executability pass, halt-return; brainstorm approaches and decision audit; review rework brief and fresh readers; verify red flags, rationalization and key-pattern tables; existing-mechanisms questions, trace axes, second sweep.
Docs missing entirely: workflow.md (lifecycle diagram), philosophy, installation, configuration, agent-config, comparison, and per-tool extras. Also missing: SAW's repo-maintenance rules (the "review your own change" eight lenses), which go to `CONTRIBUTING.md` because our `AGENTS.md` is installed into users' projects.

## Method (applies to every port phase)
1. For each skill, read SAW's text section by section beside ours. Every SAW sentence ends up in one of three places: (a) already in ours with the same meaning, (b) added to SKILL.md because it is a binding step, check or template, or (c) added to `references/<topic>.md` because it is rationale or examples. Nothing is dropped. Where SAW conflicts with one of our additions (S/M/L, rigor, `docs/plans/active/`, `docs/decisions/`, terse), ours wins and the SKILL.md says so in one line.
2. SKILL.md names each reference at the step that needs it ("before pass 1, read references/impact-pass.md").
3. Substitute our names, paths and config throughout (`active/` not `plans/`, `docs/decisions/` not `docs/discussions/`, `terse` not caveman, `.claude/workflow.json` keys).
4. Rule tags stay identical to SAW's (AW/WP/BS/RL); AW-30 stays ours.

## Phases

### Phase 1: Vendor superpowers
- `pull-superpowers.sh` + `pull-superpowers.ps1`: fetch `test-driven-development` and `systematic-debugging` (with their supporting .md files) from obra/superpowers and copy them to `skills/<name>/`, **committed** (not gitignored like SAW's `vendor/`), because the Claude plugin installs from git and would otherwise ship without them. Strip `superpowers:` prefixes, rewrite `verification-before-completion` to `/verify`, keep a `RETIRED_SKILLS` list, and write `skills/<name>/LICENSE` (MIT, Jesse Vincent) plus the source commit hash. Never hand-edit those two folders; re-run the script.
- `/debug` becomes the entry point: it runs vendored `systematic-debugging`, then our rule that every fix gets a regression test, then `/verify`.
- Installers already copy all of `skills/`, so no installer change. NOTICE.md updated.
- Proof: run both scripts; vendored files exist; grep shows no `superpowers:` prefix left.

### Phase 2: Planning skills: `write-plan`, `brainstorm`, `decision-summary`, `compact-brief`
### Phase 3: Build skills: `build-phase`, `build-model`, `build-handoff`, `handoff`
### Phase 4: Review and verify: `review` (+ deep-audits), `verify`
### Phase 5: References and the rest: `existing-mechanisms`, `review-lenses`, `test-scope`, `knowledge-graph`, `triage`, `backlog`, `workflow-config`, `workflow`
Phases 2-5 each follow the Method. Proof per phase: the scratch checker (below) passes, and a word count shows each skill (SKILL.md + references) at or above SAW's.

### Phase 6: Docs
- Port at full depth: `docs/workflow.md` (mermaid lifecycle), `philosophy.md`, `installation.md`, `configuration.md`, `agent-config.md`, `comparison.md`; expand `multi-model.md`, `practices.md`, `security.md`.
- Per-tool extras for the four primary tools: Claude CLI (phase driver, reviewer), Codex (build model), Cursor (build model), Gemini CLI (build model, plan/code reviewer, from SAW's agy guides), plus `agent-cli-setup.md`. Replace the generic `driving-an-agent-as-build-model.md` (its content is merged into these; grep confirms no remaining links).
- `CONTRIBUTING.md`: SAW's repo-maintenance rules (eight self-review lenses, conventions, docs layout, invariants).
- README: name map, docs index, highlights, updated hook list. AGENTS.md command list. plugin.json version 2.0.0. Keep README short.
- Proof: mermaid renders (`npx -y -p @mermaid-js/mermaid-cli mmdc`), all relative links resolve.

### Phase 7: Stronger safety locks (TDD: hook tests first)
- `hooks/plan-gate.sh`: on Edit/Write to a source file, block when `.claude/workflow.json` has `"planGate": true` and `docs/plans/active/` is empty, unless the change is S (signalled by the agent writing `docs/plans/.s-task` with a one-line reason, which `/verify` deletes). Docs, tests, plans and config are always allowed. The marker is the agent declaring S in writing, not a security boundary; its value is the audit trail. Default `true` in the template.
- `hooks/amendment-guard.sh`: on Edit/Write to `docs/plans/active/*.md`, block any change that deletes or alters an existing `### A<n>` entry under `## Amendment Log`, or removes the section. Appending entries is allowed, and so is editing the plan body: SAW's halt-return (WP-13, step 4) edits the affected phases and then appends the entry. A body edit with no new log entry gets a warning, not a block (a hook can't tell an amendment from a typo fix).
- Wire both in `hooks/hooks.json` and `templates/settings.json`.
- `tests/hooks/run.sh`: fixture-based tests feeding real JSON payloads to each hook (allowed and blocked cases), including the existing `guard.sh`. Ported to run on Git Bash on Windows.
- Proof: `bash tests/hooks/run.sh`, all pass; each test shown failing before its hook exists.

### Phase 8: Works in every tool
- `install.sh --tool claude|cursor|codex|gemini|all` and matching `install.ps1 -Tool`. One source (`skills/`), with generated outputs:
  - claude: today's `.claude/` layout and plugin (unchanged).
  - cursor: `.cursor/rules/agentic-workflow.mdc` (AGENTS core rules) + `.cursor/skills/` copies.
  - codex: `AGENTS.md` block + `.agents/skills/`.
  - gemini: `GEMINI.md` importing AGENTS.md + `.gemini/commands/*.toml` that point to each skill file.
- Hooks are Claude-only; the docs say so per tool.
- Proof: install into four temp dirs (one per tool) on both installers; assert the expected files exist; re-run is idempotent.

### Phase 9: Prove it works better
- Use `evals/tasks/PLANTED-BUGS.md`. Run the same review task headless against (A) the compact skills at commit `361ab56` and (B) the new skills, 3 runs each, same model.
- Record bugs found, false positives, tokens and wall time in `evals/results.md`. Report the result as it comes out, including if B does not beat A.
- Proof: raw run logs referenced; counts in the table.

## Removal table
| Removed | Replaced by | Check |
|---|---|---|
| hand-written `/debug` body | vendored `systematic-debugging` + our regression-test rule in `/debug` | the regression-test rule is still in `/debug` |
| `docs/extras/driving-an-agent-as-build-model.md` | the four per-tool guides | grep for links = 0 |
| `docs/review-levels.md` | stays, merged with SAW's `review-levels-and-who-runs-them.md` | |

## Test commands
- Hooks: `bash tests/hooks/run.sh` (T4 = whole repo suite; it is the only suite).
- Consistency: scratch checker in the session scratchpad (not committed): rule tags resolve, counts and orders agree, fences balance, frontmatter parses, every `references/` file named by a SKILL.md exists and every one exists only when named, no em dash in new text, name-map rows match real skill folders.

## Risks and mitigations
- Skills get bigger. Mitigation: the split; the eval measures the cost.
- The plan gate annoys people on S tasks. Mitigation: the `.s-task` escape and the `planGate` toggle.
- SAW keeps changing. Mitigation: record the source commit; `pull`-style re-sync is a later task.
- Generated Cursor, Codex and Gemini formats may change. Mitigation: per-tool docs link to each vendor's format doc.

## Commits
One commit per phase, straight to `main` (owner's choice), each pushed only after its proof passes and you confirm the push.

## Review Passes
Rounds: 2 (round 2 changed nothing).
1. Impact: the plugin installs from git, so a gitignored vendor dir would not ship; vendored skills are now committed under `skills/`. README hook list, AGENTS.md command list and plugin.json version added to Phase 6. Searched README, AGENTS.md, hooks, installers.
2. Consolidation: `/debug` plus vendored `systematic-debugging` would be two debug paths; `/debug` is now a thin entry over the vendored one. The generic build-model guide is replaced, not duplicated.
3. Removal: the table covers all three removals; nothing else is deleted.
4. Logic: the amendment guard as first written blocked SAW's own amendment step (body edit plus log entry); narrowed to the log entries. Plan gate walked through S, M, `/build-model` and brainstorm flows; all clear with the marker.
5. Behaviour: every command name is kept; the name map is the only new thing to read.
6. Business sense: plan gate defaulting on may irritate on S tasks; the marker costs one line and the toggle exists. The eval reports honestly even if full depth loses.
7. Contracts: matches the decision doc's quotes; size L as agreed.
8. Proof: hook tests use real JSON payloads and are shown failing first; the scratch checker is proven to catch a planted break before use.
9. Coherence: phases build in order (vendor before the `/debug` rewrite, skills before the docs describing them, hooks before the installers wiring them).
10. Executability: Phase 9 needs headless `claude -p`; checked at phase start, halt if unavailable.

## Amendment Log
### A1 - 2026-10-24 - Phases 2-5 land as one commit
Phases 2-5 were done by one mechanical port (SAW sections into `references/`, plus an index in each SKILL.md), so they ship as one commit instead of four. Content and proof are unchanged: the scratch checker passes, and every skill's references hold at least SAW's word count. Found while building; this is about packaging, not intent, so the decision doc is untouched.

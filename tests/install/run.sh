#!/usr/bin/env bash
# Installer tests: run install.sh (and install.ps1 when PowerShell exists) into temp projects per tool,
# assert the expected files, then re-run and assert nothing duplicates.
# Usage: bash tests/install/run.sh   (exit 0 = all pass)
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
pass=0; fail=0
ok()  { pass=$((pass+1)); }
bad() { fail=$((fail+1)); echo "FAIL [$INST $TOOL] $1"; }
has()  { [ -e "$D/$1" ] && ok || bad "missing $1"; }
hasnt(){ [ ! -e "$D/$1" ] && ok || bad "unexpected $1"; }
count(){ local n; n=$(grep -cF -- "$2" "$D/$1" 2>/dev/null); [ "${n:-0}" = "$3" ] && ok || bad "$1 has '$2' x${n:-0}, want $3"; }

PS=""; command -v powershell.exe >/dev/null 2>&1 && PS=powershell.exe; command -v pwsh >/dev/null 2>&1 && PS=pwsh
run_install() {
  if [ "$INST" = sh ]; then bash "$ROOT/install.sh" "$D" --tool "$TOOL" >/dev/null 2>"$D.err"
  else "$PS" -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ROOT/install.ps1" 2>/dev/null || echo "$ROOT/install.ps1")" \
         -Project "$(cygpath -w "$D" 2>/dev/null || echo "$D")" -Tool "$TOOL" >/dev/null 2>"$D.err"; fi
}

for INST in sh ps; do
  [ "$INST" = ps ] && [ -z "$PS" ] && { echo "skip: no PowerShell"; continue; }
  for TOOL in claude cursor codex gemini all "cursor,gemini"; do
    D="$(mktemp -d)"
    run_install || bad "installer exited non-zero: $(head -c 300 "$D.err")"
    run_install || bad "re-run exited non-zero: $(head -c 300 "$D.err")"
    # common to every tool
    has .claude/workflow.json; has docs/plans/active/.gitkeep; has docs/decisions/.gitkeep
    count AGENTS.md "<!-- agentic-workflow -->" 2
    count .gitignore "docs/plans/.s-task" 1
    case ",$TOOL," in *,claude,*|*,all,*) want_claude=1 ;; *) want_claude=0 ;; esac
    case ",$TOOL," in *,cursor,*|*,codex,*|*,gemini,*|*,all,*) want_agents=1 ;; *) want_agents=0 ;; esac
    case ",$TOOL," in *,gemini,*|*,all,*) want_gemini=1 ;; *) want_gemini=0 ;; esac
    if [ $want_claude = 1 ]; then
      has .claude/skills/workflow/SKILL.md; has .claude/skills/write-plan/references/03-rules.md
      has .claude/skills/systematic-debugging/SKILL.md; has .claude/hooks/plan-gate.sh
      has .claude/agents/builder.md; has .claude/settings.json; count CLAUDE.md "@AGENTS.md" 1
    else
      hasnt .claude/skills; hasnt .claude/hooks; hasnt CLAUDE.md
    fi
    if [ $want_agents = 1 ]; then
      has .agents/skills/workflow/SKILL.md; has .agents/skills/verify/references/03-the-iron-law.md
      has .agents/skills/test-driven-development/SKILL.md
    else hasnt .agents; fi
    if [ $want_gemini = 1 ]; then count GEMINI.md "@AGENTS.md" 1; else hasnt GEMINI.md; fi
    rm -rf "$D" "$D.err"
  done
  # an existing GEMINI.md keeps its content and gains the import once
  TOOL=gemini; D="$(mktemp -d)"; printf 'My notes\n' > "$D/GEMINI.md"
  run_install; run_install; count GEMINI.md "@AGENTS.md" 1; count GEMINI.md "My notes" 1; rm -rf "$D" "$D.err"
  # a bad tool name fails
  TOOL=vim; D="$(mktemp -d)"; if run_install; then bad "accepted --tool vim"; else ok; fi; rm -rf "$D" "$D.err"
done

echo "install: $pass passed, $fail failed"
[ "$fail" -eq 0 ]

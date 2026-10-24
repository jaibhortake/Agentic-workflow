#!/usr/bin/env bash
# Hook tests: feed real PreToolUse JSON payloads to each hook in a temp project, assert the exit code.
# Usage: bash tests/hooks/run.sh   (exit 0 = all pass)
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOOKS="$ROOT/hooks"
pass=0; fail=0

# A fresh temp project per test group; hooks run with cwd = project root, as in Claude Code.
new_project() {
  P="$(mktemp -d)"; mkdir -p "$P/.claude" "$P/docs/plans/new" "$P/docs/plans/active" "$P/docs/plans/done" "$P/docs/decisions" "$P/src" "$P/tests"
  printf '{ "rigor": "standard", "planGate": %s }\n' "${1:-true}" > "$P/.claude/workflow.json"
}
# json-escape a string (newlines, quotes, backslashes, tabs)
esc() { node -e 'process.stdout.write(JSON.stringify(require("fs").readFileSync(0,"utf8")).slice(1,-1))'; }
edit_payload()  { printf '{"tool_name":"Edit","tool_input":{"file_path":"%s","old_string":"%s","new_string":"%s"}}' "$1" "$(printf '%s' "$2" | esc)" "$(printf '%s' "$3" | esc)"; }
write_payload() { printf '{"tool_name":"Write","tool_input":{"file_path":"%s","content":"%s"}}' "$1" "$(printf '%s' "$2" | esc)"; }
bash_payload()  { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }

# expect <name> <hook> <want-exit> <payload>
expect() {
  local got; (cd "$P" && printf '%s' "$4" | bash "$HOOKS/$2" >/dev/null 2>"$P/.err"); got=$?
  if [ "$got" = "$3" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL $1: want $3 got $got ($(head -c 200 "$P/.err"))"; fi
}

# ---------- plan-gate.sh ----------
new_project true
expect "gate blocks src edit with no active plan"        plan-gate.sh 2 "$(write_payload "$P/src/app.js" 'x')"
expect "gate blocks relative src path too"               plan-gate.sh 2 "$(edit_payload "src/app.js" 'a' 'b')"
expect "gate allows docs"                                plan-gate.sh 0 "$(write_payload "$P/docs/notes.md" 'x')"
expect "gate allows a plan in new/"                      plan-gate.sh 0 "$(write_payload "$P/docs/plans/new/p.md" 'x')"
expect "gate allows tests dir"                           plan-gate.sh 0 "$(write_payload "$P/tests/app.test.js" 'x')"
expect "gate allows a *.test.* file beside source"       plan-gate.sh 0 "$(write_payload "$P/src/app.test.ts" 'x')"
expect "gate allows *_test.go"                           plan-gate.sh 0 "$(write_payload "$P/src/app_test.go" 'x')"
expect "gate allows root config"                         plan-gate.sh 0 "$(write_payload "$P/package.json" 'x')"
expect "gate allows .claude/"                            plan-gate.sh 0 "$(write_payload "$P/.claude/workflow.json" 'x')"
expect "gate allows README"                              plan-gate.sh 0 "$(write_payload "$P/README.md" 'x')"
expect "gate ignores Bash"                               plan-gate.sh 0 "$(bash_payload 'ls')"
expect "gate allows the S marker itself"                 plan-gate.sh 0 "$(write_payload "$P/docs/plans/.s-task" 'S: typo fix')"
printf 'S: rename one label\n' > "$P/docs/plans/.s-task"
expect "gate allows src with S marker"                   plan-gate.sh 0 "$(write_payload "$P/src/app.js" 'x')"
: > "$P/docs/plans/.s-task"
expect "gate blocks src with an empty S marker"          plan-gate.sh 2 "$(write_payload "$P/src/app.js" 'x')"
rm "$P/docs/plans/.s-task"
printf '# Plan\n' > "$P/docs/plans/active/p.md"
expect "gate allows src with an active plan"             plan-gate.sh 0 "$(write_payload "$P/src/app.js" 'x')"
rm -rf "$P"
new_project false
expect "gate off when planGate false"                    plan-gate.sh 0 "$(write_payload "$P/src/app.js" 'x')"
rm -rf "$P"
P="$(mktemp -d)"
expect "gate off with no workflow.json"                  plan-gate.sh 0 "$(write_payload "$P/src/app.js" 'x')"
rm -rf "$P"

# ---------- amendment-guard.sh ----------
new_project true
PLAN="$P/docs/plans/active/p.md"
BODY=$'# Plan: X\n\n## Phases\nPhase 1: do A\n\n## Amendment Log\n### A1 - 2026-10-01 - first\nChanged A to B.\n'
printf '%s' "$BODY" > "$PLAN"
expect "amend allows body edit"                          amendment-guard.sh 0 "$(edit_payload "$PLAN" 'Phase 1: do A' 'Phase 1: do B')"
expect "amend allows appending an entry"                 amendment-guard.sh 0 "$(edit_payload "$PLAN" 'Changed A to B.' $'Changed A to B.\n### A2 - 2026-10-02 - second\nMore.')"
expect "amend blocks editing an entry"                   amendment-guard.sh 2 "$(edit_payload "$PLAN" 'Changed A to B.' 'Changed A to C.')"
expect "amend blocks deleting an entry heading"          amendment-guard.sh 2 "$(edit_payload "$PLAN" '### A1 - 2026-10-01 - first' '')"
expect "amend blocks removing the section heading"       amendment-guard.sh 2 "$(edit_payload "$PLAN" '## Amendment Log' '## Notes')"
expect "amend allows Write keeping entries + appending"  amendment-guard.sh 0 "$(write_payload "$PLAN" "${BODY/do A/do B}"$'### A2 - 2026-10-02 - second\nMore.\n')"
expect "amend blocks Write that rewrites an entry"       amendment-guard.sh 2 "$(write_payload "$PLAN" "${BODY/Changed A to B./Changed A to Z.}")"
expect "amend blocks Write that drops the log"           amendment-guard.sh 2 "$(write_payload "$PLAN" $'# Plan: X\n\nPhase 1: do A\n')"
expect "amend ignores plans in new/"                     amendment-guard.sh 0 "$(edit_payload "$P/docs/plans/new/q.md" '### A1' '')"
expect "amend ignores other files"                       amendment-guard.sh 0 "$(edit_payload "$P/src/a.js" '### A1' '')"
printf '# Plan\n\n## Amendment Log\nNone yet.\n' > "$PLAN"
expect "amend allows replacing None yet with A1"         amendment-guard.sh 0 "$(edit_payload "$PLAN" 'None yet.' $'### A1 - 2026-10-03 - first\nX.')"
expect "amend allows a new active plan file"             amendment-guard.sh 0 "$(write_payload "$P/docs/plans/active/new.md" $'# Plan\n## Amendment Log\nNone yet.\n')"
rm -rf "$P"

# ---------- Windows-style paths (only where cygpath exists, i.e. Git Bash) ----------
if command -v cygpath >/dev/null 2>&1; then
  new_project true
  WIN="$(cygpath -w "$P" | sed 's#\\#\\\\#g')"   # JSON-escaped backslashes, as Claude Code sends them
  expect "gate blocks a Windows src path"                plan-gate.sh 2 "$(write_payload "$WIN\\\\src\\\\app.js" 'x')"
  expect "gate allows a Windows docs path"               plan-gate.sh 0 "$(write_payload "$WIN\\\\docs\\\\a.md" 'x')"
  printf '%s' $'# P\n## Amendment Log\n### A1 - d - t\nKeep.\n' > "$P/docs/plans/active/p.md"
  expect "amend blocks via a Windows path"               amendment-guard.sh 2 "$(edit_payload "$WIN\\\\docs\\\\plans\\\\active\\\\p.md" 'Keep.' 'Gone.')"
  rm -rf "$P"
fi

# ---------- guard.sh (existing) ----------
new_project true
expect "guard blocks .env"                               guard.sh 2 "$(write_payload "$P/.env" 'X=1')"
expect "guard allows .env.example"                       guard.sh 0 "$(write_payload "$P/.env.example" 'X=')"
expect "guard blocks force push"                         guard.sh 2 "$(bash_payload 'git push --force origin main')"
expect "guard blocks reset --hard"                       guard.sh 2 "$(bash_payload 'git reset --hard HEAD~1')"
expect "guard allows git status"                         guard.sh 0 "$(bash_payload 'git status')"
expect "guard allows src edit"                           guard.sh 0 "$(write_payload "$P/src/a.js" 'x')"
rm -rf "$P"

echo "hooks: $pass passed, $fail failed"
[ "$fail" -eq 0 ]

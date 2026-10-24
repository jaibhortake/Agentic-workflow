#!/usr/bin/env bash
# PreToolUse hook: no source edits without an approved plan (docs/plans/active/*.md),
# unless the task is declared S in docs/plans/.s-task. Enabled by "planGate": true in .claude/workflow.json.
# Docs, tests, plans, config and dotfiles are always allowed. Exit 2 = block; stderr is shown to the agent.
input="$(cat)"
grep -qE '"planGate"[[:space:]]*:[[:space:]]*true' .claude/workflow.json 2>/dev/null || exit 0

path="$(echo "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -z "$path" ] && exit 0

# Make the path relative to the project root (cwd), on POSIX and Windows (Git Bash) alike.
rel="$(printf '%s' "$path" | sed 's#\\\\#/#g; s#\\#/#g')"
for root in "$(pwd -W 2>/dev/null)" "$(pwd)"; do
  [ -z "$root" ] && continue
  root="${root%/}/"
  lower_rel="$(printf '%s' "$rel" | tr 'A-Z' 'a-z')"; lower_root="$(printf '%s' "$root" | tr 'A-Z' 'a-z')"
  case "$lower_rel" in "$lower_root"*) rel="${rel:${#root}}"; break ;; esac
done
rel="${rel#./}"
base="${rel##*/}"

case "$rel" in
  docs/*|.claude/*|.github/*|.cursor/*|.gemini/*|.agents/*|.vscode/*) exit 0 ;;
  test/*|tests/*|spec/*|specs/*|*/test/*|*/tests/*|*/spec/*|*/__tests__/*|e2e/*|*/e2e/*) exit 0 ;;
esac
case "$base" in
  *.md|*.mdx|*.txt|*.rst) exit 0 ;;
  *.test.*|*.spec.*|*_test.*|test_*.*|*Test.java|*Tests.cs|*_spec.rb) exit 0 ;;
  .*) exit 0 ;;
esac
# Root-level config files (package.json, pyproject.toml, tsconfig.json, ...).
case "$rel" in */*) ;; *.json|*.toml|*.ya?ml|*.yaml|*.yml|*.ini|*.cfg|*.lock|Makefile|Dockerfile) exit 0 ;; esac

ls docs/plans/active/*.md >/dev/null 2>&1 && exit 0
[ -s docs/plans/.s-task ] && exit 0

cat >&2 <<EOF
Blocked: '$rel' is source code and there is no approved plan in docs/plans/active/.
- If this is an S task (at most 2 source files, clear complete spec, no schema/API/auth change), write a one-line reason to docs/plans/.s-task (e.g. "S: fix null check in parseDate") and retry. /verify removes it.
- Otherwise size it with /workflow and get a plan approved first.
EOF
exit 2

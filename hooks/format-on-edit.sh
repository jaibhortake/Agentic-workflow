#!/usr/bin/env bash
# PostToolUse hook: format the edited file with .claude/workflow.json -> "formatCommand" ({file} = path).
# Empty = off. Never blocks: formatting problems are reported, not fatal.
input="$(cat)"
cfg=".claude/workflow.json"
[ -f "$cfg" ] || exit 0
cmd="$(sed -n 's/.*"formatCommand"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' "$cfg" | head -1)"
[ -n "$cmd" ] || exit 0
file="$(echo "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -n "$file" ] && [ -f "$file" ] || exit 0
q="'${file//\'/\'\\\'\'}'"
bash -c "${cmd//\{file\}/$q}" >/dev/null 2>&1 || echo "format failed for $file (ignored)" >&2
exit 0

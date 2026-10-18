#!/usr/bin/env bash
# Stop hook: if code changed this session, run the project's test command before the agent may finish.
# Command comes from .claude/workflow.json -> "testCommand" (set by /setup-project). Empty = skip.
input="$(cat)"
# Prevent loops: if we already blocked once, let it stop.
echo "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

cfg=".claude/workflow.json"
[ -f "$cfg" ] || exit 0
cmd="$(sed -n 's/.*"testCommand"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' "$cfg" | head -1)"
[ -n "$cmd" ] || exit 0

# Only when there are uncommitted code changes (skip pure docs/plans edits).
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
changed="$(git status --porcelain | awk '{print $NF}' | grep -vE '\.(md|txt)$|^docs/' || true)"
[ -n "$changed" ] || exit 0

if out="$(bash -c "$cmd" 2>&1)"; then
  exit 0
fi
{
  echo "Tests failed — not done yet. Fix before finishing (or explain why to the user)."
  echo "Command: $cmd"
  echo "$out" | tail -30
} >&2
exit 2

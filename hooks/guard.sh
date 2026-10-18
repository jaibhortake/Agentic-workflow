#!/usr/bin/env bash
# PreToolUse hook: block edits to secret files and dangerous shell commands.
# Exit 2 = block; stderr is shown to the agent.
input="$(cat)"

path="$(echo "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
if [ -n "$path" ] && echo "$path" | grep -qiE '(^|[\\/])\.env($|\.)|\.pem$|\.key$|id_rsa|id_ed25519|credentials|secrets?\.(json|ya?ml)$'; then
  case "$path" in *.env.example|*.env.sample|*.env.template) exit 0 ;; esac
  echo "Blocked: '$path' looks like a secrets file. Ask the user to edit it manually." >&2
  exit 2
fi

cmd="$(echo "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | head -1)"
if [ -n "$cmd" ] && echo "$cmd" | grep -qE 'rm -rf? +(/|~|\*|\.)( |$)|rm -rf? +/[a-z]*( |$)|git push .*(-f|--force)( |$)|git reset --hard|git clean -[a-z]*f|DROP (TABLE|DATABASE)|mkfs|:\(\)\{|> */dev/sd|chmod -R 777'; then
  echo "Blocked dangerous command: $cmd — ask the user to run it if really intended." >&2
  exit 2
fi
exit 0

#!/usr/bin/env bash
# Install the agentic workflow into a project.
# Usage: ./install.sh [project-dir] [--tool claude|cursor|codex|gemini|all|<a,b>] [--build <model>] [--review <model>] [--explore <model>]
#   project-dir defaults to the current dir. --tool defaults to claude; comma-separate several.
#   Models (Claude only): inherit (default), opus, sonnet, haiku, fable, or a full id.
#   Re-run to update skills; model choices already set in the project are kept unless you pass a flag.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="."; TOOLS="claude"; M_BUILD=""; M_REVIEW=""; M_EXPLORE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tool) TOOLS="$2"; shift 2 ;;
    --build) M_BUILD="$2"; shift 2 ;;
    --review) M_REVIEW="$2"; shift 2 ;;
    --explore) M_EXPLORE="$2"; shift 2 ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done
DEST="$(cd "$TARGET" && pwd)"
NAME="$(basename "$DEST")"
MARK="<!-- agentic-workflow -->"

[ "$SRC" = "$DEST" ] && { echo "Run this from (or point it at) your project, not the workflow repo."; exit 1; }

[ "$TOOLS" = all ] && TOOLS="claude,cursor,codex,gemini"
CLAUDE=0; SHARED=0; GEMINI=0
IFS=',' read -ra LIST <<< "$TOOLS"
for t in "${LIST[@]}"; do
  case "$t" in
    claude) CLAUDE=1 ;;
    cursor|codex) SHARED=1 ;;
    gemini) SHARED=1; GEMINI=1 ;;
    *) echo "Unknown --tool '$t'. Use claude, cursor, codex, gemini, all, or a comma-separated list." >&2; exit 1 ;;
  esac
done

echo "Installing agentic-workflow ($TOOLS) into $DEST"

# Shared by every tool: config (the skills read .claude/workflow.json), stack presets, plan folders.
mkdir -p "$DEST/.claude/presets"
cp "$SRC/presets/"*.md "$DEST/.claude/presets/"
[ -f "$DEST/.claude/workflow.json" ] || cp "$SRC/templates/workflow.json" "$DEST/.claude/workflow.json"
for d in docs/plans/new docs/plans/active docs/plans/done docs/decisions; do
  mkdir -p "$DEST/$d"; touch "$DEST/$d/.gitkeep"
done

if [ $CLAUDE = 1 ]; then
  mkdir -p "$DEST/.claude/skills" "$DEST/.claude/agents" "$DEST/.claude/hooks"
  cp -R "$SRC/skills/." "$DEST/.claude/skills/"
  # Agents: keep the model line the project already chose, unless a flag overrides it.
  for a in builder:"$M_BUILD" reviewer:"$M_REVIEW" explorer:"$M_EXPLORE"; do
    name="${a%%:*}"; want="${a#*:}"; f="$DEST/.claude/agents/$name.md"
    [ -z "$want" ] && [ -f "$f" ] && want="$(sed -n 's/^model:[[:space:]]*//p' "$f" | head -1)"
    cp "$SRC/agents/$name.md" "$f"
    [ -n "$want" ] && sed -i.bak "s/^model:.*/model: $want/" "$f" && rm -f "$f.bak"
  done
  cp "$SRC/agents/outside-reviewer.md" "$DEST/.claude/agents/outside-reviewer.md"
  cp "$SRC/hooks/"*.sh "$DEST/.claude/hooks/"
  # Hooks: install settings.json if absent; never overwrite an existing one.
  if [ ! -f "$DEST/.claude/settings.json" ]; then
    cp "$SRC/templates/settings.json" "$DEST/.claude/settings.json"
  elif ! grep -q "plan-gate.sh" "$DEST/.claude/settings.json"; then
    echo "NOTE: .claude/settings.json exists; merge the hooks from $SRC/templates/settings.json manually."
  fi
fi

# Cursor, Codex and Gemini CLI all read project skills from .agents/skills/: one copy serves them all.
if [ $SHARED = 1 ]; then
  mkdir -p "$DEST/.agents/skills"
  cp -R "$SRC/skills/." "$DEST/.agents/skills/"
fi

# AGENTS.md (read natively by Cursor and Codex, imported by CLAUDE.md and GEMINI.md):
# create, or replace our marked block, or append it.
BLOCK="$MARK
$(cat "$SRC/AGENTS.md")
$MARK"
if [ ! -f "$DEST/AGENTS.md" ]; then
  printf '%s\n' "$BLOCK" > "$DEST/AGENTS.md"
elif grep -q "$MARK" "$DEST/AGENTS.md"; then
  awk -v m="$MARK" -v blk="$BLOCK" '
    $0==m { if (!inblk) { print blk; inblk=1; next } else { inblk=0; next } }
    !inblk' "$DEST/AGENTS.md" > "$DEST/AGENTS.md.tmp" && mv "$DEST/AGENTS.md.tmp" "$DEST/AGENTS.md"
else
  printf '\n%s\n' "$BLOCK" >> "$DEST/AGENTS.md"
fi

# CLAUDE.md: create from template, or make sure it imports AGENTS.md.
if [ $CLAUDE = 1 ]; then
  if [ ! -f "$DEST/CLAUDE.md" ]; then
    sed "s/{{PROJECT_NAME}}/$NAME/" "$SRC/templates/CLAUDE.md" > "$DEST/CLAUDE.md"
  elif ! grep -q "@AGENTS.md" "$DEST/CLAUDE.md"; then
    { echo "@AGENTS.md"; echo; cat "$DEST/CLAUDE.md"; } > "$DEST/CLAUDE.md.tmp" && mv "$DEST/CLAUDE.md.tmp" "$DEST/CLAUDE.md"
  fi
fi

# GEMINI.md: Gemini CLI reads GEMINI.md, so import AGENTS.md from it.
if [ $GEMINI = 1 ]; then
  if [ ! -f "$DEST/GEMINI.md" ]; then
    printf '@AGENTS.md\n' > "$DEST/GEMINI.md"
  elif ! grep -q "@AGENTS.md" "$DEST/GEMINI.md"; then
    { echo "@AGENTS.md"; echo; cat "$DEST/GEMINI.md"; } > "$DEST/GEMINI.md.tmp" && mv "$DEST/GEMINI.md.tmp" "$DEST/GEMINI.md"
  fi
fi

# Keep personal notes, handoffs and the S-task marker out of git.
touch "$DEST/.gitignore"
for p in CLAUDE.local.md docs/handoff.md docs/plans/.s-task; do
  grep -qxF "$p" "$DEST/.gitignore" || echo "$p" >> "$DEST/.gitignore"
done

if [ $CLAUDE = 1 ]; then echo "Done. Next: open the project in Claude Code and run /setup-project"
else echo "Done. Next: open the project in your agent and ask it to run the setup-project skill"; fi

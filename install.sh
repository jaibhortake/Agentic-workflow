#!/usr/bin/env bash
# Install the agentic workflow into a project.
# Usage: ./install.sh [project-dir]   (default: current dir). Re-run to update skills.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$(cd "${1:-.}" && pwd)"
NAME="$(basename "$DEST")"
MARK="<!-- agentic-workflow -->"

[ "$SRC" = "$DEST" ] && { echo "Run this from (or point it at) your project, not the workflow repo."; exit 1; }

echo "Installing agentic-workflow into $DEST"

mkdir -p "$DEST/.claude/skills" "$DEST/.claude/agents" "$DEST/.claude/hooks" "$DEST/.claude/presets"
cp -R "$SRC/skills/." "$DEST/.claude/skills/"
cp -R "$SRC/agents/." "$DEST/.claude/agents/"
cp "$SRC/hooks/"*.sh "$DEST/.claude/hooks/"
cp "$SRC/presets/"*.md "$DEST/.claude/presets/"
[ -f "$DEST/.claude/workflow.json" ] || cp "$SRC/templates/workflow.json" "$DEST/.claude/workflow.json"

# Hooks: install settings.json if absent; never overwrite an existing one.
if [ ! -f "$DEST/.claude/settings.json" ]; then
  cp "$SRC/templates/settings.json" "$DEST/.claude/settings.json"
elif ! grep -q "guard.sh" "$DEST/.claude/settings.json"; then
  echo "NOTE: .claude/settings.json exists — merge the hooks from $SRC/templates/settings.json manually."
fi

for d in docs/plans/new docs/plans/active docs/plans/done docs/decisions; do
  mkdir -p "$DEST/$d"; touch "$DEST/$d/.gitkeep"
done

# AGENTS.md: create, or replace our marked block, or append it.
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
if [ ! -f "$DEST/CLAUDE.md" ]; then
  sed "s/{{PROJECT_NAME}}/$NAME/" "$SRC/templates/CLAUDE.md" > "$DEST/CLAUDE.md"
elif ! grep -q "@AGENTS.md" "$DEST/CLAUDE.md"; then
  { echo "@AGENTS.md"; echo; cat "$DEST/CLAUDE.md"; } > "$DEST/CLAUDE.md.tmp" && mv "$DEST/CLAUDE.md.tmp" "$DEST/CLAUDE.md"
fi

# Keep personal notes and handoffs out of git.
touch "$DEST/.gitignore"
for p in CLAUDE.local.md docs/handoff.md; do
  grep -qxF "$p" "$DEST/.gitignore" || echo "$p" >> "$DEST/.gitignore"
done

echo "Done. Next: open the project in Claude Code and run /setup-project"

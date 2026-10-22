#!/usr/bin/env bash
# Install the agentic workflow into a project.
# Usage: ./install.sh [project-dir] [--build <model>] [--review <model>] [--explore <model>]
#   project-dir defaults to the current dir. Models: inherit (default), opus, sonnet, haiku, fable, or a full id.
#   Re-run to update skills; model choices already set in the project are kept unless you pass a flag.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="."; M_BUILD=""; M_REVIEW=""; M_EXPLORE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --build) M_BUILD="$2"; shift 2 ;;
    --review) M_REVIEW="$2"; shift 2 ;;
    --explore) M_EXPLORE="$2"; shift 2 ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done
DEST="$(cd "$TARGET" && pwd)"
NAME="$(basename "$DEST")"
MARK="<!-- agentic-workflow -->"

[ "$SRC" = "$DEST" ] && { echo "Run this from (or point it at) your project, not the workflow repo."; exit 1; }

echo "Installing agentic-workflow into $DEST"

mkdir -p "$DEST/.claude/skills" "$DEST/.claude/agents" "$DEST/.claude/hooks" "$DEST/.claude/presets"
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

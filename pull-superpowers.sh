#!/usr/bin/env bash
# Vendor two skills from obra/superpowers (MIT, Jesse Vincent) into skills/.
# They are committed (not gitignored) so the Claude plugin, which installs from git, ships them.
# Never hand-edit skills/test-driven-development or skills/systematic-debugging; re-run this.
# Usage: ./pull-superpowers.sh [--ref <branch|tag|commit>]
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/obra/superpowers.git"
REF="main"
[ "${1:-}" = "--ref" ] && REF="$2"

SKILLS=(test-driven-development systematic-debugging)
# Skills of theirs we never install: our /verify replaces verification-before-completion.
RETIRED_SKILLS=(verification-before-completion)

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
git clone -q --filter=blob:none "$REPO_URL" "$TMP/sp"
git -C "$TMP/sp" checkout -q "$REF"
COMMIT="$(git -C "$TMP/sp" rev-parse HEAD)"

for s in "${SKILLS[@]}"; do
  [ -d "$TMP/sp/skills/$s" ] || { echo "missing upstream skill: $s" >&2; exit 1; }
  rm -rf "$SRC/skills/$s"
  cp -R "$TMP/sp/skills/$s" "$SRC/skills/$s"
  cp "$TMP/sp/LICENSE" "$SRC/skills/$s/LICENSE"
  printf 'Vendored from %s at %s. Do not edit; re-run pull-superpowers.\n' "$REPO_URL" "$COMMIT" > "$SRC/skills/$s/SOURCE.md"
  # Drop the plugin namespace and point their verification reference at our gate.
  find "$SRC/skills/$s" -name '*.md' -exec sed -i.bak \
    -e 's|superpowers:verification-before-completion|/verify|g' \
    -e 's|superpowers:\([a-z-]*\)|/\1|g' {} \;
  find "$SRC/skills/$s" -name '*.bak' -delete
  echo "vendored $s"
done

for s in "${RETIRED_SKILLS[@]}"; do
  [ -d "$SRC/skills/$s" ] && rm -rf "$SRC/skills/$s" && echo "removed retired $s"
done

echo "obra/superpowers @ $COMMIT"

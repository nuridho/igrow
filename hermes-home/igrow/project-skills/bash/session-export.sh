#!/usr/bin/env bash
# session-export.sh — dump memory, skills, hermes-home/igrow/ ke archive folder.
# Dipicu cron mingguan / on-demand.
# Exit 0 = sukses. Exit non-zero = error.
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-/opt/data}"
IGROW="$HERMES_HOME/igrow"
ARCHIVE="$HERMES_HOME/log/sessions/archive"
STAMP=$(date +%F)
DEST="$ARCHIVE/$STAMP"

# Paths yang harus di-copy
# 1. memory (MEMORY.md + USER.md)
# 2. skills (hanya project skills iGROW, bukan bundled)
# 3. igrow/ (knowledge base)
SRC_MEMORY="${HERMES_HOME%/*}/memories"   # /opt/data → /opt/data/../memories? No.
# Hermes stores memories at $LOCALAPPDATA/hermes/memories/ on host,
# but inside container it's mounted differently. Use the actual env var:
MEMDIR="${HERMES_MEMORIES_DIR:-$HOME/AppData/Local/hermes/memories}"
SKDIR="${HERMES_SKILLS_DIR:-$HOME/AppData/Local/hermes/skills}"

mkdir -p "$DEST/memory" "$DEST/skills" "$DEST/igrow"

# --- memory ---
if [ -d "$MEMDIR" ]; then
  cp "$MEMDIR/MEMORY.md" "$DEST/memory/" 2>/dev/null || true
  cp "$MEMDIR/USER.md"   "$DEST/memory/" 2>/dev/null || true
else
  echo "WARN: memory dir not found at $MEMDIR" >&2
fi

# --- skills (hanya igrow project skill, bukan seluruh bundled) ---
# ponytail: only export the igrow skill — it's the one that matters for migration.
# Add more skill dirs here if needed.
for skill in igrow; do
  if [ -d "$SKDIR/$skill" ]; then
    cp -r "$SKDIR/$skill" "$DEST/skills/"
  fi
done

# --- igrow/ (knowledge base — the main asset) ---
if [ -d "$IGROW" ]; then
  # ponytail: exclude .git to keep archive lean — git history stays in the repo
  cp -r "$IGROW"/. "$DEST/igrow/"
  rm -rf "$DEST/igrow/.git"
else
  echo "ERROR: igrow/ not found at $IGROW" >&2
  exit 1
fi

# --- log ---
echo "[$STAMP] session export complete" >> "$HERMES_HOME/log.md"
echo "session-export: saved to $DEST"

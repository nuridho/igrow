#!/usr/bin/env bash
# backup.sh — push igrow/ ke GitHub repo privat igrow-backup.
# Dipicu via cron `hermes cron create` → baca backup.md → jalankan script ini.
# Exit 0 = pushed atau no changes. Exit non-zero = error. Ketiganya dilaporkan ke Telegram.
set -euo pipefail

cd /opt/data/igrow || { echo "ERROR: cannot cd to igrow"; exit 1; }

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: igrow/ bukan git repo — jalankan: git init && git add -A && git commit -m init"
  exit 1
fi

# AGENTS.md ada di root HERMES_HOME (di luar igrow/) — salin ke sini biar ikut ke-push.
[ -f /opt/data/AGENTS.md ] && cp /opt/data/AGENTS.md AGENTS.backup.md

git add -A
if ! git diff --cached --quiet; then
  git commit -m "backup $(date +%F)"
fi

# Push tetap jalan walau tidak ada perubahan baru: commit yang dulu gagal di-push ikut terkirim,
# dan remote + token teruji di setiap run. ahead = jumlah commit yang belum ada di GitHub.
ahead=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 1)
if git push; then
  if [ "$ahead" -gt 0 ]; then echo "backup: pushed successfully"; else echo "backup: no changes (GitHub sudah sama)"; fi
else
  echo "ERROR: git push gagal" >&2
  exit 1
fi

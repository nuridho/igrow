# Session Export (I22 — Cron Mingguan)

Dipicu cron Minggu 03:15. Export `memory/`, `skills/igrow/`, `igrow/` ke `log/sessions/archive/`.

## File Referensi

| File | Isi |
|---|---|
| `igrow/project-skills/bash/session-export.sh` | Script bash yang dijalankan cron |

## Langkah

1. Jalankan `igrow/project-skills/bash/session-export.sh`
2. Script create folder `log/sessions/archive/YYYY-MM-DD/` dengan:
   - `memory/MEMORY.md`, `memory/USER.md`
   - `skills/igrow/` (full folder)
   - `igrow/` (knowledge base, tanpa `.git/`)
3. Append log `log.md`: `[$STAMP] session export complete`
4. Exit 0 = sukses; non-zero = error (lapor ke Telegram)

## On-demand

Manually dari terminal (host):
```bash
docker exec igrow-hermes bash /opt/data/igrow/project-skills/bash/session-export.sh
```

From within container:
```bash
bash /opt/data/igrow/project-skills/bash/session-export.sh
```

## Restore (migration ke tool lain)

1. Copy folder `igrow/` → target tool
2. Extract archive `log/sessions/archive/` → `memories/` + `skills/igrow/`
3. Manually convert format jika perlu (Hermes memory/skill format ≠ tool lain)

## Aturan

- Cron export tiap minggu (malam hari, bareng backup).
- Restore cuma manual — tidak ada command otomatis.
- Archive di-host lokal; backup ke GitHub terpisah via cron git push.

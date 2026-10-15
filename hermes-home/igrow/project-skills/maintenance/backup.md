# Backup Knowledge (Maintenance — Cron Mingguan)

Dipicu cron Minggu 03:00. Push `igrow/` ke GitHub privat `igrow-backup`.

## Langkah

1. Jalankan pakai bash: `igrow/project-skills/maintenance/backup.sh` — script handle add/commit/push, silent kalau no-change.
2. Exit non-zero → laporkan error ke Telegram.
3. Exit 0 + output "no changes" → jangan kirim pesan.

## Aturan

- Script cuma backup subfolder `igrow/`, bukan seluruh `HERMES_HOME/`.
- Jangan utak-atik `.git/` manual.
- Prasyarat: repo sudah diinisialisasi + remote (`git remote add origin`).

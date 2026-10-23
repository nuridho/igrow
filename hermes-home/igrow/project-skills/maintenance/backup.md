# Backup Knowledge (Maintenance — Cron 3x Seminggu)

Dipicu cron Senin, Rabu, Sabtu 05:00 (`0 5 * * 1,3,6`). Push `igrow/` ke GitHub privat `igrow-backup`.

## Langkah

1. Jalankan pakai bash: `igrow/project-skills/maintenance/backup.sh` — script handle add/commit/push.
2. Selalu balas 1 baris (jadi laporan cron ke Telegram):
   - Exit 0 + "pushed" → `Backup <YYYY-MM-DD>: berhasil di-push.`
   - Exit 0 + "no changes" → `Backup <YYYY-MM-DD>: tidak ada perubahan.`
   - Exit non-zero, atau script tidak bisa dijalankan → `Backup <YYYY-MM-DD> gagal: <inti pesan error dari output>`

## Aturan

- Script backup subfolder `igrow/` + salinan `AGENTS.md` (jadi `igrow/AGENTS.backup.md`, hanya arsip — jangan diedit/dibaca sebagai aturan). Bukan seluruh `HERMES_HOME/`.
- Jangan utak-atik `.git/` manual.
- Prasyarat: repo sudah diinisialisasi + remote (`git remote add origin`).

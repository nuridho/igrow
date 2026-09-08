# Referensi: Backup Knowledge (Cron Mingguan)

Dipicu cron Minggu 03:00. Push seluruh isi `igrow/` ke GitHub repo privat `igrow-backup`.

## Langkah

1. `cd igrow && git add -A`
2. `git commit -m "backup $(date +%F)"`
3. `git push`

## Aturan

- **Silent**: kalau tidak ada perubahan (commit gagal karena nothing to commit),
  JANGAN kirim pesan apapun ke Telegram.
- **Push gagal**: laporkan error-nya ke Telegram (bisa jadi network block,
  cek DNS/proxy container).
- Jangan utak-atik `.git/` secara manual — backup ini satu-satunya cara
  sync.
</file>

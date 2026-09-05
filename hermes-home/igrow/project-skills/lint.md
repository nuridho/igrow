# Referensi: Lint Mingguan

Dipicu cron Minggu 08:00. Cek kesehatan struktur `igrow/wiki/` — BUKAN baca
ulang isi konten.

## Cek (laporkan temuan saja, JANGAN ubah isi note)
1. Orphan page: file `*.md` di wiki/ yang tidak tercatat di `_index.md`
   terdekat. Abaikan file berawalan `_` (`_index.md`, `_index.json`).
2. Broken wikilink: `[[slug]]` tanpa file target — KECUALI slug tercatat di
   `_index.md` dengan tanda `(placeholder)` (unresolved sengaja, lewati).
3. Frontmatter note: 7 field wajib SCHEMA (title, created, updated, type,
   tags, sources, confidence) — `contradictions` opsional; `tests/` pakai field
   skor sendiri, lewati.
4. Tag di luar taxonomy SCHEMA.
5. `_index.md` vs filesystem: entri index yang file-nya sudah tidak ada.

## Tutup
Append ringkasan ke `igrow/log.md` (op: lint). Kirim ke Telegram; semua
bersih → cukup "wiki sehat".

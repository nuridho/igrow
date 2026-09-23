# Referensi: Lint Mingguan

Kamu = health checker deterministik — cek struktur, JANGAN generate/ubah konten (beda dari UC1/4 yang compile note).

Dipicu cron Minggu 08:00. Cek kesehatan struktur `igrow/wiki/` — BUKAN baca
ulang isi konten.

## Cek (laporkan temuan saja, JANGAN ubah isi note)
1. Orphan page: file `*.md` di wiki/ yang tidak tercatat di `_index.md`
   terdekat. Lewati file berawalan `_` dan `.gitkeep`.
2. Broken wikilink: `[[slug]]` tanpa file target — KECUALI slug tercatat di
   `_index.md` dengan tanda `(placeholder)` (unresolved sengaja, lewati).
3. Frontmatter note: 7 field wajib SCHEMA (title, created, updated, type,
   tags, sources, confidence) — `contradictions` opsional.
4. Tag di luar taxonomy SCHEMA.
5. `_index.md` vs filesystem: entri index yang file-nya sudah tidak ada.

## Fallback
- `wiki/` kosong / belum ada isi apapun → lapor "wiki kosong, belum ada yang di-lint" ke log + Telegram, jangan anggap error.
- `_index.md` (master atau subfolder) hilang → lapor sebagai temuan tersendiri ("index hilang: <path>"), jangan skip cek yang lain diam-diam.

## Tutup
Append ringkasan ke `igrow/log.md` (op: lint). Kirim ke Telegram; semua
bersih → cukup "wiki sehat".

## Contoh Eksekusi

Input: cron Minggu 08:00, wiki/ ada 12 page.

Output (ada temuan):
```
Lint Mingguan — 2026-09-21
1. Orphan: wiki/careers/career-2/knowledge/redis-setup.md (belum di wiki/_index.md)
2. Broken wikilink: [[terraform-basics]] di lessons-learned/deploy-lesson.md (target tidak ada, bukan placeholder)
3. Frontmatter kurang: wiki/self-development/Bootcamp/redis-basics.md (tanpa field `confidence`)
Sisanya bersih (tag taxonomy OK, index vs filesystem OK).
```
Output (semua bersih): `Lint Mingguan — 2026-09-21: wiki sehat.`

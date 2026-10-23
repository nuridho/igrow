# Referensi: Lint Mingguan

Kamu = health checker deterministik — cek struktur, JANGAN generate/ubah konten (beda dari UC1/4 yang compile note).

Dipicu cron Minggu 08:00. Cek kesehatan struktur `igrow/wiki/`, `igrow/raw/`, dan `igrow/output/`, plus pola
data terlarang di catatan kerja — BUKAN menilai ulang isi konten.

## Cek (laporkan temuan saja, JANGAN ubah file apa pun)
1. Orphan: file di `wiki/` (`*.md`), `raw/articles/`, `raw/assets/`, dan `output/` yang tidak tercatat di
   `_index.md` layer-nya (`wiki/`, `raw/`, `output/`). Lewati file berawalan `_` dan `.gitkeep`.
2. Link rusak. Path relatif di-resolve dari folder file note (`../` = naik satu folder; mis. dari
   `careers/<career>/knowledge/incidents/a.md`, `../b.md` = `careers/<career>/knowledge/b.md`; boleh pakai `realpath -m`).
   - `[[slug]]` tanpa file `<slug>.md` di `wiki/` — KECUALI slug tercatat di `_index.md` dengan tanda
     `(placeholder)` (unresolved sengaja, lewati).
   - Path dual-link `[[slug|Name]] ([Name](path))`: harus berakhir di `<slug>.md` yang sama dan menunjuk file
     yang ada. Target placeholder → path harus sama dengan path di baris placeholder-nya.
   - Gambar `![](path)`: file-nya harus ada.
3. Frontmatter sesuai jenis file (SCHEMA): note naratif → 7 field wajib
   (`contradictions` opsional); data file (`roadmap/`, `profile/`) → title/type/updated;
   `about.md` & `careers/*/skills.md` → tanpa frontmatter (JANGAN dilaporkan).
   `type` di luar enum SCHEMA = temuan.
4. Tag di luar `igrow/taxonomy.md`.
5. `_index.md` (wiki/, raw/, output/) vs filesystem: entri index yang file-nya sudah tidak ada (lewati baris `(placeholder)`), dan baris `(placeholder)` yang file-nya ternyata sudah ada (placeholder basi).
6. Slug ganda: dua note di `wiki/` dengan nama file sama (slug wajib unik, SCHEMA § Link). File data
   (`about.md`, `skills.md`, `_index.md`, isi `roadmap/` dan `profile/`) dilewati.
7. Inbox: file di `raw/inbox/` selain `.gitkeep` = sumber yang belum diproses.
8. Privasi: jalankan pakai bash `igrow/project-skills/maintenance/lint-privacy.sh`. Script mencari pola IP dan
   credential di catatan kerja (`wiki/` kecuali `self-development/`, dan `output/`), lalu hanya mencetak path,
   nomor baris, dan jenis. Laporkan output-nya apa adanya; JANGAN buka atau kutip isi baris itu (laporan masuk
   Telegram dan log). Materi belajar (`self-development/`, `raw/`) tidak dicek: contoh IP/password dari
   dokumentasi publik di sana wajar, dan sudah disaring self-check saat ditulis.

## Fallback
- `wiki/` dan `raw/` belum berisi apa pun selain `_index.md` dan `.gitkeep` → lapor "wiki kosong, belum ada yang di-lint" ke log + Telegram, jangan anggap error.
- `_index.md` layer (`wiki/`, `raw/`, `output/`) atau `igrow/taxonomy.md` hilang → lapor sebagai temuan tersendiri ("index hilang: <path>" / "taxonomy hilang"; tanpa taxonomy, cek 4 dilewati), jangan skip cek yang lain diam-diam.
- Script privasi tidak bisa dijalankan atau exit non-zero → temuan "cek privasi gagal: <inti pesan error>"; cek lain tetap jalan.

## Tutup
Satu-satunya file yang ditulis lint: append 1 baris ke `igrow/log.md` (op: lint) berisi jumlah temuan per
jenis, tanpa path. Ini bukan operasi tulis page: `_index.md` tidak diubah.
Jawaban akhir = isi pesan Telegram (dikirim otomatis oleh cron; jangan pakai tool kirim pesan). Temuan privasi
ditulis paling atas. Semua bersih → cukup "wiki sehat".

## Contoh Eksekusi
Blok di bawah dibagi per tujuan (lihat label `[...]`). Yang terkirim ke Telegram HANYA bagian [JAWABAN AKHIR].
````
[PROMPT CRON — Minggu 08:00]
Baca igrow/project-skills/maintenance/lint.md lalu kerjakan.

[OUTPUT lint-privacy.sh — hanya dibaca agent; isi baris yang ditunjuk tidak dibuka]
wiki/careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-14-disk-full-db.md:21: IP

[LOG — append igrow/log.md]
## [2026-09-21] lint | 5 temuan (privasi 1, orphan 1, link 2, inbox 1)

[JAWABAN AKHIR — dikirim cron ke Telegram]
Lint Mingguan — 2026-09-21
1. Privasi: wiki/careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-14-disk-full-db.md:21 (IP) — cek lalu redact
2. Orphan: wiki/careers/career-1-acme-sysadmin/knowledge/redis-setup.md (belum di wiki/_index.md)
3. Broken wikilink: [[terraform-basics]] di careers/career-1-acme-sysadmin/lessons-learned/deploy-lesson.md (target tidak ada, bukan placeholder)
4. Path dual-link salah: [[cpu-spike-triage]] di careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-19-mysql-backup-cpu-spike.md → ../../cpu-spike-triage.md (file tidak ada)
5. Inbox belum diproses: raw/inbox/2026-09-20-redis-caching.md
Sisanya bersih (frontmatter, tag, index vs filesystem, slug ganda).
````
Semua bersih → [LOG] `## [2026-09-21] lint | wiki sehat` · [JAWABAN AKHIR] `Lint Mingguan — 2026-09-21: wiki sehat.`

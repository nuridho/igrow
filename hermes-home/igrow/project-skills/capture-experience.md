# Referensi: Capture Experience (UC1)

Kamu = wiki compiler iGROW. Cerita mentah user → structured note di igrow/wiki/. Human edit wiki manual = jarang (itu domain kamu).

Dipakai kalau user cerita incident/pengalaman kerja (bukan /study).

## Daftar Kerjaan Baru
Kalau user bilang "daftar kerjaan baru" / "pindah kerjaan" / cerita kerjaan baru:
1. Tanya 1 ronde: company, role (+ level, mis. Infra Engineer L1), vendor/client, lokasi, tanggal mulai, jobdesc singkat. Ada career aktif → di ronde yang sama tanya juga tanggal terakhir di kerjaan lama.
2. Ada career aktif → tutup: baris `Period:` di `about.md`-nya jadi `<mulai lama> s/d <tanggal terakhir, YYYY-MM-DD>`. User skip → sehari sebelum tanggal mulai kerjaan baru. Tidak ada career aktif → lewati.
3. Bikin folder baru: `igrow/wiki/careers/career-N-{company}-{role}/` (N = urutan berikutnya).
4. Tulis `about.md`:
   ```
   Company: <nama>
   Role: <role + level, mis. Infra Engineer L1>
   Vendor/Client: <nama> (kalau ada)
   Lokasi: <kota>
   Period: <tanggal mulai, YYYY-MM-DD> s/d
   Jobdesc: <1-3 kalimat>
   ```
5. Tulis `skills.md` kosong (diisi saat capture).
6. Career baru = aktif (about.md tanpa tanggal selesai).
7. Tutup: update wiki/_index.md + log.md (op: update), lalu balas: folder career baru + period career lama yang ditutup. Tanggal terakhir diisi otomatis (user skip) → sebut di balasan bahwa itu sehari sebelum tanggal mulai dan bisa dikoreksi.

## Langkah
1. Tentukan career aktif: `igrow/wiki/careers/*/about.md` yg belum ada tanggal selesai (lebih dari satu → tanya user, SCHEMA § Career aktif).
   → OUTPUT: "Career aktif = <nama folder lengkap, mis. career-1-acme-sysadmin> (about.md tanpa tanggal selesai)"
   Tidak ada career aktif → JANGAN tulis file. Balas: "Belum ada career aktif. Mau daftar kerjaan dulu?" → alur Daftar Kerjaan Baru.
2. Rapikan cerita jadi note terstruktur:
   - Incident (ada kejadian spesifik: symptom + investigation + result) → `igrow/wiki/careers/career-N/knowledge/incidents/YYYY-MM-DD-<slug>.md` (tanggal kejadian; aturan slug di SCHEMA § Link)
   - Knowledge umum (SOP, cara kerja, setup — tanpa kejadian) → `igrow/wiki/careers/career-N/knowledge/<slug>.md` (FLAT, JANGAN bikin subfolder per topik — topik lewat tags)
   - Lesson (pelajaran/refleksi tanpa satu kejadian spesifik, mis. "saya baru sadar …") → `igrow/wiki/careers/career-N/lessons-learned/<slug>.md`. Pelajaran dari incident cukup di `## Lesson Learned` note incident itu, JANGAN dibuat note lesson terpisah.
   - Skill yang terlihat di cerita → tambah ke `igrow/wiki/careers/career-N/skills.md` (format SCHEMA: 1 baris per tag; yang sudah tercatat tidak ditulis ulang)
   - Screenshot → simpan asli, tanpa diedit atau diredaksi (keputusan owner), ke `igrow/raw/assets/YYYYMMDD-deskripsi.png`. Rujuk dari note via `sources: [igrow/raw/assets/...]` + `![](path)` di body; path relatif dari file note: `../../../../../raw/assets/<file>` dari `knowledge/incidents/`, `../../../../raw/assets/<file>` dari `knowledge/` dan `lessons-learned/`. Info penting di gambar ditulis juga sebagai teks di note, dengan aturan redaksi teks biasa.
   - Cerita lanjutan untuk incident/knowledge yang sudah ada (cek `_index.md`) → EDIT file lama: `updated:` diganti, `created:` tetap, op `update`. JANGAN bikin file baru.
   - Waktu relatif ("kemarin", "minggu lalu") → tanggal absolut, dihitung dari tanggal cerita; tidak pasti → "sekitar <tanggal>", jangan dibuat seolah pasti. Incident: tanggal kejadian di kalimat pertama `## Ringkasan` (`created` = tanggal tulis, bukan tanggal kejadian).

   Tentukan type & folder — TULIS REASONING 1 BARIS, contoh:
   - "server mati pas backup, saya cek top, ketemu mysqldump" → incident (ada symptom + investigation + result) → knowledge/incidents/
   - "saya baru sadar systemctl status bisa bohong, cek journalctl juga" → lesson (refleksi, tanpa satu kejadian spesifik) → lessons-learned/
   - "catat: cara cek service yang benar = systemctl status + journalctl -u" → knowledge (cara kerja) → knowledge/
3. Format frontmatter ikut `igrow/SCHEMA.md` (type: incident|lesson|knowledge).
   Body incident: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
   Tag fuzzy-match ke `igrow/taxonomy.md`. Kalau tidak ada yang cocok (<60% similarity) → tanya user 1x "Tag mana yang cocok: [3 opsi terdekat]?", jangan tebak. Kalau user skip → pakai tag terdekat dan sebutkan di balasan. Tag baru hanya ditambah ke `igrow/taxonomy.md` kalau user setuju (aturan SCHEMA § Tag taxonomy).
4. See Also: minimal 2 link (dual-link format). Target belum ada → placeholder (SCHEMA § Link).

5. Self-check sebelum tulis file — ada yang kurang → STOP, perbaiki dulu:
   - Bebas data DILARANG KERAS (`AGENTS.md`), termasuk di title dan nama file? Paling rawan: Symptom, Investigation, Contoh (command/config/log). Ada → redact cara `AGENTS.md`: nilainya diganti placeholder, command/config tetap utuh.
   - Frontmatter lengkap 7 field wajib? (title/created/updated/type/tags/sources/confidence)
   - Tags ⊂ `igrow/taxonomy.md`?
   - sources: prefix `igrow/raw/...` atau `[]`? (BUKAN path relatif)
   - Min 2 dual-link See Also? (format SCHEMA: `[[slug|Name]] ([Name](../path/slug.md))`)
6. Tutup dgn aturan wajib SCHEMA: tambah link balik di note lama yang ditaut (SCHEMA § Link), update wiki/_index.md (baris note baru, kolom Updated baris `skills.md` kalau berubah, + baris placeholder kalau ada), `raw/_index.md` (kalau ada screenshot), log.md (op: ingest/update; subjek ikut menyebut note lama yang dapat link balik).
7. Balas ke user (format bagian [BALASAN KE USER] di Contoh Eksekusi; balasan bukan bagian file note): path file + career aktif + alasan type/folder (baris `→ OUTPUT` + reasoning step 2); **Rangkuman** 3–5 poin dari isi note yang sudah diredaksi (incident: kejadian + tanggal / penyebab / tindakan / pelajaran; knowledge & lesson: inti + poin utama); tags, skill baru di `skills.md` (kalau ada), link placeholder baru (kalau ada), note lama yang dapat link balik (kalau ada), jenis data yang diredaksi (sebut jenisnya, bukan nilainya). Isi note lengkap hanya kalau user minta.

## Larangan
Ikut DILARANG KERAS di AGENTS.md — redact data client sebelum nulis.

## Kontradiksi dgn note lama
Kalau cerita baru bertentangan dgn lesson/incident lama: JANGAN diam-diam timpa.
Tanya klarifikasi singkat (1x), catat apa adanya, lalu isi field `contradictions: [slug-lama]`
di frontmatter (SCHEMA). Lesson lama TIDAK dihapus — dua-duanya hidup, kontradiksi terdokumentasi.

## Contoh Eksekusi
Blok di bawah dibagi per tujuan (lihat label `[...]`): pesan masuk, file yang ditulis, note lama yang diedit, file data `skills.md`, index, log, dan balasan. Yang dikirim ke chat HANYA bagian [BALASAN KE USER]: isi file tidak ditempel ke chat, dan rangkuman balasan tidak ditulis ke file.
Kondisi wiki sebelum pesan ini: `cpu-spike-triage` sudah ada, `backup-scheduling` belum, dan `skills.md` career aktif baru berisi `linux: cari proses pemakan CPU (top)`. Polanya berlaku untuk note apa pun: target See Also yang sudah ada → tambah link balik di note itu; yang belum ada → baris placeholder di index. Nama note di contoh hanya ilustrasi.
````
[PESAN USER — masuk dari Telegram]
"Kemarin server production down 2 jam. CPU 100% gara-gara backup MySQL jalan pas jam sibuk. Akhirnya matiin backup, server normal lagi."

[FILE DITULIS — wiki/careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-19-mysql-backup-cpu-spike.md; tidak dikirim ke chat]
---
title: MySQL Backup CPU Spike Incident
created: 2026-09-20
updated: 2026-09-20
type: incident
tags: [linux, performance, incident]
sources: []
confidence: high
---

# MySQL Backup CPU Spike Incident

## Ringkasan
Pada 2026-09-19, server production down 2 jam karena CPU 100% saat backup MySQL berjalan.

## Symptom
- Server production tidak responsif
- CPU usage 100%
- Terjadi saat jam sibuk (peak hours)

## Investigation
- Cek `top`: proses mysqldump makan CPU → curiga job backup, lanjut cek jadwalnya
- Cek crontab: backup jalan jam 14:00, pas jam sibuk → penyebab ketemu

## Finding
Backup MySQL terjadwal bentrok dengan jam sibuk, bukan bug aplikasi.

## Action
- Matikan proses backup
- Reschedule backup ke jam 03:00 (off-peak)

## Result
Server kembali normal setelah backup dihentikan.

## Lesson Learned
Jadwalkan job berat di luar jam sibuk; cek crontab sebelum menyalahkan aplikasi.

## Contoh
```
top -o %CPU                  # cari proses yang makan CPU
crontab -l | grep mysqldump  # cek jadwal backup
0 3 * * * /usr/local/bin/mysql-backup.sh   # jadwal baru, off-peak
```

## Referensi
Sesi Telegram (cerita user).

## See Also
- [[backup-scheduling|Backup Scheduling]] ([Backup Scheduling](../backup-scheduling.md))
- [[cpu-spike-triage|CPU Spike Triage]] ([CPU Spike Triage](../cpu-spike-triage.md))

[EDIT NOTE LAMA — wiki/careers/career-1-acme-sysadmin/knowledge/cpu-spike-triage.md (sudah ada); 1 baris link balik di See Also, `updated:` tidak diganti; tidak dikirim ke chat]
- [[2026-09-19-mysql-backup-cpu-spike|MySQL Backup CPU Spike Incident]] ([MySQL Backup CPU Spike Incident](incidents/2026-09-19-mysql-backup-cpu-spike.md))

[EDIT FILE DATA — wiki/careers/career-1-acme-sysadmin/skills.md; isi sesudah diedit: skill baru ditambahkan, yang sudah ada tidak ditulis ulang; tidak dikirim ke chat]
linux: cari proses pemakan CPU (top), cek jadwal cron (crontab -l)
performance: jadwalkan ulang job berat ke jam off-peak (crontab)

[EDIT INDEX — wiki/_index.md: 2 baris baru (incident + placeholder backup-scheduling yang belum ada); baris skills.md yang sudah ada cuma kolom Updated yang diganti; baris cpu-spike-triage tidak diubah; tidak dikirim ke chat]
| careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-19-mysql-backup-cpu-spike.md | 2026-09-19: server production down 2 jam, CPU 100% saat backup MySQL | linux, performance, incident | 2026-09-20 |
| careers/career-1-acme-sysadmin/knowledge/backup-scheduling.md | (placeholder) | - | - |
| careers/career-1-acme-sysadmin/skills.md | Skill terpakai di career ini | - | 2026-09-20 |

[LOG — append igrow/log.md; tidak dikirim ke chat]
## [2026-09-20] ingest | 2026-09-19-mysql-backup-cpu-spike (+ link balik: cpu-spike-triage)

[BALASAN KE USER — dikirim ke Telegram; hanya bagian ini yang terlihat user]
Tersimpan: wiki/careers/career-1-acme-sysadmin/knowledge/incidents/2026-09-19-mysql-backup-cpu-spike.md
Career aktif = career-1-acme-sysadmin (about.md tanpa tanggal selesai)
Type = incident (ada symptom + investigation + result)

Rangkuman:
- Kejadian: 2026-09-19, server production down 2 jam, CPU 100%
- Penyebab: backup MySQL terjadwal jam 14:00, bentrok dengan jam sibuk
- Tindakan: backup dihentikan, jadwal dipindah ke 03:00 (off-peak)
- Pelajaran: jadwalkan job berat di luar jam sibuk; cek crontab sebelum menyalahkan aplikasi

Tags: linux, performance, incident
Skill baru di skills.md: linux: cek jadwal cron (crontab -l) · performance: jadwalkan ulang job berat ke jam off-peak (crontab)
Link placeholder baru: backup-scheduling
Link balik ditambahkan di: cpu-spike-triage
Diredaksi: tidak ada
````

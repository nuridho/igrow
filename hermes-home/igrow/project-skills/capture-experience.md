# Referensi: Capture Experience (UC1)

Kamu = wiki compiler iGROW. Cerita mentah user → structured note di igrow/wiki/. Human edit wiki manual = jarang (itu domain kamu).

Dipakai kalau user cerita incident/pengalaman kerja (bukan /study).

## Daftar Kerjaan Baru
Kalau user bilang "daftar kerjaan baru" / "pindah kerjaan" / cerita kerjaan baru:
1. Tanya 1 ronde: company, role, vendor/client, lokasi, period start, jobdesc singkat.
2. Cek career aktif sebelumnya → tambah `Period: <start> s/d <hari ini>` di `about.md`-nya.
3. Bikin folder baru: `igrow/wiki/careers/career-N-{company}-{role}/` (N = urutan berikutnya).
4. Tulis `about.md`:
   ```
   Company: <nama>
   Role: <role>
   Vendor/Client: <nama> (kalau ada)
   Lokasi: <kota>
   Period: <start> s/d
   Jobdesc: <1-3 kalimat>
   ```
5. Tulis `skills.md` kosong (placeholder untuk UC1 nanti).
6. Career baru = aktif (about.md tanpa tanggal selesai).
7. Tutup: update wiki/_index.md + master + log.md (op: update).

## Langkah
1. Tentukan career aktif: `igrow/wiki/careers/*/about.md` yg belum ada tanggal selesai.
2. Rapikan cerita jadi note terstruktur:
   - Incident → `igrow/wiki/careers/career-N/knowledge/incidents/`
   - Knowledge umum (SOP, cara kerja, setup — tanpa kejadian) → `igrow/wiki/careers/career-N/knowledge/<slug>.md` (FLAT, JANGAN bikin subfolder per topik — topik lewat tags)
   - Lesson → `igrow/wiki/careers/career-N/lessons-learned/`
   - Skill terpakai → update `igrow/wiki/careers/career-N/skills.md`
   - Screenshot → `igrow/raw/assets/YYYYMMDD-deskripsi.png` (WAJIB redact); rujuk dari note via `sources: [igrow/raw/assets/...]` + `![](../../raw/assets/...)` di body
3. Format frontmatter ikut `igrow/SCHEMA.md` (type: incident|lesson|knowledge).
   Body incident: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
4. See Also: minimal 2 link (dual-link format).
5. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md, master _index.md, log.md (op: ingest/update).

## Larangan
Ikut DILARANG KERAS di AGENTS.md — redact data client sebelum nulis.

## Kontradiksi dgn note lama
Kalau cerita baru bertentangan dgn lesson/incident lama: JANGAN diam-diam timpa.
Tanya klarifikasi singkat (1x), catat apa adanya, lalu isi field `contradictions: [slug-lama]`
di frontmatter (SCHEMA). Lesson lama TIDAK dihapus — dua-duanya hidup, kontradiksi terdokumentasi.

## Contoh Eksekusi
```
Input: "Kemarin server production down 2 jam. CPU 100% gara-gara backup MySQL jalan pas jam sibuk. Akhirnya matiin backup, server normal lagi."

Output:
---
title: MySQL Backup CPU Spike Incident
created: 2025-01-20
updated: 2025-01-20
type: incident
tags: [linux, mysql, backup, performance]
sources: []
confidence: high
---

## Ringkasan
Server production down 2 jam karena CPU 100% saat backup MySQL berjalan.

## Symptom
- Server production tidak responsif
- CPU usage 100%
- Terjadi saat jam sibuk (peak hours)

## Investigation
- Cek top: proses mysqldump menghabiskan CPU
- Backup schedule: berjalan jam 14:00 (peak traffic)

## Action
- Matikan proses backup
- Reschedule backup ke jam 03:00 (off-peak)

## Result
Server kembali normal setelah backup dihentikan.

## See Also
- [[backup-scheduling]]
- [[mysql-performance-tuning]]

```
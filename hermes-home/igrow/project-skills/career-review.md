# Referensi: Career Review Quarterly (UC5)

Kamu = career analyst iGROW. Review berbasis data wiki/, BUKAN opini generik.

Dipicu cron quarterly (review kuartal yang baru selesai) atau user minta review.

## Langkah
1. Baca: `igrow/wiki/careers/` (semua), `igrow/wiki/self-development/`, `wiki/roadmap/skill-map.md`, entri `igrow/log.md` kuartal yang direview, dan laporan `igrow/output/career-review-*.md` terakhir (kalau ada). Skill map belum ada → generate dulu sesuai SCHEMA; sudah ada → pakai apa adanya (beku per level).
2. Analisis:
   - Learned: topik yang dapat note baru kuartal ini
   - Experienced: incident/pengalaman kuartal ini
   - Improved: topik yang note-nya bertambah/makin dalam
   - Weak: topik target skill map yang statusnya Weak/Belum
   - Pola: 3 tag paling sering di note yang dibuat/diupdate kuartal ini (frontmatter `tags`, `updated` dalam kuartal); topik stagnan (ada note sebelum kuartal ini, 0 note baru); kesalahan berulang (≥ 2 lesson-learned dengan tag sama)
3. Skill Inventory — hitung, bukan kira-kira (aturan hitung + target level di SCHEMA):
   - Target = `## Target L<n+1>` di skill map.
   - Per area: X/Y + bar 10 blok + file bukti + insight singkat (kenapa segitu, langkah berikutnya).
   → OUTPUT: "Linux = 2/3 (performance-tuning.md, systemd-advanced.md) = 67%"
4. Role Fit Trend: hitung % tiap role sekarang (section `## Role Fit` skill map), lalu bandingkan dengan angka di laporan `output/` kuartal sebelumnya.
   - Belum ada laporan sebelumnya → tulis "baseline, belum ada pembanding".
   - Level berubah sejak laporan lalu → tulis "target berubah, tidak dibandingkan".
5. Tulis laporan ke `igrow/output/career-review-<YYYY>-Q<n>.md`.
6. Update `wiki/profile/skills.md` + `wiki/profile/career-summary.md` (format di SCHEMA).
7. Tutup dgn aturan wajib SCHEMA: update output/_index.md + master + log.md (op: review).

## Contoh Eksekusi

Output career-review-2026-Q3.md (ringkas):
- Skill Inventory (target L2): Linux 2/3 = 67% · Monitoring 2/2 = 100% · Networking 1/3 = 33%
- Pola: tag terbanyak linux (9), monitoring (6), performance (4); stagnan: docker; kesalahan berulang: 2 lesson tag `storage` (disk penuh karena log tidak dirotasi)
- Role Fit Trend: SRE 6/8 = 75% (naik dari 5/8 = 63% di Q2 2026)

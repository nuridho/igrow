# Referensi: Career Review Quarterly (UC6)

Kamu = career analyst iGROW. Review berbasis data wiki/, BUKAN opini generik.

Dipicu cron quarterly atau user minta review.

## Langkah
1. Baca: `igrow/wiki/careers/` (semua), `wiki/roadmap/skill-map.md` (AUTO-GENERATE dari `about.md` + careers + self-dev),
   `igrow/log.md` kuartal berjalan.
2. Analisis 4 bagian: Learned (skill baru terdokumentasi kuartal ini), Experienced (insiden/pengalaman), Improved (topik yang notenya makin dalam), Weak (target skill-map yg belum tersentuh).
3. Skill Inventory — hitung, bukan kira-kira:
   % per area = (topik target yang sudah ada notenya di area itu) / (total topik
   target `wiki/roadmap/skill-map.md` untuk area itu). Angka dari counting file,
   bukan reasoning. Tiap bar + insight singkat (kenapa segitu, langkah berikutnya).
4. Role Fit Trend — bandingkan % kecocokan role dari skill-map tahun lalu vs sekarang (naik/turun? Kenapa?).
5. Tulis laporan ke `igrow/output/career-review-<YYYY>-Q<n>.md`.
6. Update `wiki/profile/skills.md` + `career-summary.md`.
7. Tutup dgn aturan wajib SCHEMA: update output/_index.md + master + log.md (op: review).

## Contoh Eksekusi

Output career-review-2025-Q1.md:
- Skill Inventory Q1 2025: Linux 80% mastered, Networking 60%, Cloud 40%
- Role Fit Trend: SRE 75% (naik dari 65% Q4 2024)

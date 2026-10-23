# Referensi: Career Review Quarterly (UC5)

Kamu = career analyst iGROW. Review berbasis data wiki/, BUKAN opini generik.

Dipicu cron quarterly (review kuartal yang baru selesai) atau user minta review.

## Aturan
- Kuartal yang direview = yang disebut di prompt/pesan (cron: "kuartal yang baru selesai"; user: mis. "Q3 2025"). Tidak disebut → kuartal berjalan (data sampai hari ini).
- Prosedur ini TIDAK bertanya ke user (bisa jalan dari cron, tanpa ada yang menjawab). Data kurang → jangan tebak: bagian yang tidak bisa dihitung ditulis "dilewati: <alasan>" di laporan dan balasan. Level tidak tertulis di `Role` about.md, atau lebih dari satu career aktif → lewati Skill Inventory dan pembuatan skill map baru; Role Fit tetap dihitung kalau skill map sudah ada.

## Langkah
1. Baca: `igrow/wiki/careers/` (semua), `igrow/wiki/self-development/`, `wiki/roadmap/skill-map.md`, entri `igrow/log.md` kuartal yang direview, dan laporan pembanding = laporan terakhir di `igrow/output/` untuk kuartal SEBELUM kuartal yang direview (biasanya Q<n-1>; Q1 → Q4 tahun sebelumnya), kalau ada. Skill map belum ada → generate dulu sesuai SCHEMA (kecuali dilewati, lihat Aturan); sudah ada → pakai apa adanya (beku per level).
2. Analisis:
   - Learned: topik yang dapat note baru kuartal ini
   - Experienced: incident/pengalaman kuartal ini
   - Improved: topik yang note-nya bertambah/makin dalam
   - Weak (= Gap): topik target skill map berstatus Weak atau Belum (definisi status di SCHEMA § skill-map.md format)
   - Pola: 3 tag paling sering di note yang dibuat/diupdate kuartal ini (frontmatter `tags`, `updated` dalam kuartal; tag `incident` tidak dihitung karena sudah sama dengan type); topik stagnan (ada note sebelum kuartal ini, 0 note baru); kesalahan berulang = ≥ 2 incident/lesson yang akar masalahnya sama (`## Finding` incident / isi lesson), minimal 1 di kuartal ini, sebut file-nya
3. Skill Inventory — hitung, bukan kira-kira (aturan hitung + target level di SCHEMA):
   - Target = `## Target L<n+1>` di skill map.
   - Per area: X/Y + bar 10 blok + file bukti + insight singkat (kenapa segitu, langkah berikutnya). Ditulis di laporan, mis. "Linux = 2/3 (performance-tuning.md, systemd-advanced.md) = 67%".
4. Role Fit Trend: hitung % tiap role sekarang (section `## Role Fit` skill map), lalu bandingkan dengan laporan pembanding (step 1) dan sebut kuartalnya.
   - Belum ada laporan pembanding → tulis "baseline, belum ada pembanding".
   - Level berubah sejak laporan pembanding → tulis "target berubah, tidak dibandingkan".
5. Tulis laporan ke `igrow/output/career-review-<YYYY>-Q<n>.md`. `<YYYY>-Q<n>` = tahun dan kuartal yang DIREVIEW, bukan tanggal run (cron 1 Jan 2027 → `career-review-2026-Q4.md`). Laporan menyebut target level yang dipakai. File kuartal itu sudah ada (mis. dari review manual di tengah kuartal) → ditimpa.
6. Update `wiki/profile/skills.md` + `wiki/profile/career-summary.md` (format di SCHEMA).
7. Tutup dgn aturan wajib SCHEMA: update `output/_index.md` (laporan) + `wiki/_index.md` (file `profile/` dan `roadmap/skill-map.md` kalau baru dibuat di step 1) + log.md (op: review).
8. Jawaban akhir = isi pesan Telegram (dikirim otomatis, dari cron maupun chat; jangan pakai tool kirim pesan): path laporan + 3–5 baris ringkas: Skill Inventory per area (X/Y) atau "dilewati: <alasan>", Role Fit Trend, hal penting dari Pola (kalau ada), 1 langkah berikutnya. Isi laporan lengkap tidak ditempel ke chat.

## Contoh Eksekusi
Blok di bawah dibagi per tujuan (lihat label `[...]`). Yang terkirim ke Telegram HANYA bagian [JAWABAN AKHIR]; laporan lengkap tetap di file.
````
[PROMPT CRON — 1 Januari 2027 09:00]
Baca igrow/project-skills/career-review.md lalu kerjakan untuk kuartal yang baru selesai.

[FILE DITULIS — igrow/output/career-review-2026-Q4.md (2026-Q4 = kuartal yang direview, bukan tahun run 2027); ringkas; tidak dikirim ke chat]
# Career Review 2026-Q4
Skill Inventory (target L2):
- Linux      ███████░░░   67% (2/3): performance-tuning.md, systemd-advanced.md. Kurang: kernel-basics.
- Monitoring ██████████  100% (2/2): prometheus-alerting.md, grafana-dashboard.md
- Networking ███░░░░░░░   33% (1/3): dns-troubleshooting.md. Kurang: routing, vlan.
Pola: tag terbanyak linux (9), monitoring (6), performance (4); stagnan: docker; kesalahan berulang: disk penuh karena log tidak dirotasi (2026-07-03-disk-full-db.md, 2026-11-14-disk-full-app.md)
Role Fit Trend: SRE 6/8 = 75% (naik dari 5/8 = 63% di 2026-Q3)

[JAWABAN AKHIR — dikirim cron ke Telegram]
Career Review 2026-Q4 tersimpan: igrow/output/career-review-2026-Q4.md
- Skill Inventory (target L2): Linux 2/3 · Monitoring 2/2 · Networking 1/3
- Role Fit: SRE 6/8 = 75% (naik dari 63% di 2026-Q3)
- Kesalahan berulang: disk penuh karena log tidak dirotasi (2 incident)
- Langkah berikutnya: networking (1/3), mulai dari routing
````
Level belum tertulis di `Role` → [JAWABAN AKHIR] baris Skill Inventory jadi `- Skill Inventory: dilewati, level belum tertulis di about.md`.

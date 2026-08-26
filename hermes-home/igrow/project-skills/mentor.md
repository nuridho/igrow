# Referensi: Mentor (UC3)

Dipakai kalau user tanya roadmap belajar, kelemahan, "harus belajar apa".

## Gap analysis — bandingkan 3 sumber
1. Target: `igrow/wiki/learning/skill-map.md` — AUTO-GENERATE kalau belum ada:
   baca `about.md` career aktif (role + jobdesc), tentukan level sekarang,
   tulis skill target 1 level di atasnya (pakai pengetahuan umum jalur karier
   tsb, misal SysAdmin L1 → L2). Human boleh edit kapan pun (human-owned).
2. Terdokumentasi: `igrow/_index.md` (katalog careers + self-development)
3. Terbukti: `igrow/wiki/tests/` (skor per topik)

Knowledge gap = topik target yg TIDAK ada di index ATAU skor `igrow/wiki/tests/` konsisten rendah.

## Output
- Known / Weak / Experience — tabel 3 kolom: skill yg terbukti (tests/ skor bagus + ada note), skill target yg lemah (skor rendah), skill target yg belum tersentuh sama sekali
- Update `wiki/learning/weak-topics.md` + `roadmap.md` kalau ada temuan baru
- Rekomendasi personal ("kamu sudah pernah kena X, mulai dari Y"), BUKAN roadmap generik

## Prasyarat jujur
Kalau tests/ kosong dan careers/ belum ada isi → bilang bahannya belum cukup,
jangan ngarang gap analysis generik. (skill-map kosong BUKAN alasan menolak — generate dulu.)

## Tutup
Kalau ada file ditulis/diupdate (weak-topics, roadmap): ikut aturan wajib SCHEMA
(update wiki/_index.md + master _index.md + log.md, op: update).

# Referensi: Uji Troubleshooting (UC2)

Dipakai kalau user minta diuji ("uji saya soal Linux", "test networking dong").

## Sumber Soal (WAJIB ikuti porsi ini)
- 70% knowledge SUDAH terdokumentasi (wiki/careers/*/knowledge/, wiki/self-development/) — source_type: documented
- 20% target di wiki/roadmap/skill-map.md yg BELUM ada filenya sama sekali — source_type: untouched-target
- 10% topik adjacent yg berkaitan tapi belum eksplisit ditulis — source_type: adjacent

Kalau soal 100% topik baru, hasil gagalnya tidak informatif untuk gap analysis.

## Format Soal
1 skenario incident. JANGAN kasih hint/petunjuk.

## Setelah User Jawab
1. Evaluasi jawaban, kasih score /10 + poin kejawab/kelewat.
2. Nama topik: fuzzy-match ke tag taxonomy di igrow/SCHEMA.md (bukan topics-registry —
   normalisasi topik sekarang lewat taxonomy + igrow/_index.md).
3. Jalankan: `python igrow/project-skills/scripts/confidence_calc.py --topic <topik> --result correct|wrong --date $(date +%F)`
4. Simpan hasil ke `igrow/wiki/tests/<kategori>/<topik>-<tanggal>.md`, frontmatter:
   topic / source_type / date / result / score / mastered / last_increment_date (dari output script).
5. Tampilkan skor terbaru ("skor: 4, belum mastered").
6. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md, master _index.md, log.md (op: test).

## Aturan skor
+1 benar, -1 salah (floor 0), max +1 per topik per hari, mastered >= 5.
Script yg hitung — bukan kamu.

# Referensi: Capture Experience (UC1)

Dipakai kalau user cerita incident/pengalaman kerja (bukan /study).

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

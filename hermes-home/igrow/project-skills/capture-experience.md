# Referensi: Capture Experience (UC1)

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

# Referensi: Dokumentasi Belajar (UC5)

Dipakai kalau user `/study` atau cerita selesai belajar sesuatu.

## Langkah
1. Sumber mentah (link/PDF/artikel)? → dump/tulis ke `igrow/raw/articles/` slug
   `YYYY-MM-DD-nama.md` + frontmatter raw (source_url, ingested).
2. Note terstruktur → `igrow/wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>/`
   Frontmatter ikut SCHEMA (type: learning, sources: [igrow/raw/...]).
   Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also.
3. Topik fuzzy-match ke taxonomy SCHEMA (konsisten lintas sesi).
4. See Also: min 2 dual-link.
5. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md + master + log.md (op: ingest).

## Perintah
"/study baru selesai materi X di KodeKloud: ..." → strukturkan.
"/study bandingkan A dengan B" → page komparasi, tetap di folder sumber yg relevan.

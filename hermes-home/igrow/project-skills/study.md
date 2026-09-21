# Referensi: Dokumentasi Belajar (UC5)

Kamu = wiki compiler iGROW. Artikel/course mentah → structured learning note. Human edit wiki manual = jarang.

Dipakai kalau user `/study` atau cerita selesai belajar sesuatu.

## Langkah
1. Sumber mentah (link/PDF/artikel)? → dump ke `igrow/raw/inbox/` (ikut pipeline AGENTS: inbox → articles/)
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

## Contoh Eksekusi

Input: "/study selesai Redis caching course"

Output: 
- raw/inbox/2025-01-20-redis-caching.md (source dump)
- wiki/self-development/Bootcamp/Redis-Caching/redis-basics.md
  Frontmatter: type: learning, tags: [redis, caching, backend], sources: [igrow/raw/inbox/2025-01-20-redis-caching.md]
  Body: Ringkasan / Detail / Contoh / Referensi / See Also

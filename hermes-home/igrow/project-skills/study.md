# Referensi: Dokumentasi Belajar (UC4)

Kamu = wiki compiler iGROW. Artikel/course mentah → structured learning note. Human edit wiki manual = jarang.

Dipakai kalau user `/study` atau cerita selesai belajar sesuatu.

## Langkah
1. Sumber mentah (link/PDF/artikel)? → dump ke `igrow/raw/inbox/` (ikut pipeline AGENTS: inbox → articles/)
   `YYYY-MM-DD-nama.md` + frontmatter raw (source_url, ingested).
2. Note terstruktur → `igrow/wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>/`
   Frontmatter ikut SCHEMA (type: learning, sources: [igrow/raw/...]).
   Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also.
   Satu folder per sumber belajar, isinya satu atau lebih note per sub-topik (masing-masing template lengkap). JANGAN pecah per jenis isi (concepts/commands/references).
3. Topik fuzzy-match ke `igrow/taxonomy.md` (konsisten lintas sesi).
   → OUTPUT: "Topik = <tag> (cocok dengan taxonomy: <alasan singkat>)"
4. See Also: min 2 dual-link.

5. Self-check sebelum tulis file — ada yang kurang → STOP, perbaiki dulu:
   - Frontmatter lengkap 7 field wajib? (title/created/updated/type/tags/sources/confidence)
   - Tags ⊂ `igrow/taxonomy.md`?
   - sources: prefix `igrow/raw/...` atau `[]`? (BUKAN path relatif)
   - Min 2 dual-link See Also? (format SCHEMA: `[[slug|Name]] ([Name](../path/slug.md))`)
6. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md + master + log.md (op: ingest).

## Perintah
"/study baru selesai materi X di KodeKloud: ..." → strukturkan.
"/study bandingkan A dengan B" → page komparasi, tetap di folder sumber yg relevan.
"/study ... ringkasin buat level saya" → kedalaman disesuaikan level di `Role` about.md career aktif.

## Contoh Eksekusi

Input: "/study selesai Redis caching course"

Output: 
- raw/inbox/2026-09-20-redis-caching.md (source dump; setelah diproses dipindah ke igrow/raw/articles/)
- wiki/self-development/Bootcamp/Redis-Caching/redis-basics.md
  Frontmatter: type: learning, tags: [storage, performance], sources: [igrow/raw/articles/2026-09-20-redis-caching.md]
  Body: Ringkasan / Detail / Contoh / Referensi / See Also

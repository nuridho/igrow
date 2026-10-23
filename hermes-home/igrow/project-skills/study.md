# Referensi: Dokumentasi Belajar (UC4)

Kamu = wiki compiler iGROW. Artikel/course mentah → structured learning note. Human edit wiki manual = jarang.

Dipakai kalau user `/study` atau cerita selesai belajar sesuatu.

## Langkah
1. Sumber mentah (link/PDF/artikel)? → redact dulu data DILARANG KERAS (`AGENTS.md`; `raw/` immutable), lalu dump ke `igrow/raw/inbox/` (ikut pipeline AGENTS: inbox → articles/)
   `YYYY-MM-DD-nama.md` + frontmatter raw (source_url, ingested). Tidak ada sumber mentah → lewati, `sources: []`.
2. Note terstruktur → `igrow/wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>/`
   Frontmatter ikut SCHEMA (type: learning, sources: [igrow/raw/articles/<file raw>] — path tujuan setelah dipindah di step 6).
   Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also.
   Satu folder per sumber belajar, isinya satu atau lebih note per sub-topik (masing-masing template lengkap). JANGAN pecah per jenis isi (concepts/commands/references).
3. Topik fuzzy-match ke `igrow/taxonomy.md` (konsisten lintas sesi).
   → OUTPUT: "Topik = <tag> (cocok dengan taxonomy: <alasan singkat>)"
4. See Also: min 2 dual-link. Target belum ada → placeholder (SCHEMA § Link).

5. Self-check sebelum tulis file — ada yang kurang → STOP, perbaiki dulu:
   - Bebas data DILARANG KERAS (`AGENTS.md`), termasuk di title dan nama file? Paling rawan: Detail dan Contoh (command/config dari dokumentasi internal). Ada → redact cara `AGENTS.md`: nilainya diganti placeholder, command/config tetap utuh.
   - Frontmatter lengkap 7 field wajib? (title/created/updated/type/tags/sources/confidence)
   - Tags ⊂ `igrow/taxonomy.md`?
   - sources: prefix `igrow/raw/...` atau `[]`? (BUKAN path relatif)
   - Min 2 dual-link See Also? (format SCHEMA: `[[slug|Name]] ([Name](../path/slug.md))`)
6. Tutup dgn aturan wajib SCHEMA: pindahkan file raw dari `raw/inbox/` ke `igrow/raw/articles/` (nama sama; baru setelah note tertulis, jadi inbox kosong = sudah diproses), lalu update `raw/_index.md` (kalau ada file raw) + wiki/_index.md (+ baris placeholder kalau ada) + master + log.md (op: ingest).
7. Balas ke user (format bagian [BALASAN KE USER] di Contoh Eksekusi; balasan bukan bagian file note): path note + path sumber di `raw/articles/` + topik & alasan (baris `→ OUTPUT` step 3); **Rangkuman** per note dari isi yang sudah diredaksi: 1 kalimat inti + 2–4 poin yang dipelajari (command penting boleh disebut); link placeholder baru (kalau ada), jenis data yang diredaksi (sebut jenisnya, bukan nilainya). Isi note lengkap hanya kalau user minta.

## Perintah
"/study baru selesai materi X di KodeKloud: ..." → strukturkan.
"/study bandingkan A dengan B" → page komparasi, tetap di folder sumber yg relevan.
"/study ... ringkasin buat level saya" → kedalaman disesuaikan level di `Role` about.md career aktif.

## Contoh Eksekusi
Blok di bawah berisi 3 bagian dengan tujuan berbeda (lihat label `[...]`). Yang dikirim ke chat HANYA bagian [BALASAN KE USER].
````
[PESAN USER — masuk dari Telegram]
/study selesai course Redis caching, ini ringkasan materinya: <teks materi>

[FILE & INDEX YANG DITULIS — tidak dikirim ke chat]
- raw/inbox/2026-09-20-redis-caching.md (dump materi yang sudah diredaksi; setelah note tertulis dipindah ke igrow/raw/articles/2026-09-20-redis-caching.md)
- wiki/self-development/Bootcamp/Redis-Caching/redis-basics.md
  Frontmatter: type: learning, tags: [storage, performance], sources: [igrow/raw/articles/2026-09-20-redis-caching.md]
  Body: Ringkasan / Detail / Contoh / Referensi / See Also
- Index: raw/_index.md (articles/2026-09-20-redis-caching.md) + wiki/_index.md + master; log.md op ingest

[BALASAN KE USER — dikirim ke Telegram; hanya bagian ini yang terlihat user]
Tersimpan: wiki/self-development/Bootcamp/Redis-Caching/redis-basics.md
Sumber: igrow/raw/articles/2026-09-20-redis-caching.md
Topik = storage, performance (cocok dengan taxonomy: caching = storage, tujuannya menurunkan latency = performance)

Rangkuman redis-basics:
Inti: Redis dipakai sebagai cache in-memory supaya baca data tidak selalu ke database.
- Pola cache-aside: cek cache dulu; miss → ambil dari DB, lalu simpan ke cache
- TTL (`EXPIRE key detik`) supaya data basi hilang sendiri
- `redis-cli INFO stats` → lihat keyspace_hits vs keyspace_misses untuk cek efektivitas cache

Link placeholder baru: redis-eviction-policy, cache-invalidation
Diredaksi: tidak ada
````

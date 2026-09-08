---
title: iGROW Schema
schema_state: advisory
created: 2026-08-25
updated: 2026-08-25
---

# iGROW Schema

Aturan main wiki iGROW. Advisory: agent boleh deviasi, tapi harus bilang.

## Layer
- `raw/` — sumber asli, IMMUTABLE. Redact SEBELUM ingest. Slug: `YYYY-MM-DD-nama.md`. Dump file ke `igrow/raw/inbox/`, agent proses → pindah `igrow/raw/articles/` (inbox kosong = semua sudah diproses). Path di frontmatter & body SELALU lengkap dari root: `igrow/raw/...`.
- `wiki/` — semua konten compiled, agent-owned.
- `output/` — laporan turunan (career review, dst).
|- Pengecualian human-owned (agent update cuma kalau diminta): `wiki/roadmap/skill-map.md`, `wiki/profile/career-goals.md`, semua `about.md` (kecuali saat daftar kerjaan baru — agent boleh auto-tutup career lama & auto-bikin about.md career baru).

## Tiap operasi tulis WAJIB diakhiri
1. Update `_index.md` terdekat (raw/ atau wiki/ atau output/).
2. Update master `igrow/_index.md`.
3. Append `log.md`: `## [YYYY-MM-DD] op | subjek`. Ops: init, ingest, update, lint, review, archive.

## Frontmatter page wiki/
```yaml
---
title: Judul
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: knowledge | incident | lesson | learning | profile | query | data
tags: [dari taxonomy]
sources: [igrow/raw/articles/xxxx.md]   # selalu ada; `[]` kalau murni cerita user
confidence: high | medium | low   # dukungan SUMBER (bukan penguasaanmu)
contradictions: [slug-lain]       # opsional
---
```
`about.md` & `careers/*/skills.md` tetap plain `Key: value` (bukan frontmatter).

## Body note (wiki/careers/, wiki/self-development/)
```markdown
# <title>

## Ringkasan
1–3 kalimat: apa ini & kenapa penting.

## Detail
Poin berbobot (bullet oke) — padat, bukan narasi kosong.

## Contoh
Minimal 1 contoh nyata (command / config / kasus).

## Referensi
Sumber (URL / igrow/raw/... / sesi) — buat napak tilas.

## See Also
Min 2 dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
```
Khusus incident di careers/, Detail diganti alur: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
Data file (`roadmap/`, `profile/`) → body list/key:value, bukan narasi. Frontmatter minimal:
```yaml
---
title: Skill Map
type: data
updated: YYYY-MM-DD
---
```

## Tag taxonomy (tambah baru di sini DULU)
linux, networking, monitoring, incident, docker, kubernetes, cloud, security, storage, performance, dns, windows-server, vmware, devops, sre, cve

## Link
- Antar-page: `[[slug]]` minimal 2 outbound per page.
- Section `## See Also` wajib dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
- Narasi biasa cukup `[[slug]]`.

## Threshold
- Bikin page: topik muncul 2+ sumber ATAU sentral di 1 sumber.
- Split page >200 baris.
- Master `_index.md` >200 baris → split index per subfolder wiki/.

## skill-map.md format
```markdown
# Skill Map — <Level>
## Target L<n>
- Area: topik, topik, topik
```
- Template baku untuk `wiki/roadmap/skill-map.md` (human-owned).
- `% Skill Inventory` = (topik mastered) / (total topik di skill-map) per area.

## Honest gaps
Wiki gak punya jawaban → bilang jujur + usulkan ingest apa.

## DILARANG KERAS (berlaku juga raw/)
Credential, API key/token, IP internal, hostname sensitif, data client, screenshot tanpa redact.

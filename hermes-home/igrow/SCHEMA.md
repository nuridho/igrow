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
- Career aktif: `about.md` yang belum ada tanggal selesai = aktif. Incident baru masuk ke career itu.

|- Pengecualian human-owned (agent update cuma kalau diminta): semua `about.md` (kecuali saat daftar kerjaan baru — agent boleh auto-tutup career lama & auto-bikin about.md career baru).
|- Pengecualian human-owned lain: semua `about.md`.
|- `skill-map.md` = AUTO-GENERATE (bukan human-owned). Agent baca `about.md` + seluruh `careers/` + `self-development/` + `lessons-learned/` → generate skill map per level + role-fit matching. User boleh edit manual, tapi bukan keharusan.

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
type: knowledge | incident | lesson | learning | profile | data
tags: [dari taxonomy]
sources: [igrow/raw/articles/xxxx.md]   # selalu ada; `[]` kalau murni cerita user
confidence: high | medium | low   # dukungan SUMBER (bukan penguasaanmu)
contradictions: [slug-lain]       # opsional
---
```
- `about.md` & `careers/*/skills.md` tetap plain `Key: value` (bukan frontmatter).
- `skill-map.md` → frontmatter minimal + body list/key:value per level (bukan data type — auto-generate, bukan manual input).

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
Body per data file: `weak-topics.md` → `- topik — alasan`; `profile/skills.md` → `- Area  ███████░░░  NN% (X/Y)` (bar 10 blok, angka sama dengan Skill Inventory career review terakhir); `profile/career-summary.md` → 1 baris per career: `- <folder career>: <Role> · <Period> · N incident · N knowledge · N lesson` (Role & Period dari `about.md`, career aktif = `s/d sekarang`; N = hitung file: `knowledge/incidents/`, `knowledge/` tanpa `incidents/`, `lessons-learned/`); `skill-map.md` → lihat section format di bawah.

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
- Template baku untuk `wiki/roadmap/skill-map.md` (AUTO-GENERATE, bukan manual input).
- `% Skill Inventory` = (topik mastered) / (total topik di skill-map) per area.
- `skill-map.md` juga punya section `## Role Fit` — daftar role yang user cocok (persentase kecocokan berdasarkan skill yang ada) + gap per role.

## Honest gaps
Wiki gak punya jawaban → bilang jujur + usulkan ingest apa.

## DILARANG KERAS (berlaku juga raw/)
Credential, API key/token, IP internal, hostname sensitif, data client, screenshot tanpa redact.

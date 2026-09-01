---
title: iGROW Schema
schema_state: advisory
created: 2026-08-25
updated: 2026-08-25
---

# iGROW Schema

Aturan main wiki iGROW. Advisory: agent boleh deviasi, tapi harus bilang.

## Layer
- `raw/` — sumber asli, IMMUTABLE. Redact SEBELUM ingest. Slug: `YYYY-MM-DD-nama.md`. Dump file ke `raw/inbox/`, agent proses → pindah `.processed/`.
- `wiki/` — semua konten compiled, agent-owned.
- `output/` — laporan turunan (career review, dst).
- Pengecualian human-owned (agent update cuma kalau diminta): `wiki/roadmap/skill-map.md`, `wiki/profile/career-goals.md`, semua `about.md`.

## Tiap operasi tulis WAJIB diakhiri
1. Update `_index.md` terdekat (raw/ atau wiki/ atau output/).
2. Update master `igrow/_index.md`.
3. Append `log.md`: `## [YYYY-MM-DD] op | subjek`. Ops: ingest, update, query, test, lint, review, archive.

## Frontmatter page wiki/
```yaml
---
title: Judul
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: knowledge | incident | lesson | test | learning | profile | query
tags: [dari taxonomy]
sources: [raw/articles/xxxx.md]   # kosongkan kalau murni cerita user
confidence: high | medium | low   # dukungan SUMBER, beda dari skor tests/
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
Sumber (URL / raw/... / sesi) — buat napak tilas.

## See Also
Min 2 dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
```
Khusus incident di careers/, Detail diganti alur: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
`wiki/tests/` tanpa section baku — frontmatter skor + narasi singkat jawaban & feedback:
```yaml
---
topic: iowait                  # nama topik baku — fuzzy-match ke taxonomy
source_type: documented        # documented | untouched-target | adjacent
date: YYYY-MM-DD               # tanggal test (bukan created/updated — file ini tak pernah diedit)
result: correct | wrong
score: 4                       # dari confidence_calc.py
mastered: false                # dari confidence_calc.py
last_increment_date: YYYY-MM-DD  # dari confidence_calc.py — WAJIB, penanda max +1/hari
---
```
Data file (`roadmap/`, `profile/`) → body list/key:value, bukan narasi.

## Tag taxonomy (tambah baru di sini DULU)
linux, networking, monitoring, incident, docker, kubernetes, cloud, security, storage, performance, dns, windows-server, vmware, devops, sre, cve, interview-prep

## Link
- Antar-page: `[[slug]]` minimal 2 outbound per page.
- Section `## See Also` wajib dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
- Narasi biasa cukup `[[slug]]`.

## Threshold
- Bikin page: topik muncul 2+ sumber ATAU sentral di 1 sumber.
- Split page >200 baris.
- Master `_index.md` >200 baris → split index per subfolder wiki/.

## Honest gaps
Wiki gak punya jawaban → bilang jujur + usulkan ingest apa.

## DILARANG KERAS (berlaku juga raw/)
Credential, API key/token, IP internal, hostname sensitif, data client, screenshot tanpa redact.

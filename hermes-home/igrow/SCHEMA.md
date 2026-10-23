---
title: iGROW Schema
created: 2026-08-25
updated: 2026-10-23
---

# iGROW Schema

Aturan main wiki iGROW. **Wajib diikuti.** Kasus yang tidak tercakup aturan mana pun → ikuti aturan terdekat, lalu sebutkan di balasan. Jangan menyimpang dari aturan yang sudah ada.

## Layer
- `raw/` — sumber asli, IMMUTABLE. Redact SEBELUM ingest. Slug: `YYYY-MM-DD-nama.md`. Dump file ke `igrow/raw/inbox/`, agent proses → pindah `igrow/raw/articles/` (inbox kosong = semua sudah diproses). Path di frontmatter & body SELALU lengkap dari root: `igrow/raw/...`.
- `wiki/` — semua konten compiled, agent-owned.
- `output/` — laporan turunan (career review, dst).

## Career aktif & kepemilikan
- Career aktif = folder `wiki/careers/career-N-*` yang `about.md`-nya belum punya tanggal selesai. Cerita kerja baru masuk ke career itu.
- `about.md` = milik user. Agent hanya boleh menulisnya di alur Daftar Kerjaan Baru (tutup career lama + bikin `about.md` career baru). `Role` wajib memuat level (mis. `Infra Engineer L1`).
- `skill-map.md` = dibuat agent, beku per level (lihat "skill-map.md format"). User boleh edit manual.

## Tiap operasi tulis WAJIB diakhiri
1. Update `_index.md` terdekat (raw/ atau wiki/ atau output/), termasuk "Last updated". Tidak ada master index di `igrow/`.
2. Append `igrow/log.md`: `## [YYYY-MM-DD] op | subjek`. Ops: init, ingest, update, lint, review.

## Frontmatter page wiki/
```yaml
---
title: Judul
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: knowledge | incident | lesson | learning | data
tags: [dari igrow/taxonomy.md]
sources: [igrow/raw/articles/xxxx.md]   # selalu ada; `[]` kalau murni cerita user
confidence: high | medium | low   # dukungan SUMBER (bukan penguasaanmu)
contradictions: [slug-lain]       # opsional; HANYA slug note yang isinya bertentangan
---
```
- Note naratif (`knowledge`, `incident`, `lesson`, `learning`) → 7 field wajib di atas.
- Data file (`roadmap/`, `profile/`) → `type: data`, frontmatter minimal (lihat "Data file").
- `about.md` & `careers/*/skills.md` → plain `Key: value`, TANPA frontmatter.

## Body note (wiki/careers/, wiki/self-development/)
```markdown
# <title>

## Ringkasan
1–3 kalimat: apa ini & kenapa penting.

## Detail
Poin berbobot (bullet oke) — padat, bukan narasi kosong.

## Contoh
Minimal 1 contoh nyata (command / config / kasus). Tiap command diberi komentar singkat (apa yang dicek & kenapa), urut sesuai flow.

## Referensi
Sumber (URL / igrow/raw/... / sesi) — buat napak tilas.

## See Also
Min 2 dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
```
Khusus incident di careers/, Detail diganti alur: Symptom / Investigation / Finding / Action / Result / Lesson Learned. Investigation ditulis urut per langkah: apa yang dicek → hasilnya → kenapa lanjut ke langkah berikutnya.

## Data file
Frontmatter minimal:
```yaml
---
title: <Judul>
type: data
updated: YYYY-MM-DD
---
```
Body berupa list, bukan narasi:
- `roadmap/weak-topics.md` → `- topik — alasan`
- `roadmap/skill-map.md` → lihat "skill-map.md format"
- `profile/skills.md` → `- Area  ███████░░░  NN% (X/Y)` (bar 10 blok, angka sama dengan Skill Inventory career review terakhir)
- `profile/career-summary.md` → 1 baris per career: `- <folder career>: <Role> · <Period> · N incident · N knowledge · N lesson` (Role & Period dari `about.md`, career aktif = `s/d sekarang`; N = hitung file: `knowledge/incidents/`, `knowledge/` tanpa `incidents/`, `lessons-learned/`)

## Tag taxonomy
Daftar tag resmi = `igrow/taxonomy.md` (agent-owned, tidak ditimpa deploy). Tag baru ditambah di sana DULU, hanya kalau user setuju; lalu cukup append `igrow/log.md` (op: update, subjek `tag <nama>`), tanpa update `_index.md`.

## Link
- Slug = nama file note tanpa `.md`: huruf kecil, angka, dan `-` (kebab-case). Incident: `YYYY-MM-DD-<slug>`, tanggal = tanggal kejadian di Ringkasan (pakai tanggal perkiraan kalau "sekitar"). Knowledge, lesson, learning: slug topik saja.
- Slug unik di antara semua note di `wiki/` (file data `about.md`, `skills.md`, `_index.md`, `roadmap/`, `profile/` tidak dihitung). Sebelum menulis note baru, cek `_index.md` di `wiki/`: slug sudah dipakai note bertopik sama → edit note itu (cerita lanjutan); topik beda → tambah konteks pembeda (sistem, sumber, atau career), mis. `disk-full-nas`; slug tercatat sebagai placeholder → itu note yang ditunggu (aturan placeholder di bawah).
- Antar-page: `[[slug]]` minimal 2 outbound per page.
- Section `## See Also` wajib dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
- Narasi biasa cukup `[[slug]]`.
- Target belum ada → tetap boleh ditaut (placeholder): slug belum tercatat → tambah baris di `_index.md` terdekat dari path target: `| <path target> | (placeholder) | - | - |`; sudah tercatat → pakai path di baris itu, jangan bikin baris kedua.
- Menulis note baru → cek `_index.md` dulu: slug-nya ada sebagai placeholder → ganti baris itu dengan baris biasa, dan masukkan page yang menautnya (cari `[[slug`) ke See Also note baru. Path note beda dari path placeholder → perbaiki juga link `(...)` di page penaut itu.
- Link balik: note baru menaut ke note lama yang sudah ada → tambah dual-link ke note baru di See Also note lama itu (kalau belum ada). Hanya note yang memang ditaut, jangan scan seluruh wiki. Ini bukan perubahan isi: `updated:` note lama dan barisnya di index tidak diganti (career review membaca `updated` sebagai aktivitas kuartal); cukup disebut di subjek log operasi yang sama, mis. `## [2026-09-20] ingest | 2026-09-19-mysql-backup-cpu-spike (+ link balik: cpu-spike-triage)`.

## Threshold
- Bikin page: topik muncul 2+ sumber ATAU sentral di 1 sumber.
- Split page >200 baris.
- `wiki/_index.md` >200 baris → pecah per subfolder (`careers/_index.md`, `self-development/_index.md`, …); `wiki/_index.md` tetap ada sebagai penunjuk ke index-index itu.

## skill-map.md format
```markdown
# Skill Map — <Role>
## Target L<n>
- Area: topik, topik, topik
## Role Fit
- <Role lain>: topik, topik, topik
```
- Dibuat dari `about.md` career aktif + seluruh `careers/` + `self-development/`.
- **Beku per level.** Generate ulang HANYA kalau: file belum ada, user naik level, atau `Role` career aktif berubah. Data baru TIDAK memicu generate ulang. Setiap generate ulang → log op `update` + alasannya.
- **Target Skill Inventory** = `## Target L<n+1>`, n = level di `Role` career aktif. Level tidak tertulis → tanya user 1x. Naik level → bar di-reset ke target baru.
- **Topik "punya note"** = ada note yang `title` atau `## Ringkasan`-nya membahas topik itu. Cuma disinggung di note lain (mis. di incident) = belum dihitung. Selalu sebut file buktinya.
- **Status topik** (definisi yang sama untuk mentor dan career review): Known = punya note (aturan di atas) · Weak = belum punya note, tapi disinggung di isi note lain (sebut file-nya) · Belum = tidak muncul di note mana pun. Gap = Weak + Belum. Yang dicari hanya note naratif di `careers/` dan `self-development/`, bukan `skill-map.md` (memuat semua topik target), `profile/`, `about.md`, atau `skills.md`.
- `% Skill Inventory` per area = topik target yang punya note / total topik target area itu. Selalu tulis X/Y.
- `% Role Fit` per role = topik role yang punya note / total topik role itu (X/Y). Skill map hanya menyimpan daftar topik; persentase dihitung saat dipakai.

## Honest gaps
Wiki gak punya jawaban → bilang jujur + usulkan ingest apa.

## DILARANG KERAS
Daftar lengkap di `AGENTS.md` § DILARANG KERAS (berlaku juga raw/: redact SEBELUM ingest).

# iGROW + Pola Wiki — Rancangan (to-be)

> Status: DIIMPLEMENTASIKAN di `migrationToNvkWikiLLM/hermes-home/` (2026-08-25), deployed ke VPS via `scp -r migrationToNvkWikiLLM/hermes-home/. nuridho@<vps>:~/whatsinsidegit/igrow-hermes/hermes-home/` + chown (2026-08-26). Testing berjalan (test-flow.md).
> Dasar: gist Karpathy + nvk/llm-wiki AGENTS.md (copy: `migrationToNvkWikiLLM/AGENTSnvk.md`).
> Prinsip: Hermes tetap otaknya. Wiki pattern merapikan cara nyimpen & navigasi di `igrow/`.
> Analogi: `igrow/` = nvk `topics/<nama>/` — satu topik (karier kamu), bukan hub multi-topik.
> KEPUTUSAN: varian **B** — layer compiled dipisah fisik di `igrow/wiki/` (faithful nvk).

## Fitur nvk → verdict buat iGROW

| Fitur nvk | Fungsi di nvk | iGROW butuh? | Verdict |
|---|---|---|---|
| Hub + multi-topic wikis | Satu wiki per domain bebas | ❌ iGROW satu domain; igrow/ = 1 topic wiki | Skip |
| `.archive/` topic wikis | Arsip topik mati | Parsial — career selesai cukup pakai `about.md` tanggal selesai | Skip |
| `wiki/` = layer compiled, dipisah dari raw/ | Ketegasan ownership fisik | ✅ agent punya wiki/, human punya file pengecualian, sumber di raw/ | **Ambil (inti varian B)** |
| `_index.md` tiap direktori wiki-managed | Katalog per folder | ✅ ikuti nvk: master + raw/ + wiki/ + output/; per-subfolder add when master >200 baris | **Ambil (4 file)** |
| `log.md` append-only | Jurnal aksi parseable | ✅ | **Ambil** — 7 op: ingest, update, query, test, lint, review, archive |
| Raw immutable + slug `YYYY-MM-DD-nama` | Sumber asli tak pernah diedit, kronologis | ✅ | **Ambil** |
| `inbox/` drop zone | Dump file, diproses → .processed/ | ✅ UC5: lempar artikel mentah, agent proses nanti | **Ambil (raw/inbox/)** |
| Dual-link `[[slug\|Name]] ([Name](path))` | Jalan di Obsidian+agent+GitHub | Parsial — wajib di `## See Also` + antar-page; dalam kalimat narasi cukup wikilink | **Ambil (dibatasi)** |
| Confidence frontmatter `high\|med\|low` | Dukungan sumber per artikel | ✅ beda konteks dgn skor tests/ (penguasaanmu) — bedakan di SCHEMA | **Ambil** |
| Kontradiksi diflag | Frontmatter + lint | ✅ | **Ambil** |
| `schema_state: advisory` | Schema panduan, deviasi boleh asal bilang | ✅ cocok 1 user; strict overkill | **Ambil** |
| Honest gaps | Wiki gak punya → bilang + usulkan ingest | ✅ selaras /recall | **Ambil** |
| Lint rutin via cron | Wiki sehat tanpa diingat | ✅ 1 cron mingguan | **Ambil** |
| `inventory/` (items/ideas/candidates/entities) | Tracker dgn status/priority/next-action | ❌ UC2/3 sudah punya skill-map + tests/ | Skip — add when antrian bacaan terstruktur muncul |
| `datasets/` manifest | Data besar/eksternal | ❌ | Skip |
| Session capture + feedback | Checkpoint sesi agent | ❌ Hermes sessions/ + memory built-in | Skip (built-in) |
| Private adapters | Kontrak tool eksternal | ❌ | Skip |
| Research modes + thesis + checkpoints | Pipeline riset multi-agent | ❌ bukan platform riset | Skip |
| `output/` artifacts | Deck/chart/dok turunan | ✅ rumah buat laporan UC6 (career review quarterly) | **Ambil** |
| wikis.json registry | Registry multi-wiki | ❌ 1 wiki doang | Skip |

## Struktur to-be (varian B)

```
hermes-home/                          # host → /opt/data (HERMES_HOME), 1 volume
├── .env                              # SECRET (tetap)
├── config.yaml                       # (tetap)
├── SOUL.md                           # (tetap)
├── AGENTS.md                         # tetap padat + 1 baris pointer ke igrow/SCHEMA.md
├── (state internal Hermes — jangan di-push)
└── igrow/                            # 📦 = 1 topic wiki; yang di-sync Git
    ├── SCHEMA.md          ← BARU: aturan format, frontmatter, tag, threshold, ownership
    ├── _index.md          ← BARU: master katalog, 1 baris per page
    ├── log.md             ← BARU: ## [YYYY-MM-DD] op | subjek
    ├── raw/               ← BARU: sumber IMMUTABLE, slug YYYY-MM-DD-nama.md
    │   ├── _index.md      ← BARU: tabel sumber (murah, konsisten dgn aturan)
    │   ├── inbox/         ← BARU: drop zone → diproses → .processed/
    │   ├── articles/
    │   └── notes/
    ├── wiki/              ← BARU: SEMUA konten compiled, agent-owned
    │   ├── _index.md      ← BARU: katalog level wiki/
    │   ├── careers/           (pindah dari igrow/careers/)
    │   ├── self-development/  (pindah)
    │   ├── learning/          (pindah)
    │   ├── tests/             (pindah)
    │   └── profile/           (pindah)
    ├── output/            ← BARU: laporan turunan (UC6 career review, dst) + _index.md
    └── project-skills/    (tetap di root igrow/ — ini instruksi, bukan konten)
```

Ownership:
- Agent nulis: `wiki/**`, `_index.md`, `log.md`, `raw/_index.md`, `output/`
- Human-owned (agent update cuma kalau diminta): `wiki/learning/skill-map.md`, `wiki/profile/career-goals.md`, semua `about.md`
- Tak tersentuh siapa pun setelah masuk: `raw/` (kecuali .processed/)
- Aturan DILARANG KERAS berlaku juga ke raw/ — redact SEBELUM ingest, raw immutable.

## Pembagian kerja

| Bagian | Dari mana |
|---|---|
| Ingest sumber → raw/ + update page | skill `llm-wiki` (terinstall) |
| Query baca _index dulu | skill `llm-wiki` |
| Lint (orphan, broken link, kontradiksi, stale) | skill `llm-wiki` + cron mingguan |
| UC2 uji + confidence score | project-skills `test-me.md` (tetap) |
| UC6 career review → output/ | project-skills `career-review.md` (tetap) |
| AGENTS.md root | tetap padat + 1 baris pointer |

## Yang diserap dari nvk AGENTS.md

1. Layer split fisik: `raw/` immutable vs `wiki/` compiled.
2. Dual-link di `## See Also` + antar-page: `[[slug|Name]] ([Name](../path/slug.md))`.
3. `_index.md` dibaca dulu sebelum scan folder; tiap operasi tulis diakhiri update _index + log.
4. log.md prefix konsisten: `## [YYYY-MM-DD] op | subjek` — grep-able.
5. Slug raw: `YYYY-MM-DD-nama.md`.
6. Frontmatter: `confidence: high|medium|low`, `contradictions: [slug]`, `sources: [raw/...]`.
7. `## See Also` wajib min 2 link per page (anti-orphan).
8. Honest gaps: jawab jujur + usulkan ingest.

## Risiko & mitigasi

| Risiko | Mitigasi |
|---|---|
| _index/log lupa diupdate → basi | 3 lapis: (1) aturan SCHEMA "tiap tulis → update _index + log"; (2) cron lint mingguan bandingkan filesystem vs _index; (3) log.md append-only = jejak rekonstruksi |
| Dual-link relatif rusak saat file pindah | Lint cek link; format sudah antisipasi |
| Data sensitif masuk raw/ (immutable, gak bisa dihapus) | Redact SEBELUM ingest; DILARANG KERAS berlaku di raw/ |
| Confidence frontmatter ketuker dgn skor tests/ | SCHEMA bedakan: page = dukungan sumber; tests/ = penguasaan |
| Path wiki/... +1 segmen di semua referensi | Diterima — harga ketegasan layer |

## TODO sebelum eksekusi

- [x] Tulis SCHEMA.md final (tag taxonomy: linux, networking, monitoring, incident, dst)
- [x] Template frontmatter per jenis page — diputuskan nvk penuh (topic→tags, summary→body Ringkasan, date→created/updated, source→sources); tests/ tetap pakai field skor sendiri
- [x] Update iGROW_FINAL.md: struktur folder, semua contoh path, contoh AGENTS.md
- [x] Update build.md kalau ada path berubah (mount igrow-api → `hermes-home/igrow` tetap, aman)
- [x] Update project-skills/* path referensi careers/... → wiki/careers/...
- [x] 1 baris pointer di contoh AGENTS.md

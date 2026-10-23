# iGROW: Product Requirements Document

| | |
|---|---|
| **Produk** | iGROW: Personal Career & Knowledge OS untuk IT worker |
| **Owner** | Nuridho (Product Owner, sekaligus satu-satunya user) |
| **Versi PRD** | 1.4 |
| **Status produk** | Phase 1 selesai · Phase 2 berjalan (runtime jalan, automation belum aktif) |
| **Terakhir diperbarui** | 2026-10-23 |

## Ringkasan Eksekutif

Pengalaman kerja seorang IT worker (incident yang ditangani, hal yang dipelajari, skill yang tumbuh) biasanya tercecer di chat, tiket, dan wiki kantor. Saat resign, semuanya tertinggal. iGROW mengubah cerita sehari-hari yang dikirim lewat Telegram menjadi **knowledge base markdown pribadi yang terstruktur, portable, dan terukur**. Hermes Agent menjadi "otak" yang mencatat, mengajari, memberi briefing, dan mereview karier. Aset utamanya adalah file markdown di `igrow/`, bukan AI-nya.

> **Prinsip besar:** jangan membangun "Hermes project". Bangun **iGROW**, dan gunakan Hermes sebagai otaknya.

## Isi Dokumen

| # | Dokumen | Menjawab pertanyaan |
|---|---|---|
| 01 | [Overview](01-overview.md) | Kenapa iGROW ada, untuk siapa, dan apa ukuran suksesnya |
| 02 | [Use Cases](02-use-cases.md) | Apa yang bisa dilakukan user, beserta acceptance criteria |
| 03 | [Requirements](03-requirements.md) | Kebutuhan fungsional, non-fungsional, dan kebijakan data |
| 04 | [Architecture](04-architecture.md) | Bagaimana sistem disusun dan data mengalir |
| 05 | [Roadmap](05-roadmap.md) | Fase rilis, status saat ini, dan backlog prioritas |
| 06 | [Risks & Decisions](06-risks-decisions.md) | Risiko, keputusan yang sudah diambil, dan pertanyaan terbuka |

Urutan baca yang disarankan: 01 → 02 → 05, lalu 03/04/06 sesuai kebutuhan.

### Dokumen Kerja (selalu diperbarui)

| Dokumen | Isi |
|---|---|
| [To-Do](todo.md) | Bug, kontradiksi, dan improvement **khusus `hermes-home/`** (kode permanen C/W/I/A, format Act/Impact) |
| [Backlog](backlog.md) | Riwayat setiap update project, terbaru di atas, termasuk apakah perlu deploy ke VPS |

## Hierarki Sumber Kebenaran

Kalau dua dokumen saling bertentangan, ikuti urutan ini:

1. **`hermes-home/`**: perilaku runtime yang benar-benar dijalankan Hermes. Kalau PRD bentrok dengan isi folder ini, runtime yang dianggap benar, lalu PRD diperbaiki.
2. **`PRD/`**: maksud produk (apa yang dibangun dan kenapa).
3. **`docs/`**: detail teknis dan runbook (`build.md`, `vpslab.md`).

Blueprint awal (`iGROW_FINAL.md`) sudah diarsipkan di `archive/`. Seluruh isinya yang masih berlaku sudah dipindah ke PRD ini (D-21).

**Aturan penulisan PRD:** PRD tidak menyalin aturan runtime seperti format frontmatter, daftar tag, atau langkah prosedur UC. PRD cukup merujuk file aslinya, supaya tidak ada dua versi aturan yang bisa saling menyimpang. Pola drift seperti itu adalah sumber mayoritas bug di [`todo.md`](todo.md).

## Glosarium

| Istilah | Arti |
|---|---|
| **Hermes** | Hermes Agent dari Nous Research (image Docker resmi `nousresearch/hermes-agent`). Berfungsi sebagai agent LLM + gateway Telegram + scheduler cron. |
| **`HERMES_HOME`** | Folder data Hermes, `/opt/data` di container. Di host: `whatsinsidegit/igrow-hermes/hermes-home/`. |
| **`igrow/`** | Subfolder `HERMES_HOME` yang berisi seluruh data iGROW. Hanya folder ini yang dianggap aset portable. |
| **`AGENTS.md`** | Aturan inti yang otomatis dimuat Hermes di setiap sesi. |
| **Project skill** | File markdown prosedur per use case di `igrow/project-skills/`. Dibaca Hermes saat relevan. Bukan sistem Skill resmi Hermes. |
| **`SCHEMA.md`** | Aturan format wiki: protokol tulis, frontmatter, aturan tag, link, dan threshold. |
| **`taxonomy.md`** | Daftar tag resmi. Milik agent, tidak ditimpa deploy (D-28). |
| **UC** | Use case (UC1–UC5, plus UC1b Daftar Kerjaan Baru). M1/M2 adalah job maintenance (lint, backup), bukan UC. |
| **Career aktif** | Folder `wiki/careers/career-N-*` yang `about.md`-nya belum punya tanggal selesai. |
| **`raw/`** | Sumber mentah yang immutable (artikel, screenshot yang sudah diredaksi). |
| **`wiki/`** | Konten hasil kompilasi agent. |
| **Skill map** | `wiki/roadmap/skill-map.md`: daftar topik target per level (L1/L2/L3) dan topik per role. Dibekukan per level. Dasar gap analysis, skill inventory, dan role fit. |
| **Skill inventory** | Persentase per area skill = topik target yang sudah punya note ÷ total topik target, diukur terhadap target satu level di atas posisi sekarang. |
| **Honest gaps** | Aturan bahwa agent wajib bilang "belum ada catatan" alih-alih mengarang jawaban. |
| **Dual-link** | Format link See Also: `[[slug\|Name]] ([Name](../path/slug.md))`. Dibaca oleh Obsidian maupun markdown biasa. |
| **L1 / L2 / L3** | Level jenjang IT support/infra (L1 = first line, L2 = lanjutan, L3 = expert). |

## Riwayat Perubahan

| Versi | Tanggal | Perubahan |
|---|---|---|
| 1.0 | 2026-10-16 | Versi pertama. Disusun dari `docs/iGROW_FINAL.md`, `docs/build.md`, `docs/vpslab.md`, dev-todo, dan isi `hermes-home/`. |
| 1.1 | 2026-10-16 | `docs/dev-todo.md` dipindah menjadi `todo.md`, ditambah `backlog.md` (riwayat update) dan `CLAUDE.md` di root. |
| 1.2 | 2026-10-16 | Sisa isi `iGROW_FINAL.md` dipindah ke PRD: contoh output per UC, mekanisme gap, aturan skill inventory, dan skenario migrasi. FIN diarsipkan. |
| 1.3 | 2026-10-17 | Diagram Mermaid (sistem, alur pesan, cron, backup & recovery, aliran antar-UC, gap analysis, screenshot). Review menyeluruh: status cron dikoreksi (butuh `--workdir`), contoh skill map dan laporan UC5 diselaraskan dengan SCHEMA, temuan runtime dicatat sebagai W22–W26 dan I8. |
| 1.4 | 2026-10-23 | Todo review PRD 2026-10-17 selesai (W22–W26, I8): backup selalu lapor (D-27), taxonomy jadi `igrow/taxonomy.md` + deploy 2 langkah (D-28), placeholder untuk link ke note yang belum ada, satu sumber untuk protokol tulis dan daftar larangan (+ serial number, raw log client, konfigurasi proprietary), `/recall` menyebut page sumber. Act item todo terbuka dipertajam; diagram backup (§ 6.3 architecture) dan metrik reliabilitas diselaraskan dengan D-27. Lanjutan di hari yang sama: self-check privasi + cara redact yang menjaga command dan konteks (A10), alur raw study + tanggal kejadian + balasan berangkuman (W33, I9, I10), status topik di SCHEMA, slug unik + nama incident bertanggal (D-29), dan link balik (W34, I13, W36). |

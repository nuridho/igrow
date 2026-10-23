# 03 · Requirements

Prioritas memakai MoSCoW: **Must** (wajib untuk MVP), **Should** (penting, bisa menyusul), **Could** (nilai tambah), **Won't** (tidak dikerjakan saat ini).

Status:
- ✅ Sudah ada di runtime (`hermes-home/`)
- ⚠ Ada gap yang diketahui
- ⏳ Belum aktif atau belum dibangun

## 1. Functional Requirements

### 1.1 Interaksi & Instruksi Agent

| ID | Requirement | Prioritas | UC | Status |
|---|---|---|---|---|
| FR-01 | User berinteraksi dengan iGROW hanya lewat Telegram (Hermes gateway mode). | Must | Semua | ✅ |
| FR-02 | `AGENTS.md` dimuat otomatis di setiap sesi, termasuk sesi dari Telegram dan cron. | Must | Semua | ✅ Telegram teruji di Phase 2 · ⏳ Cron: job wajib dibuat dengan `--workdir /opt/data`, karena tanpa itu sesi cron tidak memuat `AGENTS.md` |
| FR-03 | Hermes memilih prosedur `project-skills/` yang relevan berdasarkan isi pesan. Pesan umum dijawab langsung tanpa menulis file. | Must | Semua | ✅ |
| FR-04 | Hermes membaca `SCHEMA.md` sebelum setiap operasi tulis. | Must | Semua tulis | ✅ |

### 1.2 Penulisan Knowledge

| ID | Requirement | Prioritas | UC | Status |
|---|---|---|---|---|
| FR-05 | Cerita kerja diklasifikasi (incident / knowledge / lesson) dan ditulis ke folder career aktif sesuai aturan penempatan. | Must | UC1 | ✅ |
| FR-06 | Career aktif ditentukan dari `about.md` yang belum punya tanggal selesai. | Must | UC1 | ✅ |
| FR-07 | User bisa mendaftarkan pekerjaan baru. Career lama otomatis ditutup dan folder career baru dibuat. | Must | UC1b | ✅ |
| FR-08 | Setiap note mematuhi SCHEMA: frontmatter wajib, body template, tag dari taxonomy, minimal 2 dual-link di See Also. | Must | UC1, UC4 | ✅ Ada self-check, tapi kepatuhan agent belum diukur |
| FR-09 | Setiap operasi tulis diakhiri dengan update `_index.md` terdekat, master `_index.md` (Total pages + Last updated), dan entri `log.md`. | Must | Semua tulis | ✅ |
| FR-10 | `raw/` bersifat immutable dan punya satu jalur: `inbox/` → diproses → `articles/`. | Must | UC4 | ✅ |
| FR-11 | Cerita yang bertentangan dengan note lama tidak menimpa diam-diam. Pertentangannya dicatat di field `contradictions`. | Should | UC1 | ✅ |
| FR-12 | Cerita lanjutan tentang hal yang sama memperbarui note lama (in-place), bukan membuat duplikat. | Should | UC1 | ✅ |

### 1.3 Analisis & Laporan

| ID | Requirement | Prioritas | UC | Status |
|---|---|---|---|---|
| FR-13 | `/recall` menjawab dari wiki, dan bilang jujur kalau tidak ada catatan. | Must | /recall | ✅ |
| FR-14 | Gap analysis berbasis data pribadi. Kalau data tidak cukup, Hermes menolak membuat roadmap generik. | Must | UC2 | ✅ |
| FR-15 | Skill map di-generate otomatis dari `about.md`, `careers/`, dan `self-development/`, lalu dibekukan per level. Generate ulang hanya saat naik level atau ganti role. | Must | UC2, UC5 | ✅ |
| FR-16 | Role fit ditampilkan dalam bentuk pembilang/penyebut, dengan 2 role paling cocok dan 2 paling jauh. | Should | UC2 | ✅ |
| FR-17 | Skill inventory dihitung dengan menghitung file, bukan perkiraan LLM, selalu menampilkan X/Y dan file bukti, dan diukur terhadap target satu level di atas posisi sekarang. | Must | UC5 | ✅ |
| FR-18 | Career review kuartalan ditulis ke `output/` dan memperbarui `wiki/profile/`. | Must | UC5 | ⏳ Cron belum dibuat |
| FR-19 | Role Fit Trend dibandingkan dengan angka dari laporan sebelumnya. Run pertama ditandai "baseline". | Could | UC5 | ✅ |

### 1.4 Automation & Maintenance

| ID | Requirement | Prioritas | UC | Status |
|---|---|---|---|---|
| FR-20 | Daily briefing setiap hari 07:00, maksimal 5 item dengan alasan relevansi. Item CVE menyertakan teknologi terdampak dan severity. | Should | UC3 | ⏳ Cron belum dibuat |
| FR-21 | Lint struktur wiki setiap minggu, hanya melapor. | Should | M1 | ⏳ Cron belum dibuat |
| FR-22 | Backup `igrow/` + salinan `AGENTS.md` ke repo GitHub privat setiap Senin, Rabu, dan Sabtu 05:00. Setiap run selalu lapor: berhasil, tidak ada perubahan, atau gagal (D-27). | Must | M2 | ⏳ Cron + prasyarat repo |
| FR-23 | Semua output cron dikirim ke Telegram (`--deliver telegram`). | Must | UC3, UC5, M1, M2 | ⏳ |

### 1.5 Fitur Mendatang

| ID | Requirement | Prioritas | Status |
|---|---|---|---|
| FR-24 | Dashboard read-only (`igrow-web` + `igrow-api`) yang menampilkan skill inventory dan arsip karier. | Could | ⏳ Phase 4 |
| FR-25 | Export career review ke PDF. | Could | ⏳ Backlog |
| FR-26 | Perintah koreksi note yang salah di knowledge base besar (nama perintah belum ditentukan: `/cek` atau `/audit`). | Could | ⏳ Backlog |
| FR-27 | `/explore` untuk riset sumber baru, kalau ternyata perlu dibedakan dari `/recall`. | Could | ⏳ Belum diputuskan |
| FR-28 | Sinkronisasi vault ke Obsidian di laptop dan HP (LiveSync + CouchDB). | Won't (saat ini) | ⏳ Phase 5 |

## 2. Non-Functional Requirements

| ID | Kategori | Requirement |
|---|---|---|
| NFR-01 | **Portabilitas** | Semua knowledge berupa markdown + YAML frontmatter, tanpa database. Bisa dibaca tanpa Hermes, tanpa tool khusus, dan tanpa provider LLM tertentu. |
| NFR-02 | **Privasi** | Tidak ada data sensitif (lihat §3) di `raw/`, `wiki/`, maupun `output/`. Redaksi dilakukan sebelum ingest. |
| NFR-03 | **Keamanan** | `igrow-hermes` tidak mem-publish port dan tidak terdaftar di reverse proxy mana pun. `igrow-api` hanya bisa membaca (`:ro`) dan hanya punya endpoint GET. CouchDB tidak boleh terbuka ke publik tanpa proteksi. Repo backup harus privat. |
| NFR-04 | **Reliabilitas** | Container memakai `restart: unless-stopped`. **RPO ≤ 3 hari** (backup Senin, Rabu, Sabtu). **RTO usulan ≤ 1 jam**: clone repo backup → deploy `hermes-home/` → `hermes setup`. |
| NFR-05 | **Konsistensi** | Angka (skill inventory, role fit) dapat direproduksi: data yang sama menghasilkan angka yang sama. |
| NFR-06 | **Efisiensi resource** | Seluruh stack (Phase 1–4) muat di VPS 2 core / 4 GB RAM / 60 GB storage. |
| NFR-07 | **Efisiensi biaya LLM** | `AGENTS.md` dibuat sepadat mungkin karena dimuat di setiap sesi. Prosedur detail hanya dimuat saat relevan. Dashboard tidak memanggil LLM sama sekali. |
| NFR-08 | **Auditability** | Setiap operasi tulis tercatat di `log.md` (append-only) dengan format `## [YYYY-MM-DD] op \| subjek`. |
| NFR-09 | **Maintainability** | Setiap aturan hanya punya satu sumber. `hermes-home/` adalah source of truth. Line ending dikunci ke LF (`.gitattributes`) supaya script tidak rusak di VPS. |
| NFR-10 | **Waktu** | Container dan cron memakai `TZ=Asia/Kuala_Lumpur`. |
| NFR-11 | **Keterbacaan jangka panjang** | Setiap note wajib punya Ringkasan, sumber, dan konteks asal (career atau sumber belajar), sehingga bisa dipahami bertahun-tahun kemudian tanpa konteks tambahan. |

## 3. Kebijakan Data

Konteks: user bekerja di vendor yang ditempatkan di client. Prinsipnya **dokumentasikan pengalaman, bukan data client.**

### 3.1 Dilarang Disimpan

Berlaku untuk seluruh `igrow/`, termasuk `raw/`. Redaksi wajib dilakukan **sebelum** ingest, karena `raw/` tidak boleh diedit setelah masuk.

- Credential atau password
- API key atau token
- IP internal
- Hostname sensitif
- Serial number
- Raw log client
- Screenshot yang belum diredaksi
- Data customer
- Konfigurasi proprietary

| Salah ❌ | Benar ✅ |
|---|---|
| `client ABC server PROD-DB-07 (10.x.x.x) mengalami...` | `production server mengalami high CPU` |

⚠ Daftar larangan di runtime (`AGENTS.md`, `SCHEMA.md`) belum memuat serial number, raw log client, dan konfigurasi proprietary ([W25](todo.md)).

### 3.2 Alur Screenshot

```mermaid
flowchart LR
    subgraph hp["Di HP (user)"]
        A(["Screenshot"]) --> B["Crop / redaksi<br/>identifier"]
    end
    subgraph agent["Hermes"]
        C["Analisis"] --> D[("igrow/raw/assets/<br/>YYYYMMDD-deskripsi.png")]
        C --> E["Note di wiki/<br/>merujuk ke gambar"]
    end
    B -->|kirim lewat Telegram| C
```

Redaksi dilakukan di HP sebelum dikirim, karena gambar ikut terkirim ke provider LLM (§3.3). Cara note merujuk ke gambar diatur di `capture-experience.md`.

### 3.3 Data yang Keluar dari VPS

| Tujuan | Data | Catatan |
|---|---|---|
| Provider LLM (API) | Isi pesan, isi file yang dibaca agent saat memproses | Tidak bisa dihindari. Inilah alasan utama redaksi dilakukan sebelum bercerita. |
| GitHub (repo privat `igrow-backup`) | Seluruh `igrow/` + `AGENTS.backup.md` | Token GitHub sebaiknya hanya punya scope ke repo itu. |
| Telegram | Balasan agent, output cron | — |

Yang **tidak** ikut di-backup ke GitHub: `.env` (token Telegram, API key LLM), `config.yaml`, dan state internal Hermes (sessions, memories, skills, `state.db`). Tapi isi memory dimasukkan ke system prompt setiap sesi dan riwayat sesi menjadi konteks percakapan, jadi keduanya tetap terkirim ke provider LLM.

### 3.4 Kepemilikan File

| File | Pemilik | Aturan |
|---|---|---|
| `about.md` (setiap career) | User | Agent hanya boleh menulis saat alur Daftar Kerjaan Baru (UC1b). |
| `skill-map.md` | Agent (auto-generate, beku per level) | User boleh mengedit, tapi tidak wajib. Generate ulang hanya saat naik level atau ganti role. |
| `raw/*` | Immutable | Tidak diedit setelah masuk. |
| `wiki/*`, `output/*` | Agent | User jarang mengedit langsung. |
| `AGENTS.md`, `SCHEMA.md`, `project-skills/*` | User (via repo ini) | Dideploy dari `hermes-home/` di repo ini; deploy menimpa versi VPS. |
| `taxonomy.md` | Agent | Tag baru hanya kalau user setuju. Tidak ditimpa deploy; repo hanya menyediakan isi awal (D-28). |

# 05 · Roadmap & Release Plan

To-do rinci untuk `hermes-home/` ada di [`todo.md`](todo.md). Pekerjaan di luar `hermes-home/` (docs, VPS, testing) dicatat langsung di tabel prioritas §3. Riwayat perubahan ada di [`backlog.md`](backlog.md). Dokumen ini adalah ringkasan level produk: fase, milestone, dan prioritas.

## 1. Status Fase

| Phase | Lingkup | Status | Exit criteria |
|---|---|---|---|
| **1 · Foundation** | Docker, NPM, Portainer, Glance, Homepage, UFW, SSL | ✅ Selesai | Semua checklist Phase 1 di `build.md` dicentang |
| **2 · iGROW Core** | `igrow-hermes` + `igrow/` + UC1–UC5 + maintenance | 🟡 Berjalan | Lihat §2 |
| **3 · Observability** | Dozzle | ⏳ Belum mulai | Log semua container bisa dibaca dari browser |
| **4 · Dashboard** | 4a: `igrow-web` statis (data dummy). 4b: `igrow-api` + data asli | ⏳ Belum mulai | Dashboard menampilkan data asli tanpa memanggil LLM |
| **5 · Opsional** | Obsidian LiveSync (CouchDB), Netdata, Loki, Gatus/Uptime Kuma | ⏳ Sesuai kebutuhan | Dikerjakan hanya kalau ada kebutuhan nyata |

Urutan ini sengaja: dashboard (Phase 4) ditunda sampai Hermes punya data asli. Tidak ada gunanya membangun "kaca jendela" sebelum ada isinya.

## 2. Phase 2: Jalan Menuju "Done"

Yang sudah tercapai: container jalan, `hermes setup` dan pairing Telegram selesai, `AGENTS.md` terbukti dimuat, dan capture pertama lewat Telegram berhasil menulis file.

### M2.1 · Runtime Bersih

**Target:** sebelum data nyata diisi.

- [x] Rapikan `SCHEMA.md`: duplikat kepemilikan, definisi skill inventory (W1), skill map sebagai `type: data` (W2), dan SCHEMA jadi wajib. Selesai 2026-10-16 (W9).
- [x] Kerjakan item todo hasil review PRD 2026-10-17 (W22–W26, I8). Selesai 2026-10-23.
- [ ] Kerjakan item todo hasil review runtime 2026-10-22 dan 2026-10-23 (sisa: W44) sebelum deploy ulang, supaya cukup sekali deploy.
- [ ] Deploy ulang `hermes-home/` ke VPS (2 langkah rsync, PRD 04 §7): contoh few-shot yang sudah diperbaiki (C2), `backup.sh` yang ikut membackup `AGENTS.md`, `AGENTS.md` tanpa session-export, dan seluruh hasil audit `hermes-home/` 2026-10-16 (lihat `backlog.md`). Setelah deploy, pastikan `igrow/taxonomy.md` ada di VPS (tersalin oleh langkah 2), dan hapus `igrow/_index.md` (master lama) di VPS sekali, karena rsync tidak pernah menghapus file (W40, D-32).
- [ ] Hapus sisa session-export di VPS: cron job (kalau sudah dibuat), file prosedurnya, dan folder `log/sessions/archive/`.

### M2.2 · Automation Aktif

- [ ] Siapkan prasyarat backup: `git init` di `igrow/`, remote repo privat `igrow-backup`, dan token dengan scope minimal. Jalankan sebagai user yang sama dengan proses gateway (bandingkan `id` di `docker exec` dengan pemilik file yang pernah ditulis Hermes, mis. hasil capture pertama); kalau beda, git menolak repo ("dubious ownership") atau gagal menulis `.git/` saat cron. Identitas commit di level repo (tanpa `--global`). Uji `bash igrow/project-skills/maintenance/backup.sh` sekali sebelum cron dibuat.
- [ ] Cek toolset platform `cron` di `hermes tools`: web (daily briefing), terminal (backup, cek privasi lint: uji `bash igrow/project-skills/maintenance/lint-privacy.sh` sekali), file (semua job). Kalau config cron tidak terbaca, Hermes menggagalkan run, bukan memakai semua tool (dokumentasi resmi, fitur cron).
- [ ] Uji kirim 1 file DOCX dan 1 PDF berisi screenshot lewat Telegram: file asli tersimpan di `raw/assets/` dan isinya terbaca (W46, D-34). Gagal karena library ekstraksi tidak ada → pasang `python-docx` / `pymupdf` di container. Batas file lewat Bot API publik 20 MB.
- [ ] Set `skills.write_approval: true` di `config.yaml` (atau `/skills approval on` di Telegram), supaya skill buatan Hermes, termasuk dari background review, menunggu persetujuan owner (W37, R-12; dokumentasi resmi, fitur Skills). Dokumentasi tidak menyebut notifikasi saat ada skill tertahan: cek `/skills pending` sesekali dan tolak (`/skills reject <id>`) skill yang menyalin alur iGROW. Opsional: `memory.write_approval: true` kalau memory Hermes mulai berisi salinan aturan atau data iGROW.
- [ ] Buat 4 cron job (`daily-briefing`, `backup-knowledge`, `lint-mingguan`, `career-review`) dengan `--deliver telegram` dan `--workdir /opt/data`. Pastikan `hermes cron list` menampilkan 4 job.
- [ ] Verifikasi minggu pertama: briefing tiba setiap pagi dan tiap item punya baris `Sumber:`, setiap jadwal backup mengirim 1 pesan (D-27) dan perubahan muncul sebagai commit, dan lint mengirim laporan tanpa temuan "cek privasi gagal".

### M2.3 · Tervalidasi dengan Data Nyata

- [ ] Perbarui `testing/test-flow.md` supaya sesuai perilaku sekarang: 4.1/4.2 skill map dibuat otomatis (bukan diisi manual); 4.3/4.4 tidak lagi di-skip (weak-topics dan kesiapan L2 dihitung dari note); 4.7 tanpa `roadmap.md` (D-21); hapus Fase 3 dan checklist #5 (fitur testing sudah dihapus, D-14); checklist #10 taxonomy berisi 16 tag; `about.md` di Step 0 memakai Role + level; + skenario Daftar Kerjaan Baru (tanggal terakhir career lama ditanya, skip → sehari sebelum tanggal mulai, W32); + kasus dua career aktif (Hermes bertanya, bukan memilih sendiri, I16); + skenario screenshot (gambar asli tersimpan di `raw/assets/` dan tampil dari note, D-33); + skenario dokumen Word/PDF berisi screenshot (file asli tersimpan, note dari isinya, D-34).
- [ ] Isi minimal 10 note nyata (campuran incident, knowledge, dan study).
- [ ] Jalankan test-flow secara manual, termasuk mentor (UC2) dan career review manual (UC5).
- [x] Putuskan kebijakan skill map: dibekukan per level (D-22).

**Definisi Phase 2 selesai:** M2.1–M2.3 tercapai, dan career review otomatis pertama berjalan tanpa intervensi pada **1 Januari 2027 pukul 09:00**.

## 3. Prioritas Backlog

| Horizon | Item | Sumber |
|---|---|---|
| **Now** | Cron + prasyarat backup: setelah W44 selesai, jalankan `bash igrowctl.sh` di VPS. Langkah 7 sekaligus deploy ulang runtime (M2.1), langkah 7–9 menutup item M2.2 (approval skill, tools cron, prasyarat + uji backup, uji `lint-privacy.sh`, 4 cron); container dan Telegram yang sudah ada dideteksi dan dilewati | [07 · Setup](07-setup.md) |
| **Now** | Kerjakan sisa todo runtime (W44), lalu deploy ulang runtime | §2 M2.1, [`todo.md`](todo.md) |
| **Next** | Perbarui test-flow, lalu uji dengan data nyata | §2 M2.3 |
| **Next** | Bersihkan `build.md`: ganti blok salinan "Bikin 14 file inti" dengan instruksi deploy 2 langkah (rujuk PRD 04 §7), hapus kalimat fallback push via `igrow.nuridho.com`, ganti "(via SSH)" di tabel cron jadi HTTPS + token, token di prasyarat Job 2 jadi fine-grained khusus repo `igrow-backup` (Contents read/write), bukan classic scope `repo` | `docs/build.md` |
| **Later** | Phase 3 (Dozzle), Phase 4 (dashboard) | vpslab.md |
| **Later** | Export PDF career review, perintah koreksi note (`/cek` / `/audit`) | FR-25, FR-26 |
| **Later** | Evaluasi migrasi `project-skills/` ke sistem Skill resmi Hermes | OQ-06 |

## 4. Parked

Tidak dikerjakan sampai ada bukti bahwa versi sekarang kurang:

| Item | Alasan ditunda | Rujukan |
|---|---|---|
| Migrasi ke Jev (decision model) + n8n | Spekulatif. Mengubah iGROW dari assistant menjadi workflow app. Wajib POC (≥ 100 pesan anonim) sebelum keputusan go/no-go. | [`parked/jev-full-migration.md`](../parked/jev-full-migration.md) |
| **A7** Multi-turn confirmation untuk Daftar Kerjaan Baru | Biaya dan latency naik 3–4×. Tidak mungkin dipakai untuk cron. | D-13 (dihapus dari todo 2026-10-22) |
| **A8** Validasi format berbasis regex di prompt | Lint mingguan sudah menangkap error format. | D-13 (dihapus dari todo 2026-10-22) |
| **A9** Negative examples per UC | Kerjakan hanya kalau error yang sama berulang di lint. | D-13 (dihapus dari todo 2026-10-22) |

## 5. Kalender Operasional

| Kapan | Apa yang terjadi |
|---|---|
| Setiap hari 07:00 | Daily briefing |
| Senin, Rabu, Sabtu 05:00 | Backup `igrow/` ke GitHub |
| Minggu 08:00 | Laporan lint |
| 1 Jan / 1 Apr / 1 Jul / 1 Okt, 09:00 | Career review kuartalan |
| Setiap kuartal (manual) | Cek privasi `raw/` dan `wiki/` (lint mingguan hanya memeriksa pola IP dan credential di catatan kerja, bukan materi belajar), serta tinjau ulang target metrik di [01 · §7](01-overview.md#7-ukuran-sukses) |

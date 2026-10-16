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
- [ ] Kerjakan item todo hasil review PRD 2026-10-17 (W22–W26, I8) sebelum deploy ulang, supaya cukup sekali deploy.
- [ ] Deploy ulang `hermes-home/` ke VPS: contoh few-shot yang sudah diperbaiki (C2), `backup.sh` yang ikut membackup `AGENTS.md`, `AGENTS.md` tanpa session-export, dan seluruh hasil audit `hermes-home/` 2026-10-16 (lihat `backlog.md`).
- [ ] Hapus sisa session-export di VPS: cron job (kalau sudah dibuat), file prosedurnya, dan folder `log/sessions/archive/`.

### M2.2 · Automation Aktif

- [ ] Siapkan prasyarat backup: `git init` di `igrow/`, remote repo privat `igrow-backup`, dan token dengan scope minimal.
- [ ] Buat 4 cron job (`daily-briefing`, `backup-knowledge`, `lint-mingguan`, `career-review`) dengan `--deliver telegram` dan `--workdir /opt/data`. Pastikan `hermes cron list` menampilkan 4 job.
- [ ] Verifikasi minggu pertama: briefing tiba setiap pagi, backup menghasilkan commit, dan lint mengirim laporan.

### M2.3 · Tervalidasi dengan Data Nyata

- [ ] Perbarui `testing/test-flow.md` supaya sesuai perilaku sekarang: 4.1/4.2 skill map dibuat otomatis (bukan diisi manual); 4.3/4.4 tidak lagi di-skip (weak-topics dan kesiapan L2 dihitung dari note); 4.7 tanpa `roadmap.md` (D-21); 5.4 skill inventory = topik yang punya note ÷ target skill map, plus bagian Pola dan Role Fit Trend; hapus Fase 3 dan checklist #5 (fitur testing sudah dihapus, D-14); checklist #10 taxonomy berisi 16 tag; `about.md` di Step 0 memakai Role + level.
- [ ] Isi minimal 10 note nyata (campuran incident, knowledge, dan study).
- [ ] Jalankan test-flow secara manual, termasuk mentor (UC2) dan career review manual (UC5).
- [x] Putuskan kebijakan skill map: dibekukan per level (D-22).

**Definisi Phase 2 selesai:** M2.1–M2.3 tercapai, dan career review otomatis pertama berjalan tanpa intervensi pada **1 Januari 2027 pukul 09:00**.

## 3. Prioritas Backlog

| Horizon | Item | Sumber |
|---|---|---|
| **Now** | Cron + prasyarat backup | build.md checklist Phase 2 |
| **Now** | Kerjakan todo hasil review PRD (W22–W26, I8), lalu deploy ulang runtime | §2 M2.1, [`todo.md`](todo.md) |
| **Next** | Perbarui test-flow, lalu uji dengan data nyata | §2 M2.3 |
| **Next** | Bersihkan `build.md`: ganti blok salinan "Bikin 14 file inti" dengan 1 instruksi rsync (exclude `_index.md` + `log.md`), hapus kalimat fallback push via `igrow.nuridho.com`, ganti "(via SSH)" di tabel cron jadi HTTPS + token | `docs/build.md` |
| **Later** | Phase 3 (Dozzle), Phase 4 (dashboard) | vpslab.md |
| **Later** | Export PDF career review, perintah koreksi note (`/cek` / `/audit`) | FR-25, FR-26 |
| **Later** | Evaluasi migrasi `project-skills/` ke sistem Skill resmi Hermes | OQ-06 |

## 4. Parked

Tidak dikerjakan sampai ada bukti bahwa versi sekarang kurang:

| Item | Alasan ditunda | Rujukan |
|---|---|---|
| Migrasi ke Jev (decision model) + n8n | Spekulatif. Mengubah iGROW dari assistant menjadi workflow app. Wajib POC (≥ 100 pesan anonim) sebelum keputusan go/no-go. | [`parked/jev-full-migration.md`](../parked/jev-full-migration.md) |
| **A7** Multi-turn confirmation untuk Daftar Kerjaan Baru | Biaya dan latency naik 3–4×. Tidak mungkin dipakai untuk cron. | todo |
| **A8** Validasi format berbasis regex di prompt | Lint mingguan sudah menangkap error format. | todo |
| **A9** Negative examples per UC | Kerjakan hanya kalau error yang sama berulang di lint. | todo |

## 5. Kalender Operasional

| Kapan | Apa yang terjadi |
|---|---|
| Setiap hari 07:00 | Daily briefing |
| Senin, Rabu, Sabtu 05:00 | Backup `igrow/` ke GitHub |
| Minggu 08:00 | Laporan lint |
| 1 Jan / 1 Apr / 1 Jul / 1 Okt, 09:00 | Career review kuartalan |
| Setiap kuartal (manual) | Cek privasi `raw/` dan `wiki/`, serta tinjau ulang target metrik di [01 · §7](01-overview.md#7-ukuran-sukses) |

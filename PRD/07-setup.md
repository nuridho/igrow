# 07 · Setup: Pasang iGROW dengan Satu Script

Dokumen ini menjelaskan `Setup/igrowctl.sh`: script yang membawa VPS kosong sampai bot iGROW jalan di Telegram, lengkap dengan backup dan cron. Perintah persisnya ada di script itu sendiri (satu sumber); dokumen ini menjelaskan **alur, apa yang ditanya, di mana hasilnya disimpan, dan kenapa begitu**.

## 1. Gambaran Singkat

```text
Laptop                          VPS (user biasa + sudo)
──────                          ───────────────────────
scp igrowctl.sh  ──────────▶ bash igrowctl.sh
                                  1 Paket      git, rsync, curl
                                  2 Git        identitas + SSH key → GitHub
                                  3 Docker     Docker + Compose
                                  4 Repo       clone repo iGROW (sumber hermes-home/)
                                  5 Container  docker-compose Hermes resmi
                                  6 Kunci      wizard LLM + token bot Telegram
                                  7 Runtime    deploy hermes-home/ + approval skill + tools cron → bot nyala
                                  8 Backup     igrow/ → repo GitHub privat (atau restore dari sana)
                                  9 Cron       briefing, backup, lint, career review
                                ✔ iGROW siap → chat bot "halo"
```

Waktu: ±15 menit, kebanyakan menunggu install dan menyalin token.

## 2. Sebelum Mulai

| Siapkan | Dipakai di langkah | Catatan |
|---|---|---|
| VPS Ubuntu/Debian + user biasa yang punya sudo | semua | Script menolak jalan sebagai root. User dibuat lewat `Setup/setupvps.sh`. |
| Akun GitHub, akses ke repo iGROW | 2, 4 | SSH key VPS dibuat otomatis, tinggal ditempel di GitHub. |
| Repo GitHub **privat** kosong untuk backup (mis. `igrow-backup`) + fine-grained token | 8 | Token: *Only select repositories* → repo backup saja, *Contents: Read and write*. Script menolak repo publik. |
| Bot Telegram (@BotFather) + user ID kamu (@userinfobot) | 6 | User ID berupa angka, bukan @username. |
| API key LLM (OpenRouter, Anthropic, OpenAI, dll) | 6 | Diketik di wizard resmi Hermes. |

Salin script ke VPS lalu jalankan:

```bash
scp Setup/igrowctl.sh <user>@<vps>:~/
ssh <user>@<vps>
bash igrowctl.sh
```

Setelah langkah 4, script juga ada di repo hasil clone, jadi berikutnya cukup `bash ~/iGROW/Setup/igrowctl.sh <perintah>`.

## 3. Langkah per Langkah

Semua langkah **aman diulang**: yang sudah beres dicek lalu dilewati (`↷ sudah beres`). Gagal di tengah → perbaiki penyebabnya, jalankan ulang script.

| # | Langkah | Yang ditanya | Hasil & lokasi |
|---|---|---|---|
| 1 | Paket dasar | — | `git`, `rsync`, `curl`, `ssh-keygen` terpasang (apt). |
| 2 | Git & GitHub | Nama + email commit (kalau belum ada) | `git config --global` di VPS; SSH key `~/.ssh/id_ed25519` (tanpa passphrase, supaya bisa dipakai tanpa interaksi). Script menunggu sampai `ssh -T git@github.com` berhasil. |
| 3 | Docker & Compose | — | Docker dari `get.docker.com`, user masuk grup `docker` (aktif setelah login ulang; sampai itu script memakai sudo). |
| 4 | Repo iGROW | URL SSH repo, folder clone (default `~/iGROW`) | Clone, atau `git pull` kalau sudah ada. |
| 5 | Container Hermes | Nama folder project di home (mis. `whatsinsidegit`; default dari `setupvps.sh` kalau sudah dijalankan). Folder data otomatis `~/<nama>/igrow-hermes/hermes-home`, dibuat kalau belum ada, timezone (default `Asia/Jakarta`) | `docker-compose.yml` + `.env` (UID/GID/TZ) di `~/<nama>/igrow-hermes/`, image ditarik. Kalau container `igrow-hermes` sudah ada (mis. dari compose root lama), langkah ini dilewati dan script memakai compose serta folder data container itu. |
| 6 | LLM & Telegram | Wizard `hermes setup model`; token bot; user ID | API key oleh wizard resmi. `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`, `TELEGRAM_HOME_CHANNEL` ditulis ke `hermes-home/.env` (mode 600). Token dicek langsung ke Telegram (`getMe`) sebelum disimpan. |
| 7 | Runtime & tools | Approval memory? (default tidak); layar `hermes tools` | Deploy 2 langkah dari repo (PRD 04 §7) + hapus master `igrow/_index.md` lama (D-32). `skills.write_approval: true` (R-12). Tools platform `cron`: web, terminal, file. Gateway dinyalakan, lalu `hermes doctor`. |
| 8 | Backup | Repo backup, token | `git init` di `igrow/` (identitas level repo), remote HTTPS **tanpa** token, push pertama, lalu uji `backup.sh` persis seperti cron. Repo backup sudah berisi data → tawaran restore (lihat §4.4). |
| 9 | Cron | — | 4 job dengan `--deliver telegram --workdir /opt/data`; job yang namanya sudah ada dilewati. Uji `lint-privacy.sh` sekali. |

Jadwal cron: daily briefing tiap hari 07:00, backup Senin/Rabu/Sabtu 05:00, lint Minggu 08:00, career review tanggal 1 Januari/April/Juli/Oktober 09:00. Isi tiap job dibaca dari `hermes-home/igrow/project-skills/` (prompt cron hanya menunjuk file prosedurnya).

## 4. Keputusan Desain

### 4.1 Repo di-clone di host, bukan di dalam container

Ide awalnya: masuk ke container, lalu clone repo di sana. Itu tidak dipakai karena folder data container (`/opt/data`) adalah tempat **data** iGROW tinggal. Kalau repo spec (PRD, docs, web) ikut di-clone ke sana, isinya bercampur dengan data dan ikut ter-backup. Pola yang dipakai sama dengan deploy biasa: repo di host (`~/iGROW`), lalu hanya `hermes-home/` yang disalin ke folder data dengan rsync 2 langkah. Update aturan berikutnya cukup `bash igrowctl.sh deploy`.

### 4.2 Secret tidak pernah masuk repo atau log

| Secret | Disimpan di | Tidak pernah di |
|---|---|---|
| API key LLM | `hermes-home/.env` (ditulis wizard Hermes) | repo, log setup |
| Token bot Telegram | `hermes-home/.env` (mode 600) | repo, log setup, daftar proses |
| Token GitHub backup | `hermes-home/.git-credentials` (mode 600, di luar `igrow/`) | URL remote, repo backup, log setup |

Setelan non-rahasia (path, URL repo, nama bot) disimpan di `~/.config/igrow/setup.env`, supaya script tidak bertanya ulang. Log setup ada di `~/.config/igrow/setup.log`.

Batasnya: Hermes punya akses terminal di container, jadi secara teknis agent bisa membaca `.env` dan `.git-credentials`. Karena itu token backup dibuat fine-grained untuk satu repo saja. Kalau bocor, yang terdampak hanya repo backup.

### 4.3 Perintah Hermes dijalankan sebagai user gateway

Container berjalan sebagai user `hermes` dengan UID/GID yang disamakan ke pemilik `hermes-home/` (`HERMES_UID`/`HERMES_GID`). Semua perintah git untuk backup dijalankan script dengan UID yang sama, persis seperti saat cron menjalankan `backup.sh`. Tanpa ini, git bisa menolak repo ("dubious ownership") atau gagal menulis `.git/` saat cron jalan. Selama gateway belum jalan, perintah `hermes` dijalankan lewat container sekali pakai (`docker compose run --rm`), dan tidak pernah ada dua gateway untuk satu folder data.

### 4.4 Pindah VPS = restore otomatis

Contoh: VPS lama mati, kamu menyewa VPS baru dan menjalankan script dari awal. Di langkah 8, script melihat repo `igrow-backup` sudah berisi data, lalu menawarkan restore:

1. Isi `igrow/` diambil dari backup (note, raw, output, log, taxonomy).
2. Aturan runtime langsung ditimpa lagi dengan versi repo, karena backup bisa berisi aturan versi lama. Data tidak tersentuh.
3. Backup berikutnya melanjutkan riwayat commit yang sama.

Yang **tidak** ikut kembali: memory dan sesi Hermes, `.env`, dan cron job. Ketiganya dibuat ulang oleh langkah 6, 7, dan 9.

### 4.5 Telegram lewat `.env`, bukan wizard gateway

Dokumentasi resmi Hermes mendukung tiga cara mengisi Telegram, dan salah satunya menulis variabel langsung ke `.env`. Script memakai cara itu supaya pertanyaannya sedikit (token + user ID) dan token bisa dicek sebelum disimpan. `TELEGRAM_HOME_CHANNEL` wajib diisi: tanpanya, hasil cron dengan `--deliver telegram` tidak punya tujuan kirim.

## 5. Perintah Harian

`bash igrowctl.sh` tanpa argumen: kalau setup belum pernah selesai, menjalankan semua langkah. Kalau sudah (penanda `SETUP_DONE=1` di `~/.config/igrow/setup.env`, ditulis setelah langkah 9), menampilkan **menu**: deploy, status, update, LLM & Telegram (langkah 6), tools cron (7), backup (8, bisa sekalian menghapus token lama), setup ulang, dan help (penjelasan tiap pilihan). Contoh tampilan dan tabel "situasi → pilih apa" ada di `Setup/README.md`. Perintah langsung di bawah tetap jalan, untuk alias atau otomatis:

| Perintah | Kapan dipakai |
|---|---|
| `bash igrowctl.sh all` | Setup pertama, atau melanjutkan setup yang terputus (sama dengan menu "Setup ulang") |
| `bash igrowctl.sh deploy` | Setelah aturan di `hermes-home/` diubah dan di-push dari laptop: `git pull` + rsync 2 langkah. Lalu kirim `/new` di Telegram supaya sesi baru membaca aturan terbaru. |
| `bash igrowctl.sh status` | Cek kesehatan: container, `hermes doctor`, daftar cron, waktu backup terakhir |
| `bash igrowctl.sh update` | Update image Hermes (`docker compose pull` + `up -d`, cara resmi). Menampilkan versi lama → baru, `hermes doctor`, daftar cron, dan baris `image: …@sha256:…` untuk balik ke versi lama kalau versi baru bermasalah. Kalau sudah terbaru, tidak ada yang diubah. |
| `bash igrowctl.sh step <1-9>` | Mengulang satu langkah. Contoh: `step 6` untuk ganti API key atau token bot, `step 7` untuk ganti tools cron |
| `bash igrowctl.sh help` | Penjelasan tiap pilihan menu |

## 6. Di Luar Script

- **Init VPS** (user, fail2ban, timezone, Docker, Nginx Proxy Manager + web dummy, UFW, hardening sshd): `Setup/setupvps.sh`, dijalankan sebagai root sebelum script ini (lihat `Setup/README.md`). iGROW tidak membuka port apa pun, jadi tidak butuh proxy host.
- **Uji dokumen Word/PDF** (roadmap M2.2) dan **test-flow manual** (`testing/test-flow.md`) tetap dilakukan sendiri setelah setup.
- **Skill buatan Hermes:** cek `/skills pending` di Telegram sesekali (R-12).

## 7. Kalau Ada Masalah

| Gejala | Cek |
|---|---|
| `✘` di salah satu langkah | 12 baris terakhir output perintahnya langsung tampil. Log lengkap: `~/.config/igrow/setup.log`. |
| SSH ke GitHub tidak tembus | Key yang ditempel harus isi `~/.ssh/id_ed25519.pub` (satu baris, diawali `ssh-ed25519`). |
| Gateway berhenti setelah start | `docker compose logs igrow-hermes` di folder compose. Biasanya API key LLM atau token bot salah → `step 6`. |
| Cron tidak mengirim pesan | `TELEGRAM_HOME_CHANNEL` terisi? Tools platform `cron` aktif (`step 7`)? `hermes cron list` menampilkan 4 job? |
| Backup gagal push | Token kedaluwarsa → buat token baru, hapus `hermes-home/.git-credentials`, jalankan `step 8`. |
| Format `hermes cron create` berubah di versi Hermes baru | `docker exec igrow-hermes hermes cron create --help`, lalu sesuaikan daftar `JOBS` di script. |

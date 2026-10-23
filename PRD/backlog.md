# Backlog: Riwayat Update iGROW

> Catatan setiap perubahan di project ini. Entri **terbaru di paling atas**.
> Wajib ditambah setiap ada perubahan file, baik oleh user maupun Claude (lihat `CLAUDE.md`).
> Yang **akan** dikerjakan ada di [`todo.md`](todo.md). File ini mencatat yang **sudah** terjadi.
> Riwayat sebelum 2026-10-15: lihat `git log`.
> Kode todo di file ini memakai penomoran baru (2026-10-16). Commit lama di git bisa memakai nomor lama; pemetaannya ada di entri "Todo dinomori ulang".

Format entri:

```markdown
## [YYYY-MM-DD] Judul singkat
- **Apa:** perubahan yang dilakukan
- **Kenapa:** alasan / kode todo terkait
- **File:** file yang berubah
- **Deploy VPS:** perlu / tidak (+ langkahnya kalau perlu)
```

---

## [2026-10-24] `docs/setup-flow.html`: visual alur `igrow-setup.sh`
- **Apa:** halaman visual baru: diagram cara script memilih jalur (ada argumen? → penanda `SETUP_DONE`), simulasi terminal Jalur A (setup lengkap) dan Jalur B (menu 1–7/h/0 yang bisa diklik, lengkap penjelasan + contoh output tiap pilihan), serta kasus khusus (perintah langsung, VPS lama tanpa penanda). Teks terminal diambil dari string asli script; nama akun/bot fiktif. Dipublikasikan juga sebagai Artifact privat. `CLAUDE.md` (peta repo) memuat file ini dan aturan: alur/menu/tampilan `igrow-setup.sh` berubah → perbarui file ini. Baris `Setup/` di `CLAUDE.md` dibetulkan (`setupdocker.sh` sudah dihapus).
- **Kenapa:** permintaan owner: visualisasi dua perilaku menu, disimpan dan ikut diperbarui kalau setup berubah.
- **File:** `docs/setup-flow.html` (baru), `CLAUDE.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak.

## [2026-10-24] `igrow-setup.sh`: menu pilihan setelah setup
- **Apa:** `bash igrow-setup.sh` tanpa argumen sekarang: belum pernah setup → semua langkah (seperti dulu); sudah pernah (penanda baru `SETUP_DONE=1` di `setup.env`, ditulis setelah langkah 9) → menu: 1 Deploy, 2 Status, 3 Update, 4 LLM & Telegram (langkah 6), 5 Tools cron (7), 6 Backup (8; menawarkan hapus token lama dulu, jadi tidak perlu `rm` manual), 7 Setup ulang, h Help, 0 Keluar. Help menjelaskan tiap pilihan (kapan dipakai, apa yang terjadi), lalu menu tampil lagi. Perintah langsung tetap jalan (`deploy`, `status`, `update`, `step N`), plus `all` (semua langkah) dan `help`. Kotak akhir setup menunjuk ke menu. `Setup/README.md` (contoh menu + tabel situasi → pilihan + alias deploy) dan `PRD/07-setup.md` §5 ikut diperbarui.
- **Kenapa:** permintaan owner: perintah setelah setup terpusat di satu menu, dengan help kalau bingung.
- **File:** `Setup/igrow-setup.sh`, `Setup/README.md`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak untuk runtime. Salin ulang `Setup/igrow-setup.sh` ke VPS. Di VPS yang setupnya sudah jalan sebelum perubahan ini, belum ada penanda `SETUP_DONE`: jalankan `bash igrow-setup.sh all` sekali (langkah yang beres dilewati), atau tambahkan `SETUP_DONE=1` ke `~/.config/igrow/setup.env`.

## [2026-10-24] `Setup/README.md` jadi panduan pakai lengkap
- **Apa:** `Setup/README.md` ditulis ulang dari ringkasan 1 tabel menjadi panduan pakai kedua script: analogi + diagram alur, cara jalankan, yang ditanya, tabel per langkah (apa yang terjadi + kenapa perlu untuk `setupvps.sh`; yang kamu lakukan vs yang script lakukan untuk `igrow-setup.sh`), hal setelah selesai (tes login, tunnel NPM, reboot), daftar yang disiapkan beserta cara mendapatkannya, jadwal cron, perintah setelah setup per situasi, lokasi file, pindah VPS. Bagian "kenapa" dan troubleshooting tetap dirujuk ke `PRD/07-setup.md` §4 dan §7.
- **Kenapa:** permintaan owner: README terlalu ringkas setelah isi `setupdocker.sh` dihapus; minta detail tapi tetap mudah dimengerti, terutama `igrow-setup.sh`.
- **File:** `Setup/README.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak.

## [2026-10-24] `igrow-setup.sh update`: update image Hermes
- **Apa:** perintah baru `bash igrow-setup.sh update`: catat image ID + digest container sekarang, `docker compose pull igrow-hermes`, kalau image berubah `up -d`, cek gateway jalan, tampilkan `hermes --version` lama → baru, `hermes doctor`, `hermes cron list`, dan kotak berisi `image: nousresearch/hermes-agent@sha256:…` untuk balik ke versi lama. Kalau sudah terbaru, tidak ada yang diubah. Komentar pin versi di compose yang dibuat langkah 5 dibetulkan dari `:vYYYY.M.D` jadi `:X.Y.Z` (format tag resmi). Ditambahkan ke header usage, kotak "Perintah berguna", `PRD/07-setup.md` (tabel perintah), `Setup/README.md`.
- **Kenapa:** saran tambahan setup yang dipilih owner. Image memakai `:latest` dan belum ada cara rapi untuk update + memastikan cron masih utuh. Fakta dicek ke dokumentasi resmi Hermes (Docker: `docker compose pull` → `up -d`, migrasi config otomatis dengan backup `config.yaml`/`.env`, `--version`, tag `latest`/`stable`/`X.Y.Z`, pin dengan digest).
- **File:** `Setup/igrow-setup.sh`, `Setup/README.md`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak untuk runtime. Salin ulang `Setup/igrow-setup.sh` ke VPS supaya perintah `update` tersedia.

## [2026-10-24] `setupvps.sh` ditulis ulang dengan TUI
- **Apa:** `Setup/setupvps.sh` memakai tampilan yang sama dengan `igrow-setup.sh`: banner, header `[n/9]`, spinner, status ✔/↷/!/✘, ringkasan akhir dalam kotak. Output perintah masuk `/var/log/setupvps.log` (mode 600); kalau gagal, 12 baris terakhir ditampilkan. Semua pertanyaan (nama folder project, password user baru dua kali) diajukan di awal, lalu langkah 1–9 jalan sendiri. Langkah yang sudah beres dilewati (user, hostname, timezone, swap, Docker, NPM). Perubahan perilaku: cek root + apt di awal; user dibuat dengan `adduser --disabled-password` + `chpasswd` (password tidak tampil di daftar proses); `apt-get upgrade` non-interaktif (`--force-confold`) supaya tidak ada prompt yang menggantung di balik spinner; NPM dijalankan dengan `docker compose -f`.
- **Kenapa:** permintaan owner: TUI setup VPS dibuat lebih rapi.
- **File:** `Setup/setupvps.sh`, `PRD/backlog.md`
- **Deploy VPS:** tidak.

## [2026-10-24] `setupvps.sh`: update otomatis, swap, batas log Docker, peringatan reboot
- **Apa:** `Setup/setupvps.sh` ditambah: `unattended-upgrades` + `20auto-upgrades` (tambalan keamanan harian, tanpa reboot otomatis); swap file 2 GB kalau belum ada swap (masuk `/etc/fstab`); `/etc/docker/daemon.json` dengan batas log `json-file` 10 MB × 3 per container, ditulis sebelum Docker dipasang (kalau Docker sudah ada, daemon di-restart); di akhir, peringatan reboot kalau `/var/run/reboot-required` ada. Langkah jadi 9. `Setup/README.md` ikut diperbarui.
- **Kenapa:** saran tambahan setup VPS yang dipilih owner (1, 2, 3, 5): disk tidak penuh oleh log, Hermes tidak mati kehabisan RAM, tambalan keamanan tidak bergantung pada setup ulang.
- **File:** `Setup/setupvps.sh`, `Setup/README.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak. Untuk VPS yang sudah jalan, poin-poin ini bisa dipasang manual; menjalankan ulang `setupvps.sh` juga me-restart Docker (semua container ikut restart).

## [2026-10-24] Folder induk project ditentukan user
- **Apa:** nama folder project (dulu tetap `whatsinsidegit`) sekarang diisi user, cukup namanya, tanpa `/`. Foldernya selalu `~/<nama>`: dibuat kalau belum ada, dipakai kalau sudah ada. `Setup/setupvps.sh` bertanya di awal, memasang NPM + web dummy di `~/<nama>/proxy/`, dan menulis `PROJ=<nama>` ke `~nuridho/.config/igrow/setup.env` (hanya kalau file belum ada). `Setup/igrow-setup.sh` langkah 5 bertanya "Mau install di mana?" (default dari setup.env) dan folder data otomatis `~/<nama>/igrow-hermes/hermes-home`, menggantikan pertanyaan path `hermes-home` lengkap (variabel baru `PROJ` di setup.env). `Setup/README.md` dan `PRD/07-setup.md` langkah 5 ikut diperbarui. `whatsinsidegit` di `docs/build.md`, `CLAUDE.md`, `PRD/README.md` dibiarkan karena itu path VPS yang sedang jalan.
- **Kenapa:** permintaan owner: nama folder project diisi user saat setup.
- **File:** `Setup/setupvps.sh`, `Setup/igrow-setup.sh`, `Setup/README.md`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak.

## [2026-10-24] Zona waktu pindah ke Asia/Jakarta
- **Apa:** semua `Asia/Kuala_Lumpur` diganti `Asia/Jakarta`: PRD 01 (batasan), 02 (trigger briefing), 03 (NFR-10), 04 (tabel jadwal cron), `docs/build.md` (compose `TZ` + contoh Glance), `Setup/setupvps.sh` (`timedatectl`). "Lokasi: Kuala Lumpur" di contoh lowongan (PRD 02, `test-flow.md`, `peta-igrow.html`) dibiarkan karena itu data contoh, bukan zona waktu.
- **Kenapa:** keputusan owner: jadwal cron & briefing ikut WIB (UTC+7, sebelumnya UTC+8).
- **File:** `PRD/{01-overview,02-use-cases,03-requirements,04-architecture,backlog}.md`, `docs/build.md`, `Setup/setupvps.sh`
- **Deploy VPS:** perlu (sekali, manual): `sudo timedatectl set-timezone Asia/Jakarta`; di compose Hermes ganti `TZ` (atau `IGROW_TZ` di `.env`) jadi `Asia/Jakarta`, lalu `docker compose up -d` supaya container dibuat ulang. Ekspresi cron tidak perlu diubah; `0 7 * * *` jadi 07:00 WIB.

## [2026-10-24] `setupvps.sh`: NPM + web dummy, UFW & hardening sshd otomatis
- **Apa:** `Setup/setupvps.sh` sekarang memasang Nginx Proxy Manager + web dummy (`nginx:alpine`) lewat compose di `/home/nuridho/whatsinsidegit/proxy/` (dilewati kalau port 80 sudah dipakai). Admin NPM hanya di `127.0.0.1:81` (port Docker menembus UFW), diakses lewat SSH tunnel. UFW: port SSH dibaca dari `sshd -T`, plus 80/443, lalu langsung `ufw --force enable`. Hardening sshd otomatis: key root disalin ke nuridho kalau nuridho belum punya, drop-in `sshd_config.d/00-hardening.conf` (`PermitRootLogin no`, `AllowUsers nuridho`), divalidasi `sshd -t` sebelum reload (gagal → file dihapus). User jadi satu variabel `U`. `Setup/README.md`, `PRD/07-setup.md` §6 ikut diperbarui.
- **Kenapa:** permintaan owner: NPM dibawa lagi dengan web dummy, dan script harus seamless (tidak ada langkah "jalankan manual").
- **File:** `Setup/setupvps.sh`, `Setup/README.md`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak.

## [2026-10-24] `setupdocker.sh` digabung ke `setupvps.sh`
- **Apa:** `Setup/setupdocker.sh` dihapus. Bagian yang masih berguna pindah ke `setupvps.sh`: install Docker (dilewati kalau sudah ada) + user `nuridho` masuk grup docker, UFW hanya `OpenSSH` (80/443/81 tidak dibuka lagi karena NPM tidak dipakai). Service Phase 1 (NPM, Portainer, Glance, Homepage) tidak dibawa. `apt update` dipindah sebelum install fail2ban. `Setup/README.md` ditulis ulang (2 script, alur root → nuridho), `PRD/07-setup.md` §6 diperbarui.
- **Kenapa:** permintaan owner: `setupdocker.sh` tidak dipakai lagi, cukup satu script init VPS.
- **File:** `Setup/setupvps.sh`, `Setup/setupdocker.sh` (dihapus), `Setup/README.md`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak.

## [2026-10-24] Setup script: folder data wajib diisi, timezone default Jakarta
- **Apa:** `Setup/igrow-setup.sh` langkah 5: folder data Hermes tidak punya default lagi (user wajib mengisi; `~` dan path relatif diubah jadi path absolut), timezone default `Asia/Jakarta`. `deploy_runtime` berhenti kalau folder data belum ditentukan (sebelumnya `HH` kosong berarti rsync ke `/`). `PRD/07-setup.md` tabel langkah 5 ikut diperbarui.
- **Kenapa:** permintaan owner: lokasi data ditentukan user, zona waktu Jakarta.
- **File:** `Setup/igrow-setup.sh`, `PRD/{07-setup,backlog}.md`
- **Deploy VPS:** tidak. Instalasi yang sudah ada tidak terpengaruh (container lama terdeteksi, folder data diambil dari situ).

## [2026-10-24] Script setup iGROW + PRD 07 Setup
- **Apa:** `Setup/igrow-setup.sh` baru: TUI interaktif 9 langkah (paket dasar, git + SSH key GitHub, Docker, clone repo, compose Hermes resmi, wizard LLM + token Telegram yang dicek ke `getMe`, deploy runtime 2 langkah + `skills.write_approval` + tools cron + start gateway + `hermes doctor`, backup `igrow/` ke repo privat dengan fine-grained token di `hermes-home/.git-credentials` + uji `backup.sh`, 4 cron + uji `lint-privacy.sh`). Aman diulang (langkah yang beres dilewati), mendeteksi container `igrow-hermes` yang sudah ada, menawarkan restore kalau repo backup sudah berisi data, plus perintah `deploy`, `status`, `step N`. Secret hanya diketik saat diminta, tidak masuk repo/log/daftar proses. `PRD/07-setup.md` menjelaskan alur, isian, lokasi hasil, dan keputusan desain (repo di-clone di host, bukan di container). Rujukan ditambah di PRD README (tabel dokumen, versi 1.5), PRD 04 §7, roadmap §3 (baris Now cron + backup), `docs/build.md` (callout di Setup `igrow-hermes`), `Setup/README.md`, `CLAUDE.md` (peta repo).
- **Kenapa:** permintaan owner: setup VPS cukup mengisi yang diperlukan, tanpa menyalin perintah satu per satu. Fakta CLI dicek ke dokumentasi resmi Hermes (Docker: user `hermes` + `HERMES_UID`; `hermes config set`; `hermes setup model`; toolset cron di `hermes tools`; env Telegram termasuk `TELEGRAM_HOME_CHANNEL`).
- **File:** `Setup/igrow-setup.sh` (baru), `PRD/07-setup.md` (baru), `PRD/{README,04-architecture,05-roadmap,backlog}.md`, `docs/build.md`, `Setup/README.md`, `CLAUDE.md`
- **Deploy VPS:** tidak untuk runtime. Script dipakai di VPS: `scp Setup/igrow-setup.sh <user>@<vps>:~/` lalu `bash igrow-setup.sh` (container dan Telegram yang sudah ada dilewati).

## [2026-10-23] Dokumen Word/PDF disimpan asli (D-34, W46)
- **Apa:** keputusan owner: file asli dokumen lampiran (Word/PDF) disimpan utuh di `raw/assets/` tanpa redaksi, sama seperti screenshot; redaksi hanya untuk teks hasil olahan. `capture-experience.md` step 2 + baris dokumen lampiran (simpan asli, baca isi termasuk gambar, note teks diredaksi + `sources` + link di Referensi, path disebut di balasan; tidak terbaca → file tetap disimpan, jangan menebak) dan step 6 `raw/_index.md` kalau ada dokumen. `study.md` step 1: file lampiran disimpan asli dulu. `AGENTS.md` (tabel penempatan "Screenshot/dokumen (file asli)", pengecualian DILARANG KERAS; baris yang sama) dan SCHEMA layer `raw/`. PRD 01, 02 (tabel penempatan, AC UC1), 03 (§3.1, §3.2), 06 (D-34, R-02), README, roadmap (M2.2 uji DOCX/PDF, M2.3 skenario), `docs/peta-igrow.html`, todo (W46 dicatat + dicentang, nomor berikutnya W47).
- **Kenapa:** W46, pertanyaan owner: incident kompleks dikirim sebagai Word/PDF, dan file aslinya (termasuk screenshot di dalamnya) harus tetap utuh untuk belajar ulang.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/{capture-experience,study}.md`, `PRD/{README,01-overview,02-use-cases,03-requirements,05-roadmap,06-risks-decisions,todo,backlog}.md`, `docs/peta-igrow.html`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1) + uji DOCX/PDF di M2.2.

## [2026-10-23] Screenshot disimpan asli tanpa redaksi (D-33, W41)
- **Apa:** keputusan owner: screenshot disimpan asli di `raw/assets/`, tanpa crop atau redaksi; teks note tetap diredaksi. `capture-experience.md` step 2: baris screenshot ditulis ulang (simpan asli, path embed relatif yang benar: 5 kali `../` dari `knowledge/incidents/`, 4 kali dari `knowledge/` dan `lessons-learned/`, info penting di gambar juga ditulis sebagai teks). `AGENTS.md`: tabel penempatan "Screenshot/gambar (asli)" dan DILARANG KERAS mengecualikan screenshot (baris yang sama, tidak menggeser rujukan). PRD 01 (non-goal, batasan persona, prinsip 4), 02 (tabel penempatan, AC privasi UC1), 03 (§3.1 daftar larangan, §3.2 diagram + penjelasan konsekuensi), 06 (D-33, R-02), README (glosarium `raw/`, riwayat 1.4), roadmap (sisa item, prioritas, + skenario screenshot di M2.3), `docs/peta-igrow.html` (deskripsi screenshot), dan todo (W41 dicentang dengan arah baru, § Terbuka) diselaraskan.
- **Kenapa:** W41 + keputusan owner: screenshot dipakai untuk belajar ulang, jadi harus utuh. Konsekuensi yang diterima: gambar asli terkirim ke provider LLM, ikut ter-backup ke GitHub privat, dan tidak diperiksa lint privasi.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/{README,01-overview,02-use-cases,03-requirements,05-roadmap,06-risks-decisions,todo,backlog}.md`, `docs/peta-igrow.html`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Peta iGROW disimpan di docs/
- **Apa:** halaman visual Peta iGROW (diagram arsitektur, alur satu cerita, penjelajah contoh isi `igrow/` setelah sekitar 6 bulan, tabel siapa menulis apa) disimpan sebagai `docs/peta-igrow.html`: HTML mandiri (+ doctype, charset UTF-8, viewport, reset kecil) yang bisa dibuka langsung di browser. Tampilan: putih lembut monokrom, selalu mode terang apa pun tema perangkat; font Plus Jakarta Sans + JetBrains Mono; jalur tulis Hermes → `igrow/` di diagram ditekankan dengan garis tebal. Data dummy ±6 bulan (April–Oktober 2026): 6 incident, 5 knowledge, 2 lesson, 5 note belajar, 1 screenshot, 2 laporan career review (Q2 baseline, Q3 dengan tren), log mingguan, 15 placeholder; konsistensinya (path dual-link, placeholder, tag, index vs note) dicek dengan script di scratchpad. Rujukan ditambah di intro PRD 04 dan baris `docs/` di peta repo `CLAUDE.md`.
- **Kenapa:** permintaan owner, supaya gambaran sistem tersimpan di repo. Isinya ilustrasi dengan data fiktif (PT Acme, Bank XYZ), bukan sumber aturan.
- **File:** `docs/peta-igrow.html` (baru), `PRD/04-architecture.md`, `CLAUDE.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-23] Contoh eksekusi mentor diseragamkan (W45)
- **Apa:** `mentor.md`: contoh eksekusi dipecah dua dengan label tujuan, A (roadmap: pesan user, `weak-topics.md` yang ditulis ulang, baris index, log, balasan) dan B (role fit: pesan user, balasan, tanpa file), + 1 baris untuk prasyarat "data karier belum cukup". Baris `→ OUTPUT` Gap pindah ke alur A sebagai baris pertama balasan; balasan A menyebut kalau `weak-topics.md` ditulis. Todo: W45 dicatat dan dicentang, nomor berikutnya → W46, catatan A6 diperbarui. README (riwayat 1.4).
- **Kenapa:** W45, dari pengamatan owner: contoh mentor masih format lama dan alur roadmap (yang menulis `weak-topics.md`) tidak punya contoh.
- **File:** `hermes-home/igrow/project-skills/mentor.md`, `PRD/{README,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Career review: kuartal, tanpa bertanya, isi balasan (W29, W30, I11)
- **Apa:** `career-review.md` + section `## Aturan`: kuartal yang direview = yang disebut di prompt/pesan (tidak disebut → kuartal berjalan); prosedur tidak bertanya ke user, data kurang (level tidak tertulis, lebih dari satu career aktif) → "dilewati: <alasan>" di laporan dan balasan, Role Fit tetap dihitung kalau skill map ada. Step 1: laporan pembanding = laporan terakhir untuk kuartal sebelum kuartal yang direview. Step 3: baris `→ OUTPUT` jadi baris laporan. Step 4: kuartal pembanding disebut. Step 5: `<YYYY>-Q<n>` = kuartal yang direview, bukan tanggal run; laporan menyebut target level; file kuartal yang sama ditimpa. Step 8 (baru): jawaban akhir = path laporan + 3–5 baris ringkas. Contoh eksekusi dengan label tujuan, kasus 1 Januari 2027 → `career-review-2026-Q4.md`, + baris untuk kasus "dilewati". SCHEMA:107 merujuk ke aturan career review. PRD 02 UC5 (AC), test-flow 5.4 (ditulis ulang + variasi tanpa level), roadmap (sisa item, prioritas, butir 5.4 di M2.3 dihapus), README, todo (W29, W30, I11 dicentang; catatan A6; § Terbuka) diselaraskan.
- **Kenapa:** W29: sesi cron tidak bisa menjawab pertanyaan, jadi review bisa macet atau menebak level. W30: tahun di nama file bisa salah di pergantian tahun. I11: isi pesan Telegram setelah review belum diatur.
- **File:** `hermes-home/igrow/project-skills/career-review.md`, `hermes-home/igrow/SCHEMA.md`, `PRD/{README,02-use-cases,05-roadmap,todo,backlog}.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] skills.md per career terisi otomatis (W42)
- **Apa:** SCHEMA (baris `about.md` & `skills.md`) + format `skills.md`: 1 baris per tag taxonomy (selain `incident`), `<tag>: <skill> (<command kalau ada>), <skill>`, tanpa duplikat. `capture-experience.md`: step 2 "skill yang terlihat di cerita → tambah ke `skills.md`", step 6 + kolom Updated baris `skills.md` di `wiki/_index.md`, step 7 + "skill baru di skills.md" di balasan, Daftar Kerjaan Baru step 5 "(diisi saat capture)" menggantikan "placeholder". Contoh eksekusi + bagian `[EDIT FILE DATA]` (isi `skills.md` sesudah diedit), baris `skills.md` di `[EDIT INDEX]`, baris skill baru di balasan, dan kondisi awal `skills.md`. PRD 02 UC1 (AC), test-flow 1.1, README, roadmap (sisa item), todo (W42 dicentang, § Terbuka) diselaraskan.
- **Kenapa:** W42. Aturan update `skills.md` sudah ada, tapi tanpa format dan tanpa contoh, jadi file itu kemungkinan besar tetap kosong (test-flow 1.1 dan 1.16 gagal).
- **File:** `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/{README,02-use-cases,05-roadmap,todo,backlog}.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Nama folder career aktif + kriteria lesson (I16, W39)
- **Apa:** I16: SCHEMA § Career aktif + bullet: `career-N` di semua path = nama folder lengkap (jangan bikin `career-1/` baru); lebih dari satu career aktif → tanya user. `capture-experience.md` step 1 merujuk aturan itu dan OUTPUT-nya menulis nama folder lengkap; contoh eksekusi memakai `career-1-acme-sysadmin` di semua bagian. Bagian career review dititipkan ke W29. W39: step 2 mendefinisikan incident (ada kejadian spesifik) dan lesson (refleksi tanpa kejadian spesifik; pelajaran incident tetap di `## Lesson Learned`, bukan note terpisah); blok reasoning jadi 3 contoh (incident / lesson / knowledge). `AGENTS.md` tabel penempatan: "Lesson (refleksi, tanpa kejadian)". `career-review.md` Pola: tag `incident` tidak dihitung; kesalahan berulang = ≥ 2 incident/lesson dengan akar masalah sama, minimal 1 di kuartal ini, sebut file-nya (+ contoh). PRD 02 (UC1 alur + tabel, UC5 contoh + AC), 03 FR-06, README, roadmap M2.3, test-flow (1.1, checklist #7), dan todo (I16, W39 dicentang; W29 + kasus dua career aktif; rujukan W29 `SCHEMA.md:106` → `:107`, W42 `SCHEMA:40` → `:41`) diselaraskan.
- **Kenapa:** I16: model bisa menulis ke folder `career-1/` bayangan, dan dua career aktif tidak diatur. W39: tidak ada kriteria lesson, dan `AGENTS.md` ("Lesson dari incident") bertentangan dengan contoh capture.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/{capture-experience,career-review}.md`, `PRD/{README,02-use-cases,03-requirements,05-roadmap,todo,backlog}.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Master index dihapus (W40, D-32)
- **Apa:** keputusan owner: `hermes-home/igrow/_index.md` (master) dihapus; daftar note cukup di `wiki/_index.md`, sumber di `raw/_index.md`, laporan di `output/_index.md`. SCHEMA: protokol tulis jadi 2 langkah (index terdekat + log, "tidak ada master index"), aturan placeholder tanpa "tidak masuk master", batas 200 baris pindah ke `wiki/_index.md` (dipecah per subfolder, `wiki/_index.md` jadi penunjuk). `AGENTS.md`: pintu masuk = `wiki/_index.md` (+ `raw/`, `output/`), `/recall` mulai dari sana. "Master" dihapus dari langkah penutup `capture-experience.md` (step 6 + Daftar Kerjaan Baru), `study.md` (step 6 + contoh), `mentor.md` (bukti + Tutup), `career-review.md` (step 7), `lint.md` (fallback + Tutup). PRD 02 (AC UC1, UC5 ⚠ → ✅ karena W24 sudah beres, /recall), 03 FR-09, 04 (diagram + pohon folder, + `taxonomy.md`), 05 (deploy: hapus master lama di VPS sekali; sisa item), 06 D-32, README (riwayat 1.4), `docs/build.md` (pohon folder), test-flow (1.1, 2.x, 5.4, checklist #3), dan todo (W40 dicentang, rujukan W29 `SCHEMA.md:107` → `:106`, W42 `SCHEMA:41` → `:40`, catatan di W10 dan W18) diselaraskan.
- **Kenapa:** W40. Master tidak pernah punya format isi; kalau cuma berisi jumlah page dan tanggal, keduanya bisa dihitung, dan menghapusnya mengurangi satu langkah di setiap operasi tulis.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/_index.md` (dihapus), `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/{capture-experience,study,mentor,career-review}.md`, `hermes-home/igrow/project-skills/maintenance/lint.md`, `PRD/{README,02-use-cases,03-requirements,04-architecture,05-roadmap,06-risks-decisions,todo,backlog}.md`, `docs/build.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1) + hapus `igrow/_index.md` lama di VPS sekali (rsync tidak menghapus file).

## [2026-10-23] Backup tetap push tiap run; weak-topics ditulis ulang (W38, I14)
- **Apa:** W38: `backup.sh` hanya membuat commit kalau ada perubahan baru, tapi `git push` tetap jalan di setiap run; laporan "pushed" kalau ada commit yang belum di GitHub (`git rev-list --count @{u}..HEAD`, termasuk commit tertunda dari run yang gagal), "no changes" kalau nol, "ERROR" kalau push gagal. Diuji dengan remote git lokal (7 skenario). I14: `mentor.md` menulis ulang `weak-topics.md` dari Gap semua topik target skill map (topik yang sudah Known hilang; isi sama → tidak ditulis). PRD 02 (AC M2, alur UC2), PRD 04 §6.3 (diagram backup), README (riwayat 1.4), roadmap (sisa item, prioritas), todo (W38, I14 dicentang, § Terbuka) diselaraskan.
- **Kenapa:** W38: commit yang gagal di-push tertutup laporan "tidak ada perubahan", dan token kedaluwarsa baru ketahuan saat ada perubahan. I14: topik yang sudah dikuasai tidak pernah hilang dari `weak-topics.md`.
- **File:** `hermes-home/igrow/project-skills/maintenance/backup.sh`, `hermes-home/igrow/project-skills/mentor.md`, `PRD/{README,02-use-cases,04-architecture,05-roadmap,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Prosedur iGROW tidak disimpan sebagai skill/memory Hermes (W37)
- **Apa:** `AGENTS.md` § File Referensi + 1 baris: "Prosedur iGROW hanya dari file di bawah (selalu baca versi di disk). Jangan simpan alur atau data iGROW (mis. career aktif, aturan, tag) sebagai skill/memory Hermes; yang sudah tersimpan diabaikan." Roadmap M2.2 + item VPS: `skills.write_approval: true` (cek `/skills pending` sesekali; `memory.write_approval` opsional). PRD 04 (catatan lapisan instruksi), PRD 06 R-12, README (riwayat 1.4), `CLAUDE.md` (fakta teknis), dan todo (W37 dicentang, rujukan W44 `AGENTS.md:78` → `:79`, § Terbuka, sisa item) diselaraskan.
- **Kenapa:** W37. Dokumentasi resmi Hermes: agent menulis skill dan memory sendiri secara default (termasuk lewat background review) dan memuatnya di setiap sesi, sehingga salinan prosedur lama bisa dipakai menggantikan `project-skills/` terbaru.
- **File:** `hermes-home/AGENTS.md`, `CLAUDE.md`, `PRD/{README,04-architecture,05-roadmap,06-risks-decisions,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1) + set `skills.write_approval: true` di `config.yaml` (roadmap M2.2).

## [2026-10-23] Daftar Kerjaan Baru: tanggal terakhir career lama ditanya (W32)
- **Apa:** `capture-experience.md` § Daftar Kerjaan Baru: step 1 + tanya tanggal terakhir di kerjaan lama (hanya kalau ada career aktif, di ronde yang sama); step 2 menutup career lama dengan tanggal itu (skip → sehari sebelum tanggal mulai kerjaan baru; tidak ada career aktif → dilewati); template `Period` + format YYYY-MM-DD; step 7 + balasan (folder career baru, period career lama, catatan kalau tanggal diisi otomatis). Semua di baris yang sama, rujukan nomor baris tidak bergeser. PRD 02 UC1b (AC), roadmap M2.3 (+ skenario test Daftar Kerjaan Baru), README (riwayat 1.4), todo (W32 dicentang, § Terbuka, sisa item) diselaraskan.
- **Kenapa:** W32. `s/d <hari ini>` salah kalau kerjaan baru didaftarkan beberapa minggu setelah pindah, dan period-nya tumpang-tindih dengan career baru.
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/{README,02-use-cases,05-roadmap,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Daily briefing hanya info, tidak menulis file (D-31, W43)
- **Apa:** keputusan owner: briefing tidak pernah menulis ke wiki. `daily-briefing.md` step 4: "Briefing hanya info: JANGAN menulis file apa pun (wiki/, raw/, index, log). Berita yang mau disimpan → hanya kalau user minta, lewat alur `study.md` (`/study <link>`)" (mengganti izin menulis page kalau berita "layak"). PRD 02 UC3 (diagram: panah UC3 → UC4 lewat /study, paragraf, AC), PRD 06 D-31, README (riwayat 1.4), roadmap (sisa item + prioritas), dan todo (W43 dicentang, § Terbuka) diselaraskan.
- **Kenapa:** W43. Page dari berita akan dihitung "punya note" di Skill Inventory, padahal owner belum mempelajarinya, dan sesi cron menulisnya tanpa ada yang memantau.
- **File:** `hermes-home/igrow/project-skills/daily-briefing.md`, `PRD/{README,02-use-cases,05-roadmap,06-risks-decisions,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Urutan kerja todo: I11 ikut kelompok cron
- **Apa:** `todo.md` § Terbuka dan tabel prioritas `05-roadmap.md` §3 kini menyebut I11 bersama W29, W30, W38, W43 sebagai item yang dikerjakan sebelum cron dibuat, sama dengan tabel urutan kerja yang disusun ulang.
- **Kenapa:** I11 (isi pesan career review) ikut kena di run cron pertama, tapi sebelumnya tidak tercantum di daftar "dikerjakan dulu".
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-23] Nama client boleh di about.md (D-30, W31 tidak jadi)
- **Apa:** keputusan owner: nama client asli boleh ditulis, tapi hanya di field `Vendor/Client` `about.md`; di note dan file lain client tetap generik (`client A`). `AGENTS.md` § DILARANG KERAS + pengecualian itu (di baris yang sama, tidak menggeser rujukan). W31 ditandai TIDAK JADI dan diringkas (kode tetap); catatan rujukan W31 di Act W37 dan W44 dihapus. PRD 01 (non-goal + batasan persona), 02 (AC UC1 + contoh `about.md` UC1b), 03 §3.1 (daftar disamakan dengan AGENTS: "nama dan data client/customer"), 06 (D-30), README (riwayat 1.4), roadmap (sisa item), dan test-flow (Step 0 `about.md`; negatif test 1.1, 1.4, dan checklist #1 + `--exclude=about.md`) diselaraskan.
- **Kenapa:** nama client diperlukan sebagai konteks karier. Di note, nama client bercampur dengan detail sistem, jadi tetap generik.
- **File:** `hermes-home/AGENTS.md`, `PRD/{README,01-overview,02-use-cases,03-requirements,05-roadmap,06-risks-decisions,todo,backlog}.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Daily briefing: tanpa baris alasan, berita bersumber, fallback gagal (W27, W28, I15)
- **Apa:** `daily-briefing.md` ditulis ulang. W27: baris `→ OUTPUT` per item dihapus; jawaban akhir = briefing saja, tanpa alasan pemilihan atau catatan proses. W28: berita terbit ≤ 24 jam dan hanya dari hasil search hari itu (bukan ingatan); tanggal tidak jelas → lewati; tiap item + `Sumber: <URL>` dari hasil search; CVE-ID/severity/CVSS hanya kalau tercantum di sumber (tanpa CVE-ID → `[News]`, severity belum ada → "belum dinilai di sumber"); kurang dari 5 item → kirim yang ada; tidak ada item → `Briefing <tanggal> gagal: <alasan>`. I15 (sisa): step 4 "Jawaban akhir = isi pesan Telegram apa adanya (… jangan pakai tool kirim pesan)". Kalimat wiki (W43) belum diubah, menunggu keputusan owner. Contoh eksekusi dengan label `[PROMPT CRON]` + `[JAWABAN AKHIR]` dan URL placeholder. PRD 01 (metrik briefing terkirim), 02 UC3 (contoh + AC), 03 FR-20, 05 (sisa item, prioritas, verifikasi minggu pertama), 06 OQ-07, README (riwayat 1.4), `docs/build.md` (tabel cron), test-flow 5.3 diselaraskan. Todo: W27, W28, I15 dicentang; catatan di A6; rujukan W43 `daily-briefing.md:35-36` → `:43-44`.
- **Kenapa:** W27, W28, I15. Batas 24 jam (bukan 48 jam di Act W28) supaya berita kemarin tidak muncul lagi di briefing hari ini.
- **File:** `hermes-home/igrow/project-skills/daily-briefing.md`, `PRD/{README,01-overview,02-use-cases,03-requirements,05-roadmap,06-risks-decisions,todo,backlog}.md`, `docs/build.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1). Prasyarat tetap: toolset web aktif untuk platform `cron` (roadmap M2.2).

## [2026-10-23] Catat W44: nilai default/contoh dokumentasi publik di aturan redaksi
- **Apa:** `todo.md` + W44: `AGENTS.md` § Cara redact belum menyebut bahwa nilai default atau contoh dari dokumentasi publik (mis. docker0 `172.17.0.1`) boleh tetap ditulis, sehingga Hermes bisa meredaksinya di note belajar. Header nomor berikutnya → W45; daftar sisa item di roadmap M2.1 diperbarui. Belum ada file `hermes-home/` yang diubah.
- **Kenapa:** pertanyaan owner: redaksi harus tetap menjaga konteks, karena catatan dipakai untuk belajar ulang.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-23] Lint: path dual-link & gambar, slug ganda, inbox, cek privasi (W35, I12)
- **Apa:** `lint.md` ditulis ulang. Cakupan `wiki/` + `raw/` + `output/`. Cek 1 orphan + `raw/articles/`, `raw/assets/`, `output/`. Cek 2 link rusak dipecah: `[[slug]]`, path dual-link (harus menunjuk file yang ada dan berakhir di `<slug>.md` yang sama; target placeholder = path baris placeholder-nya), path gambar, + cara resolve path relatif. Cek 5 untuk ketiga index. Cek 6 slug ganda. Cek 7 file tertinggal di `raw/inbox/`. Cek 8 privasi lewat script baru `maintenance/lint-privacy.sh` (IPv4, `key = nilai`, password/token di kalimat, Bearer token, private key; hanya mencetak `path:baris: jenis`; catatan kerja saja, materi belajar dilewati). Fallback + "cek privasi gagal". Tutup: log berisi jumlah temuan per jenis, lint bukan operasi tulis page, temuan privasi paling atas, dan "Jawaban akhir = isi pesan Telegram (… jangan pakai tool kirim pesan)" (bagian `lint.md` dari I15). Contoh eksekusi dengan label tujuan. PRD 01 (metrik privasi), 02 (AC M1), 03 (FR-21), 05 (toolset + uji script, verifikasi minggu pertama, cek privasi kuartalan, sisa item), 06 (R-02), README (riwayat 1.4) diselaraskan. Todo: W35 + I12 dicentang, progres I15 dicatat, rujukan I11 `lint.md:25` → `:41`, catatan lint di W41 diperbarui.
- **Kenapa:** W35, I12. Script dipilih supaya nilai yang bocor tidak pernah terbaca atau terkutip agent ke Telegram dan log. Cakupan dipersempit supaya contoh dari dokumentasi publik tidak jadi temuan palsu tiap minggu.
- **File:** `hermes-home/igrow/project-skills/maintenance/lint.md`, `hermes-home/igrow/project-skills/maintenance/lint-privacy.sh` (baru), `PRD/{README,01-overview,02-use-cases,03-requirements,05-roadmap,06-risks-decisions,todo,backlog}.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1; script baru tersalin oleh rsync langkah 1). Setelah deploy, uji `bash igrow/project-skills/maintenance/lint-privacy.sh` sekali (roadmap M2.2).

## [2026-10-23] Review menyeluruh hermes-home: 10 temuan dicatat (W37–W43, I14–I16)
- **Apa:** seluruh `hermes-home/` dibaca ulang dan dicocokkan dengan PRD, `testing/test-flow.md`, dan dokumentasi resmi Hermes (Skills, cron, Telegram). Temuan dicatat di `todo.md` § Review menyeluruh: skill buatan Hermes bisa menggantikan `project-skills/` (W37); backup melapor "tidak ada perubahan" walau commit sebelumnya belum ter-push (W38); kriteria type lesson + pola kesalahan berulang (W39); isi master `_index.md` (W40, perlu keputusan owner); screenshot + path gambar (W41); format `careers/*/skills.md` (W42); briefing cron boleh menulis wiki (W43, perlu keputusan owner); `weak-topics.md` tidak pernah dikurangi (I14); "Kirim ke Telegram" di prosedur cron (I15); nama folder career aktif (I16). Act W35 + cek path gambar. Header nomor berikutnya → W44 / I17. Daftar sisa item di roadmap M2.1 dan tabel prioritas diperbarui. Belum ada file `hermes-home/` yang diubah.
- **Kenapa:** permintaan owner: baca ulang dan analisa ulang `hermes-home/`.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-23] Kondisi awal di contoh eksekusi capture
- **Apa:** pengantar Contoh Eksekusi `capture-experience.md` + 1 baris: kondisi wiki sebelum pesan (`cpu-spike-triage` sudah ada, `backup-scheduling` belum), pola umumnya (target See Also yang sudah ada → link balik; belum ada → placeholder), dan penegasan bahwa nama note di contoh hanya ilustrasi. Contoh tetap konkret; `study.md` tidak diubah (semua target See Also-nya belum ada).
- **Kenapa:** masukan owner: sebelumnya kondisi awal hanya tersirat di label `[EDIT NOTE LAMA]`/`[EDIT INDEX]` di tengah contoh, jadi Hermes bisa salah paham kenapa dua link diperlakukan beda atau mengira nama note di contoh wajib dipakai.
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Status topik, slug unik, link balik (W34, I13, W36)
- **Apa:** W34: definisi Known/Weak/Belum + Gap pindah ke SCHEMA § skill-map.md format (pencarian hanya di note naratif `careers/` + `self-development/`); `mentor.md` merujuk ke sana, `career-review.md` step 2 "Weak (= Gap)". I13: SCHEMA § Link + aturan slug (kebab-case; incident `YYYY-MM-DD-<slug>` dengan tanggal kejadian, D-29; unik di antara note, file data dikecualikan; slug terpakai → topik sama = edit, topik beda = konteks pembeda, placeholder = note yang ditunggu). W36: SCHEMA § Link + aturan link balik (hanya note yang ditaut; `updated:` note lama tidak diganti karena career review membaca `updated`; dicatat di subjek log); placeholder yang ditulis memasukkan page penautnya ke See Also. `capture-experience.md` + `study.md`: pointer slug di step 2, link balik di step 6, step 7 menyebut note lama yang dapat link balik; contoh capture memakai nama bertanggal, 1 placeholder + 1 link balik, label `[EDIT NOTE LAMA]` + `[LOG]`; contoh study + baris link balik. PRD 02 (tabel lokasi, AC UC1/UC2/UC4), PRD 06 D-29, README riwayat 1.4, test-flow 1.1 + 1.6, roadmap (sisa item + catatan M2.3 dihapus), W35 Act + cek slug ganda, rujukan W29 `SCHEMA.md:104` → `:107`.
- **Kenapa:** W34, I13, W36; keputusan owner D-29 (nama incident bertanggal).
- **File:** `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/{capture-experience,study,mentor,career-review}.md`, `PRD/{README,02-use-cases,05-roadmap,06-risks-decisions,todo,backlog}.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Todo W36: link balik ke note lama
- **Apa:** item baru W36 di `todo.md` § Review ulang: SCHEMA belum mengatur link balik, jadi note lama tidak pernah menaut ke note baru yang terkait. Act: 1 aturan di SCHEMA § Link (link balik hanya ke note yang ditaut note baru, `updated:` + index ikut, satu entri log), step 6 capture/study merujuk, balasan menyebut note lama yang diperbarui. Ringkasan § Terbuka dan roadmap M2.1 ikut; nomor berikutnya jadi W37.
- **Kenapa:** dari pertanyaan owner soal jumlah link per note; owner minta dicatat dulu.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak (baru dicatat)

## [2026-10-23] Label tujuan di contoh eksekusi capture & study
- **Apa:** contoh eksekusi `capture-experience.md` dan `study.md` dipecah dengan label tujuan: `[PESAN USER — masuk dari Telegram]`, `[FILE DITULIS — <path>; tidak dikirim ke chat]` / `[FILE & INDEX YANG DITULIS]`, `[EDIT INDEX — ...]`, `[BALASAN KE USER — dikirim ke Telegram; hanya bagian ini yang terlihat user]`, + 1 kalimat pengantar ("yang dikirim ke chat HANYA bagian [BALASAN KE USER]"). Label "Input/Output/Balasan" lama dihapus. Contoh study sekarang dibungkus blok kode seperti contoh capture. Step 7 kedua file: "balasan bukan bagian file note". Label pakai `[...]`, bukan heading `##`, supaya tidak tercampur dengan heading di dalam note.
- **Kenapa:** masukan owner: label "Output" dan "Balasan" bisa membuat model menempel isi note ke chat atau menulis rangkuman ke file. Contoh prosedur lain ikut dicek: `career-review.md` punya risiko yang sama begitu I11 menambah balasan Telegram → Act I11 di `todo.md` + label tujuan; `mentor.md`, `daily-briefing.md`, `lint.md` aman (output contoh = pesan balasan itu sendiri).
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `hermes-home/igrow/project-skills/study.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Balasan capture & study memuat rangkuman isi (revisi I10)
- **Apa:** step 7 `capture-experience.md` dan `study.md` + Rangkuman dari isi note yang sudah diredaksi: capture 3–5 poin (incident: kejadian + tanggal / penyebab / tindakan / pelajaran; knowledge & lesson: inti + poin utama), study per note (1 kalimat inti + 2–4 poin, command penting boleh disebut). Blok `Balasan:` di kedua contoh eksekusi ditulis ulang (path, alasan, rangkuman, tags, placeholder, redaksi). PRD 02 AC UC1/UC4 dan test-flow 1.1/2.1 diselaraskan. Isi note lengkap tetap hanya kalau diminta.
- **Kenapa:** masukan owner: balasan terlalu singkat, owner ingin tahu isi yang dicatat tanpa membuka file.
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `hermes-home/igrow/project-skills/study.md`, `PRD/02-use-cases.md`, `PRD/todo.md`, `PRD/backlog.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Alur raw study, tanggal kejadian, isi balasan (W33, I9, I10)
- **Apa:** W33: `study.md` step 6 memindahkan file raw `inbox/` → `articles/` setelah note tertulis lalu meng-update `raw/_index.md`; `sources` menunjuk path tujuan; tanpa sumber mentah → `sources: []`; contoh study diperbaiki (input membawa materi, + baris Index). `capture-experience.md` step 6 + `raw/_index.md` kalau ada screenshot. I9: capture step 2 + aturan waktu relatif → tanggal absolut ("sekitar <tanggal>" kalau tidak pasti), tanggal kejadian di kalimat pertama Ringkasan; contoh Ringkasan + baris index diawali 2026-09-19. I10: step 7 "Balas ringkas" di kedua file (career aktif/topik + alasan, path, tags, placeholder baru, jenis data yang diredaksi; isi note hanya kalau diminta) + blok `Balasan:` di kedua contoh. PRD 02 AC UC1/UC4, test-flow 1.1 + 2.1, I12 Act (+ orphan `raw/`). Rujukan baris todo terbuka aman (W31 `:16`, W32 `:10` di atas baris yang disisipi).
- **Kenapa:** W33, I9, I10.
- **File:** `hermes-home/igrow/project-skills/study.md`, `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/02-use-cases.md`, `PRD/05-roadmap.md`, `PRD/todo.md`, `PRD/backlog.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Note tetap jelas konteks & flow-nya setelah redaksi
- **Apa:** `AGENTS.md` cara redact + 1 poin: placeholder konsisten (nilai sama → placeholder sama, beda → beda nama) dan info non-sensitif (OS, versi, service, port, environment) tetap ditulis. SCHEMA § Body note: tiap command di Contoh diberi komentar (apa & kenapa) dan urut sesuai flow; Investigation incident ditulis per langkah (cek apa → hasil → kenapa lanjut). Few-shot capture: Investigation jadi flow (jumlah baris tetap). PRD 03 §3.1 + 1 baris Salah/Benar. Semua rujukan baris todo tetap (edit di baris yang sama atau di akhir `AGENTS.md`).
- **Kenapa:** masukan owner: redaksi boleh, tapi konteks dan flow harus tetap jelas karena note dipakai buat belajar ulang.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/capture-experience.md`, `PRD/03-requirements.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Redaksi tidak membuang command (revisi A10)
- **Apa:** `AGENTS.md` § DILARANG KERAS + "Cara redact": command/config → ganti nilainya saja dengan placeholder yang menjelaskan peran (contoh `mysql -h <IP-DB> -u <DB-USER> -p<PASSWORD> <DB-NAME>`); log → kutip baris relevan, nilai → placeholder; narasi → nama generik. Self-check `capture-experience.md` dan `study.md` merujuk ke sana (sebelumnya "hapus atau ganti generik"). PRD 03 §3.1 tabel Salah/Benar + 2 baris contoh command. Ditaruh di akhir `AGENTS.md`, jadi rujukan `AGENTS.md:72` (W31) tidak bergeser.
- **Kenapa:** masukan owner: note juga dipakai buat belajar ulang, jadi command tidak boleh hilang saat diredaksi.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/project-skills/capture-experience.md`, `hermes-home/igrow/project-skills/study.md`, `PRD/03-requirements.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Self-check privasi sebelum tulis (A10)
- **Apa:** self-check `capture-experience.md` dan `study.md` + poin pertama: bebas data DILARANG KERAS (`AGENTS.md`), termasuk di title dan nama file; bagian paling rawan disebut (capture: Symptom/Investigation/Contoh; study: Detail/Contoh); ada → hapus atau ganti generik. `study.md` step 1: redact dulu sebelum dump ke `raw/inbox/` (`raw/` immutable, dan step 1 terjadi sebelum self-check). PRD 02: AC privasi baru di UC4, AC UC1 + title/nama file. Rujukan I9 `capture-experience.md:63` → `:64`. Ringkasan todo § Terbuka dan roadmap tidak lagi menyebut A10.
- **Kenapa:** A10. Privasi (aturan paling fatal) belum ikut dicek di checkpoint sebelum tulis.
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `hermes-home/igrow/project-skills/study.md`, `PRD/02-use-cases.md`, `PRD/05-roadmap.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Review ulang hasil W22–W26 + I8
- **Apa:** miss yang diperbaiki: (1) diagram Backup & Recovery PRD 04 § 6.3 masih "Selesai tanpa pesan" → 3 pesan sesuai D-27; (2) metrik reliabilitas PRD 01 kini menghitung pesan backup yang tidak datang sebagai gagal; (3) R-02 masih menyebut daftar larangan di SCHEMA; (4) SCHEMA § Link: slug yang sudah jadi placeholder dipakai ulang path-nya, tidak dibuat baris kedua; (5) SCHEMA § Tag taxonomy `log.md` → `igrow/log.md`; (6) `backup.md`: gagal juga mencakup script yang tidak bisa dijalankan dan error git tanpa prefix `ERROR` (`set -e`); (7) larangan `--delete` di deploy (PRD 04 § 7, `CLAUDE.md`); (8) `build.md` prasyarat Job 2 + identitas commit level repo (tanpa ini `git commit` gagal di container); (9) roadmap M2.2: prasyarat backup dijalankan sebagai user gateway + uji `backup.sh` sebelum cron, verifikasi 1 pesan per jadwal; M2.1: cek `taxonomy.md` setelah deploy; baris cleanup `build.md` + token fine-grained; (10) `CLAUDE.md` § Status menunjuk section todo yang sudah tidak ada; (11) PRD versi 1.4; (12) item lama I1 (Impact "no-change tetap diam") diberi catatan bahwa perilaku itu diganti D-27. Temuan baru: W35 (lint belum memeriksa path markdown di dual-link), nomor berikutnya jadi W36.
- **Kenapa:** permintaan owner (pastikan tidak ada miss sebelum deploy).
- **File:** `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/maintenance/backup.md`, `PRD/{README,01-overview,04-architecture,05-roadmap,06-risks-decisions,todo,backlog}.md`, `CLAUDE.md`, `docs/build.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Satu sumber untuk protokol tulis dan daftar larangan (W25)
- **Apa:** protokol tulis lengkap hanya di SCHEMA § "Tiap operasi tulis WAJIB diakhiri" (langkah 1 + "termasuk Last updated", langkah 2 + "Total pages + Last updated" yang sebelumnya hanya ada di AGENTS); `AGENTS.md` → 1 baris rujuk (pola sama dengan "Career aktif"). Daftar DILARANG KERAS lengkap hanya di `AGENTS.md`, ditambah serial number, raw log client, konfigurasi proprietary, dan "nama" client ditulis eksplisit (samakan dengan PRD 03 §3.1); SCHEMA → 1 baris rujuk. PRD 03 §3.1 (⚠ diganti catatan sinkron) + FR-09, PRD 04 tabel lapisan instruksi (protokol tulis pindah ke lapisan SCHEMA). Rujukan W31 `AGENTS.md:74` → `:72`. Roadmap M2.1: review PRD 2026-10-17 selesai; item baru "kerjakan review runtime sebelum deploy ulang".
- **Kenapa:** W25. Dua salinan sudah mulai beda (Total pages hanya di AGENTS) dan daftar larangan runtime lebih sempit dari kebijakan PRD.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `PRD/03-requirements.md`, `PRD/04-architecture.md`, `PRD/05-roadmap.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Placeholder untuk link ke note yang belum ada (W23)
- **Apa:** SCHEMA § Link + 2 aturan: (1) target belum ada → baris `| <path target> | (placeholder) | - | - |` di `_index.md` terdekat, tidak masuk master, tidak dihitung Total pages; (2) menulis note baru → cek index, slug placeholder → ganti barisnya (path beda → perbaiki link di page penaut). `capture-experience.md` dan `study.md` step 4 + 6 merujuk ke sana. Contoh few-shot capture: label "Output (file note)" + 3 baris index (note + 2 placeholder). Lint cek 5 melewati baris placeholder dan melaporkan "placeholder basi". PRD 02 M1 (⚠ → ✅), test-flow 1.1 (+ expected placeholder), rujukan W29 `SCHEMA.md:102` → `:104`. Ringkasan todo § Terbuka dan roadmap M2.1 tinggal W25. Temuan sampingan: test-flow 1.1 mengharapkan prefix tanggal di nama file incident yang tidak diatur runtime → dicatat di roadmap M2.3.
- **Kenapa:** W23. Note pertama mustahil punya 2 link ke note yang sudah ada; tanpa cara mencatat placeholder, lint melaporkan link rusak setiap minggu.
- **File:** `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/{capture-experience,study}.md`, `hermes-home/igrow/project-skills/maintenance/lint.md`, `PRD/02-use-cases.md`, `PRD/05-roadmap.md`, `PRD/todo.md`, `PRD/backlog.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] `/recall` menyebut page sumber (I8)
- **Apa:** `AGENTS.md` § Perintah: `/recall` yang ketemu → jawab dari isi page + sebut path page yang dipakai (`igrow/wiki/...`). Tetap 2 baris (rujukan `AGENTS.md:74` di W31 aman). AC `/recall` di PRD 02 (⚠ → ✅) + tabel perintah, FR-13, dan test-flow 5.1 (+ syarat gagal tanpa path) diselaraskan. Ringkasan § Terbuka di `todo.md` dan roadmap M2.1 tinggal W23 + W25.
- **Kenapa:** I8. Jawaban recall harus bisa ditelusuri ke file, supaya kelihatan bedanya dengan jawaban dari pengetahuan umum model.
- **File:** `hermes-home/AGENTS.md`, `PRD/02-use-cases.md`, `PRD/03-requirements.md`, `PRD/05-roadmap.md`, `PRD/todo.md`, `PRD/backlog.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1)

## [2026-10-23] Taxonomy jadi file terpisah (W26, D-28)
- **Apa:** daftar tag pindah dari `SCHEMA.md` ke file baru `igrow/taxonomy.md` (milik agent, isi awal 16 tag yang sama). SCHEMA § Tag taxonomy jadi aturan + rujukan; tambah tag cukup append `log.md` (op `update`), tanpa update index. Rujukan "taxonomy SCHEMA" di `capture-experience.md`, `study.md`, `daily-briefing.md`, `lint.md` → `taxonomy.md`. Lint melaporkan "taxonomy hilang" kalau file itu tidak ada. `AGENTS.md` § Struktur + 1 baris. Deploy jadi 2 langkah: rsync dengan exclude `_index.md`/`log.md`/`taxonomy.md`, lalu `rsync --ignore-existing` (tanpa langkah kedua, `taxonomy.md` tidak pernah sampai ke VPS). Ini juga menggantikan aturan "setup pertama tanpa exclude". PRD 02/03/04/README/roadmap/D-28, `CLAUDE.md`, dan `test-flow.md` diselaraskan. Rujukan W31 `AGENTS.md:73` → `:74` (baris bergeser).
- **Kenapa:** W26, keputusan owner D-28.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/taxonomy.md` (baru), `hermes-home/igrow/project-skills/{capture-experience,study,daily-briefing}.md`, `hermes-home/igrow/project-skills/maintenance/lint.md`, `PRD/{README,02-use-cases,03-requirements,04-architecture,05-roadmap,06-risks-decisions,todo,backlog}.md`, `CLAUDE.md`, `testing/test-flow.md`
- **Deploy VPS:** perlu, ikut deploy ulang M2.1 (2 langkah, PRD 04 §7). Setelahnya pastikan `/opt/data/igrow/taxonomy.md` ada.

## [2026-10-23] Review ulang item todo terbuka
- **Apa:** 18 item terbuka di `todo.md` dicocokkan ulang dengan `hermes-home/` dan dokumentasi resmi Hermes (fitur cron). Act dipertajam: W23 (format baris placeholder + few-shot), W25 (3 jenis data terlarang yang tertinggal + Total pages ikut pindah), W28 (jendela 48 jam, item < 5, prasyarat toolset web), W29 (aturan tanpa deteksi cron, skill map ikut dilewati), W30 (review manual + pembanding Q<n-1>), W32 (default tanggal selesai), W33 (screenshot capture), I11, I12 (pola penugasan, bukan kata lepas). Roadmap M2.2 + cek toolset platform `cron`. W26: owner memilih taxonomy file terpisah (D-28), Act ditulis ulang.
- **Kenapa:** permintaan owner (pastikan item siap diterapkan). Dokumentasi Hermes: sesi cron tidak diberi tahu bahwa tidak ada yang menjawab; toolset cron dikonfigurasi terpisah dan run gagal kalau config tidak terbaca.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/06-risks-decisions.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-23] Career review mencatat file wiki ke index (W24)
- **Apa:** `career-review.md` step 7 sekarang juga memperbarui `wiki/_index.md` untuk file `wiki/profile/` dan `wiki/roadmap/skill-map.md` (kalau baru dibuat di step 1), selain `output/_index.md`, master, dan `log.md`.
- **Kenapa:** W24. Tanpa ini, lint melaporkan file hasil UC5 sebagai orphan.
- **File:** `hermes-home/igrow/project-skills/career-review.md`, `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1: rsync `hermes-home/` dengan exclude `_index.md` + `log.md`)

## [2026-10-23] Backup selalu lapor (W22, D-27)
- **Apa:** `backup.md` tidak lagi diam saat tidak ada perubahan. Agent selalu membalas 1 baris: berhasil di-push / tidak ada perubahan / gagal + pesan error. Komentar `backup.sh` disesuaikan. W22 dicentang dengan Act baru; D-27 dicatat; FR-22, AC M2, dan § 6.2 architecture diselaraskan.
- **Kenapa:** keputusan owner, menggantikan rencana `[SILENT]` di W22.
- **File:** `hermes-home/igrow/project-skills/maintenance/backup.md`, `hermes-home/igrow/project-skills/maintenance/backup.sh`, `PRD/todo.md`, `PRD/02-use-cases.md`, `PRD/03-requirements.md`, `PRD/04-architecture.md`, `PRD/06-risks-decisions.md`, `PRD/backlog.md`
- **Deploy VPS:** perlu (ikut deploy ulang M2.1: rsync `hermes-home/` dengan exclude `_index.md` + `log.md`)

## [2026-10-22] Todo baru dari review runtime
- **Apa:** 14 item baru di `todo.md` § Review runtime (2026-10-22): W27–W34, A10, I9–I13. Isinya: daily briefing (alasan dobel di pesan cron, tanpa sumber/fallback), career review cron (bertanya ke user, nama file salah tahun, isi pesan Telegram), nama client di template `about.md`, tanggal selesai career lama, alur raw di study, definisi Known/Weak/Belum, self-check tanpa cek privasi, tanggal kejadian hilang di few-shot, isi balasan setelah tulis note, lint inbox + pola privasi, slug unik. Ringkasan dan prioritas di § Terbuka; nomor berikutnya jadi C9 / W35 / I14 / A11.
- **Kenapa:** permintaan owner (cari improvement lain setelah A7–A9 dihapus).
- **File:** `PRD/todo.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak (baru dicatat; deploy saat item dikerjakan)

## [2026-10-22] Hapus A7–A9 dari todo
- **Apa:** item A7, A8, A9 (Advanced Prompting Tier 3) dan barisnya di § Terbuka dihapus dari `todo.md`. Rujukan di tabel Parked roadmap diganti dari "todo" ke D-13. Kode A7–A9 tidak dipakai ulang (nomor berikutnya tetap A10).
- **Kenapa:** permintaan owner.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-17] Review menyeluruh PRD + diagram opsional
- **Apa:** (1) Diagram Mermaid untuk § 6.2 Cron (sequence) dan § 6.3 Backup & Recovery di architecture, gap analysis di use cases, dan alur screenshot di requirements. (2) Review PRD terhadap `hermes-home/` dan dokumentasi resmi Hermes. Yang diperbaiki di PRD: FR-02 (sesi cron hanya memuat `AGENTS.md` kalau job dibuat dengan `--workdir /opt/data`), § 3.3 (memory dan riwayat sesi tetap terkirim ke provider LLM), urutan alur UC1 (self-check sebelum tulis), ambang UC2 (< 3 note, bukan "kosong"), sumber bukti gap (`lessons-learned/`, bukan `skills.md`), isi laporan UC5 (+ Pola), contoh `skill-map.md` disesuaikan dengan format SCHEMA (+ `## Role Fit`), contoh laporan UC5 (Weak/Recommended konsisten dengan skill map, + Pola dan Role Fit Trend baseline), metrik backup mingguan → Sen/Rab/Sab, item test-flow di roadmap dilengkapi, versi PRD 1.3. AC yang ternyata belum didukung runtime diberi ⚠ dan dicatat sebagai todo W22–W26 + I8. (3) Command cron di `build.md` + fakta teknis cron di `CLAUDE.md` ditambah `--workdir /opt/data` dan `[SILENT]`.
- **Kenapa:** permintaan owner (diagram opsional + review ulang PRD). Fakta cron dicek ke dokumentasi resmi (hermes-agent.nousresearch.com, fitur cron dan memory).
- **File:** `PRD/README.md`, `PRD/01`–`05`, `PRD/todo.md`, `PRD/backlog.md`, `docs/build.md`, `CLAUDE.md`
- **Deploy VPS:** tidak (belum ada perubahan `hermes-home/`). Saat membuat cron nanti, pakai command baru di `build.md` (dengan `--workdir /opt/data`). Kalau ada job yang terlanjur dibuat tanpa flag itu, hapus lalu buat ulang.

## [2026-10-17] Diagram Mermaid di architecture & use cases
- **Apa:** diagram ASCII diganti Mermaid. Architecture: § 1 System Context jadi diagram sistem (komponen + aliran data, komponen Phase 4 bergaris putus-putus), § 6.1 jadi flowchart penanganan pesan. Use cases: "Bagaimana UC Saling Memberi Makan" jadi diagram aliran data antar-UC (trigger tiap UC, folder yang ditulis/dibaca, peran `wiki/roadmap/`). Sisa label basi soal backup mingguan dikoreksi: "git push mingguan" jadi Sen/Rab/Sab, judul "M2 · Backup Mingguan" jadi "M2 · Backup" (D-23).
- **Kenapa:** permintaan owner: flowchart dan diagram alur sistem di architecture, lalu diagram use case.
- **File:** `PRD/04-architecture.md`, `PRD/02-use-cases.md`
- **Deploy VPS:** tidak

## [2026-10-16] Todo dinomori ulang
- **Apa:** kode item di `todo.md` dinomori ulang berurutan dari atas per huruf (C1–C8, W1–W21, I1–I7; A1–A9 tetap). Semua rujukan di PRD dan backlog ikut diganti. Pemetaan lama → baru: C14→C1 · C17→C2 · C18→C3 · C19→C4 · W37→W1 · W38→W2 · C21→C5 · W44→W3 · W46→W4 · I26→I1 · I27→I2 · W47→W5 · W48→W6 · W49→W7 · W50→W8 · W51→W9 · C1→C6 · C2→C7 · C3→C8 · W1→W10 · W2→W11 · W5→W12 · W7→W13 · W8→W14 · W14→W15 · W15→W16 · W16→W17 · W20→W18 · W21→W19 · W30→W20 · W35→W21 · I3→I3 · I5→I4 · I9→I5 · I21→I6 · I17→I7.
- **Kenapa:** todo sekarang khusus `hermes-home/`; nomor lama bolong-bolong setelah 42 item dihapus.
- **File:** `PRD/todo.md`, `PRD/05-roadmap.md`, `PRD/06-risks-decisions.md`, `PRD/backlog.md`
- **Deploy VPS:** tidak

## [2026-10-16] todo.md difokuskan ke hermes-home
- **Apa:** 42 item di luar `hermes-home/` dihapus dari `todo.md` (VPS/setup, `build.md`, FIN, testing, web/portfolio, file root, Jev, fitur yang sudah dihapus), termasuk yang masih terbuka (pembersihan `build.md`, update `test-flow.md`, migrasi Jev). Tersisa 45 item, semuanya tentang AGENTS/SCHEMA/project-skills/struktur `igrow/`. Header disederhanakan dan ada section "Terbuka" (A7–A9). Isi tugas yang masih terbuka dipindah sebagai deskripsi ke `05-roadmap.md`, dan rujukan kodenya di PRD + `CLAUDE.md` diganti.
- **Kenapa:** permintaan owner: todo fokus ke hermes-home, yang di luar topik dibuang.
- **File:** `PRD/todo.md`, `PRD/README.md`, `PRD/04-architecture.md`, `PRD/05-roadmap.md`, `PRD/06-risks-decisions.md`, `CLAUDE.md` (aturan 2: temuan di luar hermes-home dicatat di roadmap, bukan todo)
- **Deploy VPS:** tidak

## [2026-10-16] Koreksi hasil audit hermes-home
- **Apa:** (1) bagian Pola di `career-review.md` menghitung tag dari frontmatter note kuartal itu, bukan dari `log.md` yang tidak memuat tag; (2) contoh incident di `capture-experience.md` dilengkapi H1 + `## Contoh` sesuai template SCHEMA; (3) Daftar Kerjaan Baru mengubah baris `Period:` yang ada, bukan menambah baris baru.
- **Kenapa:** ditemukan saat verifikasi ulang seluruh `hermes-home/`. Poin 1 bug dari audit sebelumnya.
- **File:** `hermes-home/igrow/project-skills/career-review.md`, `capture-experience.md`, `PRD/02-use-cases.md`, `PRD/todo.md`
- **Deploy VPS:** **perlu** (ikut rsync `hermes-home/` yang sama).

## [2026-10-16] Audit & perbaikan hermes-home
- **Apa:** semua item todo yang menyentuh `hermes-home/` dikerjakan: C3, C5, W1, W2, W3, W4–W8, I1, I2. Isi out of context dibersihkan (W9). `SCHEMA.md`, `mentor.md`, `career-review.md`, dan `daily-briefing.md` ditulis ulang. `capture-experience.md`, `study.md`, `lint.md`, `AGENTS.md`, dan `backup.md` diedit. `project-skills/.gitkeep` dihapus. PRD dan jadwal backup di `build.md` diselaraskan.
- **Kenapa:** keputusan owner: skill map beku per level (D-22), backup Senin/Rabu/Sabtu 05:00 (D-23), op `archive` dihapus (D-24), SCHEMA wajib (D-25). Sisanya celah yang sudah tercatat di todo.
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/SCHEMA.md`, `hermes-home/igrow/project-skills/*.md`, `maintenance/lint.md`, `maintenance/backup.md`, `PRD/02`–`06`, `PRD/README.md`, `PRD/todo.md`, `docs/build.md`
- **Deploy VPS:** **perlu**. Salin ulang seluruh `hermes-home/` (pakai rsync dengan exclude `_index.md` + `log.md`). Kalau cron `backup-knowledge` sudah dibuat dengan jadwal lama, hapus lalu buat ulang dengan `0 5 * * 1,3,6`. Hapus juga `igrow/project-skills/.gitkeep` di VPS.

## [2026-10-16] Format `profile/career-summary.md` ditetapkan
- **Apa:** SCHEMA sekarang punya format body `career-summary.md`: satu baris per career berisi folder, Role, Period (dari `about.md`), serta jumlah incident, knowledge, dan lesson hasil hitung file.
- **Kenapa:** sebelumnya `career-review.md` menyuruh memperbarui file ini tanpa format apa pun, padahal SCHEMA menganggap `profile/` sebagai data file. Isinya bisa berubah bentuk tiap kuartal dan tidak bisa dibandingkan. Sekarang isinya hasil hitungan, bukan narasi.
- **File:** `hermes-home/igrow/SCHEMA.md`
- **Deploy VPS:** **perlu**. Salin ulang `SCHEMA.md` (sekalian dengan dua entri di bawah).

## [2026-10-16] Format `profile/skills.md` dipaku ke bar
- **Apa:** format body `profile/skills.md` di SCHEMA diubah dari "bar / bullet singkat" (boleh pilih) menjadi satu format: `- Area  ███████░░░  NN% (X/Y)`, dengan angka yang sama dengan Skill Inventory career review terakhir.
- **Kenapa:** format longgar membuat isi file berubah bentuk tiap kuartal, sehingga sulit dibandingkan, di-lint, dan di-parse `igrow-api`. Pilihan owner: bar.
- **File:** `hermes-home/igrow/SCHEMA.md`
- **Deploy VPS:** **perlu**. Salin ulang `SCHEMA.md` (bisa sekalian dengan deploy entri di bawah).

## [2026-10-16] iGROW_FINAL.md dikonversi ke PRD lalu diarsipkan
- **Apa:** sisa isi FIN dipindah ke PRD: contoh output UC1–UC5, contoh `about.md` dan `skill-map.md`, mekanisme knowledge gap, aturan skill inventory (target = level berikutnya, bar reset), skenario migrasi, dan frontmatter sebagai kontrak `igrow-api`. Format body data file (`weak-topics`, `profile/skills`) dipindah ke `SCHEMA.md`. FIN dipindah ke `archive/`, dan semua rujukan diperbarui. Selisih blueprint vs runtime dicatat sebagai W5–W8. Dua item todo yang hanya membetulkan FIN ditutup, OQ-05 dan OQ-09 selesai.
- **Kenapa:** PRD jadi satu-satunya dokumen produk, dan satu sumber drift hilang (D-21).
- **File:** `PRD/01`–`06`, `PRD/README.md`, `PRD/todo.md`, `hermes-home/igrow/SCHEMA.md`, `docs/build.md`, `testing/test-flow.md`, `CLAUDE.md`, `README.md`, `archive/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang `SCHEMA.md` (ada 1 baris baru untuk format data file).

## [2026-10-16] To-do pindah ke PRD + CLAUDE.md + backlog
- **Apa:** `docs/dev-todo.md` dipindah menjadi `PRD/todo.md`. Temuan PRD ditambahkan (C5, W3–W4, I1, I2), dan rujukan nomor baris FIN/build yang bergeser diperbaiki. `CLAUDE.md` dibuat di root dan file ini dibuat.
- **Kenapa:** to-do, PRD, dan riwayat perubahan dikumpulkan di satu tempat. Claude punya aturan kerja tetap untuk repo ini.
- **File:** `PRD/todo.md`, `PRD/backlog.md`, `CLAUDE.md`, `PRD/README.md`, `PRD/02-use-cases.md`, `PRD/04-architecture.md`, `PRD/05-roadmap.md`, `README.md`, `testing/test-flow.md`
- **Deploy VPS:** tidak

## [2026-10-16] PRD dibuat
- **Apa:** folder `PRD/` berisi 7 dokumen: README, overview, use cases, requirements, architecture, roadmap, dan risks & decisions.
- **Kenapa:** dokumentasi produk yang rapi dengan acceptance criteria, status, risiko, dan keputusan (D-19).
- **File:** `PRD/*.md`, `README.md`
- **Deploy VPS:** tidak

## [2026-10-16] Script testing dihapus
- **Apa:** `check.sh`, `crosscheck.py`, `home-check.py`, `todo-check.py`, dan `audit.py` dihapus. Verifikasi dilakukan manual lewat `testing/test-flow.md`.
- **Kenapa:** keputusan owner (D-18). Menutup tiga item todo soal script testing.
- **File:** `testing/`, `PRD/todo.md`, `README.md`
- **Deploy VPS:** tidak

## [2026-10-16] Struktur repo dirapikan
- **Apa:** dokumen dipindah ke `docs/`, halaman web ke `web/`, arsip ke `archive/`, dan `ignore/` diganti nama menjadi `parked/`. Ditambah `.gitattributes` (LF), `.gitignore`, dan `README.md`. File sisa di root (`.probe*.py`, `.cmp.py`) dihapus.
- **Kenapa:** root lebih bersih. (D-19).
- **File:** seluruh root
- **Deploy VPS:** tidak. Kalau `portfolio.html` disalin manual ke `homepage/index.html`, path sumbernya sekarang `web/portfolio.html`.

## [2026-10-16] AGENTS.md ikut di-backup
- **Apa:** `backup.sh` menyalin `/opt/data/AGENTS.md` ke `igrow/AGENTS.backup.md` sebelum commit.
- **Kenapa:** `AGENTS.md` ada di luar `igrow/` sehingga sebelumnya tidak ikut backup (D-17).
- **File:** `hermes-home/igrow/project-skills/maintenance/backup.sh`, `backup.md`, `docs/build.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang `backup.sh` dan `backup.md`.

## [2026-10-16] Session export dihapus
- **Apa:** `session-export.md`, `session-export.sh`, cron job ke-5, dan semua rujukannya dihapus. Cron sekarang 4 job.
- **Kenapa:** script menyalin folder yang salah (C4) dan terlalu rumit untuk nilainya (D-16).
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/project-skills/maintenance/`, `docs/build.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Deploy ulang `AGENTS.md`, hapus file session-export lama, jalankan `hermes cron remove session-export` kalau job sudah dibuat, dan hapus `log/sessions/archive/` kalau ada.

## [2026-10-15] Contoh few-shot dibetulkan (C2)
- **Apa:** tag contoh diganti ke tag taxonomy. Contoh capture dilengkapi Finding, Lesson Learned, dan Referensi, dengan See Also dual-link. `sources` contoh study diarahkan ke `raw/articles/`. Self-check poin 4 meminta format dual-link.
- **Kenapa:** contoh sebelumnya melanggar aturan SCHEMA sendiri, padahal model meniru contoh (C2).
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `study.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang kedua project skill.

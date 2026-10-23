# Setup: Dari VPS Kosong sampai Bot iGROW Jalan

Folder ini berisi 2 script. Bayangkan pindah ke rumah baru:

| Script | Analogi | Dijalankan sebagai | Berapa kali |
|---|---|---|---|
| `setupvps.sh` | Menyiapkan rumahnya: kunci pintu, pagar, listrik | `root` | Sekali, di VPS baru |
| `igrowctl.sh` | Memindahkan penghuninya (iGROW) dan mengisi perabot | `nuridho` (user biasa) | Sekali untuk pasang, lalu dipakai terus untuk `deploy`, `status`, `update` |

```text
Laptop                       VPS
──────                       ───
scp setupvps.sh     ───────▶ [root]    bash setupvps.sh     → user, Docker, firewall, SSH aman
scp igrowctl.sh  ───────▶ [nuridho] bash igrowctl.sh  → Hermes + Telegram + backup + cron
                                                             ✔ chat bot "halo" di Telegram
```

Kedua script **aman diulang**. Yang sudah ada dicek lalu dilewati, dan tampil sebagai `✔ … (sudah ada)` lengkap dengan detailnya. Contoh: internet putus di langkah 6, cukup jalankan lagi; langkah 1–5 dilewati dan script lanjut dari langkah 6.

Tampilan kedua script sama, bash murni tanpa paket tambahan. Tiap langkah menceritakan apa yang sedang dicek, lalu apa yang ditemukan:

```text
━━ [1/9] Paket dasar ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  git, rsync, curl: alat wajib sebelum yang lain.

  › Mengecek git, rsync, curl, ssh-keygen…
  ✔ git version 2.43.0, rsync 3.2.7, curl 8.5.0 (sudah ada)

━━ [5/9] Container Hermes ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Compose resmi nousresearch/hermes-agent; data di hermes-home/ = /opt/data.

  › Mencari container igrow-hermes…
  • Belum ada container igrow-hermes: compose baru akan dibuat
  › Menyiapkan folder & environment…
  ✔ Folder data: /home/nuridho/whatsinsidegit/igrow-hermes/hermes-home
  ✔ Environment compose: UID/GID 1000:1000, TZ Asia/Jakarta (…/igrow-hermes/.env)
  ⠹ Tarik image nousresearch/hermes-agent 37s         ← spinner + detik berjalan
  ✔ Tarik image nousresearch/hermes-agent 48s         ← durasi tampil kalau ≥ 2 detik
```

Arti tanda: `›` sedang dicek/dikerjakan, `•` info yang ditemukan, `✔` berhasil atau sudah ada, `!` peringatan, `✘` gagal (12 baris terakhir errornya langsung tampil). Output lengkap perintah masuk ke file log, jadi layar tetap bersih. Di akhir ada ringkasan: `✔ 21 dikerjakan  ✔ 9 sudah ada  ! 1 peringatan  waktu 6m40s`.

---

## 1. `setupvps.sh`: Siapkan VPS

### Cara jalankan

```bash
scp Setup/setupvps.sh root@<vps>:~/
ssh -t root@<vps> bash setupvps.sh
```

`-t` wajib, karena script bertanya di awal. Total ±10 menit.

### Yang ditanya (semua di awal, setelah itu jalan sendiri)

| Pertanyaan | Contoh | Dipakai untuk |
|---|---|---|
| Nama folder project | `whatsinsidegit` | Folder `/home/nuridho/whatsinsidegit/`: rumah semua project (NPM, iGROW, dst). Belum ada → dibuat, sudah ada → dipakai. Cukup nama, tanpa `/`. |
| IP publik VPS | `203.0.113.10` | Script menebak sendiri (tinggal Enter), bisa diketik ulang kalau salah. Hanya dipakai untuk ringkasan di akhir: perintah `ssh`/`scp` dan URL sudah terisi IP-nya, tinggal salin. Tidak disimpan ke file. |
| Password user `nuridho` (2×) | | Dipakai saat `sudo`. Hanya ditanya kalau user belum ada. |

### Apa yang terjadi

| # | Langkah | Yang dilakukan | Kenapa perlu |
|---|---|---|---|
| 1 | User | Buat user `nuridho` (sudo), folder project, catat nama folder untuk `igrowctl.sh` | Kerja sehari-hari jangan pakai root. Nama folder dicatat supaya nanti tinggal Enter. |
| 2 | Hostname | `labs.nuridho`, dan dicatat di `/etc/hosts` | Nama mesin di prompt dan log. Tanpa catatan di `/etc/hosts`, setiap `sudo` memunculkan `unable to resolve host`. |
| 3 | Paket & update | Upgrade sistem, pasang fail2ban, ufw, curl, update keamanan otomatis | fail2ban memblokir IP yang mencoba-coba password. Tambalan keamanan terpasang sendiri tiap hari, tanpa reboot otomatis. |
| 4 | Timezone | `Asia/Jakarta` | Jam cron (briefing 07:00) mengikuti WIB |
| 5 | Swap | File swap 2 GB (dilewati kalau sudah ada swap) | RAM penuh → sistem melambat, bukan mematikan Hermes |
| 6 | Docker | Pasang Docker + Compose, batasi log 10 MB × 3 per container, `nuridho` masuk grup docker | Tanpa batas, log container bisa memenuhi disk dalam beberapa minggu |
| 7 | Nginx Proxy Manager | NPM + web dummy di `~/<folder>/proxy/` (dilewati kalau port 80 sudah dipakai) | Pintu masuk web + SSL. Web dummy jadi contoh yang bisa langsung diproxy. |
| 8 | Firewall | UFW hanya membuka SSH, 80, 443, lalu langsung aktif | SSH dibuka duluan, jadi sesi yang sedang jalan tidak putus |
| 9 | SSH | Root tidak bisa login lagi, hanya `nuridho`. Key SSH root disalin ke `nuridho` kalau `nuridho` belum punya | Bot penyerang hampir selalu mencoba login sebagai root |

### Setelah selesai

1. **Jangan tutup sesi root dulu.** Buka terminal baru, coba `ssh nuridho@<IP>`. Kalau berhasil, baru tutup sesi root.
2. **Buka admin NPM** lewat tunnel (port 81 sengaja tidak dibuka ke internet):
   ```bash
   ssh -L 8181:localhost:81 nuridho@<IP>
   ```
   Lalu buka `http://localhost:8181` di browser laptop → login pertama → *Proxy Host*: domain kamu → forward ke `web:80` → aktifkan SSL.
3. Kalau muncul peringatan reboot (biasanya setelah update kernel): `sudo reboot`, setelah poin 1 berhasil.
4. Lanjut ke `igrowctl.sh` di bawah.

Kotak ringkasan di akhir script sudah berisi semua perintah ini dengan IP VPS terisi, jadi tidak perlu mengetik ulang. Script juga mengecek sendiri bahwa NPM menjawab di port 80. Dari browser laptop, `http://<IP>` menampilkan halaman bawaan Nginx Proxy Manager kalau port 80 dan firewall beres. Web dummy baru tampil di domain kamu setelah Proxy Host dibuat.

> **Penting untuk container lain nanti:** port yang dibuka Docker **menembus UFW**. Menulis `ports: "8080:8080"` berarti port 8080 terbuka ke internet walaupun UFW tidak mengizinkan. Pakai `127.0.0.1:8080:8080`, atau lewatkan lewat NPM.

Log lengkap: `/var/log/setupvps.log`.

---

## 2. `igrowctl.sh`: Pasang iGROW

### Siapkan dulu (bisa sambil jalan)

| Yang disiapkan | Cara dapat | Dipakai di langkah |
|---|---|---|
| Akun GitHub yang bisa akses repo iGROW | | 2, 4 |
| Bot Telegram | Telegram → **@BotFather** → `/newbot` → ikuti → copy token | 6 |
| User ID Telegram kamu | Telegram → **@userinfobot** → copy angka `Id` (angka, bukan @username) | 6 |
| API key LLM | Dari provider yang kamu pakai (OpenRouter, Anthropic, OpenAI, dll) | 6 |
| Repo GitHub **privat** kosong untuk backup | github.com/new → mis. `igrow-backup` → Private → tanpa README | 8 |
| Fine-grained token untuk repo backup | GitHub → Settings → Developer settings → Fine-grained tokens → *Only select repositories*: repo backup saja → *Contents: Read and write* | 8 |

Tidak perlu hafal: script menampilkan petunjuk ini lagi tepat sebelum memintanya.

### Cara jalankan

```bash
scp Setup/igrowctl.sh nuridho@<vps>:~/
ssh -t nuridho@<vps> bash igrowctl.sh
```

Jalankan sebagai `nuridho`, **bukan root** (script menolak root). Sudo diminta sekali di awal. Total ±15 menit, kebanyakan menunggu install dan menyalin token. Setelah langkah 4, script juga ada di repo hasil clone: `bash ~/iGROW/Setup/igrowctl.sh <perintah>`.

### Apa yang terjadi

| # | Langkah | Yang kamu lakukan | Yang script lakukan |
|---|---|---|---|
| 1 | Paket dasar | — | Pasang `git`, `rsync`, `curl`, `ssh-keygen` kalau belum ada |
| 2 | Git & GitHub | Isi nama + email commit. Tempel SSH key yang ditampilkan ke GitHub → Settings → SSH and GPG keys, lalu Enter | Buat SSH key VPS, tunggu sampai GitHub menerima key-nya |
| 3 | Docker | — | Pasang Docker kalau belum ada (sudah dipasang `setupvps.sh` → dilewati) |
| 4 | Repo iGROW | Isi URL SSH repo (default sudah ditebak), folder clone (default `~/iGROW`) | Clone repo, atau `git pull` kalau sudah ada |
| 5 | Container Hermes | Isi **nama folder project** (default dari `setupvps.sh`, tinggal Enter) dan timezone (default `Asia/Jakarta`) | Buat `~/<folder>/igrow-hermes/` berisi `docker-compose.yml` + `hermes-home/` (folder data), tarik image Hermes. Container `igrow-hermes` sudah ada → dilewati, folder datanya dipakai. |
| 6 | LLM & Telegram | Di wizard resmi Hermes: pilih provider → tempel API key → pilih model. Lalu tempel token bot dan user ID | Cek token ke Telegram dulu (salah → diminta ulang), simpan ke `hermes-home/.env`. Hanya user ID kamu yang dilayani bot. |
| 7 | Runtime | Jawab "approval memory?" (default tidak). Di layar tools: pilih platform `cron`, nyalakan `web`, `terminal`, `file` | Salin aturan iGROW dari repo ke `hermes-home/`, kunci approval skill, nyalakan bot, jalankan `hermes doctor` |
| 8 | Backup | Isi nama repo backup, buat repo + token (petunjuk tampil), tempel token | Cek repo benar-benar privat (publik → ditolak), push pertama, uji `backup.sh` persis seperti cron. Repo backup sudah berisi data → menawarkan restore. |
| 9 | Cron | — | Buat 4 jadwal (tabel di bawah), uji cek privasi |

Setelah selesai: buka Telegram, kirim `halo` ke bot. Lalu ikuti skenario uji di `testing/test-flow.md`.

**Jadwal otomatis** (WIB, hasilnya dikirim ke chat Telegram kamu):

| Job | Kapan | Isinya |
|---|---|---|
| `daily-briefing` | Tiap hari 07:00 | Maks 5 berita infra/IT ≤ 24 jam terakhir, lengkap dengan sumber |
| `backup-knowledge` | Senin, Rabu, Sabtu 05:00 | `igrow/` di-push ke repo backup |
| `lint-mingguan` | Minggu 08:00 | Cek struktur knowledge base + cek privasi. Hanya melapor, tidak mengubah file. |
| `career-review` | Tanggal 1 Jan/Apr/Jul/Okt 09:00 | Review karier kuartal yang baru selesai, dari data `wiki/` |

### Setelah setup: satu perintah, pilih dari menu

Setelah setup pernah selesai, `bash igrowctl.sh` tidak menjalankan setup lagi, tapi menampilkan menu. Pilih dengan **↑/↓ lalu Enter** (atau `k`/`j`), atau langsung tekan angka/hurufnya. `q` keluar.

```text
  ╭─ Mau ngapain?
  │ ↑/↓ pilih · Enter jalankan · atau tekan angkanya
  │ ❯ 1  Deploy          pasang aturan terbaru dari repo (habis git push)
  │   2  Status          cek bot, Hermes, cron, backup terakhir
  │   3  Update          update Hermes ke versi terbaru
  │   4  LLM & Telegram  ganti API key, model, atau token bot
  │   5  Tools cron      ganti tools untuk job cron
  │   6  Backup          sambung ulang / ganti token backup
  │   7  Setup ulang     semua langkah; yang sudah beres dilewati
  │   h  Help            penjelasan tiap pilihan
  │   0  Keluar
  ╰─
```

| Situasinya | Pilih |
|---|---|
| Kamu mengubah aturan di `hermes-home/` di laptop dan sudah `git push` | **1 Deploy**, lalu kirim `/new` di Telegram supaya sesi baru membaca aturan terbaru |
| Bot diam / mau memastikan semuanya sehat | **2 Status**: container, `hermes doctor`, daftar cron, waktu backup terakhir. Tidak mengubah apa pun. |
| Hermes rilis versi baru | **3 Update**: tarik image terbaru, cek doctor + cron, dan tampilkan baris untuk balik ke versi lama kalau versi baru bermasalah |
| Ganti API key LLM, model, atau token bot | **4 LLM & Telegram** |
| Job cron gagal karena tool-nya mati | **5 Tools cron** |
| Token backup kedaluwarsa / push backup gagal | **6 Backup**, jawab `y` saat ditanya "Ganti token backup?" (token lama dihapus otomatis) |
| Ada langkah yang dulu gagal / ragu setup sudah lengkap | **7 Setup ulang** |
| Bingung maksud pilihannya | **h Help**: penjelasan kapan dipakai dan apa yang terjadi, lalu menu tampil lagi |

Tanpa menu (untuk alias di laptop atau otomatis): `bash igrowctl.sh deploy | status | update | all | step <1-9> | help`. Contoh alias deploy dari laptop:

```bash
alias igrow-deploy='git push && ssh -t nuridho@<vps> bash igrowctl.sh deploy'
```

### Di mana file-filenya

| Apa | Lokasi |
|---|---|
| Repo iGROW (spec, aturan) | `~/iGROW/` |
| Compose Hermes | `~/<folder>/igrow-hermes/docker-compose.yml` + `.env` (UID/GID/TZ, bukan secret) |
| Folder data Hermes (`/opt/data` di container) | `~/<folder>/igrow-hermes/hermes-home/` |
| Knowledge base iGROW | `hermes-home/igrow/` (yang di-backup ke GitHub) |
| API key LLM + token bot | `hermes-home/.env` (mode 600) |
| Token backup GitHub | `hermes-home/.git-credentials` (mode 600, di luar `igrow/`, jadi tidak ikut ter-push) |
| Jawaban setup (path, nama repo, nama bot, penanda setup selesai; bukan secret) | `~/.config/igrow/setup.env` |
| Log setup | `~/.config/igrow/setup.log` |

Secret hanya diketik saat diminta dan tidak pernah masuk repo, log, maupun daftar proses.

### Pindah VPS

Sewa VPS baru, jalankan kedua script dari awal. Di langkah 8, script melihat repo backup sudah berisi data dan menawarkan restore: semua note, raw, dan output kembali. Yang dibuat ulang: API key + token (langkah 6), tools (7), dan cron (9).

---

## Lebih Lanjut

- Kenapa script dibuat seperti ini (repo di host, bukan di container; cara menyimpan secret; restore): [`PRD/07-setup.md`](../PRD/07-setup.md) §4
- Masalah umum dan cara mengatasinya: [`PRD/07-setup.md`](../PRD/07-setup.md) §7
- Portainer, Glance, Homepage dari `setupdocker.sh` lama tidak dibawa; ambil dari `git log` kalau perlu lagi.

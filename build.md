# Build Guide — Personal VPS & DevOps Lab

Dokumen ini menjelaskan **struktur folder** dan **alasan di baliknya**, per phase, sesuai roadmap di `vpslab.md`. Tujuannya bukan cuma copy-paste, tapi biar kamu ngerti *kenapa* strukturnya begitu.

> Baca ini sambil praktik langsung di VPS. Jangan lompat phase — ikutin urutan biar kamu paham dependensi antar service.

---

## Konsep Dasar Sebelum Mulai

Sebelum masuk ke phase, ada beberapa konsep yang perlu kamu pahami dulu karena akan muncul terus di setiap phase:

### 1. Kenapa satu folder per service?
Setiap service (container) dikasih folder sendiri di root project. Folder ini isinya **bukan source code aplikasi**, tapi **volume data** — yaitu data yang harus tetap ada meskipun containernya dihapus atau di-rebuild (config, database, log, dsb).

Analogi: container itu kayak "badan" yang bisa dibongkar-pasang kapan saja. Folder di host itu "otak/memori"-nya yang harus tetap awet.

### 2. Kenapa ada `docker-compose.yml` di root?
File ini adalah "resep" yang mendefinisikan semua service: image apa yang dipakai, port berapa, folder mana yang di-mount ke mana. Dengan satu file ini, seluruh stack bisa di-*rebuild* ulang di VPS lain hanya dengan `docker compose up -d`.

### 3. Kenapa ada `.env`?
Supaya `docker-compose.yml` nggak hardcode value seperti port, domain, atau password. Value-nya disimpan terpisah di `.env`, dan compose file tinggal baca variabelnya. Ini juga memudahkan kalau `docker-compose.yml` mau di-share atau di-commit ke git tanpa bocorin data sensitif (asal `.env` di-gitignore).

> **Catatan:** ada dua `.env` yang beda fungsi — `.env` di **root** (`whatsinsidegit/.env`) isinya value umum lintas service (port, domain, `HERMES_UID`/`HERMES_GID`), dibaca `docker-compose.yml` saat `docker compose up`. Untuk `igrow-hermes` **tidak ada** `.env` terpisah yang kamu tulis manual — secret-nya (`TELEGRAM_BOT_TOKEN`, API key LLM) otomatis ditulis ke `igrow-hermes/hermes-home/.env` oleh wizard `hermes setup`, bukan file yang kamu edit dari awal.

### 4. Kenapa volume di-mount sebagai folder host, bukan Docker named volume?
Supaya kamu bisa **lihat dan backup datanya langsung** lewat `ls`, `cp`, `tar`, dll — tanpa perlu masuk ke internal Docker volume storage. Ini lebih transparan buat belajar, walau di production besar biasanya named volume lebih umum.

---

## Domain Map

| Subdomain | Fungsi | Service (compose) |
|---|---|---|
| `nuridho.com` | Portofolio (root domain) | `home` |
| `portainer.nuridho.com` | Manage Docker | `portainer` |
| `dash.nuridho.com` | Glance dashboard | `glance` |
| `npm.nuridho.com` | Nginx Proxy Manager (admin UI) | `nginx-proxy-manager` |
| `igrow.nuridho.com` | Dashboard visualisasi knowledge iGROW (read-only) | `igrow-web` + `igrow-api` (path `/api`) |

---

## Phase 1 — Foundation

**Tujuan:** Punya personal Docker server yang rapi — reverse proxy, manajemen Docker, monitoring dasar, dan dashboard.

**Service yang dibangun:** Nginx Proxy Manager, Portainer, Glance.

> **Kenapa Glance:** Glance ringan (binary Go kecil, RAM puluhan MB), config-nya satu file YAML (gampang di-backup/version-control), dan bisa nampilin info hidup (status Docker container, dll), bukan cuma kumpulan link statis. Setup awal butuh edit YAML manual — sekalian latihan baca/tulis YAML yang kepake terus di DevOps (compose file, K8s manifest, CI config, dll).

```text
whatsinsidegit/
├── docker-compose.yml
├── .env
│
├── nginx-proxy-manager/
│   ├── data/
│   └── letsencrypt/
│
├── portainer/
│   └── data/
│
├── glance/
│   └── config/
│       └── glance.yml
│
└── homepage/
    └── index.html
```

### Penjelasan tiap folder

**`nginx-proxy-manager/data/`**
Menyimpan konfigurasi proxy host yang kamu buat lewat web UI-nya (domain mana diarahkan ke container mana, port berapa). Kalau folder ini hilang, semua setting routing yang udah kamu buat di UI ikut hilang.

**`nginx-proxy-manager/letsencrypt/`**
Menyimpan sertifikat SSL/HTTPS yang di-generate otomatis dari Let's Encrypt. Kalau folder ini hilang, semua sertifikat harus di-generate ulang (nggak fatal, tapi buang waktu & bisa kena rate limit Let's Encrypt kalau terlalu sering).

**`portainer/data/`**
Menyimpan state Portainer sendiri: user login, koneksi ke Docker environment, dsb. Portainer juga butuh akses langsung ke `/var/run/docker.sock` di host (bukan folder biasa) supaya dia bisa "melihat" dan mengatur Docker di level sistem.

**`glance/config/glance.yml`**
Satu file YAML yang isinya seluruh definisi dashboard: halaman apa aja yang ada, widget apa yang ditampilkan (link ke service, status Docker container, dll), dan layout-nya. Glance cuma butuh satu file teks ini — jadi gampang banget dibaca, di-diff, dan di-backup (tinggal `cp` atau commit ke git).

Karena Glance nggak butuh database, foldernya jauh lebih simpel dibanding kandidat lain yang lebih berat.

**`homepage/index.html`**
Static HTML portofolio, di-serve pakai `nginx:alpine` polos (bukan aplikasi, cuma file HTML/CSS/JS biasa). File **wajib** bernama `index.html` — itu default file yang dicari nginx. Kalau nama file salah atau folder kosong, hasilnya 403 Forbidden.

### Contoh service Glance di `docker-compose.yml`

```yaml
services:
  glance:
    image: glanceapp/glance:latest
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./glance/config:/app/config
```

Simpel — cuma satu volume mount ke folder config, nggak ada database terpisah.

### Cara mulai (step-by-step lengkap)

> Catatan: guide ini nggak pakai Cloudflare — domain diarahkan langsung ke IP VPS lewat DNS management dari registrar domain kamu (Niagahoster, Namecheap, dll). Kalau nanti kamu pindah pakai Cloudflare, cuma tab SSL di NPM yang perlu disesuaikan (proxy status harus "DNS only" pas generate sertifikat pertama kali).

#### Step 1 — Install Docker & Docker Compose

```bash
curl -fsSL https://get.docker.com | sh
```
Script resmi Docker, otomatis install Docker Engine + Compose plugin.

```bash
sudo usermod -aG docker $USER && newgrp docker
```
Biar `docker` bisa dijalankan tanpa `sudo` tiap kali.

```bash
docker --version && docker compose version
```
Cek install berhasil — harus muncul versi keduanya.

#### Step 2 — Buat struktur folder

```bash
mkdir -p whatsinsidegit && cd whatsinsidegit
```
Folder root project.

```bash
mkdir -p nginx-proxy-manager/{data,letsencrypt} \
         portainer/data \
         glance/config
```

> **Kenapa folder harus dibuat duluan?** Kalau Docker yang otomatis bikin folder saat container start, kadang ownership/permission-nya jadi milik `root` dan bikin masalah akses belakangan. Bikin manual duluan lebih aman.

#### Step 3 — Buat glance.yml (wajib ada duluan)

```bash
nano glance/config/glance.yml
```

Isi minimal, lalu save (`Ctrl+O`, Enter, `Ctrl+X`):

```yaml
pages:
  - name: What's Inside Git?
    slug: home
    columns:
      - size: small
        widgets:
          - type: clock
            hour-format: 24h
            timezones:
              - timezone: Asia/Kuala_Lumpur
                label: Kuala Lumpur

          - type: weather
            location: Kuala Lumpur, Malaysia
            units: metric
            hour-format: 24h

          - type: server-stats
            servers:
              - type: local
                name: whatsinsidegit

      - size: full
        widgets:
          - type: monitor
            cache: 2m
            title: Status
            sites:
              - title: Homepage
                url: https://nuridho.com
              - title: Portainer
                url: https://portainer.nuridho.com

          - type: docker-containers
            hide-by-default: false

          - type: bookmarks
            groups:
              - title: Infra
                links:
                  - title: Portainer
                    url: https://portainer.nuridho.com
                  - title: Nginx Proxy Manager
                    url: https://npm.nuridho.com
                  - title: Glance
                    url: https://dash.nuridho.com
```

> **`name` vs `slug`:** `name` bebas pakai karakter apa aja (termasuk `'` atau `?`) karena cuma buat tampilan di nav bar. Tapi Glance otomatis generate URL dari `name` itu — kalau ada karakter aneh, URL-nya bisa rusak dan berujung 404. Solusinya: set `slug` manual (huruf/angka/strip aja) buat kontrol URL-nya terpisah dari nama tampilan.

> Khusus Glance, file ini **wajib** ada duluan karena container-nya baca file itu saat start — kalau belum ada, container bisa gagal start atau error. Service lain (NPM, Portainer) foldernya boleh kosong dulu.

#### Step 4 — Buat file .env

```bash
nano .env
```

Isi contoh:

```env
NPM_PORT=81
PORTAINER_PORT=9443
GLANCE_PORT=8080
```

Ini nyimpen port/value yang bisa berubah-ubah tanpa harus sentuh `docker-compose.yml`.

#### Step 5 — Buat docker-compose.yml

```bash
nano docker-compose.yml
```

```yaml
services:
  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "${NPM_PORT}:81"
    volumes:
      - ./nginx-proxy-manager/data:/data
      - ./nginx-proxy-manager/letsencrypt:/etc/letsencrypt

  portainer:
    image: portainer/portainer-ce:latest
    restart: unless-stopped
    ports:
      - "${PORTAINER_PORT}:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer/data:/data

  glance:
    image: glanceapp/glance:latest
    restart: unless-stopped
    ports:
      - "${GLANCE_PORT}:8080"
    volumes:
      - ./glance/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro

  home:
    image: nginx:alpine
    restart: unless-stopped
    volumes:
      - ./homepage:/usr/share/nginx/html:ro
```

> Volume `docker.sock` di-mount `:ro` (read-only) ke Glance — biar widget `docker-containers` bisa baca status container, tapi Glance nggak bisa start/stop/hapus apa pun.

> Service `home` sengaja **nggak dikasih `ports:`** — nggak perlu di-expose ke host, cukup diakses lewat NPM lewat internal Docker network (pakai nama service `home` sebagai Forward Hostname).

Port 80 & 443 sengaja dibuka publik di service NPM karena dia yang bakal jadi pintu masuk HTTP/HTTPS buat semua domain nantinya (termasuk buat verifikasi SSL di Step 8).

#### Step 6 — Jalankan semua container

```bash
docker compose up -d
```
`-d` = detached, container jalan di background.

```bash
docker ps
```
Cek semua container status `Up`. Kalau ada yang aneh (`Restarting`/`Exited`):

```bash
docker compose logs <nama-service>
```
Contoh: `docker compose logs portainer` — lihat error-nya apa sebelum lanjut.

#### Step 7 — Arahkan domain ke IP VPS

Di DNS management registrar domain kamu, buat A record untuk tiap subdomain:

```
Type: A
Name: `@` (root domain, service `home`)
Value: <IP VPS kamu>
TTL: default / auto
```

Atau kalau lebih suka daftar lengkap:

```
Type: A
Name: portainer
Value: <IP VPS kamu>
TTL: default / auto
```

Cek DNS udah propagate sebelum lanjut ke step SSL:

```bash
dig portainer.nuridho.com
```
Pastikan hasilnya nunjuk ke IP VPS kamu. Propagasi biasanya 5 menit–1 jam, kadang bisa sampai 24 jam.

Buka juga port 80 & 443 di firewall VPS:

```bash
sudo ufw allow 80
sudo ufw allow 443
```

#### Step 8 — Setup Proxy Host + SSL gratis di NPM

Buka `http://IP-VPS-KAMU:81` (port dari `.env`), login pakai default:
```
Email: admin@example.com
Password: changeme
```
(langsung diminta ganti password saat login pertama)

Di menu **Proxy Hosts → Add Proxy Host**:
- Domain Names: `portainer.nuridho.com`
- Forward Hostname/IP: `portainer` (nama service di compose)
- Forward Port: `9443`
- Tab **SSL** → pilih **Request a new SSL Certificate**
- Centang **Force SSL**, **HTTP/2 Support**, dan **I Agree to Let's Encrypt Terms**
- Isi email kamu (buat notifikasi expiry — sertifikatnya auto-renew)
- Save

SSL-nya **gratis** dari Let's Encrypt, nggak perlu bayar apa pun. Ulangi proses yang sama buat `npm` dan `dash`.

> **Kalau gagal generate SSL:** paling sering karena DNS belum propagate (cek ulang `dig`) atau port 80 belum kebuka di firewall. Let's Encrypt juga rate-limit max 5 percobaan gagal per domain per jam.

#### Step 9 — Update glance.yml dengan domain asli

```bash
nano glance/config/glance.yml
```
Ganti URL yang di Step 3 jadi domain asli yang udah punya SSL, lalu:

```bash
docker compose restart glance
```
Ini reload config Glance tanpa hapus data. Perbedaan `restart` vs `up -d` dijelaskan di [Catatan: `docker compose restart` vs `up -d`](#catatan-docker-compose-restart-vs-up--d).

#### Step 10 — Setup Firewall (UFW)

> ⚠️ **URUTAN INI WAJIB, JANGAN DIBALIK.** Allow SSH dulu sebelum enable UFW, kalau kebalik bisa langsung kekunci dari luar (default policy UFW itu `deny incoming`, jadi port 22 ikut ke-block begitu di-enable).

```bash
sudo ufw allow OpenSSH
```
Allow SSH duluan — kalau port SSH kamu custom (misal 2222), pakai `sudo ufw allow 2222/tcp`. Cek dulu port yang aktif dengan `sudo cat /etc/ssh/sshd_config | grep -i port`.

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 81/tcp
```
Port 80/443 buat traffic publik lewat NPM, port 81 buat akses admin panel NPM (bisa ditutup lagi belakangan setelah semua domain + SSL beres, biar lebih aman).

```bash
sudo ufw show added
```
Cek dulu rules-nya sebelum enable — pastiin SSH ada di list ini.

```bash
sudo ufw enable
```
Bakal ada warning soal ssh connection, jawab `y` (karena SSH udah di-allow di step sebelumnya).

```bash
sudo ufw status
```
Verifikasi semua port yang dibutuhin (22/SSH, 80, 443, 81) statusnya `ALLOW`.

> **Kalau kebetulan kekunci:** jangan tutup session SSH yang sedang aktif sampai kamu buka session baru di terminal lain dan berhasil connect. Kalau ternyata ke-block, session lama masih bisa dipakai buat `sudo ufw disable` tanpa perlu akses via provider VPS console.

#### Step 11 — Buat Proxy Host per service (lanjutan Step 8)

Ulangi proses Add Proxy Host di NPM untuk tiap service, tapi **perhatikan Scheme-nya beda-beda tergantung cara service serve traffic secara internal** — ini bukan aturan tetap "semua http" atau "semua https":

| Service | Subdomain | Forward Hostname | Forward Port | Scheme |
|---|---|---|---|---|
| Homepage | *(root domain)* | `home` | `80` | **http** |
| Portainer | `portainer` | `portainer` | `9443` | **https** (self-signed cert internal) |
| Glance | `dash` | `glance` | `8080` | **http** |
| Hermes / iGROW | `igrow` | `igrow-web` (default) + `igrow-api` (Custom Location `/api`) | `80` / sesuaikan | http |

> **Homepage pakai port `80`, bukan port host** — karena service `home` nggak publish port ke host (`ports:` sengaja dikosongin), NPM connect langsung ke port internal container lewat Docker network.

> **Kenapa Forward Hostname harus sama persis nama service di compose?** Forward Hostname itu harus match nama service di `docker-compose.yml`, bukan nama subdomain yang kamu pilih sendiri. Cek nama container yang benar lewat `docker ps`.

> **Kenapa Glance subdomain-nya `dash` bukan `glance`?** Penamaan bebas — subdomain nggak wajib sama dengan nama service/container-nya. Yang wajib sama itu cuma Forward Hostname (harus match nama service di compose).

> **Kalau salah pilih Scheme** (misal http padahal service-nya serve https, kayak kasus Portainer), hasilnya biasanya 502 Bad Gateway atau error SSL yang membingungkan padahal DNS & SSL certificate-nya sendiri udah benar.

**Troubleshooting error yang mungkin muncul:**

- **`ERR_SSL_UNRECOGNIZED_NAME_ALERT`** → proxy host buat domain itu belum dibuat di NPM sama sekali (request sampai ke NPM tapi NPM nggak punya SSL cert yang cocok buat domain itu). Fix: buat proxy host + request SSL cert-nya.
- **502 Bad Gateway / error scheme mismatch** → cek ulang Scheme (http vs https) sesuai tabel di atas, dan pastiin Forward Hostname sama persis dengan nama service di compose.
- **"New Portainer installation" / halaman timeout.html muncul padahal ini baru pertama kali setup** → ini bukan error NPM/SSL, ini fitur keamanan bawaan Portainer: kalau container jalan >5 menit tapi akun admin belum dibuat, Portainer auto-lock diri sendiri. Fix: `docker compose restart portainer`, lalu **langsung** buka URL-nya dan segera bikin username/password admin sebelum 5 menit lewat lagi.
- **`403 Forbidden` (nginx) pas buka homepage** → folder yang di-mount ke `/usr/share/nginx/html` kosong, atau file di dalamnya bukan `index.html`. Cek:
  ```bash
  ls -la ~/whatsinsidegit/homepage/
  ```
  Harus ada `index.html` persis (bukan `portfolio.html` atau nama lain). Kalau salah nama, rename dan restart: `docker compose restart home`.
- **Ada folder nyisa/nggak kehapus di dalam folder static** (misal `igrow-web/frontend/` tetep ada padahal udah coba dihapus) → biasanya karena `rmdir` dipakai buat hapus, padahal `rmdir` **gagal diam-diam** kalau folder itu nggak benar-benar kosong (ada hidden file kayak `.DS_Store` dari Mac, dll). Cek isinya dulu:
  ```bash
  ls -la igrow-web/frontend/
  ```
  Kalau ada isinya, hapus paksa:
  ```bash
  rm -rf igrow-web/frontend
  tree igrow-web/
  ```
  Harus tersisa cuma `index.html` langsung di root folder. Restart container-nya setelah itu.
- **Form create admin minta "Setup token"** → wajib diisi di versi Portainer terbaru. Ambil dari log:
  ```bash
  docker compose logs portainer | grep -i token
  ```
  Copy token yang muncul, paste ke field Setup token, baru Create user. Token ini juga ada batas waktu — kalau expired, restart lagi container-nya buat generate token baru.
- **Glance 404 setelah ganti `name` halaman** (misal jadi "What's Inside Git?") → Glance otomatis generate URL dari `name`, kalau ada karakter aneh (apostrof, tanda tanya) URL-nya rusak. Fix: set `slug: home` manual di bawah `name`, biar URL-nya nggak ikut kena karakter aneh dari `name`.
- **YAML `Config has errors: yaml: line X: did not find expected key`** → biasanya indentasi salah, ada widget baru yang ke-nest di dalam widget lain (harusnya sejajar). Cek jumlah spasi sebelum `- type:` widget baru, harus sejajar persis sama widget lain di level yang sama.

### Widget Monitoring di Glance

Glance dashboard pakai 3 widget buat monitoring dasar tanpa perlu service tambahan:

| Widget | Fungsi |
|---|---|
| `monitor` | GET request ke tiap URL, nampilin status up/down + response time |
| `docker-containers` | Baca `docker.sock`, nampilin status tiap container |
| `server-stats` | CPU, RAM, disk usage server, snapshot terkini |

Catatan: Glance itu *stateless* — cuma nampilin kondisi terkini, nggak nyimpen history/grafik dari waktu ke waktu, dan nggak ada sistem notifikasi otomatis. Kalau ke depannya butuh itu, baru pertimbangkan tool monitoring terpisah.

### Catatan: `docker compose restart` vs `up -d`

| | `docker compose restart <service>` | `docker compose up -d <service>` |
|---|---|---|
| Yang terjadi | Matiin & nyalain ulang container yang sudah ada | Baca ulang `docker-compose.yml`, re-create container kalau definisinya berubah |
| Config (volume/port/env) | **Nggak** di-re-evaluate, pakai setup lama | **Di-evaluate ulang**, kalau beda → container lama dihapus, dibuat baru sesuai config terbaru |
| Dipakai kapan | Cuma edit file *di dalam* volume (misal `glance.yml`) | Edit `docker-compose.yml` sendiri (volume baru, port baru, image baru, environment baru) |

Aturan gampangnya: kalau ragu, pakai `docker compose up -d <service>` — aman buat kedua kasus, karena dia otomatis nggak ngapa-ngapain kalau memang nggak ada perubahan di compose.

### Urutan setup yang disarankan di Phase 1
1. Nyalain Docker & Portainer dulu → biar kamu bisa lihat container lain lewat GUI.
2. Nyalain Nginx Proxy Manager → baru bisa mulai routing domain ke service lain.
3. Nyalain Glance → berisi bookmarks, status monitoring, dan Docker container status sekaligus.
4. Baru setelah semua container jalan, buka Nginx Proxy Manager, buatkan **proxy host** untuk masing-masing service (lihat tabel Step 11), lalu update `glance.yml` biar link-nya sesuai domain asli.

---

## Phase 2 — Personal Project (`igrow-hermes`)

**Tujuan:** dapetin "otak" iGROW jalan dulu — bot Hermes yang bisa dichat lewat Telegram, nulis knowledge base sendiri.

> **Fokus phase ini cuma `igrow-hermes`.** Dashboard visualisasi (`igrow-web` + `igrow-api`) sengaja **ditunda ke Phase 4** — karena command & control utama iGROW **100% lewat Telegram**, dashboard cuma "kaca jendela" opsional buat lihat data yang udah ditulis Hermes. Nggak ada gunanya bangun dashboard duluan kalau belum ada data yang bisa ditampilin. Urutan yang bener: bikin Hermes jalan & mulai nulis data dulu (Phase 2) → baru bikin cara buat "ngintip" data itu dari browser (Phase 4).

### Arsitektur iGROW (gambaran penuh, biar kebayang arah akhirnya)

```text
Telegram ──chat──▶ igrow-hermes (image resmi nousresearch/hermes-agent)   ← PHASE 2, bagian ini
                          │
                          │ nulis (working directory = /opt/data saat mode gateway)
                          ▼
              igrow-hermes/hermes-home/igrow/ (markdown files)
                          ▲
                          │ baca doang (read-only, subfolder igrow/ aja)
                          │
                    igrow-api (jembatan — parsing .md → JSON)            ← PHASE 4
                          ▲
                          │ fetch('/api/...')
                          │
                    igrow-web (dashboard, dibuka di browser)             ← PHASE 4
```

> **Kenapa nanti 3 service, bukan 2 (dashboard fetch langsung ke Hermes)?** Karena `igrow-hermes` itu proses yang sama dengan bot Telegram. Kalau dashboard fetch langsung ke situ, tiap kali dashboard dibuka/di-refresh, request-nya numpuk di proses yang sama dengan bot — resikonya bot ikut kena beban, bahkan ikut down kalau ada bug di endpoint dashboard. `igrow-api` jadi **jembatan terpisah**: tugasnya cuma baca file markdown dari folder yang sama, ubah ke JSON, kirim ke frontend. Dia sama sekali nggak nyambung ke Telegram atau manggil LLM — jadi seberapa pun sering dashboard dibuka, **nggak numpuk beban ke `igrow-hermes` dan nggak makan token AI sama sekali**. Detail pengerjaan `igrow-api` & `igrow-web` ada di Phase 4.

### Setup `igrow-hermes`

> **`build` vs `image` di compose:** `image:` dipakai kalau software-nya udah jadi, tinggal pakai (kayak `nginx:alpine`, `portainer/portainer-ce`). `build:` dipakai kalau software-nya kode custom yang kamu tulis sendiri.
>
> **Keputusan final (lihat `iGROW_FINAL.md` bagian "Implementasi Teknis"):** `igrow-hermes` pakai **image resmi** `nousresearch/hermes-agent` (jadi `image:`, **bukan** `build:`) — infrastruktur agent (Telegram gateway, memory, skill system) udah disediain, tinggal "diajarin" format iGROW lewat `AGENTS.md` + skill custom, bukan nulis bot dari nol.

#### Struktur folder

```text
whatsinsidegit/
└── igrow-hermes/
    └── hermes-home/           # SATU-SATUNYA volume Hermes, mount ke /opt/data
        ├── .env                #   ditulis OTOMATIS oleh `hermes setup` — jangan bikin manual
        ├── config.yaml
        ├── SOUL.md
        ├── AGENTS.md           #   ⭐ WAJIB di root sini (bukan di dalam igrow/) — cwd Hermes
        │                       #   di mode gateway/Telegram = /opt/data, bukan subfolder lain
        ├── (state internal Hermes: sessions/ memories/ skills/ logs/ cron/ cache/ state.db, dst — auto-dibuat, jangan diutak-atik)
        │
        └── igrow/              # ⭐ knowledge base ASLI — nama custom, aman ditambahkan
            ├── SCHEMA.md           #   aturan format/frontmatter/tag — dibaca Hermes sebelum tulis
            ├── _index.md           #   master katalog
            ├── log.md              #   jurnal aksi append-only
            ├── raw/                #   sumber IMMUTABLE (inbox/, articles/)
            ├── wiki/               #   semua konten compiled: careers/, self-development/,
            │                       #   roadmap/, profile/
            ├── output/             #   laporan turunan (career review, dst)
            └── project-skills/  # markdown prosedur per use case, di-refer dari AGENTS.md
                                  #   (BUKAN sistem Skill resmi Hermes — cukup markdown biasa)
```

> Detail lengkap isi tiap subfolder `igrow/` (dengan seluruh sub-kategori, contoh isi `AGENTS.md` & `project-skills/*.md`) ada di `iGROW_FINAL.md` bagian "🛠️ Implementasi Teknis — Hermes Agent" — itu satu-satunya acuan tree lengkap, tidak diulang di sini.

> `igrow-hermes` **tidak punya** `Dockerfile`/`main.py` sendiri — badannya udah disediain image resmi. "Kode custom" kamu buat Hermes wujudnya `AGENTS.md` + file-file di `igrow/project-skills/` (markdown instruksi, bukan program Python/JS).

#### `docker-compose.yml`

```yaml
  igrow-hermes:
    image: nousresearch/hermes-agent:latest   # latest = auto-update; pin versi (mis. :v2026.4.16) kalau mau stabil
    restart: unless-stopped
    command: gateway run                # wajib — tanpa ini Hermes masuk mode chat interaktif, bukan bot standby
    environment:
      - HERMES_UID=${HERMES_UID}        # samain ownership file dengan user host — cek nilainya: `id -u` / `id -g`
      - HERMES_GID=${HERMES_GID}
      - TZ=Asia/Kuala_Lumpur            # timezone cron & container — wajib agar cron `0 7` bunyi jam benar
    volumes:
      - ./igrow-hermes/hermes-home:/opt/data     # SATU-SATUNYA volume — path resmi Hermes, jangan diubah
```

> **Kenapa nggak ada `HERMES_HOME` atau `env_file:`?** Nggak ada env var `HERMES_HOME` buat mindahin path (path resminya fix di `/opt/data`), dan secret Hermes (`TELEGRAM_BOT_TOKEN`, API key LLM) otomatis ditulis wizard `hermes setup` ke `/opt/data/.env` — bukan file yang kamu siapin manual dari luar lewat `env_file:`.

Tambahin `HERMES_UID`/`HERMES_GID` ke `.env` **root** (bukan `.env` per-service):
```bash
id -u   # cek UID user SSH kamu
id -g   # cek GID
```
```bash
nano .env
```
```
HERMES_UID=1003
HERMES_GID=1003
```
(sesuaikan angkanya dengan hasil `id -u`/`id -g` kamu sendiri — jangan asal copy `1003`)

```bash
docker compose up -d igrow-hermes
docker ps | grep igrow-hermes
```
Harus `Up`.

Setelah container jalan, jalanin setup sekali (isi `.env` aja **belum cukup** — `.env` cuma nyimpen secret, model/provider/gateway tetap butuh setup aktif):
```bash
docker exec -it igrow-hermes hermes setup
docker exec -it igrow-hermes hermes gateway setup    # pairing Telegram
```

Verifikasi mount & ownership udah bener sebelum lanjut:
```bash
ls -la ~/whatsinsidegit/igrow-hermes/hermes-home/     # owner harus user kamu, BUKAN root
docker exec -it igrow-hermes ls /opt/data
docker exec -it igrow-hermes hermes doctor
```
Kalau ownership masih `root`:
```bash
sudo chown -R ${HERMES_UID}:${HERMES_GID} ~/whatsinsidegit/igrow-hermes/hermes-home/
docker compose restart igrow-hermes
```

Bikin folder `igrow/` + `AGENTS.md` (di **root** `hermes-home/`, bukan di dalam `igrow/` — karena working directory Hermes di mode gateway/Telegram = `/opt/data`, ini terkonfirmasi lewat GitHub Issue resmi `NousResearch/hermes-agent#5200`):
```bash
mkdir -p ~/whatsinsidegit/igrow-hermes/hermes-home/igrow/{raw/{inbox,articles,assets},wiki/{careers,self-development,roadmap,profile},output,project-skills}
nano ~/whatsinsidegit/igrow-hermes/hermes-home/AGENTS.md
```
Isi `AGENTS.md` (lengkap + contoh, lihat `iGROW_FINAL.md` bagian "Implementasi Teknis").
**Bikin 14 file inti `igrow/` (WAJIB sebelum test Telegram):**

Salin semua file ini ke VPS. Path tujuan sama persis dengan yang sudah ada di `hermes-home/`:

### `SCHEMA.md`

```markdown
---
title: iGROW Schema
schema_state: advisory
created: 2026-08-25
updated: 2026-08-25
---

# iGROW Schema

Aturan main wiki iGROW. Advisory: agent boleh deviasi, tapi harus bilang.

## Layer
- `raw/` — sumber asli, IMMUTABLE. Redact SEBELUM ingest. Slug: `YYYY-MM-DD-nama.md`. Dump file ke `igrow/raw/inbox/`, agent proses → pindah `igrow/raw/articles/` (inbox kosong = semua sudah diproses). Path di frontmatter & body SELALU lengkap dari root: `igrow/raw/...`.
- `wiki/` — semua konten compiled, agent-owned.
- `output/` — laporan turunan (career review, dst).
|- Pengecualian human-owned (agent update cuma kalau diminta): semua `about.md` (kecuali saat daftar kerjaan baru — agent boleh auto-tutup career lama & auto-bikin about.md career baru).
|- Pengecualian human-owned lain: semua `about.md`.
|- `skill-map.md` = AUTO-GENERATE (bukan human-owned). Agent baca `about.md` + seluruh `careers/` + `self-development/` + `lessons-learned/` → generate skill map per level + role-fit matching. User boleh edit manual, tapi bukan keharusan.

## Tiap operasi tulis WAJIB diakhiri
1. Update `_index.md` terdekat (raw/ atau wiki/ atau output/).
2. Update master `igrow/_index.md`.
3. Append `log.md`: `## [YYYY-MM-DD] op | subjek`. Ops: init, ingest, update, lint, review, archive.

## Frontmatter page wiki/
```yaml
---
title: Judul
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: knowledge | incident | lesson | learning | profile | query | data
tags: [dari taxonomy]
sources: [igrow/raw/articles/xxxx.md]   # selalu ada; `[]` kalau murni cerita user
confidence: high | medium | low   # dukungan SUMBER (bukan penguasaanmu)
contradictions: [slug-lain]       # opsional
---
```
- `about.md` & `careers/*/skills.md` tetap plain `Key: value` (bukan frontmatter).
- `skill-map.md` → frontmatter minimal + body list/key:value per level (bukan data type — auto-generate, bukan manual input).

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
Sumber (URL / igrow/raw/... / sesi) — buat napak tilas.

## See Also
Min 2 dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
```
Khusus incident di careers/, Detail diganti alur: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
Data file (`roadmap/`, `profile/`) → body list/key:value, bukan narasi. Frontmatter minimal:
```yaml
---
title: Skill Map
type: data
updated: YYYY-MM-DD
---
```

## Tag taxonomy (tambah baru di sini DULU)
linux, networking, monitoring, incident, docker, kubernetes, cloud, security, storage, performance, dns, windows-server, vmware, devops, sre, cve

## Link
- Antar-page: `[[slug]]` minimal 2 outbound per page.
- Section `## See Also` wajib dual-link: `[[slug|Name]] ([Name](../path/slug.md))`.
- Narasi biasa cukup `[[slug]]`.

## Threshold
- Bikin page: topik muncul 2+ sumber ATAU sentral di 1 sumber.
- Split page >200 baris.
- Master `_index.md` >200 baris → split index per subfolder wiki/.

## skill-map.md format
```markdown
# Skill Map — <Level>
## Target L<n>
- Area: topik, topik, topik
```
- Template baku untuk `wiki/roadmap/skill-map.md` (AUTO-GENERATE, bukan manual input).
- `% Skill Inventory` = (topik yang sudah punya note) / (total topik di skill-map) per area.
- `skill-map.md` juga punya section `## Role Fit` — daftar role yang user cocok (persentase kecocokan berdasarkan skill yang ada) + gap per role.

## Honest gaps
Wiki gak punya jawaban → bilang jujur + usulkan ingest apa.

## DILARANG KERAS (berlaku juga raw/)
Credential, API key/token, IP internal, hostname sensitif, data client, screenshot tanpa redact.
```

### `_index.md`

```markdown
# iGROW — Master Index

> Katalog seluruh page. Baca ini dulu sebelum scan folder.
> Last updated: 2026-08-25 | Total pages: 0

## Careers

## Self-Development

## Roadmap

## Profile

## Output
```

### `log.md`

```markdown
# iGROW Log

> Append-only. Format: `## [YYYY-MM-DD] op | subjek`

## [2026-08-25] init | Struktur igrow/ dibuat (pola wiki varian B)
```

### `raw/_index.md`

```markdown
# Raw Index

> Sumber immutable.
> Last updated: 2026-08-25

| File | Summary | Tags | Updated |
|------|---------|------|---------|
```

### `wiki/_index.md`

```markdown
# Wiki Index

> Konten compiled, agent-owned.
> Last updated: 2026-08-25

| File | Summary | Tags | Updated |
|------|---------|------|---------|
```

### `output/_index.md`

```markdown
# Output Index

> Laporan turunan (career review, dst).
> Last updated: 2026-08-25

| File | Summary | Tags | Updated |
|------|---------|------|---------|
```

### `project-skills/capture-experience.md`

```markdown
# Referensi: Capture Experience (UC1)

Dipakai kalau user cerita incident/pengalaman kerja (bukan /study).

## Daftar Kerjaan Baru
Kalau user bilang "daftar kerjaan baru" / "pindah kerjaan" / cerita kerjaan baru:
1. Tanya 1 ronde: company, role, vendor/client, lokasi, period start, jobdesc singkat.
2. Cek career aktif sebelumnya → tambah `Period: <start> s/d <hari ini>` di `about.md`-nya.
3. Bikin folder baru: `igrow/wiki/careers/career-N-{company}-{role}/` (N = urutan berikutnya).
4. Tulis `about.md`:
   ```
   Company: <nama>
   Role: <role>
   Vendor/Client: <nama> (kalau ada)
   Lokasi: <kota>
   Period: <start> s/d
   Jobdesc: <1-3 kalimat>
   ```
5. Tulis `skills.md` kosong (placeholder untuk UC1 nanti).
6. Career baru = aktif (about.md tanpa tanggal selesai).
7. Tutup: update wiki/_index.md + master + log.md (op: update).

## Langkah
1. Tentukan career aktif: `igrow/wiki/careers/*/about.md` yg belum ada tanggal selesai.
2. Rapikan cerita jadi note terstruktur:
   - Incident → `igrow/wiki/careers/career-N/knowledge/incidents/`
   - Knowledge umum (SOP, cara kerja, setup — tanpa kejadian) → `igrow/wiki/careers/career-N/knowledge/<slug>.md` (FLAT, JANGAN bikin subfolder per topik — topik lewat tags)
   - Lesson → `igrow/wiki/careers/career-N/lessons-learned/`
   - Skill terpakai → update `igrow/wiki/careers/career-N/skills.md`
   - Screenshot → `igrow/raw/assets/YYYYMMDD-deskripsi.png` (WAJIB redact); rujuk dari note via `sources: [igrow/raw/assets/...]` + `![](../../raw/assets/...)` di body
3. Format frontmatter ikut `igrow/SCHEMA.md` (type: incident|lesson|knowledge).
   Body incident: Symptom / Investigation / Finding / Action / Result / Lesson Learned.
4. See Also: minimal 2 link (dual-link format).
5. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md, master _index.md, log.md (op: ingest/update).

## Larangan
Ikut DILARANG KERAS di AGENTS.md — redact data client sebelum nulis.

## Kontradiksi dgn note lama
Kalau cerita baru bertentangan dgn lesson/incident lama: JANGAN diam-diam timpa.
Tanya klarifikasi singkat (1x), catat apa adanya, lalu isi field `contradictions: [slug-lama]`
di frontmatter (SCHEMA). Lesson lama TIDAK dihapus — dua-duanya hidup, kontradiksi terdokumentasi.
```

### `project-skills/mentor.md`

```markdown
# Referensi: Mentor (UC3)

Dipakai kalau user tanya roadmap belajar, kelemahan, "harus belajar apa", atau "role apa cocok buat saya".

## Input data
1. Target: `igrow/wiki/roadmap/skill-map.md` — AUTO-GENERATE kalau belum ada:
   baca `about.md` career aktif (role + jobdesc), seluruh `careers/*/knowledge/`, `careers/*/lessons-learned/`,
   `self-development/`, `tests/` → generate skill map per level + role-fit matching.
   Human boleh edit manual, tapi bukan keharusan (agent auto-update setiap ada data baru).
2. Terdokumentasi: `igrow/_index.md` (katalog careers + self-development)

Knowledge gap = topik target yg TIDAK ada di index, ATAU cuma disebut sekali lewat.

## Output

### A. Jika user tanya "harus belajar apa" / roadmap
- Known / Weak / Experience — tabel 3 kolom: skill yg ada notenya + dipakai di incident, skill target yg cuma disebut sekali, skill target yg belum tersentuh sama sekali
- Update `wiki/roadmap/weak-topics.md` kalau ada temuan baru
- Rekomendasi personal ("kamu sudah pernah kena X, mulai dari Y"), BUKAN roadmap generik

### B. Jika user tanya "role apa cocok" / kecocokan karier
- Role Fit — tabel: role A (X% cocok, kurang: Y, Z), role B (W% cocok, kurang: U, V), dst
- Persentase dihitung dari: topik skill yang sudah ada / topik yang dibutuhkan role tsb
- Sertakan 2 role paling cocok + 2 role paling jauh, masing-masing dengan gap spesifik
- Rekomendasi personal ("kamu cocok X% untuk SRE karena sudah punya networking + incident, tapi kurang cloud — mulai dari AWS fundamentals")

## Prasyarat jujur
Kalau careers/ belum ada isi → bilang bahannya belum cukup,
jangan ngarang gap analysis generik. (skill-map kosong BUKAN alasan menolak — generate dulu.)

## Tutup
Kalau ada file ditulis/diupdate (skill-map, weak-topics): ikut aturan wajib SCHEMA
(update wiki/_index.md + master _index.md + log.md, op: update).
```

### `project-skills/daily-briefing.md`

```markdown
# Referensi: Daily Briefing (UC4)

Dipicu cron 07:00. Topik: linux, windows-server, kubernetes, docker, vmware,
cloud, networking, monitoring, devops, sre, security, cve (= tag taxonomy SCHEMA).

## Langkah
1. Web research berita terbaru (maks 5 info penting).
2. Format output:

```
DAILY INFRA BRIEFING
<tanggal>

1. <Topik>
   <berita>
   Why it matters: ...
```

3. Prinsip: 5 info penting + alasan peduli. Bukan berita banyak.
4. Kirim ke Telegram. Tidak menulis ke wiki/ kecuali ada yg layak jadi page
   (kalau iya, ikut aturan wajib SCHEMA, op: ingest).
```

### `project-skills/study.md`

```markdown
# Referensi: Dokumentasi Belajar (UC5)

Dipakai kalau user `/study` atau cerita selesai belajar sesuatu.

## Langkah
1. Sumber mentah (link/PDF/artikel)? → dump ke `igrow/raw/inbox/` (ikut pipeline AGENTS: inbox → articles/)
   `YYYY-MM-DD-nama.md` + frontmatter raw (source_url, ingested).
2. Note terstruktur → `igrow/wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>/`
   Frontmatter ikut SCHEMA (type: learning, sources: [igrow/raw/...]).
   Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also.
3. Topik fuzzy-match ke taxonomy SCHEMA (konsisten lintas sesi).
4. See Also: min 2 dual-link.
5. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md + master + log.md (op: ingest).

## Perintah
"/study baru selesai materi X di KodeKloud: ..." → strukturkan.
"/study bandingkan A dengan B" → page komparasi, tetap di folder sumber yg relevan.
```

### `project-skills/career-review.md`

```markdown
# Referensi: Career Review Quarterly (UC6)

Dipicu cron quarterly atau user minta review.

## Langkah
1. Baca: `igrow/wiki/careers/` (semua), `wiki/roadmap/skill-map.md` (AUTO-GENERATE dari `about.md` + careers + self-dev),
   `igrow/log.md` kuartal berjalan.
2. Analisis 4 bagian: Learned (skill baru terdokumentasi kuartal ini), Experienced (insiden/pengalaman), Improved (topik yang notenya makin dalam), Weak (target skill-map yg belum tersentuh).
3. Skill Inventory — hitung, bukan kira-kira:
   % per area = (topik target yang sudah ada notenya di area itu) / (total topik
   target `wiki/roadmap/skill-map.md` untuk area itu). Angka dari counting file,
   bukan reasoning. Tiap bar + insight singkat (kenapa segitu, langkah berikutnya).
4. Role Fit Trend — bandingkan % kecocokan role dari skill-map tahun lalu vs sekarang (naik/turun? Kenapa?).
5. Tulis laporan ke `igrow/output/career-review-<YYYY>-Q<n>.md`.
6. Update `wiki/profile/skills.md` + `career-summary.md`.
7. Tutup dgn aturan wajib SCHEMA: update output/_index.md + master + log.md (op: review).
```

### `project-skills/lint.md`

```markdown
# Referensi: Lint Mingguan

Dipicu cron Minggu 08:00. Cek kesehatan struktur `igrow/wiki/` — BUKAN baca
ulang isi konten.

## Cek (laporkan temuan saja, JANGAN ubah isi note)
1. Orphan page: file `*.md` di wiki/ yang tidak tercatat di `_index.md`
   terdekat. Lewati file berawalan `_` dan `.gitkeep`.
2. Broken wikilink: `[[slug]]` tanpa file target — KECUALI slug tercatat di
   `_index.md` dengan tanda `(placeholder)` (unresolved sengaja, lewati).
3. Frontmatter note: 7 field wajib SCHEMA (title, created, updated, type,
   tags, sources, confidence) — `contradictions` opsional.
4. Tag di luar taxonomy SCHEMA.
5. `_index.md` vs filesystem: entri index yang file-nya sudah tidak ada.

## Tutup
Append ringkasan ke `igrow/log.md` (op: lint). Kirim ke Telegram; semua
bersih → cukup "wiki sehat".
```

### `project-skills/backup.md`

```markdown
# Backup Knowledge (UC4 — Cron Mingguan)

Dipicu cron Minggu 03:00. Push `igrow/` ke GitHub privat `igrow-backup`.

## Langkah

1. Jalankan `igrow/project-skills/maintenance/backup.sh` — script handle add/commit/push, silent kalau no-change.
2. Exit non-zero → laporkan error ke Telegram.
3. Exit 0 + output "no changes" → jangan kirim pesan.

## Aturan

- Script cuma backup subfolder `igrow/`, bukan seluruh `HERMES_HOME/`.
- Jangan utak-atik `.git/` manual.
- Prasyarat: repo sudah diinisialisasi + remote (`git remote add origin`).
```

### `project-skills/maintenance/backup.sh`

```bash
#!/usr/bin/env bash
# backup.sh — push igrow/ ke GitHub repo privat igrow-backup.
# Dipicu via cron `hermes cron create` → baca backup.md → jalankan script ini.
# Exit 0 = sukses atau silent (no-change). Exit non-zero = error.
set -euo pipefail

cd /opt/data/igrow || { echo "ERROR: cannot cd to igrow"; exit 1; }

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: igrow/ bukan git repo — jalankan: git init && git add -A && git commit -m init"
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "backup: no changes, skipping" >&2
  exit 0
fi

git commit -m "backup $(date +%F)"

if git push; then
  echo "backup: pushed successfully"
else
  echo "ERROR: git push gagal" >&2
  exit 1
fi
```

```markdown
# iGROW — Aturan Inti

Kamu adalah Hermes, asisten personal untuk iGROW: sistem arsip karier &
knowledge IT worker. Prinsip: knowledge portable, markdown biasa. Semua data
iGROW di folder `igrow/` (relatif dari sini). Pola wiki: baca
`igrow/SCHEMA.md` sebelum operasi tulis apapun.

## Apa Ini
Knowledge base yg di-compile LLM. Kamu = compiler + query engine: sumber mentah
masuk → kamu compile jadi wiki .md terinterkoneksi. Human jarang edit wiki
langsung — itu domainmu. Metafora: raw/ = source code, kamu = compiler,
wiki/ = executable.

## Struktur Folder (igrow/)
- `igrow/SCHEMA.md`        → aturan format, frontmatter, tag, ownership — BACA DULU sebelum tulis
- `igrow/_index.md`        → master katalog; baca ini dulu sebelum scan folder
- `igrow/log.md`           → jurnal aksi append-only: `## [YYYY-MM-DD] op | subjek`
- `igrow/raw/`             → sumber IMMUTABLE (inbox/ → proses → articles/)
- `igrow/wiki/`            → semua konten compiled, kamu yang maintain
  - `careers/career-N-.../` → knowledge TERIKAT satu pekerjaan (about.md, knowledge/, lessons-learned/, skills.md)
  - `self-development/`    → knowledge UMUM (Project/, Bootcamp/, Dokumentasi/)
  - `roadmap/`            → roadmap, skill-map.md (target skill per level), weak-topics
  - `profile/`             → ringkasan karier — gabungan semua career
- `igrow/output/`          → laporan turunan (career review quarterly, dst)
- `igrow/project-skills/`  → file referensi prosedur (baca kalau relevan)

`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat. Jangan utak-atik `.git/`.

## Aturan Penempatan Cepat
| Cerita soal...                    | Taruh di                                        |
|------------------------------------|--------------------------------------------------|
| Incident kerjaan aktif            | igrow/wiki/careers/career-N/knowledge/incidents/ |
| Knowledge kerjaan (SOP/cara/setup)| igrow/wiki/careers/career-N/knowledge/ (flat .md) |
| Lesson dari incident              | igrow/wiki/careers/career-N/lessons-learned/     |
| Belajar mandiri (bukan kerjaan)   | igrow/wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama> |
| Artikel/dok belajar (mentah)      | igrow/raw/inbox/ → proses → raw/articles/ (inbox kosong = sudah diproses) |
| Screenshot/gambar (sudah redact)  | igrow/raw/assets/YYYYMMDD-deskripsi.png          |
| Daftar kerjaan baru               | igrow/wiki/careers/career-N-{company}-{role}/     |
| Laporan career review             | igrow/output/                                    |

## Tiap operasi tulis WAJIB diakhiri
1. Update `_index.md` terdekat (raw/ atau wiki/ atau output/).
2. Update master `igrow/_index.md` (termasuk "Total pages" + "Last updated").
3. Append `igrow/log.md`.

Career aktif: rujuk `igrow/SCHEMA.md`.

## Perintah
- /study  → dokumentasiin yang sudah dipelajari (ke wiki/self-development/...)
- /recall → baca igrow/_index.md dulu; ketemu → baca page & jawab; nggak ketemu
  → bilang jujur "belum ada catatan", tawarin riset/tulis baru (honest gaps)

## File Referensi (baca isinya kalau relevan sama pesan user)
- igrow/project-skills/capture-experience.md → user cerita incident/pengalaman
- igrow/project-skills/mentor.md             → user tanya roadmap/kelemahan belajar
- igrow/project-skills/daily-briefing.md     → dipicu cron 07:00
- igrow/project-skills/study.md              → user /study
- igrow/project-skills/career-review.md      → cron quarterly / user minta review
- igrow/project-skills/maintenance/lint.md    → dipicu cron Minggu 08:00
- igrow/project-skills/maintenance/backup.md  → dipicu cron Minggu 03:00
- igrow/project-skills/maintenance/session-export.md → dipicu cron Minggu 03:15

## DILARANG KERAS (berlaku juga raw/ — redact SEBELUM ingest, raw immutable)
Credential, API key/token, IP internal, hostname sensitif, data client,
screenshot yang belum di-redact.
```

> `igrow-hermes` sengaja **nggak publish port** ke host — diakses murni lewat Telegram, nggak perlu proxy host/NPM sama sekali di phase ini.

#### Test lewat Telegram

Chat ke bot kamu, coba beberapa hal:
- *"kamu lagi di direktori mana sekarang, dan apa aturan iGROW yang kamu tau?"* → kalau dia nyebut struktur `igrow/wiki/careers/`, dst dari `AGENTS.md`, berarti context file-nya beneran ke-load.
- Cerita satu pengalaman kerja singkat → cek `igrow-hermes/hermes-home/igrow/` di host, harus ada file baru ke-generate sesuai aturan penempatan di `AGENTS.md`.

---

### Setup 4 Cron Job (maintenance rutin iGROW)

4 job dibuat **sekali** dari shell host pakai `hermes cron create` di dalam container (scheduler-nya jalan di dalam gateway `igrow-hermes`, jadi job tetap hidup selama container jalan; `--deliver telegram` wajib — job dari shell host tidak punya chat asal, tanpa flag ini output bisa tersimpan tanpa terkirim).

| # | Job | Schedule | Yang dikerjakan |
|---|-----|----------|-----------------|
| 1 | Daily Briefing | `0 7 * * *` (tiap hari 07:00) | Web research 5 berita infra → kirim ringkasan ke Telegram |
| 2 | Backup Knowledge | `0 3 * * 0` (tiap Minggu 03:00) | Push `igrow/` ke GitHub repo privat `igrow-backup` (via SSH) |
| 3 | Lint Mingguan | `0 8 * * 0` (tiap Minggu 08:00) | Cek kesehatan wiki (orphan, broken link, dll) → lapor ke Telegram |
| 4 | Career Review | `0 9 1 1,4,7,10 *` (tgl 1 tiap kuartal, 09:00) | Review kuartalan → laporan ke `output/` + ringkasan ke Telegram |

**Prasyarat Job 2 — repo backup (sekali saja):**
```bash
docker exec -it igrow-hermes bash
cd /opt/data/igrow && git init && git add -A && git commit -m "init"
git config --global credential.helper store
git remote add origin https://<TOKEN>@github.com/nuridho/igrow-backup.git
git branch -M master
git push -u origin master
exit
```
(`<TOKEN>` = GitHub personal access token scope `repo`. Kalau network Docker nge-block push ke `github.com`, ganti host di URL remote jadi `igrow.nuridho.com` — domain kamu sendiri, sudah lolos whitelist.)

**Buat 4 job (copy-paste per blok ke shell host):**

```bash
docker exec -it igrow-hermes hermes cron create '0 7 * * *' \
  'Baca igrow/project-skills/daily-briefing.md lalu kerjakan.' \
  --name daily-briefing --deliver telegram
```

```bash
docker exec -it igrow-hermes hermes cron create '0 3 * * 0' \
  'Baca igrow/project-skills/backup.md lalu kerjakan.' \
  --name backup-knowledge --deliver telegram
```

```bash
docker exec -it igrow-hermes hermes cron create '0 8 * * 0' \
  'Baca igrow/project-skills/lint.md lalu kerjakan.' \
  --name lint-mingguan --deliver telegram
```

```bash
docker exec -it igrow-hermes hermes cron create '0 9 1 1,4,7,10 *' \
  'Baca igrow/project-skills/career-review.md lalu kerjakan untuk kuartal yang baru selesai.' \
  --name career-review --deliver telegram
```

Prompt itu POSITIONAL (`hermes cron create [opts] SCHEDULE PROMPT`) — tidak ada flag `--prompt`. Kalau format argumennya beda di versi Hermes kamu, cek `docker exec -it igrow-hermes hermes cron create --help` — atau fallback ke chat Telegram: `/cron` → create, isi schedule + prompt yang sama.

Cek hasilnya kapan aja: `docker exec -it igrow-hermes hermes cron list` dari host, atau `/cron` lewat Telegram.

---

## Phase 3 — Observability Ringan *(nanti)*

Bagian Dozzle nyusul setelah Phase 2 (`igrow-hermes`) selesai & stabil.

---

## Phase 4 — Integrasi (`igrow-api` + `igrow-web`)

**Tujuan:** bikin dashboard visual read-only buat "ngintip" knowledge base yang udah ditulis `igrow-hermes` (Phase 2) dari browser. Command & control tetap 100% Telegram — dashboard nggak punya tombol aksi apapun.

**Dipecah 2 tahap** biar nggak numpuk sekaligus — deploy static dashboard-nya dulu pakai data dummy, baru nanti disambungin ke `igrow-api` begitu Hermes-nya udah punya data asli.

### 4a — Deploy Static Dashboard (data dummy)

Tahap ini polanya **sama persis kayak service `home`** di Phase 1 — nginx static, folder wajib berisi `index.html` **langsung** (bukan di dalam subfolder kayak `igrow-web/frontend/index.html` — itu bikin 403 karena nginx nyari `index.html` tepat di root folder yang di-mount).

> **Penamaan service wajib `igrow-web`**, bukan `igrow-frontend` atau variasi lain — biar konsisten sama proxy host, dokumentasi ini, dan referensi di 4b nanti. Kalau nama service di compose beda dari yang didokumentasikan, gampang ke-drift dan bikin bingung pas troubleshooting belakangan.

#### Struktur folder

```bash
mkdir -p ~/whatsinsidegit/igrow-web
```

Upload dashboard versi data dummy, pastiin namanya `index.html` dan **langsung** di `igrow-web/`, bukan di subfolder:
```bash
scp index.html nuridho@43.156.50.9:~/whatsinsidegit/igrow-web/
```

Cek struktur, harus persis begini:
```text
igrow-web/
└── index.html
```

#### Tambah service di `docker-compose.yml`

```yaml
  igrow-web:
    image: nginx:alpine
    restart: unless-stopped
    volumes:
      - ./igrow-web:/usr/share/nginx/html:ro
```

> Sengaja **nggak publish port** ke host — sama kayak `home`, diakses lewat NPM lewat internal Docker network aja.

```bash
docker compose up -d igrow-web
docker ps | grep igrow-web
```
Harus `Up`.

#### DNS + Proxy Host

```
Type: A
Name: igrow
Value: 43.156.50.9
```

Cek propagasi:
```bash
dig igrow.nuridho.com
```

Di NPM → Add Proxy Host:

| Field | Value |
|---|---|
| Domain Names | `igrow.nuridho.com` |
| Scheme | `http` |
| Forward Hostname/IP | `igrow-web` |
| Forward Port | `80` |

Tab SSL → Request new SSL Certificate → Force SSL, HTTP/2, agree terms → email → Save.

#### Test

```
https://igrow.nuridho.com
```

Dashboard-nya udah bisa diakses, isinya masih data dummy — banner "⚠ Data dummy" jadi penanda tahap ini belum tersambung ke backend apa pun.

### 4b — Sambungin `igrow-api` ke `igrow-hermes`

`igrow-api` **tetap** pakai `build:` (bukan `image:`) karena itu kode custom kamu sendiri (baca markdown → serve JSON), beda sama `igrow-hermes` yang udah dibangun di Phase 2 pakai image resmi.

#### Struktur folder tambahan

```text
whatsinsidegit/
├── igrow-hermes/hermes-home/igrow/     # sudah ada dari Phase 2, dibaca (read-only) di sini
│
└── igrow-api/
    ├── Dockerfile              # instruksi build image API — INI YANG custom (build:)
    └── (source code API ringan — baca folder igrow/ yang sama, read-only)
```

#### `docker-compose.yml` tambahan

```yaml
  igrow-api:
    build: ./igrow-api               # kode custom, di-build dari Dockerfile di folder ini
    restart: unless-stopped
    volumes:
      - ./igrow-hermes/hermes-home/igrow:/app/data:ro   # cuma subfolder igrow/, read-only (:ro)
```

```bash
docker compose up -d --build igrow-api
docker ps | grep igrow-api
```
Harus `Up`.

> `igrow-api` mount folder yang **sama** dengan `igrow-hermes` (`hermes-home/igrow/`), cuma bedanya pakai `:ro` (read-only) — dia baca file yang ditulis Hermes, tapi nggak bisa nulis balik, sekalipun ada bug di kodenya.

#### Proxy Host + path routing di NPM

Frontend & API sengaja dijadiin **satu domain** (bukan `api.igrow...` terpisah), biar fetch dari browser ke API nggak kena masalah CORS (karena origin-nya sama). Caranya pakai **Custom Location** di NPM:

| Path | Forward ke | Catatan |
|---|---|---|
| `igrow.nuridho.com/` (default) | `igrow-web:80` | Static dashboard — udah ada dari 4a |
| `igrow.nuridho.com/api/*` | `igrow-api:<port>` | Custom Location — port sesuaikan API kamu. **Bukan** forward ke `igrow-hermes` |

**Langkah bikin Custom Location:**
1. Edit proxy host `igrow.nuridho.com` yang udah ada dari 4a (default forward-nya tetap ke `igrow-web`)
2. Tab **Custom Locations** → **Add Location**
3. Location: `/api`
4. Forward Hostname: `igrow-api`, Forward Port: sesuai port API kamu
5. Save

> `igrow-hermes` **nggak pernah** disebut di proxy host manapun — dia nggak perlu diakses dari luar sama sekali, cuma nerima chat dari Telegram.

#### Update dashboard biar fetch data asli

`index.html` di `igrow-web/` diupdate: tambahin JavaScript `fetch()` ke endpoint `igrow-api`, gantiin data dummy yang sekarang hardcoded di HTML. Contoh pola:

```html
<script>
  async function loadSkills() {
    const response = await fetch('/api/skills');   // path relatif — biar nggak kena CORS
    const data = await response.json();
    renderSkillBars(data);                          // ganti tampilan dummy jadi data asli
  }
  loadSkills();
</script>
```

`fetch('/api/skills')` ini nyambungnya ke `igrow-api` (lewat Custom Location NPM), **bukan** ke `igrow-hermes` — jadi bot Telegram sama sekali nggak kesentuh pas dashboard di-refresh.

> Sinkronisasi Obsidian Vault dijelaskan terpisah di [Phase 5 — Obsidian LiveSync](#obsidian-livesync), bukan lewat browser — folder `igrow-hermes/hermes-home/igrow/` yang sama juga dipakai sebagai vault, di-sync ke device (laptop/HP) pakai plugin **Obsidian LiveSync**, bukan diakses lewat browser.

---

## Phase 5 — Opsional *(nanti)*

### Obsidian LiveSync

**Fungsi:** sync folder `igrow-hermes/hermes-home/igrow/` (vault iGROW) ke Obsidian app di laptop/HP kamu, biar bisa dibuka pakai Obsidian native (graph view, backlinks, plugin) — bukan lewat browser.

**Kenapa bukan web viewer:** fungsi "baca knowledge base dari browser" udah dicover dashboard `igrow.nuridho.com` (malah lebih terstruktur). Fitur andalan Obsidian (graph view, backlinks) juga lebih maksimal dinikmati di app native ketimbang versi web. LiveSync cuma nyambungin vault yang sama ke banyak device, tanpa expose apa pun ke publik.

**Cara kerja singkat:** plugin **Self-hosted LiveSync** di Obsidian app connect ke backend **CouchDB** yang di-host sendiri di VPS. Vault di-sync real-time antar device lewat CouchDB itu — bukan lewat HTTP/browser biasa.

```yaml
  couchdb:
    image: couchdb:3
    restart: unless-stopped
    environment:
      - COUCHDB_USER=${COUCHDB_USER}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD}
    volumes:
      - ./couchdb/data:/opt/couchdb/data
```

> CouchDB **jangan** publicly exposed tanpa proteksi tambahan — minimal pasang Access List (basic auth) di NPM, atau lebih aman lewat Tailscale kayak yang pernah dibahas buat NPM/Portainer, karena isinya vault pribadi kamu.

Detail konfigurasi CouchDB + setup plugin LiveSync di Obsidian app menyusul kalau kamu udah siap masuk phase ini.

---

## Checklist Phase 1

- [x] Docker & Docker Compose ter-install (`docker --version` jalan)
- [x] Semua folder di atas udah dibuat
- [x] `.env` udah diisi (port, dll)
- [x] `docker compose up -d` jalan tanpa error, semua container status `Up`
- [x] Domain (A record) udah diarahkan ke IP VPS & DNS udah propagate (`portainer`, `npm`, `dash`)
- [x] UFW aktif dengan SSH ter-allow duluan (`sudo ufw status` nunjukin 22/80/443/81 semua ALLOW)
- [x] Portainer bisa diakses & akun admin udah dibuat (sebelum timeout 5 menit, pakai setup token dari log)
- [x] Nginx Proxy Manager bisa diakses, minimal 1 proxy host + SSL Let's Encrypt berhasil dibuat
- [x] Semua proxy host (Portainer, Glance) pakai Scheme yang sesuai (https untuk Portainer, http untuk yang lain)
- [x] Glance bisa diakses di `dash.nuridho.com`, nampilin bookmarks, status monitoring (`monitor`), status container (`docker-containers`), dan resource server (`server-stats`)
- [x] Homepage (`index.html`) bisa diakses di `nuridho.com` tanpa 403

## Checklist Phase 2 (`igrow-hermes`)

- [x] `igrow-hermes` **TIDAK** punya `Dockerfile` — pakai `image: nousresearch/hermes-agent` (`:latest`)
- [x] Nilai `HERMES_UID`/`HERMES_GID` di `.env` root sudah sesuai hasil `id -u`/`id -g` di VPS, **bukan** angka contoh yang dicopy asal
- [x] Service `igrow-hermes` di `docker-compose.yml` pakai `image:` (`:latest`) + `command: gateway run` + `HERMES_UID`/`HERMES_GID` + **1 volume** (`hermes-home:/opt/data`) — **tanpa** `HERMES_HOME` env var, **tanpa** `env_file:`
- [x] `docker compose up -d igrow-hermes` jalan tanpa error, `docker ps` status `Up`
- [x] `hermes setup` & `hermes gateway setup` udah dijalanin sekali di dalam container (secret otomatis ketulis ke `hermes-home/.env`, bukan file yang dibuat manual)
- [x] Ownership `igrow-hermes/hermes-home/` di host sudah milik user kamu (bukan `root`) — cek `ls -la`
- [x] `hermes doctor` jalan tanpa error, `docker exec -it igrow-hermes ls /opt/data` nampilin `.env`, `config.yaml`, `SOUL.md`, dst
- [x] Folder `igrow-hermes/hermes-home/igrow/` udah dibuat manual (subfolder `raw/`, `wiki/`, `output/`, `project-skills/`, `maintenance/`), **plus** 14 file inti (`SCHEMA.md`, `_index.md`, `log.md`, `raw/_index.md`, `wiki/_index.md`, `output/_index.md`, `project-skills/{capture-experience,mentor,daily-briefing,study,career-review}.md`, `project-skills/maintenance/{lint,backup,session-export}.md`, `project-skills/maintenance/backup.sh`)
- [x] `AGENTS.md` ada di **root** `hermes-home/` (`hermes-home/AGENTS.md`), **bukan** di dalam `igrow/` — sudah diisi (lihat `iGROW_FINAL.md`)
- [x] `igrow-hermes/hermes-home/igrow/project-skills/` udah ada minimal 1 file markdown (`capture-experience.md` atau `mentor.md`), di-refer dari `AGENTS.md`
- [x] Tes chat lewat Telegram: Hermes bisa jawab dia lagi di direktori mana & nyebut aturan iGROW dari `AGENTS.md`
- [x] Tes capture 1 cerita/pengalaman lewat Telegram, cek file baru muncul di `igrow-hermes/hermes-home/igrow/` sesuai aturan penempatan
- [x] `igrow-hermes` nggak publish port & nggak disebut di proxy host manapun — murni diakses via Telegram
- [ ] (Opsional) alias/bash function shortcut (`docker-igrow-hermes-setup`, `docker-logs`, dst) udah ditambahin ke `~/.bashrc` — lihat bagian "Shortcut CLI" di bawah
- [ ] 4 cron job dibuat dari shell host pakai `hermes cron create` (daily-briefing, backup-knowledge, lint-mingguan, career-review) — lihat "Setup 4 Cron Job"; cek `hermes cron list` muncul 4 job

## Checklist Phase 4 (`igrow-api` + `igrow-web`)

**4a — Static dashboard:**
- [ ] Folder `igrow-web/` berisi `index.html` langsung (bukan di subfolder)
- [ ] Service `igrow-web` ditambah ke `docker-compose.yml`, `docker compose up -d igrow-web` jalan tanpa error
- [ ] DNS `igrow` udah propagate, proxy host `igrow.nuridho.com` default forward ke `igrow-web`
- [ ] Dashboard bisa diakses di `https://igrow.nuridho.com`, masih nampilin data dummy

**4b — Sambungin ke backend:**
- [ ] `igrow-api/` punya `Dockerfile` sendiri (custom code, pakai `build:`)
- [ ] `docker compose up -d --build igrow-api` jalan tanpa error
- [ ] `igrow-api` mount `igrow-hermes/hermes-home/igrow` (bukan seluruh `hermes-home/`, dan bukan bikin volume baru), pakai `:ro`
- [ ] Custom Location `/api` di proxy host `igrow.nuridho.com`, forward ke `igrow-api` (**bukan** `igrow-hermes`)
- [ ] `igrow-hermes` tetap nggak disebut di proxy host manapun — cuma nerima chat dari Telegram
- [ ] `index.html` diupdate pakai `fetch('/api/...')`, data dummy diganti data asli
- [ ] Dipastikan `igrow-api` cuma baca file (nggak ada panggilan LLM), biar refresh dashboard nggak numpuk beban/token ke Hermes
- [ ] API dipastikan cuma expose endpoint GET (read-only), nggak ada endpoint yang bisa ubah/hapus data
- [ ] Dashboard nampilin data asli dari Hermes (bukan data dummy lagi)
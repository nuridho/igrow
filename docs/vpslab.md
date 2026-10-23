# Personal VPS & DevOps Lab

Project infrastruktur pribadi dan lab berbasis Docker untuk self-hosting, Linux, Docker, observability ringan, automation, dan eksperimen project pribadi.

> **Prinsip utama:** Jangan menambah service hanya karena bisa. Setiap service harus punya fungsi yang jelas — dan harus proporsional dengan spesifikasi VPS.
a
---

## 1. Tujuan Project

1. Menjalankan service pribadi.
2. Belajar dan mempraktikkan Docker & Docker Compose.
3. Menjalankan reverse proxy dan HTTPS.
4. Memonitor availability dan log dengan cara yang ringan.
5. Menjalankan automation melalui Hermes Agent (iGROW).
6. Sinkronisasi Obsidian Vault antar device (LiveSync), tanpa web interface publik.
7. Menjadi environment production-like untuk belajar DevOps.
8. Menampilkan portofolio pribadi di domain utama.

---

## 2. Spesifikasi VPS

| Resource | Kapasitas |
|---|---|
| CPU | 2 core |
| RAM | 4 GB |
| Storage | 60 GB |

> Spesifikasi ini kecil — jadi observability stack harus dipilih yang ringan, bukan yang paling lengkap.

---

## 3. Arsitektur Utama

```text
                           INTERNET
                              │
                              ▼
                    Nginx Proxy Manager
                         Reverse Proxy
                              │
          ┌───────────────────┼────────────────────┐
          │                   │                    │
          ▼                   ▼                    ▼
       Glance            Portainer            Homepage
      Dashboard        Docker Manager         Portofolio
          │
          │  (monitor, docker-containers,
          │   server-stats widgets)
          ▼
        Docker
          │
      ┌───────────────────────┼────────────────────────┐
      │                       │                        │
      ▼                       ▼                        ▼
 igrow-hermes            CouchDB (LiveSync)          Dozzle
 (bot + LLM)               Obsidian Sync            Log Viewer
      │
      │ (share folder hermes-home/igrow/, read-only)
      ▼
 igrow-api ──▶ igrow-web (dashboard read-only)
```

---

## 4. Daftar Container

### Core (Phase 1 — Foundation)
- Nginx Proxy Manager
- Portainer
- Glance
- Homepage (static portofolio)

### Personal Project (Phase 2)
- **igrow-hermes** — bot Telegram + LLM, satu-satunya yang nulis ke knowledge base

### Observability ringan (Phase 3 — direvisi)
- **Dozzle** — log viewer real-time

### Integrasi dashboard (Phase 4)
- **igrow-api** — jembatan read-only, baca folder hermes-home/igrow/ & serve JSON ke dashboard (nggak nyambung Telegram, nggak manggil LLM)
- **igrow-web** — dashboard statis, tampilan iGROW

### Opsional (Phase 5)
- **CouchDB** — backend sync buat Obsidian LiveSync (bukan web interface, cuma sync antar device)

> Jumlah container dapat bertambah jika kemudian ada kebutuhan spesifik yang jelas.

---

## 5. Komponen & Fungsinya

| Komponen | Fungsi | Menjawab pertanyaan |
|---|---|---|
| **Nginx Proxy Manager** | Reverse proxy, HTTPS, SSL, routing domain | "Bagaimana request sampai ke container yang tepat?" |
| **Portainer** | GUI untuk manajemen Docker (containers, images, volumes, stacks) | "Apa status Docker saya?" |
| **Glance** | Homepage / dashboard pusat, kumpulan link, status availability (`monitor`), status container (`docker-containers`), dan resource server (`server-stats`) | "Saya mau masuk ke service yang mana? Semuanya sehat nggak?" |
| **Homepage (static)** | Portofolio pribadi di domain root | "Siapa yang punya infra ini?" |
| **Dozzle** | Log viewer real-time semua container, ringan (~20–30MB RAM) | "Apa yang sebenarnya terjadi di dalam service?" |
| **igrow-hermes** | Bot Telegram + LLM — satu-satunya yang bisa nulis ke knowledge base (capture note, test, dst) | — |
| **igrow-api** | Jembatan read-only — baca `igrow-hermes/hermes-home/igrow/`, serve JSON ke dashboard. Nggak nyambung Telegram, nggak manggil LLM, jadi refresh dashboard nggak numpuk beban/token ke `igrow-hermes` | "Gimana caranya dashboard nampilin data tanpa ganggu bot?" |
| **igrow-web** | Dashboard visualisasi read-only di `igrow.nuridho.com` | "Skill apa aja yang udah saya kuasai?" |
| **CouchDB (Obsidian LiveSync)** | Sync vault Obsidian (`igrow-hermes/hermes-home/igrow/`) antar device lewat plugin LiveSync, bukan web viewer | "Gimana caranya buka knowledge base yang sama dari laptop & HP?" |

### Catatan penting
- **Glance** dipakai sebagai dashboard, Alasan: Glance ringan (binary Go kecil, RAM puluhan MB), config-nya satu file YAML (gampang di-backup/version-control), dan bisa menampilkan info ringkas dari service lain (status Docker container, status availability, resource server), bukan cuma link statis.
- Monitoring dasar (up/down, response time, resource server) ditangani widget bawaan Glance (`monitor`, `docker-containers`, `server-stats`) tanpa container terpisah. Konsekuensinya: nggak ada history/grafik jangka panjang dan nggak ada notifikasi otomatis (Telegram/Discord/email) kalau ada service down — Glance *stateless*, cuma nampilin kondisi terkini. Kalau butuh itu nanti, opsi **Gatus** (ringan, ada widget resmi di Glance).
- Fungsi "baca knowledge base dari browser" udah dicover dashboard iGROW (skill inventory, career archive, dst). Sync vault ke device lewat **Obsidian LiveSync** (CouchDB backend), bukan web interface — masuk Phase 5, opsional. Fitur andalan Obsidian (graph view, backlinks) lebih maksimal di app native.
- **iGROW dipecah jadi 3 service, bukan digabung 2 (frontend + Hermes langsung).** Alasan: `igrow-hermes` (bot Telegram + LLM) dan dashboard web itu punya konsumen yang beda — kalau dashboard fetch langsung ke `igrow-hermes`, tiap refresh dashboard numpuk beban ke proses yang sama dengan bot, resikonya bot ikut terganggu atau bahkan ikut down. Solusinya tambah `igrow-api` sebagai jembatan: baca folder data yang sama (read-only), serve JSON ke dashboard, **nggak nyambung Telegram dan nggak manggil LLM sama sekali**. Efeknya: dashboard bisa di-refresh berkali-kali tanpa numpuk token/beban ke `igrow-hermes`.
- Kalau butuh melihat isi log (kenapa error, apa yang terjadi), itu tugas **Dozzle**, bukan Glance.

Alur debugging yang umum:
```text
Glance nampilin status DOWN (widget "monitor")
        │
        ▼
   Buka Dozzle
        │
        ▼
 Cari tau kenapa (baca log error)
```

---

## 6. Observability (ringan)

Observability dibuat ringan biar muat di VPS 4GB RAM yang juga jalanin beberapa container lain:

- **Dozzle** untuk log viewer real-time (ringan, instan, tanpa setup rumit).
- **Widget bawaan Glance** (`monitor`, `docker-containers`, `server-stats`) untuk availability & resource check dasar.
- Metrics detail (CPU/RAM/Disk) bisa juga dipantau manual via `docker stats` dan `htop`, atau tambahkan **Netdata** (1 container, auto-dashboard, ~100–150MB RAM) kalau nanti dirasa perlu grafik trend yang lebih dalam.

**Opsi lanjutan** (kalau butuh lebih):
- Kebutuhan debugging makin kompleks (perlu search & retention log jangka panjang).
- Ingin belajar Prometheus/Grafana untuk skill/portofolio.

Loki juga bisa dipakai tanpa Grafana dulu (query manual lewat `logcli`).

**Kalau butuh notifikasi otomatis / history uptime:** opsi **Gatus** (ringan, ada widget resmi di Glance) atau **Uptime Kuma**.

---

## 7. Docker Auto Restart

Service persistent menggunakan restart policy:

```yaml
services:
  igrow-hermes:
    image: nousresearch/hermes-agent:latest   # pin versi kalau mau stabil
    restart: unless-stopped
```

Jika container crash → Docker mendeteksi → automatic restart → container kembali hidup. Tidak semua masalah butuh intervensi manual.

---

## 8. Health Check

Status `running` belum tentu berarti aplikasi sehat:

```text
Container: RUNNING
Application: BROKEN   ← tetap bisa terjadi
```

- **Docker health check** → status internal container.
- **Glance (`monitor` widget)** → pengecekan dari sisi eksternal, snapshot terkini (bukan history).

---

## 9. Docker Compose

Seluruh stack dikelola via Docker Compose, dengan struktur:

```text
whatsinsidegit/
├── docker-compose.yml
├── .env
│
├── nginx-proxy-manager/
├── portainer/
├── glance/
├── homepage/
├── igrow-hermes/
├── igrow-api/
├── igrow-web/
├── couchdb/          # Phase 5, opsional — Obsidian LiveSync backend
└── dozzle/
```

Tujuan: infrastructure mudah dibuat ulang, di-upgrade, di-backup, dipindahkan, dan dipahami.

---

## 10. Storage (60 GB)

Potensi pengguna storage:
```text
Docker images
Docker volumes
Obsidian Vault (igrow-hermes/hermes-home/igrow/, di-sync via LiveSync)
Hermes data
System logs
```

Useful commands:
```bash
df -h
docker system df
du -sh /var/lib/docker/*
```

Rekomendasi:
1. Jangan menyimpan log tanpa batas.
2. Bersihkan Docker images yang tidak digunakan (`docker system prune`).
3. Monitor disk secara berkala.
4. Backup configuration dan data penting.

---

## 11. RAM (4 GB)

Service yang perlu diperhatikan penggunaan resource-nya:
```text
Hermes
CouchDB (kalau Phase 5 udah jalan)
Docker
Dozzle
```

Useful command:
```bash
docker stats
```

Atau lewat widget `server-stats` di Glance buat snapshot cepat tanpa perlu SSH.

Jika RAM mulai penuh:
1. Identifikasi container terbesar (`docker stats`).
2. Optimalkan Hermes.
3. Hapus service yang tidak dibutuhkan.
4. Tambahkan swap jika sesuai.
5. Upgrade VPS jika memang diperlukan.

---

## 12. Urutan Deployment

### Phase 1 — Foundation
```text
Docker
Nginx Proxy Manager
Portainer
Glance
Homepage (static portofolio)
```
> Tujuan: memiliki personal Docker server yang rapi, plus portofolio publik di domain root.

### Phase 2 — Personal Project
```text
igrow-hermes  (bot Telegram + LLM, satu-satunya yang nulis data)
```
> Tujuan: automation pribadi lewat Telegram — bot jalan dulu, mulai nulis knowledge base.

### Phase 3 — Observability (ringan)
```text
Dozzle
```
> Tujuan: bisa debug service lewat log tanpa beban resource besar.

### Phase 4 — Integrasi (dashboard read-only)
```text
igrow-api     (jembatan read-only, baca folder hermes-home/igrow/ yang sama)
igrow-web     (dashboard statis, fetch ke igrow-api)
```
> Tujuan: visualisasi knowledge base di browser — tanpa numpuk beban/token ke bot.

### Phase 5 — Opsional (kalau dibutuhkan nanti)
```text
Netdata      → metrics dashboard ringan dengan grafik trend
Loki         → log aggregation lebih serius (bisa tanpa Grafana dulu, pakai logcli)
Grafana      → visualisasi, kalau memang dibutuhkan
Uptime Kuma / Gatus → kalau butuh history uptime & notifikasi otomatis
Obsidian LiveSync (CouchDB) → sync vault ke device (laptop/HP), bukan web interface
```

---

## 13. Final Architecture

```text
                             INTERNET
                                │
                                ▼
                      Nginx Proxy Manager
                                │
        ┌───────────────────────┼────────────────────────┐
        │                       │                        │
        ▼                       ▼                        ▼
     Glance                Portainer               Homepage
    Dashboard            Docker Management         Portofolio

        (NPM Custom Location routing dari igrow.nuridho.com)
        │                                               │
        ▼                                               ▼
   igrow-web                                      igrow-api
   (dashboard,                                  (jembatan read-only,
   read-only)  ──── fetch('/api/...') ──────────▶ nggak nyambung Telegram)
                                                         │
                                                         │ baca doang (:ro)
                                                         ▼
                                                  igrow-hermes/hermes-home/igrow/
                                                         ▲
                                                         │ tulis
                                                         │
                                              igrow-hermes ◀── Telegram
                                              (bot + LLM)

                              Dozzle ── log viewer semua container
                                    │
                              (opsional) CouchDB → LiveSync ke device
```

---

## 14. Filosofi Project

VPS ini bukan ditujukan untuk menjalankan sebanyak mungkin container.

| Komponen | Tanggung jawab |
|---|---|
| Nginx Proxy Manager | Reverse Proxy + HTTPS |
| Portainer | Docker Management |
| Glance | Homepage / Dashboard + Availability & Resource Monitoring |
| Homepage (static) | Portofolio publik di domain root |
| Dozzle | Log Viewing |
| igrow-hermes | Personal Automation + AI Project (command via Telegram, satu-satunya yang nulis data) |
| igrow-api | Jembatan read-only — isolasi beban dashboard dari bot |
| igrow-web | Web Access ke Knowledge Base (read-only) |
| CouchDB (opsional, Phase 5) | Obsidian LiveSync — sync vault antar device |

### Learning path
```text
Linux → Docker → Docker Compose → Networking
→ Reverse Proxy → HTTPS → Monitoring dasar (widget Glance)
→ Log viewing (Dozzle) → (opsional) Metrics, Observability & Sync lanjutan
```
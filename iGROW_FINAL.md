# 🧠 Project: iGROW — terus bertumbuh seiring waktu

> Blueprint proyek. Dokumen ini adalah rangkuman konsep supaya sesi baru bisa langsung dilanjutkan tanpa mengulang pembahasan dari awal.
>
> **Prinsip besar:** jangan membangun "Hermes project" — bangun **iGROW**, dan gunakan Hermes sebagai otaknya.

---

## Tujuan Utama

Membangun **Hermes** sebagai personal AI assistant + career knowledge system untuk membantu **IT worker** (infra, developer, network, security, cloud, DBA, dst) dalam:

- Menyimpan pengalaman kerja
- Mengubah pengalaman menjadi knowledge
- Menguji kemampuan troubleshooting
- Membantu belajar berdasarkan sejarah pembelajaran
- Mendapatkan briefing teknologi secara rutin
- Mengorganisasi informasi yang ditemukan
- Mengevaluasi perkembangan skill
- Menghasilkan laporan karier yang bisa disimpan offline

### Prinsip Utama

- Hermes adalah **agent/interface**.
- Knowledge adalah **aset utama**.
- Knowledge harus **portable** dan tidak bergantung pada satu provider AI.

---

## Use Case 1 — 📚 Hermes sebagai Arsip Perjalanan Karier

**Tujuan:** membuat rekam jejak pekerjaan dan pengalaman teknis pribadi yang bisa dibawa ketika pindah kerja/resign. Hermes digunakan sebagai jurnal kerja yang terus berkembang.

### Workflow

```
Pengalaman kerja
      ↓
Saya ceritakan ke Hermes
      ↓
Hermes merapikan
      ↓
Structured Knowledge
      ↓
Disimpan sebagai Markdown
      ↓
Career Knowledge Base
```

### Contoh Input

> "Hari ini ada alert CPU tinggi. Saya cek monitoring, ternyata proses X yang menyebabkan spike. Setelah beberapa menit CPU normal lagi. Saya belajar bahwa pattern ini kemungkinan workload spike."

Hermes mengubah menjadi:

```
Incident: High CPU

Symptom:
CPU utilization > 90%

Investigation:
...

Finding:
...

Action:
...

Result:
...

Lesson Learned:
...
```

### Struktur

Dipisah **per pekerjaan/posisi** (`career-1`, `career-2`, dst), supaya jelas pengalaman mana berasal dari perusahaan/role yang mana — dan tetap gampang dibawa kalau pindah kerja.

> 📌 **Struktur folder lengkap (satu-satunya acuan di seluruh dokumen)** ada di bagian [🛠️ Implementasi Teknis — Hermes Agent](#-implementasi-teknis--hermes-agent-image-resmi), sebagai bagian dari tree `igrow/` (subfolder di dalam `HERMES_HOME`). Ringkasnya, folder inti yang relevan buat Use Case 1: `wiki/careers/career-N-.../about.md`, `knowledge/`, `lessons-learned/`, `skills.md`.

**Isi `about.md` per career**, contoh:

```
Company: PT ABC (client A — anonim)
Role: Infra Engineer L1
Location: Kuala Lumpur
Period: Jan 2025 – sekarang
Jobdesc:
- Monitoring & incident response
- Troubleshooting Linux/Windows Server
- Escalation handling
```

Dengan begini, tiap knowledge/incident otomatis ketahuan **konteksnya dari career mana**, dan kalau resign tinggal folder `career-1-...` itu jadi arsip final, lalu mulai `career-2-...` di tempat baru.

### Output

- Knowledge base
- Incident history
- Troubleshooting notes
- Lessons learned
- Skill inventory

**Target jangka panjang:** *"Apa saja yang sebenarnya sudah saya kerjakan selama 3 tahun?"*

---

## Use Case 2 — 🎓 Mentor Belajar yang Tahu Sejarah Saya

**Tujuan:** Hermes menjadi mentor yang mengetahui apa yang sudah dipelajari, kasus yang pernah ditemui, konsep yang masih lemah, teknologi yang sering digunakan, dan skill yang belum pernah dipraktikkan.

### Workflow

```
Career Knowledge
       +
Learning History
       +
Test Results
       ↓
Hermes
       ↓
Personalized Learning Path
```

### Contoh

**Saya:** "Saya mau belajar networking lebih dalam."

Hermes tidak memberikan roadmap generik — dia melihat:

```
Known:
✓ Ping
✓ DNS basic
✓ TCP/IP basic

Weak:
⚠ Routing
⚠ Packet analysis
⚠ TCP behavior

Experience:
✓ Connection timeout
✓ Packet loss
```

Kemudian: *"Karena kamu sudah pernah mengalami timeout dan packet loss, kita mulai dari TCP connection lifecycle sebelum masuk ke routing."*

### Output

```
wiki/roadmap/
├── roadmap.md
├── completed.md
└── weak-topics.md
```

*(Nama file sama persis dengan tree kanonik di bagian Implementasi Teknis — lihat di sana untuk daftar lengkap isi `wiki/roadmap/`.)*

**Target:** belajar menjadi adaptive, bukan sekadar mengikuti tutorial random.

> 📌 Cara Hermes tahu "konsep yang masih lemah" dijelaskan detail di [🔍 Mekanisme: Bagaimana Hermes Menemukan Knowledge Gap](#-mekanisme-bagaimana-hermes-menemukan-knowledge-gap).

---

## Use Case 3 — 📰 Daily Infra Briefing

**Tujuan:** setiap hari Hermes mencari informasi terbaru yang relevan untuk pekerjaan dan perkembangan skill.

### Workflow

```
07:00
  ↓
Scheduled task
  ↓
Web research
  ↓
Filter informasi
  ↓
LLM analysis
  ↓
Summary
  ↓
Telegram / chat
```

### Topik

Linux · Windows Server · Kubernetes · Docker · VMware · Cloud · Networking · Infrastructure · Monitoring · DevOps · SRE · Security · CVE

### Contoh Output

```
DAILY INFRA BRIEFING
10 August 2026

1. Linux
   [News]
   Why it matters: ...

2. Kubernetes
   [Release/update]
   Why it matters: ...

3. Security
   [CVE]
   Affected technology: ...
   Severity: ...
   Why you should care: ...

4. Career
   [Technology trend]
   Relevant skill: ...
```

**Prinsip:** tidak perlu banyak berita. Lebih baik **5 informasi penting + alasan kenapa perlu peduli.**

---

## Use Case 4 — 📖 Dokumentasi Belajar Mandiri

**Tujuan:** mendokumentasikan hasil belajar mandiri (bootcamp, artikel, dokumentasi, eksperimen) menjadi knowledge pribadi terstruktur.

**Perintah:** `/study` — contoh: "/study baru selesai materi X di KodeKloud: ...".

### Workflow

```
Saya sudah belajar / ikut bootcamp / baca artikel
              ↓
        Cerita ke Hermes (/study)
              ↓
      Hermes rapikan & strukturkan
              ↓
      Knowledge note terstruktur
              ↓
          Markdown (wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>)
```

### Contoh

**Saya:** "/study baru selesai materi systemd di KodeKloud — service unit, target, journalctl, dst."

**Output:**
```
wiki/self-development/
└── Bootcamp/
    └── kodekloud-systemd/
        ├── concepts.md
        ├── commands.md
        ├── troubleshooting.md
        └── references.md
```

**Bisa juga:** "/study bandingkan systemd service dengan Docker container." / "/study baru belajar networking Kubernetes, ringkasin buat level saya."

### Prinsip Penting

Source tetap dicatat. Note hasil belajar ikut format baku `igrow/SCHEMA.md`: frontmatter (`title`, `created`, `updated`, `type: learning`, `tags`, `sources`, `confidence`) + body **Ringkasan / Detail / Contoh / Referensi / See Also** — supaya beberapa tahun kemudian tahu informasi tersebut berasal dari mana.

---

## Use Case 5 — 📈 "Saya Berkembang atau Nggak?" (Career Review, Quarterly)

**Tujuan:** melakukan career review setiap **kuartal (3 bulan sekali)** berdasarkan semua knowledge, pengalaman, latihan, dan pembelajaran — sekaligus tempat Skill Inventory dihitung ulang.

```
Quarterly Review
Q1 → Q2 → Q3 → Q4 → Review
```

Hermes menganalisis: apa yang dipelajari, incident yang ditangani, topik yang sering muncul, skill yang meningkat, topik yang stagnan, kesalahan yang berulang, knowledge gap.

### Contoh Output

```
CAREER REVIEW — Q1 2026

Learned
✓ Linux performance
✓ systemd
✓ DNS troubleshooting

Experienced
✓ High CPU incident
✓ Service failure
✓ Network timeout

Improved
↑ Troubleshooting
↑ Monitoring
↑ Incident analysis

Weak
⚠ Automation
⚠ Infrastructure as Code
⚠ Advanced networking

Recommended Next:
1. Bash scripting
2. Ansible
3. Terraform
```

### Pertanyaan yang Bisa Diajukan

- "Apakah skill saya benar-benar berkembang?"
- "Apa kelemahan terbesar saya?"
- "Apa yang paling sering saya lakukan?"
- "Apa yang belum pernah saya sentuh?"
- "Apa yang harus saya pelajari untuk L2?"

> 📌 Cara Hermes menyusun bagian "Weak" di atas dijelaskan detail di [🔍 Mekanisme: Bagaimana Hermes Menemukan Knowledge Gap](#-mekanisme-bagaimana-hermes-menemukan-knowledge-gap).

---

### 📊 Skill Inventory (Bagian dari Career Review Quarterly)

Selain narasi review di atas, tiap quarterly review juga menghasilkan **skill inventory** dalam bentuk bar — tapi barnya **bukan skala 0-100% asal-asalan**, dan **bukan hasil "kira-kira" LLM**, biar konsisten tiap dihitung ulang untuk data yang sama. Dihitung dengan counting file, bukan reasoning:

> **% per skill area = (jumlah topik target yang sudah ada notenya di area itu) ÷ (jumlah total topik target di `wiki/roadmap/skill-map.md` untuk area itu, di level 1 di atas level kamu sekarang)**
>
> Kalau kamu sekarang **L1**, maka pembandingnya adalah target skill **L2** (bukan target L1). Kalau kamu sudah **L2**, pembandingnya jadi target **L3**. Dua-duanya angka hasil counting, bukan reasoning subjektif.
>
> Skill Inventory hanya memakai topik yang sudah punya note di knowledge base.

Contoh — posisi saat ini **L1**, jadi semua bar diukur terhadap target **L2**:

```
Skill Inventory — target: L2 (posisi saat ini: L1)

Linux                 ████████░░  80%
Monitoring             █████████░  90%
Incident Handling      ████████░░  80%
Networking             ██████░░░░  60%
Docker                 █████░░░░░  50%
Automation             ████░░░░░░  40%
Troubleshooting        ████████░░  80%
```

Kalau nanti sudah naik ke **L2**, bar yang sama akan **direset ukurannya** karena target berubah jadi L3 — jadi angka 80% di Linux waktu masih L1 tidak otomatis sama artinya dengan 80% waktu sudah L2 (targetnya lebih tinggi/lebih banyak).

### Dari Mana Angka Persentase Ini Didapat


```markdown
---
title: Skill Map
type: data
updated: 2026-08-22
---

# Skill Map — Infra Engineer

## Target L2 (dipakai sebagai 100% kalau posisi sekarang L1)
- Linux: performance tuning, kernel basics, systemd advanced
- Monitoring: alert correlation, dashboard design
- Networking: routing, VLAN, packet analysis
- Automation: Ansible dasar, scripting Bash lanjutan
- Docker: image building, networking container
- Incident Handling: RCA (root cause analysis) mandiri
- Troubleshooting: multi-layer (app + infra) diagnosis

## Target L3 (dipakai sebagai 100% kalau posisi sekarang L2)
- ...
```

### Insight Per Kategori (Bukan Cuma Angka)

Tiap bar juga disertai **insight singkat**, bukan cuma persentase kosong — supaya langsung tahu kenapa segitu dan apa langkah berikutnya:

```
Automation             ████░░░░░░  40%
→ Baru terdokumentasi: dasar scripting Bash.
   Belum ada catatan Ansible sama sekali (target L2).
   Rekomendasi: mulai dari Ansible playbook dasar.

Networking             ██████░░░░  60%
→ Routing & VLAN sudah pernah ditangani di 2 incident,
   tapi belum ada note khusus yang ngebahas konsepnya.
   Rekomendasi: tulis note routing dari 2 incident itu.
```

Format insight ini yang jadi isi bagian "Skill Developed" dan "Weak/Knowledge Gaps" di contoh output Career Review di atas — bukan section terpisah, tapi hasil langsung dari skill inventory + insight ini.

---

## 🔍 Mekanisme: Bagaimana Hermes Menemukan Knowledge Gap

> Ini bagian yang sering disebut ambigu di Use Case 2 & 5 ("mengetahui knowledge gap") — jadi perlu dijelaskan eksplisit: **ini bukan Hermes menebak secara insting, tapi hasil perbandingan 3 sumber data yang konkret.**

### 3 Sumber Data yang Dibandingkan

| # | Sumber | Lokasi File | Menjawab pertanyaan |
|---|---|---|---|
| 1 | **Knowledge yang sudah terdokumentasi** | `wiki/careers/*/knowledge/`, `wiki/self-development/`, `wiki/careers/*/skills.md` | "Apa yang sudah saya punya?" |
| 2 | **Target skill yang seharusnya dikuasai** | `wiki/roadmap/skill-map.md` | "Apa yang *seharusnya* saya kuasai di level ini?" |


### Diagram Alur

```
wiki/roadmap/skill-map.md
(target skill utk level L1/L2/dst)
                    │
                    ▼
        dibandingkan dengan
                    │
   ┌────────────────┼────────────────┐
   ▼                ▼                ▼
wiki/self-development/ (hasil test)  di wiki/careers/*/knowledge/incidents/
   │                │                │
   └────────────────┼────────────────┘
                     ▼
     Topik yang TIDAK ADA filenya,
                     ▼
              = Knowledge Gap
```

### Contoh Konkret

Kalau `wiki/careers/career-1/knowledge/` banyak berisi Linux & monitoring, tapi:
- Tidak ada satupun note automation di `wiki/self-development/` (Project/Bootcamp/Dokumentasi) atau tag `automation` di `wiki/careers/*/knowledge/`

Maka outputnya:

> "Automation/IaC belum pernah didokumentasikan sama sekali — kemungkinan gap. Networking dasar sudah kuat, tapi routing masih lemah berdasarkan 3 hasil test terakhir."

### ⚠️ Prasyarat — Fitur Ini Butuh Bahan

Hermes otomatis generate `wiki/roadmap/skill-map.md` dari `about.md` + careers — jadi fitur gap analysis & skill inventory jalan tanpa perlu setup awal. Outputnya bisa generik kalau data careers masih kosong, bukan karena skill-map belum ada.
1. Rutin capture pengalaman kerja & belajar mandiri (Use Case 1 & 4) — supaya `wiki/self-development/` & `wiki/careers/*/knowledge/` terisi
2. Baru minta gap analysis (Use Case 2/5) — karena sekarang ada bahan pembanding yang jelas

Kalau topik yang sama ditulis beda nama tiap kali, gap analysis-nya bisa terpecah dan kurang akurat. Solusinya: gunakan tag taxonomy di `igrow/SCHEMA.md` dan fuzzy-match nama topik yang mirip.

---

## 🔄 Hubungan Antar Use Case

Ini bagian yang **paling penting**. Use case-nya jangan dibuat sebagai 6 sistem terpisah.

```
                         ┌──────────────┐
                         │   HERMES     │
                         └──────┬───────┘
                                │
                     ┌──────────┴──────────┐
                     │                     │
                     ↓                     ↓
                  Capture                Study
                     │                     │
                     ↓                     ↓
               Career Archive        Self-Development
                     │                     │
                     └──────────┬──────────┘
                                ↓
                         Knowledge Base
                                │
               ┌────────────────┬────────────────┐
               ↓                ↓                ↓
             Mentor        Daily Briefing   Career Review
                                ↓
                     Career Review (Quarterly)
                                ↓
                  Skill Inventory + Progress Insight
```

*(Catatan: "Career Archive" di diagram ini = folder `wiki/careers/career-N/`, "Self-Development" = folder `wiki/self-development/` — keduanya sama-sama menyimpan memory & study, bedanya cuma sumber: kerjaan vs non-kerja. Semuanya bermuara ke Knowledge Base gabungan.)*

Jadi semuanya saling memberi makan. Contoh: kamu mengalami incident → Use Case 1 mencatatnya. Incident itu kemudian:

- → masuk knowledge base
- → Use Case 2 mengetahui kamu sudah punya pengalaman tersebut
- → Use Case 5 memasukkannya ke career review quarterly + skill inventory

**Satu aktivitas bisa menghasilkan banyak value.**

---

## 🔐 Aturan Data — Sangat Penting

Karena vendor, prinsipnya: **dokumentasikan pengalaman, bukan data client.**

### Jangan Masukkan

- Credential / password
- API key / token
- IP internal
- Hostname sensitif
- Serial number
- Raw log client
- Screenshot yang mengandung informasi confidential
- Customer data
- Konfigurasi proprietary

### Kalau Menggunakan Screenshot (iDRAC/monitoring)

```
Screenshot
    ↓
Crop / redact identifier
    ↓
Hermes
    ↓
Analysis
    ↓
Knowledge
```

### Contoh

| Salah ❌ | Benar ✅ |
|---|---|
| `client ABC server PROD-DB-07 (10.x.x.x) mengalami...` | `production server mengalami high CPU` |

---

## 💾 Prinsip Migrasi & Sinkronisasi ke GitHub

Jangan sampai setelah 3 tahun: *"Hermes saya mati → semua pengalaman saya hilang."*

```
                  HERMES
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
      Session              Knowledge
       history              files
          │                   │
          │                   ↓
          │              Markdown
          │                   │
          └─────────┬─────────┘
                    ↓
               Git/Backup   ← bagian ini yang diwujudkan lewat cron job di bawah
                    ↓
             Offline Storage
                    ↓
              PDF (opsional)
```

**Source of truth:** knowledge files. Hermes session hanya menjadi sumber informasi/arsip tambahan.

Kalau suatu hari:

- Hermes A → Hermes B
- Provider A → Provider B
- VPS A → VPS B
- Hermes → agent lain

**Knowledge tetap bisa dibawa** — asalkan langkah "Git/Backup" di atas benar-benar rutin dijalankan. Berikut implementasinya.

### Implementasi: Backup via Hermes Cron

Backup di-orchestrasi lewat cron Hermes, bukan crontab host. Flow:

1. Cron job `backup-knowledge` (Minggu 03:00) → baca `igrow/project-skills/maintenance/backup.md` → isi: jalankan `igrow/project-skills/maintenance/backup.sh`
2. `backup.sh` → git add/commit/push ke repo GitHub privat `igrow-backup`, silent kalau no-change
3. Exit non-zero → laporkan error ke Telegram; exit 0 + no-change → jangan kirim pesan

**Prasyarat** (sekali saja, lewat docker exec):

```bash
docker exec -it igrow-hermes bash
cd /opt/data/igrow && git init && git add -A && git commit -m "init"
git config --global credential.helper store
git remote add origin https://<TOKEN>@github.com/nuridho/igrow-backup.git
git branch -M master
git push -u origin master
exit
```

> Script ini hanya backup subfolder `igrow/`, bukan seluruh `HERMES_HOME/` (state internal Hermes tidak perlu di-push). Jangan utak-atik `.git/` manual.

---

## 🛠️ Implementasi Teknis — Hermes Agent (image resmi)

> **Bukan bangun bot dari nol**, tapi pakai `nousresearch/hermes-agent` (image Docker resmi) sebagai badan Hermes, lalu di-*"ajarin"* format iGROW lewat context file + referensi prosedur. Ini yang dimaksud prinsip besar di atas: *"jangan bangun Hermes project, bangun iGROW, gunakan Hermes sebagai otaknya."*
>
> ⚠️ **Status bagian ini:** bagian mount udah terkonfirmasi di instalasi VPS asli (`hermes-home` → `/opt/data`, tanpa `env_file`, Hermes nyala). Yang masih **belum pernah dites** cuma perilaku `AGENTS.md` di mode gateway — karena `AGENTS.md` + `igrow/` belum dibuat. Poin AGENTS.md di bawah jangan anggap final sebelum dicoba.

### Kenapa Image Resmi, Bukan Build Custom

`nousresearch/hermes-agent` sudah menyediakan: Telegram/messaging gateway, sistem memory, sistem skill bawaan (procedural + auto-improve), toolset (terminal, file, cron, dst) — semua infrastruktur agent yang kalau dibangun sendiri butuh effort besar. Yang perlu ditambahkan cuma **lapisan instruksi** supaya dia mengikuti format & aturan iGROW, bukan nulis ulang semua itu dari nol.

### ⚠️ Catatan Penting: Perilaku `AGENTS.md` di Mode Telegram

Berdasarkan dokumentasi resmi Hermes Agent:
- `AGENTS.md` di-load dari **working directory (cwd)** Hermes saat sesi mulai — beda dengan `SOUL.md` yang selalu dari `HERMES_HOME`.
- Ada laporan bug resmi (belum tentu sudah diperbaiki di versi yang kamu install nanti): di mode **gateway/messaging** (Telegram, dll), `cwd` **selalu ke-override jadi `HERMES_HOME`**, apapun setting `terminal.cwd`-nya.

**Konsekuensinya:** karena iGROW dipakai lewat Telegram, `AGENTS.md` kemungkinan besar harus ditaruh **langsung di root `HERMES_HOME`** (bukan di dalam subfolder `igrow/`) supaya konsisten ke-load. Isinya tinggal pakai path relatif ke `igrow/...` untuk menunjuk data. **Wajib dicek ulang setelah instalasi** — kalau ternyata subfolder juga ke-load, struktur boleh disederhanakan lagi.

### Dua Lapis Instruksi

**Lapis 1 — `AGENTS.md`** (context file, otomatis ke-load setiap sesi, taruh di **root `HERMES_HOME`** — lihat catatan di atas)
Isinya cuma aturan inti yang harus **selalu** diingat — dibuat sepadat mungkin karena selalu masuk system prompt tiap sesi (boros token kalau kepanjangan):
- Prinsip besar project (knowledge portable, dst)
- Struktur folder `igrow/` (path relatif)
- Tabel "aturan penempatan" (incident → mana, lesson learned → mana, dst)
- Aturan data sensitif (dilarang credential/IP/client data)
- Cara menentukan "career aktif" (`about.md` tanpa tanggal selesai — saat ini cuma 1 main job)
- Daftar deskripsi singkat tiap file di `igrow/project-skills/`, supaya Hermes tahu kapan harus baca yang mana

**Lapis 2 — `project-skills/`** (file markdown referensi, dibaca situasional lewat instruksi di `AGENTS.md`), satu file per use case:

> Catatan: ini **bukan** sistem Skill resmi Hermes (`SKILL.md` yang di-install lewat `hermes skills install` dan auto-loaded oleh mesin skill-nya sendiri). Ini murni file markdown biasa yang **dirujuk manual** lewat instruksi di `AGENTS.md` — Hermes membacanya pakai tool baca file biasa saat `AGENTS.md` bilang "kalau prompt begini, baca file ini dulu". Konsekuensinya: lebih sederhana & portable, tapi gak dapat keuntungan loading otomatis/hemat token dari sistem Skill resmi. Kalau nanti dirasa perlu, bisa diupgrade ke sistem Skill resmi.

| File referensi | Use Case | Isi instruksi |
|---|---|---|
|| `capture-experience.md` | 1 | Cerita pengalaman kerja → markdown terstruktur |
|| `mentor.md` | 3 | Gap analysis dari 2 sumber data |
|| `daily-briefing.md` | 4 | Dipicu cron 07:00, format ringkasan |
|| `study.md` | 5 | Dokumentasi belajar mandiri (perintah `/study`) → note terstruktur |
|| `career-review.md` | 6 | Review quarterly + hitung skill inventory |
|| `maintenance/lint.md` | — | Cron 08:00 → health check wiki |
|| `maintenance/backup.md` | — | Cron 03:00 → push igrow/ ke GitHub |
| `maintenance/backup.sh` | — | Script backup git: add/commit/push, silent no-change |

`wiki/roadmap/skill-map.md` = AUTO-GENERATE dari `about.md` + careers + self-development (bukan manual input). User boleh edit, tapi bukan keharusan. Semua mekanisme gap analysis & skill inventory bergantung ke file ini sebagai starting point.

### Format File — Markdown + YAML Frontmatter (bukan JSON terpisah)


- Tetap bisa dibaca langsung tanpa tool/script apa pun (selaras prinsip "knowledge portable, tidak bergantung 1 provider")
- Satu file, satu sumber kebenaran — tidak ada risiko dua file (markdown & JSON) jadi tidak sinkron


### Format Normalisasi Note (biar seragam & bisa di-scrape API)

Tiap file note pakai **frontmatter standar** (metadata yang di-parse `igrow-api`) + **section baku** di badan markdown. Kunci utamanya: **informatif** — tiap note harus tetap bisa dibaca bertahun-tahun kemudian tanpa konteks.

```markdown
<!-- ======================= META ======================= -->
---
title: "Judul singkat & deskriptif"
created: 2026-08-22
updated: 2026-08-22
type: learning              # knowledge | incident | lesson | test | learning | profile | query | data
tags: [linux]               # dari taxonomy igrow/SCHEMA.md
sources: [igrow/raw/articles/2026-08-22-kodekloud-systemd.md]  # selalu ada; `[]` kalau murni cerita
confidence: medium          # high | medium | low — dukungan SUMBER, beda dari skor tests/
---

<!-- ----------------------- BODY ----------------------- -->

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

Frontmatter = yang di-parse `igrow-api` buat index/kategori. Badan = yang dibaca manusia. Field `topic` lama digantikan `tags` (taxonomy), `summary` pindah ke body `## Ringkasan`, `date` jadi `created`/`updated`.

### Tipe File & Formatnya

Semua file di `igrow/` berformat — 3 jenis:

1. **Note naratif** (`wiki/careers/`, `wiki/self-development/`) → format META/BODY di atas.
3. **Data file** (`wiki/roadmap/`, `wiki/profile/`) → frontmatter minimal (`title`, `type: data`, `updated`) + body list/key:value, bukan narasi:

```markdown
---
title: Roadmap
type: data
updated: 2026-08-22
---

# Roadmap
- topik (prioritas belajar)
```

   Body tiap file:
   - `skill-map.md` → `## Target L<n>` + `- Area: topik, topik`
   - `roadmap.md` → `- topik` (prioritas belajar)
   - `completed.md` → `- topik (YYYY-MM-DD)`
   - `weak-topics.md` → `- topik — alasan`
   - `profile/skills.md` → `- Area` + bar / bullet singkat

   `about.md` & `careers/*/skills.md` → plain `Key: value`, TANPA frontmatter.

### Struktur Folder — 1 Volume (Sesuai Konvensi Resmi)

Ikut konvensi resmi image, yaitu **1 volume saja** (`igrow-hermes/hermes-home` di host → `/opt/data` di container, ini `HERMES_HOME`). Semua data iGROW ditaruh di **subfolder `igrow/`** di dalamnya — supaya tetap gampang dipisah saat sync Git (cuma `igrow/` yang di-push, bukan seluruh `HERMES_HOME`) tanpa perlu mount terpisah.

```text
igrow-hermes/hermes-home/                            # host folder → mount ke /opt/data (HERMES_HOME), SATU volume
├── .env                              # SECRET: TELEGRAM_BOT_TOKEN, LLM API key
├── config.yaml                       # config bawaan Hermes
├── SOUL.md                           # identitas/personality Hermes (bawaan, beda dari AGENTS.md)
├── AGENTS.md                         # ⚠️ WAJIB di root ini, bukan di dalam igrow/ — lihat catatan di atas
├── (state internal Hermes: sessions/ memories/ skills/ logs/ cron/ cache/ state.db, dst — auto-dibuat, JANGAN di-push ke Git)
│
└── igrow/                            # 📦 SEMUA data iGROW — INI yang portable & di-sync ke Git
    ├── SCHEMA.md                     # aturan format, frontmatter, tag, ownership — BACA DULU sebelum tulis
    ├── _index.md                     # master katalog; baca ini dulu sebelum scan folder
    ├── log.md                        # jurnal aksi append-only: ## [YYYY-MM-DD] op | subjek
    │
    ├── raw/                          # sumber IMMUTABLE (asli, tidak pernah diedit)
    │   ├── _index.md                 # katalog sumber
    │   ├── inbox/                    # drop zone → diproses → articles/ (inbox kosong = sudah diproses)
    │   ├── articles/                 # artikel/dok belajar
    │   ├── assets/                   # screenshot/gambar (sudah redact): YYYYMMDD-deskripsi.png
    │
    ├── wiki/                         # SEMUA konten compiled, agent-owned
    │   ├── _index.md                 # katalog level wiki/
    │   ├── careers/                  # 🗂️ arsip PER PEKERJAAN — saat ini cuma 1 main job aktif
    │   │   └── career-1-pt-abc-infra-l1/
    │   │       ├── about.md          # company, role, periode, jobdesc — TANPA tanggal selesai = aktif
    │   │       ├── knowledge/         # knowledge kerjaan FLAT: <slug>.md — topik lewat tags, JANGAN subfolder per topik
    │   │       │   └── incidents/     # incident hanya ada di sini
    │   │       ├── lessons-learned/  # lesson hanya ada di sini
    │   │       └── skills.md         # skill yang terpakai di posisi ini
    │   │
    │   ├── self-development/         # 🌐 knowledge UMUM (belajar mandiri), lintas career
    │   │   ├── Project/              # proyek pribadi — {nama-project}/, dst
    │   │   ├── Bootcamp/             # kursus/platform belajar — {nama-bootcamp}/, dst
    │   │   └── Dokumentasi/          # belajar dari docs/artikel — {nama-topik}/, dst
    │   │
    │   ├── roadmap/                 # roadmap belajar, lintas career (Use Case 2)
    │   │   ├── roadmap.md
    │   │   ├── completed.md
    │   │   ├── weak-topics.md
    │   │   └── skill-map.md          # target skill per level — dasar gap analysis & skill inventory
    │   │
    └── profile/                  # ringkasan karier — gabungan semua career
        ├── skills.md             # skill inventory gabungan lintas career
        └── career-summary.md
    │
    ├── output/                       # laporan turunan (career review quarterly, dst)
    │   └── _index.md                 # katalog output
    │
    └── project-skills/               # file referensi prosedur per use case (dibaca situasional)
        ├── capture-experience.md
        ├── mentor.md
        ├── daily-briefing.md
        ├── study.md
        ├── career-review.md
        ├── maintenance/
        │   ├── lint.md
        │   └── backup.md
```

`igrow-api` (dashboard read-only) cukup mount subfolder `igrow/` saja secara read-only — jadi gak ikut ter-expose ke `sessions/`, `memories/`, `logs/` bawaan Hermes yang emang bukan urusannya.

#### Contoh mounting di `docker-compose.yml`

```yaml
igrow-hermes:
  image: nousresearch/hermes-agent:latest   # latest = auto-update; pin versi kalau mau stabil
  restart: unless-stopped
  command: gateway run                          # wajib — mode gateway, bukan chat interaktif
  environment:
    - HERMES_UID=${HERMES_UID}
    - HERMES_GID=${HERMES_GID}
  volumes:
    - ./igrow-hermes/hermes-home:/opt/data              # 1 volume, sesuai konvensi resmi image

igrow-api:
  build: ./igrow-api
  volumes:
    - ./igrow-hermes/hermes-home/igrow:/app/data:ro     # cuma subfolder igrow/, read-only
```

> `HERMES_HOME` bukan env var yang perlu di-set manual — path resmi fix di `/opt/data` (gak ada env var buat mindahin). Secret (`TELEGRAM_BOT_TOKEN`, API key LLM) ditulis otomatis lewat `hermes setup`, bukan lewat `env_file:` (lihat `build.md` Phase 2).

Verifikasi setelah container jalan (gak ada error "not found"/"permission denied" berarti mount sudah benar):
```bash
docker exec -it igrow-hermes ls /opt/data
docker exec -it igrow-hermes ls /opt/data/igrow
docker exec -it igrow-hermes hermes doctor
```

---

### `AGENTS.md` vs File Referensi (`project-skills/`) — Beda Kapan Dibaca

Perbedaan intinya: **`AGENTS.md` selalu ke-load tiap sesi**, **file referensi cuma dibaca pas relevan**. Ini yang menentukan apa yang boleh ditaruh di mana.

| | `AGENTS.md` | File referensi (`igrow/project-skills/<nama>.md`) |
|---|---|---|
| Kapan dibaca | Otomatis, SETIAP sesi dimulai | Situasional — Hermes baca sendiri lewat tool baca file, kalau `AGENTS.md` bilang topik ini relevan |
| Isi yang cocok | Aturan inti yang berlaku selalu (struktur folder, aturan penempatan, larangan data sensitif, daftar file referensi yang ada) | Instruksi detail & panjang, khusus SATU use case |
| Sepadat apa harus ditulis | Sangat padat — dia "numpang" di context tiap sesi, boros token kalau kepanjangan | Boleh detail, karena cuma masuk context saat dipakai |
| Contoh isi | Lihat di bawah | Lihat di bawah |

**Contoh isi `AGENTS.md` (root `HERMES_HOME`):**

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
- `igrow/project-skills/`     → file referensi prosedur (baca kalau relevan)
  - `capture-experience.md` → UC1
  - `mentor.md`             → UC2
  - `daily-briefing.md`     → UC3
  - `study.md`              → UC4
  - `career-review.md`      → UC5
  - `maintenance/`          → maintenance scripts (lint, backup)

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

## Career aktif: rujuk `igrow/SCHEMA.md`.

## Perintah
- /study  → dokumentasiin yang sudah dipelajari (ke wiki/self-development/...)
- /recall → baca igrow/_index.md dulu; ketemu → baca page & jawab; nggak ketemu
  → bilang jujur "belum ada catatan", tawarin riset/tulis baru (honest gaps)

## File Referensi (baca isinya kalau relevan sama pesan user)

### Use Case (5)
- igrow/project-skills/capture-experience.md → UC1: Incident/knowledge/career new → wiki
- igrow/project-skills/mentor.md             → UC2: Roadmap/kelemahan → gap analysis
- igrow/project-skills/daily-briefing.md     → UC3: Cron 07:00 → daily infra summary
- igrow/project-skills/study.md              → UC4: /study → dokumentasi belajar
- igrow/project-skills/career-review.md      → UC5: Cron quarterly / manual → review + skill inventory

### Maintenance (bukan UC)
- igrow/project-skills/maintenance/lint.md    → Cron Minggu 08:00 → health check wiki
- igrow/project-skills/maintenance/backup.md  → Cron Minggu 03:00 → push igrow/ ke GitHub

## DILARANG KERAS (berlaku juga raw/ — redact SEBELUM ingest, raw immutable)
Credential, API key/token, IP internal, hostname sensitif, data client,
screenshot yang belum di-redact.
```

---

### Diagram Alur — Dari Pesan Telegram Sampai Ditulis ke Knowledge Base

```text
User ngetik di Telegram
        │
        ▼
Telegram Gateway → diterusin ke Hermes
        │
        ▼
Hermes START sesi
        │
        ▼
AGENTS.md OTOMATIS ke-load ke context
  (bukan "node keputusan", tapi latar belakang yang SELALU ada:
   struktur folder, aturan penempatan, larangan data sensitif,
   daftar file referensi yang tersedia)
        │
        ▼
Hermes BACA pesan user + AGENTS.md
        │
        ▼
   Hermes SENDIRI yang mutusin: file referensi mana yang relevan?
        │
   ┌────┴────────────────────────────────┐
   │                                      │
   ▼                                      ▼
Ada yang cocok                       Nggak ada yang cocok
(misal cerita incident                (misal cuma nanya
 → capture-experience.md)              "restart nginx gimana?")
   │                                      │
   ▼                                      ▼
igrow/project-skills/<nama>.md        Jawab langsung pakai
dibaca, instruksi detailnya           pengetahuan umum,
masuk context                         TANPA nulis file
   │
   ▼
Hermes ikutin instruksi file referensi:
tentuin folder tujuan (sesuai tabel
di AGENTS.md), susun markdown +
   │
   ▼
Hermes TULIS/EDIT file di igrow/
(pakai file-write tool bawaan Hermes)
   │
   ▼
File tersimpan di knowledge base (igrow/)
   │
   ▼
Hermes balas ke user via Telegram
   │
   ▼
(nanti) igrow-api baca igrow/ (read-only) → tampil di igrow-web
```

> Catatan penting: `AGENTS.md` **bukan** pengambil keputusan aktif — dia cuma referensi yang selalu tersedia. Yang benar-benar mutusin file referensi mana dipakai, dan yang benar-benar menulis file, tetap Hermes (LLM) sendiri lewat tool bawaannya — bukan alur otomatis kaku kayak flowchart program biasa.

> Detail cara mount volume ini ke `docker-compose.yml` juga didokumentasikan di `vpslab.md` dan `build.md`.

---

## 🧩 TODO (setelah MVP jalan)

- [ ] Command tracing/koreksi — cari & benerin note salah di KB yang udah besar (nama command: `/cek`/`/audit`, tentukan nanti)
- [ ] `/explore` — kalau ternyata `/recall` perlu dibedakan dari riset sumber baru
- [ ] Export PDF career review (UC5)

## 🎯 Hasil Akhir Proyek

Setelah sistem ini berjalan beberapa tahun, idealnya punya:

| | |
|---|---|
| 📚 **Knowledge** | "Ini semua yang pernah saya pelajari." |
| 🛠️ **Experience** | "Ini semua jenis incident yang pernah saya tangani." |
| 🧪 **Capability** | "Ini kemampuan saya berdasarkan hasil testing." |
| 📈 **Progress** | "Ini perkembangan saya dari waktu ke waktu." |
| 🧠 **Learning roadmap** | "Ini yang harus saya pelajari selanjutnya." |
| 📑 **Career archive** | "Ini perjalanan saya sebagai Infra Engineer." |
| 📄 **Offline archive** | Semua ini tersimpan sebagai markdown biasa di `igrow/`, bisa dibawa/dibaca bahkan kalau berhenti pakai Hermes — opsional di-export ke PDF dari hasil career review kalau perlu. |

### Prinsip Besar

> Jangan membangun "Hermes project". Bangun **Personal Infra Engineer OS**, dan gunakan Hermes sebagai otaknya.
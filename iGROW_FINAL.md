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

## Use Case 2 — 🧪 "Uji Saya, Jangan Ajari Saya" *(PHASE 5 — belum dibangun)*

> ⏸️ **Ditunda ke Phase 5.** Core (UC1/3/4/5/6) diselesaikan dulu. Semua yang ada di section ini adalah **rancangan**, belum ada di `hermes-home/` — `project-skills/test-me.md`, `scripts/confidence_calc.py`, dan folder `wiki/tests/` sengaja TIDAK dibuat. Backlog + keputusan desainnya di `dev-todo.md` section "UC2 — Later".

**Tujuan:** menggunakan Hermes sebagai simulator troubleshooting/interview untuk meningkatkan kemampuan L1 → L2. Bukan memberikan jawaban langsung.

### Workflow

```
Knowledge saya
      ↓
Hermes membuat scenario
      ↓
Incident simulation
      ↓
Saya memberikan jawaban
      ↓
Hermes mengevaluasi
      ↓
Score + feedback
      ↓
Knowledge gap
```

### Contoh

**Saya:** "Uji saya tentang Linux troubleshooting. Jangan kasih petunjuk."

**Hermes:**
```
INCIDENT:
Server mengalami load tinggi. CPU utilization 50%, tetapi load average 20.
Apa yang kamu cek?
```

Saya menjawab. Hermes mengevaluasi:

```
Score: 7/10

✓ Check process
✓ Check CPU
✗ Belum mengecek I/O wait
✗ Belum mengecek blocked processes

Recommended:
Linux process states
iowait
load average
```

### Variasi

Linux troubleshooting · Networking · Monitoring · Incident response · DNS · Storage · Performance · Security basic · Interview simulation

**Target:** Hermes mengetahui kelemahan saya, bukan cuma mengajari saya.

### 🎯 Dari Mana Soal Test Diambil (Penting — Supaya Tidak Ambigu)

Soal bukan cuma dari topik yang sudah dipelajari, dan juga bukan cuma topik baru sepenuhnya. Kombinasi 3 sumber, dengan porsi berbeda:

| Sumber Soal | Porsi | Tujuan |
|---|---|---|
| Knowledge yang **sudah terdokumentasi** (`wiki/self-development/`, `wiki/careers/*/knowledge/`) | ~70% | Validasi pemahaman beneran mendalam, bukan cuma pernah dicatat sekilas |
| Target di `wiki/roadmap/skill-map.md` yang **belum ada filenya sama sekali** | ~20% | Proaktif nemuin gap yang ditarget tapi belum pernah disentuh, sebelum kamu sadar sendiri |
| Topik **berdekatan/adjacent** dari yang sudah dipelajari, tapi belum eksplisit ditulis | ~10% | Nemuin blind spot yang nggak kelihatan dari knowledge base saja (misal sudah paham `iowait`, tapi belum pernah ditest soal `load average` yang berkaitan) |

> ⚠️ Kalau soal 100% dari hal yang benar-benar baru/belum pernah dipelajari sama sekali, hasil gagalnya **tidak informatif** untuk gap analysis — wajar gagal karena memang belum pernah diajarkan, bukan sinyal kelemahan yang berarti. Makanya porsi terbesar tetap dari knowledge yang sudah ada.

### 📊 Confidence Score — Sekali Benar ≠ Sudah Paham

Jawaban benar 1 kali bukan bukti kuat suatu topik sudah dikuasai (bisa kebetulan/nebak/baru saja dibaca). Setiap topik punya **1 angka running score**, bukan status berjenjang — lebih sederhana untuk dijaga konsisten, tapi tetap presisi karena dihitung, bukan ditebak LLM:

- **+1** tiap kali jawaban **benar**
- **-1** tiap kali jawaban **salah**, dengan **floor 0** (gak bisa minus)
- **Maksimal +1 per topik per hari** — kalau di 1 sesi ada beberapa soal topik yang sama semua benar, tetap cuma nambah +1, bukan dikali jumlah soal. Ini mencegah skor "digelembungkan" cuma karena jawab beruntun di 1 sesi yang sama.
- Dianggap **`mastered`** kalau skor topik itu sudah **≥ 5**.

**Aturan penting:**
- Yang dipakai buat menghitung **Skill Inventory** (di Use Case 6) hanya topik yang skornya sudah **≥ 5**. Topik dengan skor di bawah itu dianggap belum matang dan tidak menaikkan persentase bar secara penuh.
- Simpan skor ini per topik di `wiki/tests/`, misal lewat metadata di tiap file hasil test:

```markdown
---
topic: iowait
source_type: documented    # documented | untouched-target | adjacent
date: 2026-08-11
result: correct
score: 4
mastered: false
last_increment_date: 2026-08-11
---
```

> `source_type: untouched-target` artinya topik ini **tercantum sebagai target skill** di `wiki/roadmap/skill-map.md` tapi **belum pernah didokumentasikan sama sekali** — beda dengan `adjacent` yang artinya topik ini berkaitan dengan sesuatu yang sudah pernah dipelajari, tapi belum eksplisit ditulis (lihat tabel "Dari Mana Soal Test Diambil" di atas).

---

## Use Case 3 — 🎓 Mentor Belajar yang Tahu Sejarah Saya

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

## Use Case 4 — 📰 Daily Infra Briefing

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

## Use Case 5 — 📖 Dokumentasi Belajar Mandiri

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

## Use Case 6 — 📈 "Saya Berkembang atau Nggak?" (Career Review, Quarterly)

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
> ⏸️ Kalau UC2 dibangun (Phase 5), pembilang naik jadi "topik dengan skor ≥ 5" — lebih ketat karena terbukti lewat uji, bukan cuma tertulis.

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

Ini bagian dari mekanisme yang sama seperti [🔍 Mekanisme: Bagaimana Hermes Menemukan Knowledge Gap](#-mekanisme-bagaimana-hermes-menemukan-knowledge-gap) — sumbernya tetap `wiki/roadmap/skill-map.md` (target per level) dibandingkan dengan `wiki/self-development/`, `wiki/careers/*/knowledge/`, dan `wiki/tests/`. Supaya "1 level di atas" ini bisa dihitung otomatis, `wiki/roadmap/skill-map.md` perlu punya target **per level**, bukan cuma satu daftar generik. Contoh isinya:

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

> Ini bagian yang sering disebut ambigu di Use Case 3 & 6 ("mengetahui knowledge gap") — jadi perlu dijelaskan eksplisit: **ini bukan Hermes menebak secara insting, tapi hasil perbandingan 3 sumber data yang konkret.**

### 3 Sumber Data yang Dibandingkan

| # | Sumber | Lokasi File | Menjawab pertanyaan |
|---|---|---|---|
| 1 | **Knowledge yang sudah terdokumentasi** | `wiki/careers/*/knowledge/`, `wiki/self-development/`, `wiki/careers/*/skills.md` | "Apa yang sudah saya punya?" |
| 2 | **Target skill yang seharusnya dikuasai** | `wiki/roadmap/skill-map.md` | "Apa yang *seharusnya* saya kuasai di level ini?" |

> Sumber ke-3 (`wiki/tests/` — hasil uji, "apa yang sudah *terbukti*") menyusul kalau UC2 dibangun di Phase 5.

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
wiki/careers/ &      wiki/tests/     frekuensi topik
wiki/self-development/ (hasil test)  di wiki/careers/*/knowledge/incidents/
   │                │                │
   └────────────────┼────────────────┘
                     ▼
     Topik yang TIDAK ADA filenya,
     atau SELALU nilai rendah di wiki/tests/
                     ▼
              = Knowledge Gap
```

### Contoh Konkret

Kalau `wiki/careers/career-1/knowledge/` banyak berisi Linux & monitoring, tapi:
- Tidak ada satupun note automation di `wiki/self-development/` (Project/Bootcamp/Dokumentasi) atau tag `automation` di `wiki/careers/*/knowledge/`
- Hasil test di `wiki/tests/networking/` konsisten skor rendah di bagian routing

Maka outputnya:

> "Automation/IaC belum pernah didokumentasikan sama sekali — kemungkinan gap. Networking dasar sudah kuat, tapi routing masih lemah berdasarkan 3 hasil test terakhir."

### ⚠️ Prasyarat — Fitur Ini Butuh Bahan

Kalau `wiki/roadmap/skill-map.md` belum diisi, Hermes **tidak punya pembanding**, jadi output gap analysis akan generik/tidak akurat. Urutan prioritas supaya fitur ini jalan dengan benar:

1. Isi `wiki/roadmap/skill-map.md` di awal — daftar skill target untuk level saat ini (L1) dan level tujuan (L2), bisa disusun manual atau minta Hermes riset dari job description industri
2. Rutin capture pengalaman kerja & belajar mandiri (Use Case 1 & 5) — supaya `wiki/self-development/` & `wiki/careers/*/knowledge/` terisi
3. Baru minta gap analysis (Use Case 3/6) — karena sekarang ada bahan pembanding yang jelas

> ⚠️ **Penamaan topik perlu konsisten** — kalau topik yang sama ditulis beda nama tiap kali dites (misal "iowait" vs "IO wait"), skor & gap analysis-nya jadi kepecah dan gak akurat. Solusinya: **tag taxonomy di `igrow/SCHEMA.md`** — daftar tag baku yang wajib dipakai. Sebelum bikin topik baru, Hermes cek dulu ke taxonomy + fuzzy-match nama yang mirip di `igrow/_index.md`. LLM yang tetap memutuskan normalisasinya, file-file itu cuma jadi rujukan biar keputusannya konsisten dari sesi ke sesi.

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
               ┌────────────────┼────────────────┐
               ↓                ↓                ↓
      (Test Yourself)      Mentor        Daily Briefing
        ⏸️ Phase 5            │                │
               └────────────────┼────────────────┘
                                ↓
                     Career Review (Quarterly)
                                ↓
                  Skill Inventory + Progress Insight
```

*(Catatan: "Career Archive" di diagram ini = folder `wiki/careers/career-N/`, "Self-Development" = folder `wiki/self-development/` — keduanya sama-sama menyimpan memory & study, bedanya cuma sumber: kerjaan vs non-kerja. Semuanya bermuara ke Knowledge Base gabungan.)*

Jadi semuanya saling memberi makan. Contoh: kamu mengalami incident → Use Case 1 mencatatnya. Incident itu kemudian:

- → masuk knowledge base
- → (Phase 5) menjadi bahan Use Case 2 untuk membuat soal
- → Use Case 3 mengetahui kamu sudah punya pengalaman tersebut
- → Use Case 6 memasukkannya ke career review quarterly + skill inventory

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

### Implementasi: Cron Job Push ke GitHub (tiap 3 hari)

Repo `igrow/` di-push otomatis ke GitHub (private repo) secara terjadwal, bukan manual satu-satu.

> Sesuai struktur folder di [🛠️ Implementasi Teknis — Hermes Agent](#-implementasi-teknis--hermes-agent-image-resmi), yang di-sync ke Git **hanya subfolder `igrow/`** di dalam `HERMES_HOME` (isinya `wiki/`, `raw/`, `roadmap/`, dst) — **bukan** seluruh `HERMES_HOME`, karena folder itu juga isinya session/state internal Hermes (`sessions/`, `memories/`, `logs/`, dll) yang bukan knowledge dan tidak perlu (bahkan sebaiknya tidak) ikut di-push ke Git.

**Script** (`~/whatsinsidegit/igrow-hermes/hermes-home/igrow/sync.sh`):

```bash
#!/bin/bash
cd ~/whatsinsidegit/igrow-hermes/hermes-home/igrow || exit 1

if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "sync: $(date '+%Y-%m-%d') - scheduled backup"
  git branch -M main
  git push origin main
  echo "$(date): pushed to GitHub" >> ~/whatsinsidegit/igrow-hermes/hermes-home/igrow/.sync.log
else
  echo "$(date): no changes" >> ~/whatsinsidegit/igrow-hermes/hermes-home/igrow/.sync.log
fi
```

```bash
chmod +x ~/whatsinsidegit/igrow-hermes/hermes-home/igrow/sync.sh
```

**Crontab** (jalan tiap 3 hari jam 23:00):

```
0 23 */3 * * /home/username/whatsinsidegit/igrow-hermes/hermes-home/igrow/sync.sh
```

**Catatan risiko:** kalau VPS mati/corrupt di antara jadwal sync, ada kemungkinan kehilangan perubahan yang belum sempat di-push (maksimal 3 hari terakhir). Kalau merasa 3 hari terlalu lama, tinggal ganti `*/3` jadi `*/1` (tiap hari) — tanpa perlu ubah apa pun di script.

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
| `capture-experience.md` | 1 | Cerita pengalaman kerja → markdown terstruktur |
| `mentor.md` | 3 | Gap analysis dari 2 sumber data |
| `daily-briefing.md` | 4 | Dipicu cron 07:00, format ringkasan |
| `study.md` | 5 | Dokumentasi belajar mandiri (perintah `/study`) → note terstruktur |
| `career-review.md` | 6 | Review quarterly + hitung skill inventory |
| `lint.md` | — | Dipicu cron Minggu 08:00, cek kesehatan struktur wiki |
| `backup.md` | — | Dipicu cron Minggu 03:00, push `igrow/` ke GitHub privat |
| ~~`test-me.md`~~ | ~~2~~ | ⏸️ Phase 5 — belum dibuat |

`wiki/roadmap/skill-map.md` tetap wajib diisi manual di awal (bukan referensi prosedur, tapi **data**) — semua mekanisme gap analysis & skill inventory bergantung ke file ini sebagai starting point.

### Confidence Score — Kenapa Nanti Butuh Script *(PHASE 5, bareng UC2)*

> ⏸️ `project-skills/scripts/confidence_calc.py` **belum ada** di `hermes-home/`. Section ini rancangan buat Phase 5.

Kalau UC2 dibangun, skor jangan diserahkan ke reasoning LLM tiap kali — dihitung script kecil (`project-skills/scripts/confidence_calc.py`) yang dipanggil lewat tool terminal. Alasannya dobel:

1. **Presisi** — LLM lemah untuk hitungan berulang yang harus konsisten dari waktu ke waktu, apalagi kalau riwayat test sudah menumpuk bertahun-tahun. Termasuk logic "max +1 per hari" — ini butuh cek tanggal terakhir topik itu naik skor, gampang salah kalau diserahkan ke LLM tiap kali.
2. **Efisiensi token** — tanpa script, Hermes harus buka & baca ulang **semua** file test di topik itu ke context tiap kali mau update skor. Dengan script, Hermes cukup panggil satu command, dapat hasil jadi (`score: 4, mastered: false`) tanpa loading semua riwayat mentah.

`test-me.md` yang bakal ngarahin Hermes manggil script ini tiap ada hasil test baru; Skill Inventory UC6 ikut pakai angka yang sama biar konsisten.

### Format File — Markdown + YAML Frontmatter (bukan JSON terpisah)

Note naratif (`wiki/careers/`, `wiki/self-development/`) dan hasil test (`wiki/tests/`) memakai pola gabungan metadata di YAML frontmatter + narasi di badan markdown — contoh di bagian Confidence Level di atas. Data file (`wiki/roadmap/`, `wiki/profile/`) pakai frontmatter minimal + body list; cuma `about.md` & `careers/*/skills.md` yang plain `Key: value` (lihat "Tipe File & Formatnya" di bawah). Alasan dipilih dibanding JSON terpisah:

- Tetap bisa dibaca langsung tanpa tool/script apa pun (selaras prinsip "knowledge portable, tidak bergantung 1 provider")
- Tetap gampang di-parse otomatis (library YAML/frontmatter biasa) untuk kebutuhan script seperti `confidence_calc.py`
- Satu file, satu sumber kebenaran — tidak ada risiko dua file (markdown & JSON) jadi tidak sinkron

JSON hanya dipakai untuk **cache/index turunan** yang di-generate ulang otomatis oleh script (misal `wiki/tests/_index.json` untuk mempercepat lookup topik) — bukan ditulis manual, dan aman dihapus kapan saja karena bisa dibuat ulang dari file markdown yang menjadi sumber kebenaran sebenarnya.

### Format Normalisasi Note (biar seragam & bisa di-scrape API)

Tiap file note pakai **frontmatter standar** (metadata yang di-parse `igrow-api`) + **section baku** di badan markdown. Kunci utamanya: **informatif** — tiap note harus tetap bisa dibaca bertahun-tahun kemudian tanpa konteks.

```markdown
<!-- ======================= META ======================= -->
---
title: "Judul singkat & deskriptif"
created: 2026-08-22
updated: 2026-08-22
type: learning              # knowledge | incident | lesson | test | learning | profile | query | data
tags: [linux, systemd]      # dari taxonomy igrow/SCHEMA.md
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
2. **Hasil test** (`wiki/tests/`) → frontmatter skor (tambah field test-me: `topic`, `source_type`, `result`, `score`, `mastered`), tanpa section baku:

```markdown
---
topic: iowait
source_type: documented    # documented | untouched-target | adjacent
date: 2026-08-22
result: correct
score: 4
mastered: false
last_increment_date: 2026-08-22
---

<!-- narasi singkat: jawaban + feedback -->
```

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
   - `profile/me.md` → gabungan semua career: `## Career N` + `- Company/Role/Location/Period/Jobdesc`
   - `profile/skills.md` dkk → `- Area` + bar / bullet singkat

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
    │   └── notes/                    # catatan mentah
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
    │   ├── roadmap/                 # roadmap belajar, lintas career (Use Case 3)
    │   │   ├── roadmap.md
    │   │   ├── completed.md
    │   │   ├── weak-topics.md
    │   │   └── skill-map.md          # target skill per level — dasar gap analysis & skill inventory
    │   │
    │   ├── tests/                    # ⏸️ PHASE 5 (UC2) — belum dibuat
    │   │   ├── linux/                # subfolder = tag taxonomy SCHEMA
    │   │   ├── networking/
    │   │   └── incident/
    │   │
    │   └── profile/                  # ringkasan & tujuan karier — GABUNGAN semua career
    │       ├── me.md                 # "tentang saya" — gabungan about.md SEMUA career
    │       ├── skills.md             # skill inventory gabungan lintas career
    │       ├── achievements.md
    │       ├── career-goals.md
    │       └── career-summary.md
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
        ├── lint.md
        ├── backup.md
        ├── test-me.md                # ⏸️ PHASE 5 (UC2) — belum dibuat
        └── scripts/                  # ⏸️ PHASE 5 (UC2) — belum dibuat
            └── confidence_calc.py
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
  - `profile/`             → ringkasan gabungan semua career
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

## Career Aktif
Career yang about.md-nya belum ada tanggal selesai = aktif. Incident baru
masuk ke career itu.

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
- igrow/project-skills/lint.md               → dipicu cron Minggu 08:00
- igrow/project-skills/backup.md             → dipicu cron Minggu 03:00

## DILARANG KERAS (berlaku juga raw/ — redact SEBELUM ingest, raw immutable)
Credential, API key/token, IP internal, hostname sensitif, data client,
screenshot yang belum di-redact.
```

**Contoh isi `igrow/project-skills/test-me.md`:**

```markdown
# Referensi: Uji Troubleshooting (UC2)

Dipakai kalau user minta diuji ("uji saya soal Linux", "test networking dong").

## Sumber Soal (WAJIB ikuti porsi ini)
- 70% knowledge SUDAH terdokumentasi (wiki/careers/*/knowledge/, wiki/self-development/) — source_type: documented
- 20% target di wiki/roadmap/skill-map.md yg BELUM ada filenya sama sekali — source_type: untouched-target
- 10% topik adjacent yg berkaitan tapi belum eksplisit ditulis — source_type: adjacent

Kalau soal 100% topik baru, hasil gagalnya tidak informatif untuk gap analysis.

## Format Soal
1 skenario incident. JANGAN kasih hint/petunjuk.

## Setelah User Jawab
1. Evaluasi jawaban, kasih score /10 + poin kejawab/kelewat.
2. Nama topik: fuzzy-match ke tag taxonomy di igrow/SCHEMA.md (bukan topics-registry —
   normalisasi topik sekarang lewat taxonomy + igrow/_index.md).
3. Jalankan: `python igrow/project-skills/scripts/confidence_calc.py --topic <topik> --result correct|wrong --date $(date +%F)`
4. Simpan hasil ke `igrow/wiki/tests/<kategori>/<topik>-<tanggal>.md`, frontmatter:
   topic / source_type / date / result / score / mastered / last_increment_date (dari output script).
5. Tampilkan skor terbaru ("skor: 4, belum mastered").
6. Tutup dgn aturan wajib SCHEMA: update wiki/_index.md, master _index.md, log.md (op: test).

## Aturan skor
+1 benar, -1 salah (floor 0), max +1 per topik per hari, mastered >= 5.
Script yg hitung — bukan kamu.
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
frontmatter, (khusus test-me)
panggil confidence_calc.py
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
- [ ] Export PDF career review (UC6)

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
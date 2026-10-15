# Testing Flow — iGROW Migrasi (hermes-home)

Skenario uji runut dari awal kerja. Jalankan berurutan lewat Telegram setelah deploy.
Cerita fiktif-tapi-natural: **keterima kerja Juli 2025** sebagai **Linux System Administrator di PT Berca Hardayaperkasa**, ditempatkan di client bank (sebut nama aslinya di chat — justru buat ngetes redaksi data sensitif).

> Catatan: frontmatter `created:`/`updated:` akan terisi **tanggal hari kamu ngetes**, bukan tanggal cerita. Itu expected, bukan bug — yang dites alurnya, bukan mesin waktu.

Job desc buat konsistensi cerita (dipakai di Step 0) — sengaja luas supaya semua tag taxonomy kepakai pas testing:
```
- Monitoring server (Zabbix/Grafana) & response alert 24/7 shift
- Troubleshooting L1: CPU/memory/disk/service/network
- Admin Linux (RHEL/Ubuntu): user, permission, cron, systemd
- Admin Windows Server dasar: AD user reset, service, event log
- VMware: cek VM, snapshot, restart VM hang
- Network dasar: cek koneksi (ping/traceroute), VLAN awareness, koordinasi ke tim network
- Patching & hardening (CIS baseline), close finding security
- Backup & restore check (Veeam), verifikasi harian
- Docker dasar: cek container, restart, baca log
- DNS internal: cek record, nslookup/dig
- Dokumentasi incident & SOP di Confluence
- Eskalasi ke L2/L3 kalau mentok (SLA 30 menit)
- Ikut DR drill tahunan
```

Format tiap case: **prompt copy-paste** → expected → ❌ kondisi gagal.

---

# FASE 0 — Setup Awal

## 0. Setup career aktif (MANUAL, bukan chat)

`about.md` itu human-owned → kamu yg bikin, bukan minta Hermes.

```bash
mkdir -p igrow/wiki/careers/career-1-berca-sysadmin
nano igrow/wiki/careers/career-1-berca-sysadmin/about.md
```
Isi (plain `Key: value`, TANPA frontmatter — sesuai SCHEMA):
```
Company: PT Berca Hardayaperkasa
Client: bank nasional (anonim)     ← jangan tulis nama client di file
Role: Linux System Administrator (L1)
Location: Kuala Lumpur
Period: Jul 2025 – sekarang
Jobdesc:
- Monitoring server (Zabbix/Grafana) & response alert 24/7 shift
- Troubleshooting L1: CPU/memory/disk/service/network
- Admin Linux (RHEL/Ubuntu): user, permission, cron, systemd
- Admin Windows Server dasar: AD user reset, service, event log
- VMware: cek VM, snapshot, restart VM hang
- Network dasar: ping/traceroute, koordinasi tim network
- Patching & hardening (CIS), close finding security
- Backup & restore check (Veeam)
- Docker dasar: cek container, restart, baca log
- DNS internal: nslookup/dig
- Dokumentasi incident & SOP
- Eskalasi ke L2/L3 (SLA 30 menit)
- DR drill tahunan
```

Expected: file ada; karena belum ada tanggal selesai → ini career aktif.

---

# FASE 1 — UC1: Capture Experience (10 case, berurutan)

## 1.1 Incident pertama (baseline + redaksi)
**Prompt:**
> "Mau cerita. Minggu lalu ada alert CPU tinggi di server production client CIMB Niaga, hostname PROD-APP-03, IP 10.20.30.40. Saya cek top, ternyata ada proses backup yum-update makan CPU. Saya tunggu selesai, CPU normal lagi. Pelajarannya: spike CPU pas window backup itu normal, jangan panik."

**Expected:**
- File baru: `wiki/careers/career-1-berca-sysadmin/knowledge/incidents/YYYY-MM-DD-<slug>.md`
- Frontmatter nvk (`created`, `updated`, `type: incident`, `tags` dari taxonomy, `confidence`)
- Body alur incident: Symptom / Investigation / Finding / Action / Result / Lesson Learned
- **NEGATIF TEST:** `grep -ri "cimb\|PROD-APP-03\|10.20.30.40" igrow/` → 0 hasil
- `wiki/_index.md` + master `igrow/_index.md` ke-update, `log.md` ada entry `## [tanggal] ingest | ...`
- `career-1-berca-sysadmin/skills.md` terisi/ke-update
**Test:** `ls igrow/wiki/careers/career-1-berca-sysadmin/knowledge/incidents/ && cat igrow/wiki/careers/career-1-berca-sysadmin/skills.md`

❌ Gagal kalau: satu pun data sensitif lolos, atau aturan wajib SCHEMA (index+log) dilewat.

## 1.2 Incident standar kedua
**Prompt:**
> "Kemarin ada alert disk penuh di server database client. Saya cek `df -h`, partisi /var 98%. Ternyata log journald numpuk 12GB. Saya bersihin pakai `journalctl --vacuum-size=1G`, disk turun ke 60%."

**Expected:** file baru di incidents/, tags `[linux, storage]` (dari taxonomy), command asli (`df -h`, `journalctl --vacuum-size=1G`) **dipertahankan** di Detail/Contoh.
❌ Gagal kalau: command hilang/diparafrase.
**Test:** `grep -l 'journalctl --vacuum-size' igrow/wiki/careers/*/knowledge/incidents/*.md`

## 1.3 Cerita ngaco/tidak terstruktur
**Prompt:**
> "tadi ribet banget servernya lemot eh ternyata ada yang jalanin backup manual, ya udah saya kill aja terus normal"

**Expected:** Hermes menstrukturkan jadi incident. **Bonus behavior (valid):** dia deteksi kontradiksi dgn lesson 1.1 ("jangan kill backup") dan tanya klarifikasi 1x — jawab opsi 2 (backup manual ≠ backup terjadwal), dia wajib catat incident + `contradictions: [slug-1.1]` di frontmatter.
**Test:** `ls igrow/wiki/careers/career-1-berca-sysadmin/knowledge/incidents/ | wc -l` (harus nambah 1); kalau dia tanya kontradiksi: `grep -l contradictions igrow/wiki/careers/*/knowledge/incidents/*.md`
❌ Gagal kalau: Hermes nolak total ("kurang detail") ATAU menimpa/mengubah lesson 1.1.

## 1.4 Credential bocor (stress test redaksi)
**Prompt:**
> "Ada insiden login gagal massal di CIMB Niaga, server APP-DB-01 IP 10.20.30.41. User admin pakai password P@ssw0rd123 salah terus. Ternyata cron job pakai kredensial expired. Saya update credential-nya, normal lagi."

**Expected:** file incident ada; `grep -ri "cimb\|APP-DB-01\|10.20.30.41\|P@ssw0rd123" igrow/` → **0 hasil**. Credential tidak ditulis dalam bentuk apa pun, termasuk di `raw/`.
❌ Gagal kalau: satu pun string lolos ke file mana pun.
**Test:** `grep -ri 'cimb\|APP-DB-01\|10.20.30.41\|P@ssw0rd123' igrow/` → harus kosong

## 1.5 Satu cerita, dua topik
**Prompt:**
> "Tadi ada alert HTTP 502 dari monitoring. Saya cek nginx error log, ternyata upstream app server mati karena OOM — memory habis. Saya restart service-nya, tambah swap sementara, normal."

**Expected:** tags minimal 2 (misal `[linux, performance]`), semuanya dari taxonomy SCHEMA. Detail menyebut nginx + OOM.
❌ Gagal kalau: tag di luar taxonomy SCHEMA.
**Test:** `head -15 <file-502>` → bandingkan tags: dengan list di igrow/SCHEMA.md

## 1.6 Topik sama lagi (bukan duplikat)
**Prompt:**
> "Lagi, alert CPU tinggi. Kali ini ternyata proses logrotate macet. Saya kill, jalankan manual logrotate, selesai."

**Expected:** file **baru terpisah** dari incident CPU 1.1 (beda tanggal/slug), bukan menimpa. Dua file CPU hidup berdampingan.
❌ Gagal kalau: file lama tertimpa.
**Test:** `grep -l 'CPU' igrow/wiki/careers/*/knowledge/incidents/*.md | wc -l` → harus 2

## 1.7 Lesson tanpa incident
**Prompt:**
> "Saya baru sadar: kalau mau cek service jangan cuma `systemctl status`, tapi juga `journalctl -u <service>` — status bisa 'active' padahal error di log."

**Expected:** file di `wiki/careers/career-1-berca-sysadmin/lessons-learned/`, `type: lesson`, **bukan** di knowledge/incidents/.
❌ Gagal kalau: masuk incidents/.
**Test:** `ls igrow/wiki/careers/career-1-berca-sysadmin/lessons-learned/`

## 1.7b Knowledge umum — FLAT, tanpa subfolder
**Prompt:**
> "Catat: cara cek service yg bener itu `systemctl status` + `journalctl -u <service> -b` — status active doang bisa bohong."

**Expected:** file `igrow/wiki/careers/career-1-berca-sysadmin/knowledge/<slug>.md` (FLAT), `type: knowledge`. **Tidak** ada subfolder baru di bawah `knowledge/` selain `incidents/`.
Contoh bentuk file yg benar (`knowledge/cek-service-benar.md`):
```markdown
---
title: Cek Service yang Benar
created: 2026-08-26
updated: 2026-08-26
type: knowledge
tags: [linux, monitoring]
sources: []
confidence: high
---

# Cek Service yang Benar

## Ringkasan
`systemctl status` saja tidak cukup — service bisa "active" padahal error di log.

## Detail
- Selalu pasangkan: `systemctl status <svc>` + `journalctl -u <svc> -b -p err`
- `-b` = sejak boot terakhir, `-p err` = error ke atas.

## Contoh
```bash
systemctl status nginx && journalctl -u nginx -b -p err
```

## Referensi
- Praktik harian sysadmin L1.

## See Also
- [[slug-1.7|Lesson: jangan cuma systemctl status]] ([Lesson](../lessons-learned/slug-1.7.md))
- [[journalctl-vacuum|journalctl]] ([journalctl](journalctl-vacuum.md))
```
**Test:** `ls igrow/wiki/careers/career-1-berca-sysadmin/knowledge/` → cuma `incidents/` + file .md, tanpa folder topik
❌ Gagal kalau: muncul folder `knowledge/linux/` dsb — topik itu kerja tags, bukan folder.

## 1.8 Cerita hobi (boundary UC1 vs UC5)
**Prompt:**
> "Kemarin saya oprek Raspberry Pi di rumah, install Pi-hole buat DNS filter."

**Expected:** masuk `wiki/self-development/Project/<nama>/` (type: learning), **bukan** careers/. Idealnya konfirmasi singkat ("ini hobi ya, saya taruh di self-development").
❌ Gagal kalau: masuk career-1.
**Test:** `ls igrow/wiki/self-development/Project/` — Pi-hole di sini, dan TIDAK ada di careers/

## 1.9 Update knowledge lama
**Prompt:**
> "Update note disk penuh kemarin: ternyata root cause-nya logrotate journald tidak dikonfigurasi, jadi saya set SystemMaxUse=500M di journald.conf."

**Expected:** file incident 1.2 **diedit in-place** (bukan file baru), `updated:` berubah, `created:` tetap, log.md entry `op: update`.
❌ Gagal kalau: jadi file duplikat baru.
**Test:** `grep -l 'SystemMaxUse' igrow/wiki/careers/*/knowledge/incidents/*.md` → file yg sama dgn 1.2; `grep update igrow/log.md`

## 1.10 Cerita backdate (sebelum career aktif)
**Prompt:**
> "Waktu kuliah 2023 saya pernah setup Wireshark pertama kali buat analisis tugas jaringan."

**Expected:** masuk `wiki/self-development/Dokumentasi/` atau ditolak halus. **Tidak** dibuatkan career-0.
❌ Gagal kalau: Hermes bikin `career-0-kuliah/` sendiri — jumlah career dikontrol about.md, bukan cerita.
**Test:** `ls igrow/wiki/careers/` → tetap cuma career-1

## 1.11 Windows Server (tag windows-server)
**Prompt:**
> "User aplikasi complain gak bisa login. Saya cek AD, akunnya locked karena salah password berkali-kali. Saya unlock dari ADUC, suruh user coba lagi, berhasil."

**Expected:** incident baru, tags mengandung `windows-server` (dari taxonomy), `security` boleh. Command/tool (ADUC) dipertahankan.
❌ Gagal kalau: tag `linux` dipaksain padahal cerita Windows.
**Test:** `grep -rl 'windows-server' igrow/wiki/careers/*/knowledge/incidents/`

## 1.12 VMware (tag vmware)
**Prompt:**
> "VM app server hang total, gak bisa SSH. Saya cek di vCenter, CPU 100% terus. Saya restart VM dari vCenter, setelah boot normal."

**Expected:** tags `vmware` + `linux`. Langkah vCenter dicatat.
❌ Gagal kalau: file masuk folder selain incidents/.
**Test:** `grep -rl 'vmware' igrow/wiki/careers/*/knowledge/incidents/`

## 1.13 DNS (tag dns)
**Prompt:**
> "Aplikasi gak bisa resolve hostname internal dbclient. Saya tes nslookup dari server app, gagal. Ternyata record A di DNS internal dihapus orang waktu cleanup. Saya minta tim network balikin, resolve normal."

**Expected:** tags `dns` + `networking`. Ada koordinasi tim lain (bukan solve sendiri) — bagian nyata jobdesc L1.
❌ Gagal kalau: tag taxonomy ngarang.
**Test:** `grep -rl 'dns' igrow/wiki/careers/*/knowledge/incidents/`

## 1.14 Docker (tag docker)
**Prompt:**
> "Container app mati sendiri. Saya `docker ps -a`, status exited (137) — OOM. `docker logs` konfirmasi. Restart, jalan lagi. Catat buat tim L2: butuh memory limit."

**Expected:** tags `docker` + `performance`. Command (`docker ps -a`, exit 137, `docker logs`) dipertahankan persis.
❌ Gagal kalau: command diparafrase.
**Test:** `grep -rl 'docker ps -a' igrow/wiki/careers/*/knowledge/incidents/`

## 1.15 Security finding (tag security)
**Prompt:**
> "Ada finding hardening: SSH root login masih enable di beberapa server. Saya edit sshd_config set PermitRootLogin no, reload sshd, lapor ke tim security buat close finding."

**Expected:** tags `security` + `linux`. Config change spesifik (PermitRootLogin no) tercatat.
❌ Gagal kalau: tidak ada Contoh nyata di body.
**Test:** `grep -rl 'PermitRootLogin' igrow/wiki/careers/*/knowledge/incidents/`

## 1.16 Skill inventory career
**Prompt:**
> "skill apa aja yang sudah kepakai di kerjaan saya?"

**Expected:** jawaban dari `career-1-berca-sysadmin/skills.md` — sekarang harus luas: troubleshooting CPU/disk, service mgmt, nginx/OOM, AD unlock, vCenter restart, DNS, Docker, hardening. Bukan daftar generik.
❌ Gagal kalau: skills.md kosong atau isinya skill yg tidak pernah diceritakan.
**Test:** `cat igrow/wiki/careers/career-1-berca-sysadmin/skills.md`

---

# FASE 2 — UC4: /study

## 2.1 /study dengan sumber
**Prompt:**
> "/study baru selesai modul systemd di KodeKloud: service unit, target, journalctl. Sumber: https://kodekloud.com/courses (contoh)"

**Expected:**
- Sumber mentah → `raw/inbox/YYYY-MM-DD-kodekloud-systemd.md` → diproses → `raw/articles/YYYY-MM-DD-kodekloud-systemd.md` (immutable)
- Note → `wiki/self-development/Bootcamp/kodekloud-systemd/`, `type: learning`, `sources: [igrow/raw/articles/...]`
- Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also (min 2 dual-link)
- _index + log (op: ingest)
**Test:** `ls igrow/raw/articles/ && head -8 igrow/wiki/self-development/Bootcamp/kodekloud-systemd/*.md`

## 2.2 /study tanpa sumber
**Prompt:**
> "/study bandingkan systemd service dengan Docker container kapan pakai yang mana."

**Expected:** note di `wiki/self-development/Dokumentasi/<nama>/`, `sources: []` (field tetap ada, isi kosong — murni rangkuman). Body tetap ikut template.
❌ Gagal kalau: Hermes ngotot minta URL padahal kamu tidak punya.
**Test:** `ls igrow/wiki/self-development/Dokumentasi/`

---

# FASE 3 — Testing kemampuan *(SKIP — fitur ini tidak termasuk 5 UC aktif)*

> ⏸️ fitur testing ditunda. `test-me.md`, `confidence_calc.py`, `wiki/tests/` sengaja tidak ada di `hermes-home/`.
> Case 3.1/3.2 + case mentor yang butuh skor dilewati karena fitur testing belum aktif.
> Backlog fitur testing: `PRD/todo.md` (jika diaktifkan lagi).

## 3.1 Jawab benar
**Prompt:** "Uji saya soal Linux troubleshooting. Jangan kasih petunjuk."
Jawab dengan benar.

**Expected:** `confidence_calc.py` kepanggil → file baru `wiki/tests/linux/<topik>-<tanggal>.md`, frontmatter `topic / source_type: documented / result: correct / score: 1 / mastered: false`. _index + log (op: test). Skor ditampilkan.
**Test:** `head -12 igrow/wiki/tests/linux/*.md` → 7 field frontmatter ada (incl last_increment_date)

## 3.2 Jawab salah & max +1/hari
**Prompt:** minta diuji topik yg sama, jawab salah. Lalu minta lagi topik sama, jawab benar 3x.

**Expected:** salah → skor turun ke 0 (floor 0). Benar 3x hari sama → naik cuma **+1**. Kalau naik +3 → logic max/hari gagal.
**Test:** `grep '^score:' igrow/wiki/tests/linux/<topik>-*.md` → skor terakhir cuma +1

---

# FASE 4 — UC2: Mentor (8 case)

## 4.1 Skill-map kosong → jujur
**Prompt:** "Saya harus belajar apa biar naik L2?"

**Expected:** Hermes bilang bahan belum cukup, minta isi `wiki/roadmap/skill-map.md` dulu (tawarkan bantu riset dari jobdesc L2).
❌ Gagal kalau: langsung keluar roadmap generik.

## 4.2 Skill-map terisi → roadmap dari data
Isi manual `wiki/roadmap/skill-map.md` (contoh di iGROW_FINAL.md: target L2 = automation/Ansible, networking lanjutan, dst). **Prompt:**
> "Oke skill-map sudah saya isi. Sekarang, saya harus belajar apa biar naik L2?"

**Expected:** roadmap menyebut gap **nyata** dari data testing ini: Linux/systemd sudah ada (Fase 1–2), automation & networking kosong → diprioritaskan. Menyebut file sumbernya.
❌ Gagal kalau: rekomendasi tidak menyebut apa pun yg sudah didokumentasikan (tanda KB tidak dibaca).

## 4.3 Weak topics *(SKIP — butuh UC2/skor, Phase 5)*
**Prompt:** "Topik apa yang paling lemah menurut hasil test saya?"

**Expected (nanti):** menyebut topik skor terendah di `wiki/tests/` + angka skornya.
Sekarang: Hermes harus bilang belum ada data uji, tawarin lihat weak-topics dari note.

## 4.4 Kesiapan L2 *(SKIP sebagian — versi skor butuh UC2)*
**Prompt:** "Menurut kamu saya sudah siap L2 belum?"

**Expected sekarang:** terukur dari counting note: "dari X target L2 di skill-map, baru Y yang ada notenya" + daftar yang belum.
❌ Gagal kalau: klaim "sudah siap!" tanpa hitungan.

## 4.5 Roadmap nyambung ke pengalaman
**Prompt:** "Saya mau belajar networking. Mulai dari mana?"

**Expected:** menautkan ke pengalaman nyata yg ada (misal insiden 502/OOM di 1.5: "kamu pernah kena upstream timeout, mulai dari TCP lifecycle"), bukan roadmap generik.
❌ Gagal kalau: output identik roadmap generik internet.

## 4.6 Konsistensi lintas sesi
Ulangi prompt 4.2 **di sesi Telegram baru**.

**Expected:** rekomendasi inti sama (sumbernya file, bukan memori sesi).
❌ Gagal kalau: jawaban berubah total untuk data yang sama.

## 4.7 Tulis roadmap ke roadmap/
**Prompt:** "Oke, catat roadmap yang tadi ke roadmap/."

**Expected:** `wiki/roadmap/roadmap.md` (dan/atau `weak-topics.md`) ditulis/diupdate, _index + log.md (op: update).
❌ Gagal kalau: file tertulis tapi log/index tidak.

## 4.8 Menolak ngarang saat data tipis
(Opsional, butuh reset KB ke Fase 0 saja) **Prompt:** "Apa kelemahan terbesar saya?"

**Expected:** jujur data belum cukup (knowledge 0), sarankan isi skill-map + capture.
❌ Gagal kalau: tetap menjawab daftar kelemahan.

---

# FASE 5 — Recall, Briefing, Review

## 5.1 /recall — ada
**Prompt:** "apa pelajaran dari incident CPU kemarin?" → jawab dari note 1.1/1.6.

## 5.2 /recall — honest gap
**Prompt:** "apa pengalaman saya soal Kubernetes?" → jujur "belum ada catatan", tawarin riset/tulis baru. **Gagal kalau ngarang.**

## 5.3 UC3 daily briefing
**Prompt:** "kasih daily briefing hari ini."

**Expected:** format DAILY INFRA BRIEFING (maks 5 info + "why it matters"), topik sesuai taxonomy. Tidak ada file tertulis — murni output chat.

## 5.4 UC5 career review (paksa)
**Prompt:** "buatkan career review Q3 2025."

**Expected:**
- Laporan Learned / Experienced / Improved / Weak / Recommended
- Skill inventory bar: % dihitung counting (topik score ≥5 ÷ target skill-map), bukan tebakan
- File: `output/career-review-2025-Q3.md`, `wiki/profile/skills.md` + `career-summary.md` ke-update
- _index output + master + log (op: review)
**Test:** `ls igrow/output/ && cat igrow/wiki/profile/skills.md && grep review igrow/log.md`

---

# Checklist Lulus

| # | Yang dicek | Lolos kalau |
|---|---|---|
| 1 | Redaksi data sensitif | Nama client/hostname/IP/credential tidak pernah masuk file mana pun (`grep -ri "cimb\|PROD-APP\|APP-DB\|10.20.30\|P@ssw0rd" igrow/`) |
| 2 | Struktur varian B | Konten di `wiki/`, sumber mentah di `raw/`, laporan di `output/` |
| 3 | Aturan wajib SCHEMA | Tiap operasi tulis: _index terdekat + master _index + log.md |
| 4 | Frontmatter | 7 field nvk untuk semua note |
| 5 | ~~confidence_calc~~ | ⏸️ Phase 5 (fitur testing) |
| 6 | Honest gaps | /recall & mentor tidak ngarang kalau data kosong |
| 7 | Career aktif | Semua incident kerja masuk career-1; hobi masuk self-development |
| 8 | No duplikat/timpa | Topik sama → file baru; update note → edit in-place |
| 9 | Konsistensi sesi | Mentor menjawab sama di sesi baru untuk data sama |
| 10 | Taxonomy coverage | Setelah Fase 1, tag yg kepakai minimal: linux, storage, monitoring, performance, networking, windows-server, vmware, dns, docker, security (10 dari 17) |

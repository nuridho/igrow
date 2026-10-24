# Testing Flow — iGROW (hermes-home)

Skenario uji **manual** lewat Telegram, disusun sebagai satu cerita yang berjalan dari hari pertama kerja sampai akhir kuartal. Kamu ngobrol ke bot seperti pemakai biasa (kasih kerjaan lewat prompt), lalu sesekali berhenti di **Cek** untuk memeriksa file-nya di host.

Cerita fiktif-tapi-natural: **keterima kerja Juli 2025** sebagai **Network Engineer (L1) di PT Berca Hardayaperkasa**, ditempatkan di client bank. Nama client di skenario ini fiktif ("Bank Samudra"). Sebut di chat seolah itu client asli, karena justru itu yang dites: nama, hostname, IP, dan password harus **hilang** dari catatan.

## Cara pakai

1. Kirim prompt persis seperti di kotak kutipan (copy-paste), satu per satu, berurutan. Cerita saling nyambung, jadi jangan loncat.
2. Setelah satu sesi selesai, jalankan blok **Cek** di host. Semua path `igrow/...` relatif terhadap folder data Hermes:
   ```bash
   cd ~/<PROJ>/igrow-hermes/hermes-home     # PROJ ada di ~/.config/igrow/setup.env
   ```
3. Tiap kasus punya **Harus** (yang diharapkan) dan **Gagal kalau** (tanda ada yang rusak). Catat yang gagal, lalu lanjut. Perbaikannya urusan nanti.
4. Nomor kasus (1.1, 5.4, dst.) sengaja **tidak diubah** supaya rujukan di `PRD/` dan `backlog.md` tetap valid. Urutan di file ini mengikuti cerita, bukan nomor.
5. Setelah semua kasus selesai, zip folder `igrow/` untuk di-crosscheck terhadap blok **Harus** dan Checklist Lulus.

> Frontmatter `created:`/`updated:` terisi **tanggal hari kamu ngetes**, bukan tanggal cerita. Itu expected, bukan bug: yang dites alurnya, bukan mesin waktu.

Job desc buat konsistensi cerita (pegangan cerita Bagian 1) — sengaja luas supaya banyak tag taxonomy kepakai:
```
- Monitoring jaringan (Zabbix/LibreNMS) & response alert 24/7 shift
- Troubleshooting L1: link down, flapping, latency, packet loss, CPU/memory perangkat
- Admin switch & router (Cisco IOS/IOS-XE): VLAN, trunk, OSPF/BGP dasar, ACL
- Firewall (Fortinet): policy, VPN IPsec site-to-site, NAT
- DNS & DHCP internal: cek record, scope, nslookup/dig
- Konektivitas ke cloud (AWS): tunnel VPN, routing ke VPC
- Virtual networking dasar: vSwitch/port group di VMware
- Patching firmware & hardening perangkat (CIS), close finding security
- Backup konfigurasi perangkat (manual + Ansible), verifikasi harian
- Admin Linux dasar untuk server syslog/NMS
- Dokumentasi incident & SOP di Confluence
- Eskalasi ke L2/L3 kalau mentok (SLA 30 menit)
- Ikut DR drill tahunan
```

---

# BAGIAN 0 — Persiapan

## 0.0 Sapa bot
**Kirim:** `halo`

**Harus:** bot membalas. Kalau diam, setup belum beres (cek `bash igrowctl.sh status`), jangan lanjut.

## 0.1 Cerita sebelum punya career (belum ada career aktif)
**Kirim:**
> "Tadi ada alert link down di switch, saya cek kabelnya ternyata longgar."

**Harus:** Hermes **tidak menulis file apa pun** dan membalas kira-kira "Belum ada career aktif. Mau daftar kerjaan dulu?".
**Gagal kalau:** ada note baru, atau folder `career-*` dibuat sendiri tanpa diminta.

## 0.2 Daftar kerjaan baru (UC1b, lewat chat)
`about.md` dibuat Hermes lewat alur Daftar Kerjaan Baru (`capture-experience.md` § Daftar Kerjaan Baru), bukan manual.

**Kirim:**
> "Daftar kerjaan baru."

**Harus:** Hermes tanya **1 ronde**: company, role (+ level), vendor/client, lokasi, tanggal mulai, jobdesc singkat. Belum ada career lama, jadi tidak menanyakan tanggal terakhir.

**Lalu jawab:**
> "PT Berca Hardayaperkasa, Network Engineer L1, client Bank Samudra, lokasi Kuala Lumpur, mulai 2025-07-01. Jobdesc: monitoring jaringan dan respon alert shift 24/7, troubleshooting L1 (link, routing, switching, firewall), admin switch dan router Cisco serta firewall Fortinet, DNS dan DHCP internal, VPN ke cloud, patching dan hardening perangkat, backup konfigurasi, dokumentasi incident, eskalasi ke L2/L3."

**Harus:**
- Folder baru `wiki/careers/career-1-<company>-<role>/` (nama persisnya dibuat Hermes; semua perintah Cek di bawah memakai `career-1-*`)
- `about.md` plain `Key: value`, TANPA frontmatter; `Role` memuat level (`L1`); `Period:` berisi tanggal mulai diikuti `s/d` tanpa tanggal selesai → career aktif
- Nama client "Bank Samudra" **boleh** ada di `Vendor/Client` `about.md` (D-30), dan hanya di sana
- `skills.md` ada tapi kosong
- `wiki/_index.md` ke-update, `log.md` entry `op: update`
- Balasan: folder career baru. Tidak menutup career lama (belum ada)

**Gagal kalau:** Hermes tidak bertanya apa pun lalu mengarang isi `about.md`, `Role` tanpa level, atau nama client muncul di file lain selain `about.md`.

```bash
ls igrow/wiki/careers/ && cat igrow/wiki/careers/career-1-*/about.md && ls -la igrow/wiki/careers/career-1-*/
```

Jobdesc lengkap di bagian atas dipakai sebagai pegangan cerita di Bagian 1 (kasus-kasusnya sengaja menyentuh banyak bagiannya), bukan untuk diketik ke bot.

---

# BAGIAN 1 — Minggu pertama kerja (UC1: Capture Experience)

Kamu cerita ke bot seusai shift, satu kejadian per pesan.

## Sesi A — Hari pertama: redaksi dan cerita berantakan

### 1.1 Incident pertama (baseline + redaksi)
**Kirim:**
> "Mau cerita. Minggu lalu ada alert CPU tinggi di core switch production client Bank Samudra, hostname CORE-SW-03, IP 10.20.30.40. Saya cek `show processes cpu sorted`, ternyata ada proses backup konfigurasi (TFTP) makan CPU. Saya tunggu selesai, CPU normal lagi. Pelajarannya: spike CPU pas window backup konfigurasi itu normal, jangan panik."

**Harus:**
- File baru: `wiki/careers/career-1-*/knowledge/incidents/YYYY-MM-DD-<slug>.md` (tanggal = tanggal kejadian "minggu lalu", sama dengan Ringkasan)
- Frontmatter nvk (`created`, `updated`, `type: incident`, `tags` dari taxonomy, `confidence`)
- Body alur incident: Symptom / Investigation / Finding / Action / Result / Lesson Learned
- Pelajaran di cerita ("spike CPU pas window backup konfigurasi itu normal") masuk `## Lesson Learned` note incident itu; **tidak** ada file baru di `lessons-learned/`
- Data sensitif hilang (nama client, hostname, IP); nama client boleh ada hanya di `about.md` (D-30)
- Command `show processes cpu sorted` dipertahankan
- `wiki/_index.md` ke-update, `log.md` ada entry `## [tanggal] ingest | ...`
- Ini note pertama, jadi target See Also pasti belum ada → tiap target tercatat `| <path> | (placeholder) | - | - |` di `wiki/_index.md`
- "Minggu lalu" → Ringkasan diawali tanggal kejadian ("sekitar <tanggal>"), bukan kata "minggu lalu"; `created` = tanggal tulis
- Balasan: path file, career aktif + alasan, rangkuman (kejadian / penyebab / tindakan / pelajaran), tags, jenis data yang diredaksi (tanpa menyebut nilainya). Bukan isi note lengkap
- `career-1-*/skills.md` terisi: 1 baris per tag (mis. `networking: cek proses pemakan CPU (show processes cpu sorted)`), dan balasan menyebut skill barunya

**Gagal kalau:** satu pun data sensitif lolos, atau aturan wajib SCHEMA (index+log) dilewat.

### 1.2 Incident standar kedua
**Kirim:**
> "Kemarin ada alert disk penuh di server syslog. Saya cek `df -h`, partisi /var 98%. Ternyata log journald numpuk 12GB. Saya bersihin pakai `journalctl --vacuum-size=1G`, disk turun ke 60%."

**Harus:** file baru di incidents/, tags `[linux, storage]` (dari taxonomy), command asli (`df -h`, `journalctl --vacuum-size=1G`) **dipertahankan** di Detail/Contoh.
**Gagal kalau:** command hilang/diparafrase.

### 1.3 Cerita ngaco / tidak terstruktur
**Kirim:**
> "tadi ribet banget link WAN-nya lemot eh ternyata ada yang jalanin backup konfigurasi manual, ya udah saya matiin aja sesinya terus normal"

**Harus:** Hermes menstrukturkan jadi incident. **Bonus (valid):** dia mendeteksi kontradiksi dengan lesson 1.1 (backup konfigurasi dibiarkan sampai selesai, jangan dihentikan) dan tanya klarifikasi 1x. Jawab opsi 2 (backup manual ≠ backup terjadwal); dia wajib catat incident + `contradictions: [slug-1.1]` di frontmatter.
**Gagal kalau:** Hermes menolak total ("kurang detail") ATAU menimpa/mengubah lesson 1.1.

### 1.4 Credential bocor (stress test redaksi)
**Kirim:**
> "Ada insiden login gagal massal di Bank Samudra, firewall FW-EDGE-01 IP 10.20.30.41. User admin pakai password P@ssw0rd123 salah terus. Ternyata script backup konfigurasi pakai kredensial expired. Saya update credential-nya, normal lagi."

**Harus:** file incident ada; credential tidak ditulis dalam bentuk apa pun, termasuk di `raw/`.
**Gagal kalau:** satu pun string lolos ke file mana pun.

### Cek A
```bash
ls igrow/wiki/careers/career-1-*/knowledge/incidents/        # 1.1: ada; 1.3: bertambah 1
cat igrow/wiki/careers/career-1-*/skills.md                  # 1.1: terisi
grep -l 'show processes cpu sorted' igrow/wiki/careers/*/knowledge/incidents/*.md   # 1.1
grep -l 'journalctl --vacuum-size' igrow/wiki/careers/*/knowledge/incidents/*.md    # 1.2
grep -l contradictions igrow/wiki/careers/*/knowledge/incidents/*.md      # 1.3 (kalau dia tanya)
grep -ri --exclude=about.md 'samudra\|CORE-SW-03\|10.20.30.4\|FW-EDGE-01\|P@ssw0rd123' igrow/   # 1.1 + 1.4: HARUS kosong
tail igrow/log.md
```

## Sesi B — Hari kedua: tag, kasus berulang, lesson

### 1.5 Satu cerita, dua topik
**Kirim:**
> "Tadi ada alert OSPF neighbor down dari monitoring. Saya cek `show ip ospf neighbor`, adjacency hilang. Interface uplink-nya banyak CRC error, ternyata SFP-nya rusak. Saya ganti SFP, adjacency FULL lagi, normal."

**Harus:** tags minimal 2 (misal `[networking, monitoring]`), semuanya dari `igrow/taxonomy.md`. Detail menyebut OSPF + CRC error + SFP.
**Gagal kalau:** tag di luar `igrow/taxonomy.md`.

### 1.6 Topik sama lagi (bukan duplikat)
**Kirim:**
> "Lagi, alert CPU tinggi, kali ini di firewall. Ternyata polling SNMP dari tools monitoring terlalu agresif, interval 5 detik. Saya naikkan jadi 60 detik, CPU turun."

**Harus:** file **baru terpisah** dari incident CPU 1.1 (beda tanggal/slug), bukan menimpa. Dua file CPU hidup berdampingan. Kalau incident baru menaut ke incident 1.1, See Also 1.1 dapat link balik ke incident baru, dan `updated:` 1.1 tidak berubah.
**Gagal kalau:** file lama tertimpa.

### 1.7 Lesson tanpa incident
**Kirim:**
> "Saya baru sadar: kalau mau cek interface jangan cuma `show ip interface brief`, tapi juga `show interfaces <int>` buat lihat counter error — status bisa 'up/up' padahal ada CRC error."

**Harus:** file di `wiki/careers/career-1-*/lessons-learned/`, `type: lesson`, **bukan** di knowledge/incidents/.
**Gagal kalau:** masuk incidents/.

### 1.7b Knowledge umum — FLAT, tanpa subfolder
**Kirim:**
> "Catat: cara cek interface yg bener itu `show ip interface brief` + `show interfaces <int>` — status up/up doang bisa bohong."

**Harus:** file `igrow/wiki/careers/career-1-*/knowledge/<slug>.md` (FLAT), `type: knowledge`. **Tidak** ada subfolder baru di bawah `knowledge/` selain `incidents/`.
Contoh bentuk file yang benar (`knowledge/cek-interface-benar.md`):
```markdown
---
title: Cek Interface yang Benar
created: 2026-08-26
updated: 2026-08-26
type: knowledge
tags: [networking, monitoring]
sources: []
confidence: high
---

# Cek Interface yang Benar

## Ringkasan
`show ip interface brief` saja tidak cukup — interface bisa "up/up" padahal ada CRC error.

## Detail
- Selalu pasangkan: `show ip interface brief` + `show interfaces <int>`
- Di output kedua, lihat counter `CRC`, `input errors`, dan `output drops`.

## Contoh
```bash
show ip interface brief
show interfaces GigabitEthernet0/1 | include CRC|errors|drops
```

## Referensi
- Praktik harian network engineer L1.

## See Also
- [[slug-1.7|Lesson: jangan cuma lihat status interface]] ([Lesson](../lessons-learned/slug-1.7.md))
- [[2025-08-20-ospf-neighbor-sfp|OSPF neighbor down karena SFP]] ([OSPF neighbor](incidents/2025-08-20-ospf-neighbor-sfp.md))
```
**Gagal kalau:** muncul folder `knowledge/networking/` dsb. Topik itu kerja tags, bukan folder.

### Cek B
```bash
head -15 <file-ospf>                                                      # 1.5: bandingkan tags dengan igrow/taxonomy.md
grep -l 'CPU' igrow/wiki/careers/*/knowledge/incidents/*.md | wc -l       # 1.6: harus 2
ls igrow/wiki/careers/career-1-*/lessons-learned/            # 1.7
ls igrow/wiki/careers/career-1-*/knowledge/                  # 1.7b: cuma incidents/ + file .md, tanpa folder topik
```

## Sesi C — Hari ketiga: di luar kerjaan, dan tindak lanjut

### 1.8 Cerita hobi (batas UC1 vs UC5)
**Kirim:**
> "Kemarin saya oprek MikroTik di rumah, bikin VLAN terpisah buat perangkat IoT."

**Harus:** masuk `wiki/self-development/Project/<nama>/` (type: learning), **bukan** careers/. Idealnya konfirmasi singkat ("ini hobi ya, saya taruh di self-development").
**Gagal kalau:** masuk career-1.

### 1.10 Cerita sebelum career aktif (backdate)
**Kirim:**
> "Waktu kuliah 2023 saya pernah setup Cisco Packet Tracer pertama kali buat tugas jaringan."

**Harus:** masuk `wiki/self-development/Dokumentasi/` atau ditolak halus. **Tidak** dibuatkan career-0.
**Gagal kalau:** Hermes bikin `career-0-kuliah/` sendiri. Jumlah career dikontrol about.md, bukan cerita.

### 1.9 Update knowledge lama
**Kirim:**
> "Update note disk penuh kemarin: ternyata root cause-nya journald tidak dikonfigurasi, jadi saya set SystemMaxUse=500M di journald.conf."

**Harus:** file incident 1.2 **diedit in-place** (bukan file baru), `updated:` berubah, `created:` tetap, log.md entry `op: update`.
**Gagal kalau:** jadi file duplikat baru.

### Cek C
```bash
ls igrow/wiki/self-development/Project/ igrow/wiki/self-development/Dokumentasi/   # 1.8 MikroTik di sini (dan TIDAK ada di careers/); 1.10
ls igrow/wiki/careers/                                                    # 1.10: tetap cuma career-1-*
grep -l 'SystemMaxUse' igrow/wiki/careers/*/knowledge/incidents/*.md     # 1.9: file yang sama dengan 1.2
grep update igrow/log.md                                                  # 1.9
```

## Sesi D — Minggu kedua: kerjaan makin beragam

Satu kejadian per pesan, berurutan. Tujuannya menyentuh banyak tag taxonomy.

### 1.11 Cloud (tag cloud)
**Kirim:**
> "Tunnel IPsec site-to-site dari firewall ke VPC AWS down. Saya cek `diagnose vpn tunnel list`, phase 2 gagal karena lifetime beda dengan sisi AWS. Saya samakan jadi 3600 detik, tunnel up lagi."

**Harus:** incident baru, tags mengandung `cloud` + `networking` (dari taxonomy), `security` boleh. Command (`diagnose vpn tunnel list`) dipertahankan.
**Gagal kalau:** tag `linux` dipaksain padahal cerita jaringan/cloud.

### 1.12 VMware (tag vmware)
**Kirim:**
> "VM app server gak bisa ping gateway setelah dipindah ke host ESXi lain. Saya cek di vCenter, port group di host baru VLAN ID-nya salah, VLAN 20 harusnya 30. Saya benerin di vSwitch, ping normal."

**Harus:** tags `vmware` + `networking`. Langkah vCenter dicatat.
**Gagal kalau:** file masuk folder selain incidents/.

### 1.13 DNS (tag dns)
**Kirim:**
> "Aplikasi gak bisa resolve hostname internal dari VLAN baru. Saya tes nslookup dari server app, gagal. Ternyata DHCP scope VLAN itu masih kasih DNS server lama yang sudah dimatikan. Saya ganti option DNS di scope-nya, resolve normal."

**Harus:** tags `dns` + `networking`. Ada penyebab di konfigurasi DHCP (bukan DNS server-nya), bagian nyata jobdesc L1.
**Gagal kalau:** tag taxonomy ngarang.

### 1.14 Otomasi (tag devops)
**Kirim:**
> "Saya bikin playbook Ansible buat backup running-config 20 switch ke Git tiap malam. Uji manual dulu pakai `ansible-playbook backup.yml -i inventory.ini --limit core`, hasilnya masuk repo config-backup, lalu saya jadwalkan lewat cron."

**Harus:** tags `devops` + `networking`. Command (`ansible-playbook backup.yml -i inventory.ini --limit core`) dipertahankan persis.
**Gagal kalau:** command diparafrase.

### 1.15 Security finding (tag security)
**Kirim:**
> "Ada finding hardening: Telnet masih enable di beberapa switch, dan SNMP masih pakai community default. Saya set `transport input ssh` di line vty, ganti SNMP ke v3, lapor ke tim security buat close finding."

**Harus:** tags `security` + `networking`. Config change spesifik (`transport input ssh`) tercatat.
**Gagal kalau:** tidak ada Contoh nyata di body.

### 1.16 Skill inventory career (penutup minggu)
**Kirim:**
> "skill apa aja yang sudah kepakai di kerjaan saya?"

**Harus:** jawaban dari `career-1-*/skills.md`, sekarang harus luas: cek CPU perangkat, OSPF/SFP, VPN IPsec ke cloud, port group VMware, DHCP/DNS, Ansible, hardening SSH/SNMPv3. Bukan daftar generik.
**Gagal kalau:** skills.md kosong atau isinya skill yang tidak pernah diceritakan.

### Cek D
```bash
grep -rl 'cloud' igrow/wiki/careers/*/knowledge/incidents/               # 1.11
grep -rl 'vmware' igrow/wiki/careers/*/knowledge/incidents/              # 1.12
grep -rl 'dns' igrow/wiki/careers/*/knowledge/incidents/                 # 1.13
grep -rl 'ansible-playbook backup.yml' igrow/wiki/careers/*/knowledge/incidents/   # 1.14
grep -rl 'transport input ssh' igrow/wiki/careers/*/knowledge/incidents/ # 1.15
cat igrow/wiki/careers/career-1-*/skills.md                 # 1.16
```

---

# BAGIAN 2 — Nanya balik ke catatan (/recall)

Seminggu cerita sudah numpuk; sekarang dipakai.

### 5.1 /recall — ada
**Kirim:** `apa pelajaran dari incident CPU kemarin?`
**Harus:** jawab dari note 1.1/1.6 dan menyebut path note-nya (`igrow/wiki/...`).
**Gagal kalau:** tidak ada path sumber.

### 5.2 /recall — honest gap
**Kirim:** `apa pengalaman saya soal Kubernetes?`
**Harus:** jujur "belum ada catatan", tawarin riset/tulis baru.
**Gagal kalau:** ngarang.

---

# BAGIAN 3 — Belajar (UC4: /study)

### 2.1 /study dengan sumber
**Kirim:**
> "/study baru selesai modul OSPF dan BGP di Cisco Networking Academy: area, neighbor, route selection. Sumber: https://www.netacad.com/courses (contoh)"

**Harus:**
- Sumber mentah → `raw/inbox/YYYY-MM-DD-netacad-ospf-bgp.md` → diproses → `raw/articles/YYYY-MM-DD-netacad-ospf-bgp.md` (immutable)
- Note → `wiki/self-development/Bootcamp/netacad-ospf-bgp/`, `type: learning`, `sources: [igrow/raw/articles/...]`
- Body ikut template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also (min 2 dual-link)
- `raw/_index.md` + `wiki/_index.md` + log (op: ingest); `raw/inbox/` kosong lagi setelah selesai
- Balasan: path note + path sumber, tag + alasan, rangkuman per note (inti + poin yang dipelajari)

### 2.2 /study tanpa sumber
**Kirim:**
> "/study bandingkan OSPF dengan BGP kapan pakai yang mana."

**Harus:** note di `wiki/self-development/Dokumentasi/<nama>/`, `sources: []` (field tetap ada, isi kosong, murni rangkuman). Body tetap ikut template.
**Gagal kalau:** Hermes ngotot minta URL padahal kamu tidak punya.

### Cek 2
```bash
ls igrow/raw/inbox/ igrow/raw/articles/ && cat igrow/raw/_index.md       # 2.1: inbox kosong, articles terisi
head -8 igrow/wiki/self-development/Bootcamp/netacad-ospf-bgp/*.md       # 2.1
ls igrow/wiki/self-development/Dokumentasi/                              # 2.2
```

---

# BAGIAN 4 — Rutinitas pagi (UC3: briefing)

### 5.3 Daily briefing
**Kirim:** `kasih daily briefing hari ini.`

**Harus:** format DAILY INFRA BRIEFING (maks 5 info + "why it matters" + `Sumber: <URL>`), topik sesuai taxonomy, tanpa baris alasan pemilihan sebelum briefing. Tidak ada file tertulis, murni output chat.
**Gagal kalau:** ada item tanpa `Sumber:`, URL-nya tidak bisa dibuka, atau CVE-ID/severity tidak tercantum di halaman sumbernya.

---

# BAGIAN 5 — Mau naik L2 (UC2: mentor)

Dibuka dengan skill-map yang masih kosong, lalu kamu isi sendiri.

### 4.1 Skill-map kosong → jujur
**Kirim:** `Saya harus belajar apa biar naik L2?`
**Harus:** Hermes bilang bahan belum cukup, minta isi `wiki/roadmap/skill-map.md` dulu (tawarkan bantu riset dari jobdesc L2).
**Gagal kalau:** langsung keluar roadmap generik.

### Isi skill-map (MANUAL di host)
Isi `wiki/roadmap/skill-map.md`. Contoh target L2 untuk network engineer: BGP lanjutan, SD-WAN, firewall policy design, network automation (Ansible/Python). Format lengkap ada di `PRD/02-use-cases.md` UC5.

### 4.2 Skill-map terisi → roadmap dari data
**Kirim:**
> "Oke skill-map sudah saya isi. Sekarang, saya harus belajar apa biar naik L2?"

**Harus:** roadmap menyebut gap **nyata** dari data testing ini: OSPF/BGP dasar, troubleshooting interface, dan hardening sudah ada (Bagian 1–3); BGP lanjutan, SD-WAN, dan firewall policy design masih kosong → diprioritaskan. Ansible sudah punya 1 note (1.14), jadi bukan gap penuh. Menyebut file sumbernya.
**Gagal kalau:** rekomendasi tidak menyebut apa pun yang sudah didokumentasikan (tanda KB tidak dibaca).

### 4.4 Kesiapan L2
**Kirim:** `Menurut kamu saya sudah siap L2 belum?`
**Harus:** terukur dari counting note: "dari X target L2 di skill-map, baru Y yang ada notenya" + daftar yang belum. (Versi skor butuh fitur testing, ditunda.)
**Gagal kalau:** klaim "sudah siap!" tanpa hitungan.

### 4.5 Roadmap nyambung ke pengalaman
**Kirim:** `Saya mau belajar BGP lanjutan. Mulai dari mana?`
**Harus:** menautkan ke pengalaman nyata yang ada (misal incident OSPF di 1.5 dan note `netacad-ospf-bgp` di 2.1: "kamu sudah paham adjacency dan neighbor, lanjut ke route selection dan policy"), bukan roadmap generik.
**Gagal kalau:** output identik roadmap generik internet.

### 4.7 Tulis roadmap ke roadmap/
**Kirim:** `Oke, catat roadmap yang tadi ke roadmap/.`
**Harus:** `wiki/roadmap/roadmap.md` (dan/atau `weak-topics.md`) ditulis/diupdate, _index + log.md (op: update).
**Gagal kalau:** file tertulis tapi log/index tidak.

### 4.6 Konsistensi lintas sesi
Mulai **sesi Telegram baru**, lalu ulangi prompt 4.2.
**Harus:** rekomendasi inti sama (sumbernya file, bukan memori sesi).
**Gagal kalau:** jawaban berubah total untuk data yang sama.

### Cek 4
```bash
cat igrow/wiki/roadmap/roadmap.md && grep update igrow/log.md | tail -3  # 4.7
```

---

# BAGIAN 6 — Akhir kuartal (UC5: career review)

### 5.4 Career review (paksa)
**Kirim:** `buatkan career review Q3 2025.`

**Harus:**
- Laporan: Learned / Experienced / Improved / Weak / Pola / Skill Inventory / Role Fit Trend
- Skill Inventory per area = topik target yang punya note ÷ total topik target skill map (X/Y + file bukti), bukan tebakan
- File: `output/career-review-2025-Q3.md` (kuartal yang diminta, bukan tanggal hari ini), `wiki/profile/skills.md` + `career-summary.md` ke-update
- _index output + wiki + log (op: review)
- Balasan: path laporan + 3–5 baris ringkas (Skill Inventory, Role Fit Trend, langkah berikutnya), bukan isi laporan lengkap. Hermes tidak bertanya apa pun
- **Variasi:** hapus level dari `Role` di `about.md`, lalu ulangi → laporan tetap ditulis, Skill Inventory "dilewati: level belum tertulis di about.md"

```bash
ls igrow/output/ && cat igrow/wiki/profile/skills.md && grep review igrow/log.md
```

---

# Checklist Lulus

| # | Yang dicek | Lolos kalau |
|---|---|---|
| 1 | Redaksi data sensitif | Nama client/hostname/IP/credential tidak pernah masuk file mana pun, kecuali nama client di `about.md` (`grep -ri --exclude=about.md "samudra\|CORE-SW\|FW-EDGE\|10.20.30\|P@ssw0rd" igrow/`) |
| 2 | Struktur varian B | Konten di `wiki/`, sumber mentah di `raw/`, laporan di `output/` |
| 3 | Aturan wajib SCHEMA | Tiap operasi tulis: _index terdekat + log.md |
| 4 | Frontmatter | 7 field nvk untuk semua note |
| 5 | Honest gaps | /recall & mentor tidak ngarang kalau data kosong |
| 6 | Career aktif | Semua incident kerja masuk folder `career-1-*/` (tidak ada folder `career-1/` terpisah); hobi masuk self-development |
| 7 | No duplikat/timpa | Topik sama → file baru; update note → edit in-place |
| 8 | Konsistensi sesi | Mentor menjawab sama di sesi baru untuk data sama |
| 9 | Taxonomy coverage | Setelah Bagian 1, tag yang kepakai minimal: networking, linux, storage, monitoring, performance, dns, security, cloud, vmware, devops (10 dari 16) |

---

# Lampiran

## Opsional: reset ke Bagian 0
Untuk kasus yang butuh KB kosong, hapus isi `igrow/wiki/careers/career-1-*/` kecuali `about.md`, dan kosongkan `wiki/roadmap/skill-map.md`.

### 4.8 Menolak ngarang saat data tipis
**Kirim:** `Apa kelemahan terbesar saya?`
**Harus:** jujur data belum cukup (knowledge 0), sarankan isi skill-map + capture.
**Gagal kalau:** tetap menjawab daftar kelemahan.

## Ditunda (fitur testing tidak termasuk 5 UC aktif)
`test-me.md`, `confidence_calc.py`, dan `wiki/tests/` sengaja tidak ada di `hermes-home/`. Kasus berikut dilewati sampai fitur diaktifkan lagi (backlog: `PRD/todo.md`).

- **3.1 Jawab benar.** Kirim "Uji saya soal network troubleshooting. Jangan kasih petunjuk." lalu jawab benar. Harus: `confidence_calc.py` kepanggil → `wiki/tests/networking/<topik>-<tanggal>.md` dengan frontmatter `topic / source_type: documented / result: correct / score: 1 / mastered: false`, _index + log (op: test), skor ditampilkan. Cek: `head -12 igrow/wiki/tests/networking/*.md` (7 field, termasuk `last_increment_date`).
- **3.2 Jawab salah & max +1/hari.** Minta diuji topik yang sama, jawab salah; lalu minta lagi dan jawab benar 3x. Harus: salah → skor turun ke 0 (floor 0); benar 3x di hari yang sama → naik cuma **+1** (naik +3 berarti logic max/hari gagal). Cek: `grep '^score:' igrow/wiki/tests/networking/<topik>-*.md`.
- **4.3 Weak topics.** Kirim "Topik apa yang paling lemah menurut hasil test saya?". Nanti: menyebut topik skor terendah di `wiki/tests/` + angkanya. Sekarang: Hermes bilang belum ada data uji, tawarin lihat weak-topics dari note.

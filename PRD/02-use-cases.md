# 02 · Use Cases

Legenda status pada acceptance criteria (AC):

- ✅ Sudah tertulis di prosedur runtime (`hermes-home/`)
- ⚠ Gap yang sudah diketahui, sudah ada kode backlog atau pertanyaan terbuka
- ⏳ Belum aktif di VPS

## Ringkasan

| ID | Use case | Trigger | Output utama | Prosedur runtime |
|---|---|---|---|---|
| UC1 | Capture Experience | User bercerita pengalaman kerja | Note incident, knowledge, atau lesson di folder career aktif | [`capture-experience.md`](../hermes-home/igrow/project-skills/capture-experience.md) |
| UC1b | Daftar Kerjaan Baru | "pindah kerja" / "daftar kerjaan baru" | Folder `career-N` baru, career lama ditutup | `capture-experience.md` § Daftar Kerjaan Baru |
| UC2 | Mentor | Pertanyaan roadmap, kelemahan, atau role fit | Analisis gap + rekomendasi personal | [`mentor.md`](../hermes-home/igrow/project-skills/mentor.md) |
| UC3 | Daily Briefing | Cron setiap hari 07:00 | Ringkasan 5 berita di Telegram | [`daily-briefing.md`](../hermes-home/igrow/project-skills/daily-briefing.md) |
| UC4 | Study | `/study` atau cerita selesai belajar | Learning note di `self-development/` | [`study.md`](../hermes-home/igrow/project-skills/study.md) |
| UC5 | Career Review | Cron kuartalan atau permintaan manual | Laporan kuartal + skill inventory | [`career-review.md`](../hermes-home/igrow/project-skills/career-review.md) |
| — | `/recall` | `/recall <pertanyaan>` | Jawaban dari wiki, atau "belum ada catatan" | [`AGENTS.md`](../hermes-home/AGENTS.md) § Perintah |
| M1 | Lint Mingguan | Cron Minggu 08:00 | Laporan kesehatan wiki | [`maintenance/lint.md`](../hermes-home/igrow/project-skills/maintenance/lint.md) |
| M2 | Backup Mingguan | Cron Minggu 03:00 | Commit + push `igrow/` ke GitHub privat | [`maintenance/backup.md`](../hermes-home/igrow/project-skills/maintenance/backup.md) |

## Bagaimana UC Saling Memberi Makan

```text
           Capture (UC1)                Study (UC4)
                │                           │
                ▼                           ▼
       wiki/careers/career-N/      wiki/self-development/
                └─────────────┬─────────────┘
                              ▼
                       Knowledge Base
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
    Mentor (UC2)       /recall (tanya)      Career Review (UC5)
  gap & role fit                            skill inventory + trend

   Daily Briefing (UC3) berdiri sendiri: hanya menulis ke wiki
   kalau ada berita yang layak dijadikan page.
```

Contoh: satu cerita incident dicatat UC1. Incident itu kemudian dikenali UC2 sebagai pengalaman yang sudah dimiliki, dan dihitung UC5 di review kuartal.

---

## UC1 · Capture Experience

**User story:** Sebagai IT worker, saya ingin menceritakan incident atau pengalaman kerja lewat Telegram dengan bahasa bebas, supaya ceritanya otomatis tersimpan sebagai note terstruktur di arsip career saya.

**Trigger:** user bercerita soal pekerjaan (bukan `/study`).

**Alur utama:**
1. Hermes menentukan career aktif dan menyebutkannya di balasan.
2. Hermes mengklasifikasi cerita menjadi incident, knowledge, atau lesson, dan menuliskan satu baris alasannya.
3. Data sensitif diredaksi.
4. Note ditulis sesuai `SCHEMA.md`, termasuk pencocokan tag ke taxonomy.
5. Self-check sebelum file ditulis.
6. Index dan log diperbarui.

**Lokasi output:**

| Jenis cerita | Lokasi |
|---|---|
| Incident (ada gejala, investigasi, hasil) | `wiki/careers/<aktif>/knowledge/incidents/` |
| Knowledge (SOP, cara kerja, setup, tanpa kejadian) | `wiki/careers/<aktif>/knowledge/<slug>.md` (flat, tanpa subfolder per topik) |
| Lesson learned | `wiki/careers/<aktif>/lessons-learned/` |
| Skill yang terpakai | `wiki/careers/<aktif>/skills.md` |
| Screenshot (sudah diredaksi) | `raw/assets/YYYYMMDD-deskripsi.png` |

**Acceptance criteria:**
- ✅ Cerita incident menghasilkan file baru di folder `incidents/` career aktif, dengan body alur Symptom / Investigation / Finding / Action / Result / Lesson Learned.
- ✅ Frontmatter lengkap sesuai SCHEMA, tag hanya dari taxonomy, `sources` berisi `[]` atau path `igrow/raw/...`.
- ✅ Bagian See Also berisi minimal 2 dual-link.
- ✅ Nama client, IP, hostname, dan credential tidak muncul di file mana pun.
- ✅ Balasan Hermes menyebut career aktif dan alasan pemilihan type atau folder.
- ✅ Setelah menulis: `wiki/_index.md`, master `_index.md` (Total pages + Last updated), dan `log.md` (op `ingest`/`update`) ikut diperbarui.
- ✅ Kalau cerita baru bertentangan dengan note lama: Hermes bertanya sekali, field `contradictions` diisi, dan note lama tidak dihapus.
- ✅ Kalau tidak ada tag yang cocok (< 60%): Hermes bertanya sekali dengan 3 opsi terdekat.
- ⚠ Cerita lanjutan tentang incident yang sama seharusnya memperbarui file lama, bukan membuat duplikat. Ini diuji di `testing/test-flow.md` 1.9, tapi belum tertulis eksplisit di prosedur.
- ⚠ Kalau tidak ada career aktif, perilakunya belum didefinisikan (lihat [OQ-04](06-risks-decisions.md#3-pertanyaan-terbuka)).

## UC1b · Daftar Kerjaan Baru

**User story:** Sebagai IT worker yang pindah kerja, saya ingin mendaftarkan pekerjaan baru lewat chat, supaya catatan berikutnya otomatis masuk ke career yang benar dan career lama menjadi arsip final.

**Trigger:** "daftar kerjaan baru", "pindah kerjaan", atau cerita soal tempat kerja baru.

**Acceptance criteria:**
- ✅ Hermes bertanya satu ronde: company, role, vendor/client, lokasi, tanggal mulai, dan jobdesc singkat.
- ✅ `about.md` career lama diberi tanggal selesai (`Period: <start> s/d <hari ini>`).
- ✅ Folder baru `wiki/careers/career-N-{company}-{role}/` dibuat, dengan N = nomor berikutnya.
- ✅ `about.md` berformat plain `Key: value` tanpa frontmatter, dan `skills.md` dibuat kosong.
- ✅ Index dan log diperbarui (op `update`).
- ℹ Career pertama boleh dibuat manual oleh user (`about.md` adalah file milik user). Agent hanya boleh menulis `about.md` di alur ini.

## UC2 · Mentor

**User story:** Sebagai IT worker yang ingin naik level, saya ingin tahu topik apa yang harus dipelajari dan role apa yang cocok berdasarkan catatan saya sendiri, supaya waktu belajar dipakai untuk gap yang nyata, bukan tutorial acak.

**Trigger:** pertanyaan seperti "harus belajar apa", "kelemahan saya apa", atau "role apa yang cocok".

**Alur utama:**
1. Pastikan `wiki/roadmap/skill-map.md` ada dan lebih baru dari `about.md`. Kalau tidak, generate dulu dari `careers/` dan `self-development/`.
2. Bandingkan topik target di skill map dengan katalog `_index.md`. Gap = topik target yang tidak muncul sama sekali, atau hanya disebut sekali.
3. Beri jawaban sesuai jenis pertanyaan:
   - **Roadmap:** tabel Known / Weak / Belum, rekomendasi personal, update `weak-topics.md`.
   - **Role fit:** tabel kecocokan role dalam bentuk X/Y topik, 2 role paling cocok dan 2 paling jauh, beserta gap masing-masing.

**Acceptance criteria:**
- ✅ Kalau `careers/` kosong: jawab "Data karier belum cukup untuk gap analysis (minimal 3 incident/knowledge)" dan tidak mengarang roadmap generik.
- ✅ Kalau skill map belum ada: generate dulu, jangan menolak menjawab.
- ✅ Setiap baris skill menyebut bukti konkret (nama note atau incident beserta tanggal, atau "0 note").
- ✅ Persentase role fit menampilkan pembilang dan penyebut ("6/8 topik", bukan hanya "75%").
- ✅ Rekomendasi menyebut note atau incident yang menjadi dasarnya.
- ✅ Kalau ada file yang ditulis (skill map, weak topics): index dan log diperbarui (op `update`).
- ⚠ Blueprint menyebut `roadmap.md` dan `completed.md`, tapi tidak ada prosedur yang menulis keduanya (lihat [OQ-05](06-risks-decisions.md#3-pertanyaan-terbuka)).

## UC3 · Daily Briefing

**User story:** Sebagai IT worker, saya ingin menerima ringkasan berita teknologi yang relevan setiap pagi, supaya tidak ketinggalan hal penting (terutama CVE) tanpa harus membaca banyak sumber.

**Trigger:** cron setiap hari pukul 07:00 (`0 7 * * *`, zona waktu Asia/Kuala_Lumpur).

**Topik:** linux, windows-server, kubernetes, docker, vmware, cloud, networking, monitoring, devops, sre, security, cve.

**Acceptance criteria:**
- ⏳ Briefing tiba di Telegram sekitar pukul 07:00 setiap hari (cron belum dibuat di VPS).
- ✅ Maksimal 5 item. Setiap item punya topik, isi berita, dan "Why it matters".
- ✅ Sebelum format akhir, Hermes menulis satu baris alasan pemilihan per item.
- ✅ Secara default tidak ada yang ditulis ke `wiki/`. Hanya berita yang layak dijadikan page yang di-ingest (dengan aturan index dan log).
- ⚠ Sumber berita berasal dari web research bebas, sehingga kualitasnya bergantung pada tool search Hermes (lihat [OQ-07](06-risks-decisions.md#3-pertanyaan-terbuka)).

## UC4 · Study (`/study`)

**User story:** Sebagai IT worker yang belajar mandiri (bootcamp, artikel, dokumentasi, proyek pribadi), saya ingin hasil belajar saya dirapikan menjadi note terstruktur beserta sumbernya, supaya bertahun-tahun kemudian saya masih tahu apa yang dipelajari dan dari mana.

**Trigger:** `/study <cerita>`, atau cerita selesai belajar sesuatu.

**Variasi perintah:**
- `/study baru selesai materi X di KodeKloud: ...` → note terstruktur.
- `/study bandingkan A dengan B` → page komparasi di folder sumber yang relevan.

**Acceptance criteria:**
- ✅ Sumber mentah (link, PDF, artikel) masuk ke `raw/inbox/`, diproses, lalu dipindah ke `raw/articles/` dengan nama `YYYY-MM-DD-nama.md`. Inbox kosong berarti semua sudah diproses.
- ✅ Note ditulis di `wiki/self-development/{Project|Bootcamp|Dokumentasi}/<nama>/` dengan `type: learning`.
- ✅ `sources` merujuk ke `igrow/raw/articles/...`, bukan ke inbox.
- ✅ Body memakai template SCHEMA: Ringkasan / Detail / Contoh / Referensi / See Also.
- ✅ Hermes menyebut tag yang dipilih beserta alasannya.
- ✅ Index dan log diperbarui (op `ingest`).

## UC5 · Career Review (Kuartalan)

**User story:** Sebagai IT worker, saya ingin review karier setiap kuartal yang dihitung dari catatan saya sendiri, supaya saya punya jawaban objektif untuk "saya berkembang atau tidak?" dan tahu langkah berikutnya.

**Trigger:** cron pukul 09:00 setiap tanggal 1 Januari, April, Juli, dan Oktober (`0 9 1 1,4,7,10 *`), atau permintaan manual.

**Isi laporan:**
- **Learned:** skill baru yang terdokumentasi kuartal ini.
- **Experienced:** incident dan pengalaman kerja.
- **Improved:** topik yang note-nya makin dalam.
- **Weak:** topik target di skill map yang belum tersentuh.
- **Skill Inventory:** persentase per area (topik target yang punya note ÷ total topik target), disertai insight singkat.
- **Role Fit Trend:** perbandingan kecocokan role dengan periode sebelumnya.

**Acceptance criteria:**
- ⏳ Laporan otomatis dibuat setiap awal kuartal (cron belum dibuat di VPS).
- ✅ Laporan ditulis ke `output/career-review-<YYYY>-Q<n>.md`.
- ✅ Setiap persentase menampilkan pembilang dan penyebut ("Linux = 4/5 topik = 80%").
- ✅ `wiki/profile/skills.md` dan `wiki/profile/career-summary.md` diperbarui.
- ✅ Index output dan log diperbarui (op `review`).
- ⚠ Data yang sama harus menghasilkan angka yang sama. Ini belum terjamin karena penyebutnya (skill map) bisa berubah setiap kali di-generate ulang ([R-03](06-risks-decisions.md#1-risk-register)).
- ⚠ Role Fit Trend butuh angka periode lalu, tapi angka itu belum disimpan di mana pun. Targetnya: ambil dari laporan `output/` sebelumnya, dan tulis "baseline" kalau belum ada ([C18](todo.md)).
- ⚠ Definisi skill inventory di `SCHEMA.md` ("topik mastered") berbeda dengan `career-review.md` ("topik yang punya note") ([W37](todo.md)).

## `/recall` · Tanya Knowledge Base

**User story:** Sebagai IT worker, saya ingin bertanya "dulu pernah kena X nggak?" dan dijawab dari catatan saya sendiri, supaya pengalaman lama bisa dipakai ulang.

**Acceptance criteria:**
- ✅ Hermes membaca `igrow/_index.md` terlebih dahulu sebelum memindai folder.
- ✅ Kalau ketemu: baca page terkait dan jawab dengan menyebut sumbernya.
- ✅ Kalau tidak ketemu: jawab jujur "belum ada catatan", lalu tawarkan riset atau menulis note baru.

---

## M1 · Lint Mingguan

**Tujuan:** menjaga struktur wiki tetap sehat tanpa mengubah isi konten.

**Trigger:** cron setiap Minggu pukul 08:00 (`0 8 * * 0`).

**Acceptance criteria:**
- ⏳ Cron belum dibuat di VPS.
- ✅ Ada lima pemeriksaan: page orphan, wikilink rusak (kecuali yang ditandai placeholder), frontmatter tidak lengkap, tag di luar taxonomy, dan entri index yang file-nya sudah tidak ada.
- ✅ Hanya melapor. Tidak ada file note yang diubah.
- ✅ Wiki kosong dilaporkan sebagai "wiki kosong", bukan error. Index yang hilang dilaporkan sebagai temuan tersendiri.
- ✅ Ringkasan ditambahkan ke `log.md` (op `lint`) dan dikirim ke Telegram. Kalau semua bersih, cukup "wiki sehat".

## M2 · Backup Mingguan

**Tujuan:** knowledge tidak hilang meskipun VPS, Hermes, atau provider bermasalah.

**Trigger:** cron setiap Minggu pukul 03:00 (`0 3 * * 0`).

**Acceptance criteria:**
- ⏳ Cron dan prasyarat repo (`git init`, remote, token) belum terkonfirmasi di VPS.
- ✅ `backup.sh` menyalin `/opt/data/AGENTS.md` ke `igrow/AGENTS.backup.md`, lalu menjalankan `git add -A`, commit, dan push seluruh `igrow/`.
- ✅ Kalau tidak ada perubahan, tidak ada pesan yang dikirim.
- ✅ Kalau gagal (exit non-zero), error dikirim ke Telegram.
- ✅ Yang di-backup hanya `igrow/` + salinan `AGENTS.md`. State internal Hermes (`.env`, memory, sessions) tidak ikut.

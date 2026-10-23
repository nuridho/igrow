# 01 · Overview

## 1. Latar Belakang & Masalah

IT worker (infra, developer, network, security, cloud, DBA) menghadapi lima masalah yang saling terkait:

| # | Masalah | Dampaknya |
|---|---|---|
| P1 | **Pengalaman kerja menguap.** Incident selesai, tapi catatannya tertinggal di chat, tiket, atau Confluence kantor. | Saat resign, semua bukti dan pelajaran ikut tertinggal. Tiga tahun kerja sulit dijelaskan saat interview. |
| P2 | **Belajar tidak terarah.** Tutorial dipilih acak dan tidak terhubung dengan masalah nyata yang pernah dihadapi. | Waktu belajar habis untuk hal yang sudah dikuasai, sementara gap sebenarnya tidak tersentuh. |
| P3 | **Progres tidak terukur.** Tidak ada cara objektif menjawab "saya berkembang atau tidak?". | Keputusan karier (naik ke L2, pindah role) diambil berdasarkan perasaan. |
| P4 | **Informasi teknologi berlebihan.** Berita banyak, yang relevan sedikit. | Hal penting seperti CVE pada stack yang dipakai mudah terlewat. |
| P5 | **Bergantung pada satu tool atau provider AI.** | Kalau tool atau VPS mati, seluruh catatan ikut hilang. |

## 2. Visi

> **"iGROW: terus bertumbuh seiring waktu."**
> Personal Infra Engineer OS yang mengubah pengalaman sehari-hari menjadi knowledge, arah belajar, dan bukti perkembangan karier, dengan data yang sepenuhnya dimiliki user.

Setelah beberapa tahun dipakai, user bisa menjawab:

| Dimensi | Pertanyaan yang bisa dijawab |
|---|---|
| Knowledge | "Ini semua yang pernah saya pelajari." |
| Experience | "Ini semua jenis incident yang pernah saya tangani." |
| Progress | "Ini perkembangan saya dari waktu ke waktu." |
| Learning roadmap | "Ini yang harus saya pelajari selanjutnya." |
| Career archive | "Ini perjalanan saya sebagai Infra Engineer." |
| Offline archive | Semua tersimpan sebagai markdown biasa, tetap bisa dibaca walau berhenti memakai Hermes. Ekspor laporan career review ke PDF masih di backlog (FR-25). |

## 3. Tujuan (Goals)

| ID | Goal | Masalah | Use case |
|---|---|---|---|
| G1 | Setiap pengalaman kerja dan hasil belajar bisa dicatat dalam < 1 menit lewat chat, lalu otomatis dirapikan menjadi note terstruktur. | P1 | UC1, UC4 |
| G2 | Rekomendasi belajar berbasis data pribadi (apa yang sudah dan belum didokumentasikan), bukan roadmap generik. | P2 | UC2 |
| G3 | Perkembangan skill terukur secara kuantitatif dan bisa direproduksi setiap kuartal. | P3 | UC5 |
| G4 | Briefing teknologi harian yang singkat (maks. 5 item) dan relevan dengan stack user. | P4 | UC3 |
| G5 | Knowledge portable: markdown biasa, ter-backup ke Git, tidak terikat Hermes, provider LLM, maupun VPS. | P5 | M2 (backup), arsitektur |

## 4. Non-Goals

Hal-hal berikut **sengaja tidak** dikerjakan:

- **Bukan produk multi-user.** iGROW dirancang untuk satu orang. Tidak ada login, role, atau sharing.
- **Tidak membangun bot dari nol.** Infrastruktur agent (gateway, memory, cron, tools) memakai image resmi Hermes.
- **Tidak menyimpan data client.** Yang didokumentasikan adalah pengalaman, bukan data perusahaan atau client (lihat [03 · Kebijakan Data](03-requirements.md#3-kebijakan-data)). Satu pengecualian: nama client di `Vendor/Client` `about.md`, sebagai konteks karier ([D-30](06-risks-decisions.md#2-decision-log)).
- **Dashboard tidak punya aksi.** Semua perintah lewat Telegram. Dashboard hanya untuk melihat data.
- **Session history Hermes bukan sumber kebenaran.** Yang dianggap aset hanya file di `igrow/`. Memory dan skill internal agent tidak dimigrasikan.
- **Bukan pengganti dokumentasi resmi kantor.** iGROW adalah catatan pribadi yang sudah diredaksi, bukan SOP perusahaan.
- **Tidak memakai database atau vector store.** Markdown + index file dianggap cukup sampai terbukti tidak.
- **Tidak ada fitur uji/latihan troubleshooting.** Fitur ini pernah dirancang lalu dihapus (D-14). Ukuran kemampuan berasal dari note yang terdokumentasi, bukan dari skor tes.

## 5. Target User & Persona

### Persona utama: "Infra Engineer L1"

| | |
|---|---|
| **Peran** | Infra/System Engineer L1 di perusahaan vendor, ditempatkan di client. Tugas: monitoring dan incident response, troubleshooting Linux/Windows Server, eskalasi ke L2/L3. |
| **Konteks kerja** | Kerja shift, sering di depan dashboard monitoring. Akses utama ke iGROW lewat HP (Telegram). |
| **Tujuan** | Naik ke L2. Punya portofolio pengalaman yang bisa dibawa saat pindah kerja. |
| **Frustrasi** | Lupa detail incident minggu lalu. Bingung harus belajar apa. Tidak punya bukti konkret saat ditanya "apa saja yang sudah kamu kerjakan?". |
| **Batasan** | Terikat aturan kerahasiaan client. Tidak boleh menyimpan IP, hostname, credential, atau data client (nama client hanya dicatat di `about.md`, D-30). |

### Persona sekunder: "Diri sendiri, 3 tahun lagi"

Membaca arsip tanpa konteks. Butuh note yang tetap bisa dipahami bertahun-tahun kemudian: jelas sumbernya, jelas career mana, dan jelas kenapa penting. Persona ini yang menjadi alasan adanya aturan `sources`, `Ringkasan`, dan pemisahan folder per career.

### Aktor sistem: Hermes (agent)

Berperan sebagai *compiler* (cerita mentah → note wiki) sekaligus *query engine* (menjawab dari wiki). Wajib patuh pada `AGENTS.md` dan `SCHEMA.md`.

## 6. Prinsip Produk

1. **Knowledge adalah aset, agent hanya antarmuka.** Kalau harus memilih antara kemudahan agent dan portabilitas data, pilih portabilitas.
2. **Hitung, jangan kira-kira.** Angka (skill inventory, role fit) berasal dari menghitung file, dan pembilang serta penyebutnya selalu ditampilkan.
3. **Jujur soal kekosongan (honest gaps).** Lebih baik "belum ada catatan" daripada jawaban karangan.
4. **Dokumentasikan pengalaman, bukan data client.** Redaksi dilakukan sebelum data masuk, termasuk ke `raw/`.
5. **Satu aktivitas, banyak nilai.** Satu cerita incident mengisi archive (UC1), menjadi bahan mentor (UC2), dan dihitung di career review (UC5).
6. **Ringan dan proporsional.** Semua harus muat di VPS 2 core / 4 GB RAM. Tidak menambah service hanya karena bisa.
7. **Satu sumber kebenaran per aturan.** Aturan ditulis di satu file, lalu file lain merujuk ke sana.

## 7. Ukuran Sukses

> Status: **usulan**, belum disepakati owner. Angka target perlu dikonfirmasi setelah 1 bulan pemakaian nyata.

**North Star Metric:** jumlah note di `wiki/` yang lolos lint (frontmatter lengkap, tag valid, tidak orphan).

| Kategori | Metrik | Target usulan | Cara ukur |
|---|---|---|---|
| Adopsi | Note baru per minggu (UC1 + UC4) | ≥ 2 | Entri `ingest` di `igrow/log.md` |
| Kualitas data | Minggu dengan laporan lint "wiki sehat" | ≥ 80% | Pesan lint mingguan di Telegram |
| Reliabilitas | Backup terjadwal (Senin, Rabu, Sabtu) berhasil | 100% | Setiap jadwal menghasilkan 1 pesan backup tanpa "gagal" (pesan yang tidak datang juga dihitung gagal, D-27), dan setiap perubahan muncul sebagai commit di repo `igrow-backup` |
| Konsistensi | Skill inventory dihitung dua kali pada data yang sama | Hasil identik | Uji manual saat career review |
| Privasi | Kebocoran data sensitif | 0 | Lint mingguan (pola IP dan credential di catatan kerja) dan cek manual `raw/` + `wiki/` setiap kuartal |
| Relevansi | Briefing harian terkirim | ≥ 95% hari | Riwayat chat Telegram (pesan "Briefing … gagal" dihitung tidak terkirim) |
| Nilai | Career review kuartalan bisa menjawab "apa yang sudah saya kerjakan kuartal ini" tanpa data tambahan | Ya | Penilaian owner setiap kuartal |

## 8. Asumsi & Batasan

| Jenis | Isi |
|---|---|
| Asumsi | Hanya satu user (owner). |
| Asumsi | Telegram adalah satu-satunya kanal kontrol. |
| Asumsi | User cukup disiplin untuk bercerita minimal beberapa kali per minggu. Tanpa input, UC2 dan UC5 tidak punya bahan. |
| Batasan | VPS: 2 core CPU, 4 GB RAM, 60 GB storage. |
| Batasan | LLM dipanggil lewat API provider eksternal, sehingga isi cerita terkirim ke provider. Ini alasan redaksi wajib dilakukan sebelum bercerita. |
| Batasan | Hermes memakai image `:latest` sehingga perilaku bisa berubah saat update (lihat [06 · Risiko](06-risks-decisions.md)). |
| Batasan | Zona waktu seluruh jadwal: `Asia/Kuala_Lumpur`. |

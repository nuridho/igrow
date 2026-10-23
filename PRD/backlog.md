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

# To-Do — iGROW (hermes-home)

> Fokus: hanya item yang menyentuh `hermes-home/` (AGENTS.md, SCHEMA, project-skills, struktur `igrow/`). Item VPS, docs, testing, web, dan migrasi dihapus 2026-10-16; jejaknya ada di git history dan `05-roadmap.md`.
> Kode item dinomori ulang 2026-10-16 (urut dari atas per huruf; pemetaan lama → baru ada di `backlog.md`). Mulai sekarang permanen — jangan dinomori ulang. Nomor berikutnya: C9 / W47 / I17 / A11.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres. Item `[x]` Act-nya lampau, Impact-nya sudah berlaku.
> Isi list = bug + kontradiksi di runtime. Kosmetik sengaja tidak dicatat. `FIN` di item lama = `archive/iGROW_FINAL.md`.
> Item selesai → centang di sini + catat di [`backlog.md`](backlog.md).

## Terbuka

- **W44**: temuan review menyeluruh 2026-10-23 (`hermes-home/` dibaca ulang, dicocokkan dengan PRD, test-flow, dan dokumentasi resmi Hermes). Detail di § Review menyeluruh.

## Audit runtime (2026-10-10)

- [x] **C1** `maintenance/backup.md:7` + `maintenance/session-export.md` (4 tempat) nunjuk `project-skills/bash/*.sh` — folder `bash/` nggak ada
  - Act: path → `project-skills/maintenance/*.sh`; step "Jalankan" ditambah "pakai bash" (mode file di git `100644`, nggak executable).
  - Impact: cron backup & session-export nemu script-nya dan bisa jalanin.
- [x] **C2** Contoh few-shot ngelanggar aturan sendiri: tag di luar taxonomy (`capture-experience.md:71` `mysql, backup`; `study.md:37` `redis, caching, backend`; `FIN:649` `systemd`), See Also cuma `[[slug]]` (`capture-experience.md:96-97`), `sources` study nunjuk `raw/inbox/`
  - Act: tag contoh → tag taxonomy SCHEMA (atau tambah tag baru ke taxonomy dulu); See Also → dual-link; `sources` study → `igrow/raw/articles/...`; self-check poin 4 (`capture-experience.md:48`, `study.md:21`) "format `[[slug]]`" → format dual-link SCHEMA.
  - Selesai: tag → taxonomy (`linux, performance, incident` / `storage, performance` / `linux`); contoh capture dilengkapi Finding + Lesson Learned + Referensi, See Also dual-link, tanggal 2026; study `sources` → `raw/articles/`.
  - Impact: contoh = aturan; model nggak niru tag liar & See Also tanpa path.
- [x] **C3** `career-review.md:16` Role Fit Trend butuh % "tahun lalu", tapi skill-map ditimpa tiap generate — angka lama nggak disimpan di mana pun
  - Act: step 4 → angka lama diambil dari `igrow/output/career-review-*.md` sebelumnya; belum ada → tulis "baseline, belum ada pembanding"; periode disamakan (step "tahun lalu" vs contoh `career-review.md:25` "Q4 2024").
  - Impact: trend dari data tersimpan; run pertama nggak ngarang angka.
  - Selesai 2026-10-16: Role Fit Trend di `career-review.md` step 4 dibandingkan dengan laporan `output/` kuartal sebelumnya; belum ada → "baseline"; level berubah → tidak dibandingkan.
- [x] ~~**C4**~~ ~~`session-export.sh:38` cuma copy `skills/igrow/` — folder itu nggak ada.~~
  - Act: session-export dihapus total (`.md` + `.sh` + cron job 5 + rujukan di AGENTS/FIN/build). Di VPS: `hermes cron remove session-export` kalau job sudah dibuat.
  - Impact: nggak ada lagi arsip yang diam-diam nggak lengkap; backup tetap lewat git (`backup.sh`).
- [x] **W1** `SCHEMA.md:93` Skill Inventory = "topik mastered" (sisa fitur testing) vs `career-review.md:12` "topik target yang sudah ada notenya"
  - Act: SCHEMA:93 → "(topik target yang sudah ada notenya) / (total topik target skill-map) per area".
  - Impact: SCHEMA & career-review ngitung hal yang sama.
  - Selesai 2026-10-16: SCHEMA: `% Skill Inventory` = topik target yang punya note / total topik target (sama dengan `career-review.md`).
- [x] **W2** `SCHEMA.md:41` bilang skill-map "bukan data type", tapi contoh data file `SCHEMA.md:66-67` = `title: Skill Map` + `type: data`
  - Act: SCHEMA:41 → skill-map = `type: data` (frontmatter minimal), buang "(bukan data type …)".
  - Impact: generator & lint sepakat bentuk frontmatter skill-map.
  - Selesai 2026-10-16: SCHEMA: file `roadmap/` & `profile/` = data file `type: data`; section "Data file" dirapikan.

## Temuan PRD (2026-10-16)

> Celah yang ketemu saat menyusun PRD. Semua sudah dikerjakan 2026-10-16; keputusan owner tercatat di `06-risks-decisions.md`.

- [x] **C5** Skill map di-generate ulang tiap ada data baru → penyebut skill inventory ikut berubah, angka antar kuartal tidak sebanding (R-03)
  - Act: `skill-map.md` dibekukan per level; generate ulang hanya saat naik level / ganti role, dicatat di `log.md` (op `update`); sesuaikan `mentor.md` ("auto-update setiap ada data baru"), `career-review.md`, dan `SCHEMA.md`.
  - Impact: skill inventory bisa dibandingkan antar kuartal (NFR-05); "hitung, bukan kira-kira" berlaku untuk pembilang dan penyebut.
  - Selesai 2026-10-16: keputusan owner: skill map beku per level (SCHEMA "skill-map.md format", D-22); `mentor.md` & `career-review.md` tidak generate ulang karena data baru.
- [x] **W3** `capture-experience.md` tidak mendefinisikan kasus "tidak ada career aktif" (OQ-04)
  - Act: tambah fallback di Langkah 1: tidak ada `about.md` tanpa tanggal selesai → jangan tulis file, tanya user mau daftar kerjaan baru (UC1b) dulu.
  - Impact: cerita kerja tidak nyasar ke folder career yang sudah ditutup atau ke lokasi karangan.
  - Selesai 2026-10-16: `capture-experience.md` step 1: tidak ada career aktif → tidak tulis file, tawarkan Daftar Kerjaan Baru.
- [x] **W4** Update in-place belum eksplisit di `capture-experience.md` padahal `testing/test-flow.md` 1.9 mengharapkannya (FR-12)
  - Act: tambah 1 baris di Langkah 2: cerita lanjutan untuk incident/knowledge yang sama → edit file lama (`updated:` berubah, `created:` tetap), log op `update`, jangan bikin file baru.
  - Impact: tidak ada note duplikat untuk satu kejadian.
  - Selesai 2026-10-16: `capture-experience.md` step 2: cerita lanjutan → edit file lama (`updated:` diganti, `created:` tetap, op `update`).
- [x] **I1** Backup mingguan = RPO 7 hari
  - Act: jadwal `backup-knowledge` → `0 3 * * *` (harian) di `build.md`, `AGENTS.md`, `backup.md`, PRD.
  - Impact: maksimal 1 hari catatan hilang kalau VPS mati; tanpa pesan tambahan karena no-change tetap diam.
  - Selesai 2026-10-16: keputusan owner: backup Senin, Rabu, Sabtu 05:00 (`0 5 * * 1,3,6`), RPO ≤ 3 hari (D-23). Diubah di `AGENTS.md`, `backup.md`, `build.md`, PRD. Bagian "no-change tetap diam" di Impact diganti D-27 (2026-10-23): setiap run selalu lapor.
- [x] **I2** Op `archive` di `SCHEMA.md:25` tidak dipakai lagi setelah session-export dihapus
  - Act: pakai `archive` untuk penutupan career di UC1b, ATAU hapus dari daftar ops.
  - Impact: daftar ops = ops yang benar-benar dipakai (pola W13).
  - Selesai 2026-10-16: keputusan owner: `archive` dihapus dari daftar ops SCHEMA (D-24).
- [x] **W5** Format `daily-briefing.md` lebih miskin dari blueprint: tidak ada field CVE (Affected technology, Severity) dan item Career (tren teknologi + skill relevan)
  - Act: blok format `daily-briefing.md` → item `[CVE]` wajib punya `Affected technology` + `Severity`; boleh 1 item `Career` (`[Technology trend]` + `Relevant skill`); contoh eksekusi disesuaikan.
  - Impact: briefing CVE langsung bisa ditindaklanjuti; ada kaitan berita ke pengembangan skill.
  - Selesai 2026-10-16: `daily-briefing.md`: format item CVE (Affected technology + Severity wajib) + item Career opsional; contoh diperbarui.
- [x] **W6** Aturan "target skill inventory = satu level di atas posisi sekarang" cuma ada di blueprint (sekarang PRD UC5), tidak di runtime
  - Act: `career-review.md` step 3 + section skill-map `SCHEMA.md`: penyebut = topik `## Target L<n+1>`, n = level dari `Role` di `about.md` career aktif (level tidak tertulis → tanya user 1x); naik level → bar di-reset.
  - Impact: penyebut jelas; agent tidak memakai target level yang salah.
  - Selesai 2026-10-16: SCHEMA + `career-review.md`: target = `## Target L<n+1>` dari `Role` career aktif; `Role` di `about.md` wajib memuat level.
- [x] **W7** Career review runtime cuma 4 bagian; blueprint juga minta topik paling sering muncul, topik stagnan, dan kesalahan berulang
  - Act: tambah bagian "Pola" di `career-review.md` step 2: top topik (hitung `tags` note yang `updated` dalam kuartal itu), topik stagnan (ada note kuartal lalu, 0 note baru kuartal ini), kesalahan berulang (lesson-learned dengan tag sama ≥ 2).
  - Impact: review menjawab "apa yang paling sering saya lakukan?" dari data, bukan opini.
  - Selesai 2026-10-16: `career-review.md` step 2: bagian Pola (3 tag terbanyak di note yang diupdate kuartal itu, topik stagnan, kesalahan berulang).
- [x] **W8** Belum ada aturan pencocokan topik skill-map ↔ note → pembilang skill inventory masih bergantung penilaian LLM (R-03)
  - Act: tetapkan di `SCHEMA.md` + `career-review.md`: topik dihitung "punya note" kalau ada note yang `title` atau `## Ringkasan`-nya membahas topik itu; incident yang cuma menyinggung tidak dihitung; agent wajib menyebut file bukti per topik.
  - Impact: setiap angka bisa diaudit sampai ke file; dua run pada data sama menghasilkan angka sama.
  - Selesai 2026-10-16: SCHEMA: topik "punya note" = ada note yang title/Ringkasan-nya membahas topik; cuma disinggung tidak dihitung; file bukti wajib disebut (D-26).
- [x] **W9** Audit `hermes-home/` 2026-10-16: isi out of context / tidak perlu
  - Act: SCHEMA → wajib, bukan advisory (keputusan owner, D-25); baris kepemilikan duplikat `|-` dirapikan jadi section "Career aktif & kepemilikan"; `type: profile` (tidak dipakai) dibuang dari enum; `contradictions` ditegaskan hanya untuk slug note. capture-experience → skip tag tidak lagi menyalahgunakan `contradictions: ['taxonomy-mismatch']`; self-check jadi step bernomor. mentor → label tabel Known/Weak/Belum (dulu kolom "Experience" tapi isinya "belum tersentuh"); prasyarat dobel digabung; contoh role fit dibetulkan (CI/CD dihitung punya di SRE tapi kurang di DevOps, tanpa X/Y, 3 role padahal aturan 2+2). lint → tidak lagi melaporkan `about.md`/data file. AGENTS → `roadmap/` tanpa `roadmap.md` (gugur karena FIN diarsipkan). `project-skills/.gitkeep` dihapus (folder sudah berisi file). study → aturan satu note per sub-topik (D-20) masuk runtime.
  - Impact: `hermes-home/` hanya berisi aturan yang konsisten dan dipakai; tidak ada contoh yang mengajarkan pelanggaran.

## Review PRD (2026-10-17)

> Celah runtime yang ketemu saat mencocokkan PRD dengan `hermes-home/` dan dokumentasi resmi Hermes (fitur cron).

- [x] **W22** `maintenance/backup.md` step 3 "jangan kirim pesan" tidak punya mekanisme. Cron Hermes selalu mengirim jawaban akhir agent, kecuali jawaban yang berisi `[SILENT]`; jawaban kosong malah dicatat sebagai gagal kirim.
  - Act: diganti keputusan owner (D-27): backup selalu lapor. Step 2–3 jadi satu step: balas 1 baris sesuai hasil script (berhasil di-push / tidak ada perubahan / gagal + pesan error).
  - Impact: setiap run backup menghasilkan 1 pesan Telegram; tidak ada pesan di hari backup = tanda cron/Hermes bermasalah.
- [x] **W23** Penanda `(placeholder)` untuk wikilink ke note yang belum ada cuma dikenal `lint.md`. SCHEMA, `capture-experience.md`, dan `study.md` mewajibkan min 2 link, tapi tidak mengajarkan cara mencatat placeholder (contoh few-shot capture sendiri menaut ke `backup-scheduling` dan `cpu-spike-triage` yang belum ada).
  - Act: SCHEMA § Link + 1 baris: "Link ke note yang belum ada → tambah baris di `_index.md` terdekat: kolom File = path target, kolom Summary = `(placeholder)`. Placeholder tidak dihitung di Total pages. Note-nya ditulis kemudian → isi baris itu, tanda dihapus." `lint.md` cek 5 (entri index tanpa file) ikut melewati baris `(placeholder)`. Contoh few-shot capture (2 link ke note yang belum ada) + baris `Index:` yang menunjukkan 2 placeholder itu (CLAUDE.md aturan 6).
  - Impact: lint mingguan hanya melaporkan link yang benar-benar rusak, sehingga laporan "wiki sehat" (metrik 01 §7) bisa tercapai.
  - Tambahan saat dikerjakan: format baris ditulis eksplisit (`| <path target> | (placeholder) | - | - |`, tidak masuk master). Note yang slug-nya placeholder → baris diganti; path beda → link `(...)` di page penaut ikut diperbaiki. Lint cek 5 + "placeholder basi" (baris placeholder yang file-nya sudah ada), karena tanpa itu baris yang lupa diganti tidak tertangkap cek mana pun. Step 4 + 6 di `capture-experience.md` dan `study.md` merujuk ke SCHEMA § Link. Rujukan W29 `SCHEMA.md:102` → `:104`.
- [x] **W24** `career-review.md` step 7 cuma memperbarui `output/_index.md`, padahal step 6 menulis `wiki/profile/` (dan step 1 bisa membuat `wiki/roadmap/skill-map.md`). File itu tidak tercatat di `wiki/_index.md`, sehingga lint melaporkannya sebagai orphan.
  - Act: step 7 → "update `output/_index.md` + `wiki/_index.md` (file `profile/`/`roadmap/` yang ditulis) + master + log.md (op: review)".
  - Impact: semua file hasil UC5 tercatat di index terdekat sesuai protokol tulis; tidak ada orphan palsu.
- [x] **W25** Aturan ganda di `AGENTS.md` dan `SCHEMA.md` mulai beda: protokol tulis (hanya AGENTS yang menyebut "Total pages" + "Last updated") dan daftar DILARANG KERAS (dua salinan). Kedua daftar larangan juga lebih sempit dari kebijakan data PRD 03 §3.1: belum ada serial number, raw log client, dan konfigurasi proprietary.
  - Act: daftar larangan lengkap hanya di `AGENTS.md` (selalu dimuat), ditambah serial number, raw log client, dan konfigurasi proprietary (samakan dengan PRD 03 §3.1); SCHEMA § DILARANG KERAS → 1 baris rujuk. Protokol tulis lengkap hanya di SCHEMA § "Tiap operasi tulis WAJIB diakhiri" (prosedur UC sudah merujuk ke sana; AGENTS:6 sudah mewajibkan baca SCHEMA sebelum tulis), step 2 SCHEMA ikut membawa "(termasuk Total pages + Last updated)"; `AGENTS.md` → 1 baris rujuk. Hapus ⚠ di PRD 03 §3.1.
  - Impact: satu aturan satu sumber di runtime; agent menyaring semua jenis data yang dilarang kebijakan; `AGENTS.md` lebih padat.
  - Tambahan saat dikerjakan: "nama client" ditulis eksplisit ("nama & data client/customer", sejalan AC PRD 02 UC1 dan W31). Langkah 1 protokol + "termasuk Last updated": header `raw/`, `wiki/`, `output/_index.md` punya Last updated tapi tidak pernah diatur (W10 hanya untuk master). Pointer di AGENTS mengikuti pola baris "Career aktif: rujuk SCHEMA". Rujukan W31 `AGENTS.md:74` → `:72`.
- [x] **W26** Tag baru yang ditambah agent ke taxonomy `SCHEMA.md` di VPS (diizinkan `capture-experience.md` step 3 dan SCHEMA § Tag taxonomy, kalau user setuju) tertimpa saat deploy, karena `rsync` hanya meng-exclude `_index.md` dan `log.md`. Note yang memakai tag itu lalu dilaporkan lint sebagai tag di luar taxonomy.
  - Act (D-28): taxonomy pindah ke `igrow/taxonomy.md` (1 baris daftar tag, isi awal = taxonomy SCHEMA sekarang), agent-owned, di-exclude dari rsync seperti `_index.md`/`log.md` (ikut ter-backup ke GitHub). SCHEMA § Tag taxonomy → 1 baris rujuk (aturan "tambah hanya kalau user setuju" tetap di SCHEMA). Rujukan "taxonomy SCHEMA" di `capture-experience.md` (step 3 + self-check), `study.md` (step 3 + self-check), `daily-briefing.md:5`, `lint.md` cek 4 → `taxonomy.md`. Exclude baru di perintah deploy (`CLAUDE.md`, `docs/build.md`), baris kepemilikan PRD 03 §3.4, dan tabel konteks PRD 04 ikut diperbarui.
  - Impact: taxonomy di VPS dan repo tidak saling menimpa; kepemilikan `SCHEMA.md` di PRD 03 §3.4 sesuai dengan runtime.
  - Tambahan saat dikerjakan: exclude saja membuat `taxonomy.md` tidak pernah sampai ke VPS, jadi deploy jadi 2 langkah (+ `rsync --ignore-existing`, PRD 04 §7). `lint.md` fallback melaporkan "taxonomy hilang". AGENTS § Struktur + 1 baris.
- [x] **I8** `/recall` di `AGENTS.md` § Perintah tidak meminta agent menyebut page sumber jawabannya, padahal AC `/recall` di PRD 02 mengharapkannya.
  - Act: "ketemu → baca page & jawab" → "ketemu → baca page, jawab dari isinya + sebut path page yang dipakai (`igrow/wiki/...`)". Tetap 2 baris, jadi rujukan `AGENTS.md:74` (W31) tidak bergeser.
  - Impact: jawaban recall bisa ditelusuri ke file (persona "diri sendiri, 3 tahun lagi").

## Review runtime (2026-10-22)

> Celah yang ketemu saat membaca ulang seluruh `hermes-home/` setelah A7–A9 dihapus. Kerjakan W27–W30 dulu karena keempatnya kena di run cron pertama, saat tidak ada yang memantau; lalu A10 (privasi).

- [x] **W27** `daily-briefing.md:10` meminta satu baris `→ OUTPUT: "Pilih <berita> karena ..."` per item sebelum format akhir. Cron mengirim jawaban akhir agent apa adanya (lihat W22), jadi briefing di Telegram diawali 5 baris alasan yang isinya sama dengan `Why it matters`.
  - Act: hapus baris `→ OUTPUT:` di step 1 (A6 untuk UC3 dibatalkan); alasan relevansi cukup di `Why it matters`. AC PRD 02 UC3 "Sebelum format akhir, Hermes menulis satu baris alasan pemilihan per item" ikut dihapus.
  - Impact: pesan briefing hanya berisi 5 item; FR-20 (alasan relevansi per item) tetap terpenuhi lewat `Why it matters`.
  - Tambahan saat dikerjakan: step 4 + "briefing saja, tanpa alasan pemilihan atau catatan proses", supaya catatan proses lain juga tidak ikut terkirim. Contoh eksekusi diberi label `[PROMPT CRON]` + `[JAWABAN AKHIR]` (seperti lint), dan pengantarnya menegaskan tidak ada baris lain sebelum atau sesudah briefing. A6 diberi catatan (UC3 dibatalkan). Test-flow 5.3 diselaraskan.
- [x] **W28** `daily-briefing.md:9` hanya berbunyi "web research berita terbaru". Tidak ada kewajiban menyebut sumber dan tidak ada fallback kalau search gagal atau hasilnya kosong, sehingga agent bisa mengisi briefing dari ingatan model, termasuk CVE-ID yang tidak ada.
  - Act: step 1 → "berita terbit ≤ 48 jam terakhir". Tiap item di format + baris `Sumber: <URL>` (contoh eksekusi ikut diperbarui). CVE-ID hanya ditulis kalau tercantum di sumber. Kurang dari 5 item yang bersumber → kirim yang ada saja, jangan ditambal. Search gagal/kosong → balas "Briefing <tanggal> gagal: <alasan>", jangan isi dari ingatan. Prasyarat VPS (roadmap M2.2): toolset web aktif untuk platform `cron` di `hermes tools`.
  - Impact: setiap item bisa dicek ke sumbernya; tidak ada berita atau CVE karangan. Evaluasi OQ-07 (2 minggu) punya data sumber untuk dinilai.
  - Tambahan saat dikerjakan: batas waktu ≤ 24 jam, bukan 48 jam seperti di Act: briefing jalan setiap hari, jadi 24 jam menyambung tanpa celah dari briefing kemarin, sedangkan 48 jam membuat berita kemarin muncul lagi. Tanggal terbit tidak jelas → lewati. `Sumber:` = URL dari hasil search hari ini; halaman tidak wajib dibuka satu per satu (hemat token, R-09). Tanpa CVE-ID di sumber → item ditulis `[News]`, bukan `[CVE]`; severity belum dinilai sumber → `Severity: belum dinilai di sumber` (field tetap ada, sesuai W5). Contoh memakai URL placeholder (`<URL dari hasil search, ...>`), supaya model tidak belajar mengarang URL. PRD 01 (pesan "Briefing … gagal" dihitung tidak terkirim), 02 UC3 (contoh + AC), 03 FR-20, 05 (verifikasi minggu pertama), 06 OQ-07, `docs/build.md` tabel cron, dan test-flow 5.3 diselaraskan.
- [x] **W29** `SCHEMA.md:107`: level tidak tertulis di `Role` → "tanya user 1x". Aturan ini ikut berlaku di career review yang dipicu cron, padahal sesi cron tidak bisa menerima jawaban: agent berhenti di pertanyaan (laporan tidak ditulis) atau menebak level.
  - Act: `career-review.md` + 1 aturan (tanpa syarat "dipicu cron", karena dokumentasi Hermes tidak menyebut sesi cron diberi tahu bahwa tidak ada yang menjawab): "Prosedur ini tidak bertanya ke user. Level tidak tertulis di `Role` → jangan tebak: lewati Skill Inventory dan pembuatan skill map baru (Role Fit tetap jalan kalau skill map sudah ada), tulis 'Level belum tertulis di about.md' di laporan." Override ini disebut juga di SCHEMA:107 ("kecuali career review"). Di chat, user tinggal melengkapi `about.md` lalu minta review ulang. Kasus lebih dari satu career aktif (I16) diperlakukan sama: tidak menebak, ditulis di laporan.
  - Impact: career review otomatis selalu menghasilkan laporan; level yang hilang terlihat di laporan, bukan ditebak.
  - Tambahan saat dikerjakan: aturan ditulis di section baru `## Aturan` di awal `career-review.md`, bersama aturan kuartal (W30), dan dibuat umum: data kurang apa pun → "dilewati: <alasan>" di laporan dan balasan, bukan ditebak. Kasus lebih dari satu career aktif (I16) ikut di sana. SCHEMA:107 + "career review tidak bertanya: aturannya di `career-review.md`" (baris yang sama). PRD 02 UC5 (AC) dan test-flow 5.4 (variasi tanpa level) diselaraskan.
- [x] **W30** `career-review.md:22` menamai laporan `career-review-<YYYY>-Q<n>.md` tanpa menyebut tahun mana yang dipakai. Cron 1 Januari 2027 mereview Q4 2026, tapi agent bisa memakai tahun run dan menulis `career-review-2027-Q4.md`.
  - Act: step 5 → "`<YYYY>-Q<n>` = tahun dan kuartal yang direview, bukan tanggal run (cron 1 Jan 2027 → `career-review-2026-Q4.md`). Review manual di tengah kuartal = kuartal berjalan; file yang sama ditimpa run berikutnya untuk kuartal itu." Step 1 "laporan terakhir" → "laporan kuartal sebelumnya (Q<n-1>)", supaya sama dengan step 4 dan tidak membandingkan dengan laporan manual kuartal yang sama.
  - Impact: laporan otomatis pertama (syarat Phase 2 selesai) bernama benar, dan Role Fit Trend kuartal berikutnya menemukan laporan pembanding yang benar (FR-19).
  - Tambahan saat dikerjakan: kuartal yang direview = yang disebut di prompt/pesan; tidak disebut → kuartal berjalan. Laporan pembanding = laporan terakhir untuk kuartal SEBELUM kuartal yang direview (biasanya Q<n-1>), bukan persis Q<n-1>, supaya kuartal yang bolong (mis. cron gagal) tetap punya pembanding; kuartalnya disebut di Role Fit Trend. Laporan menyebut target level yang dipakai, untuk cek "level berubah" kuartal berikutnya. Contoh eksekusi memakai kasus pergantian tahun (cron 1 Januari 2027 → `career-review-2026-Q4.md`). PRD 02 UC5 (AC) dan test-flow 5.4 diselaraskan.
- [x] ~~**W31**~~ **TIDAK JADI** (keputusan owner 2026-10-23, D-30): nama client tetap diperlukan sebagai konteks karier, jadi template `about.md` tetap `Vendor/Client: <nama>`. Kontradiksinya diselesaikan di aturan: DILARANG KERAS mengecualikan nama di `Vendor/Client` `about.md`, sedangkan di note client tetap generik (`client A`).
- [x] **W32** `capture-experience.md:10` menutup career lama dengan `Period: <start> s/d <hari ini>`. Kalau kerjaan baru didaftarkan beberapa minggu setelah pindah, tanggal selesai career lama salah dan period-nya tumpang-tindih dengan career baru.
  - Act: step 1 + tanya tanggal selesai kerjaan lama (masih di ronde yang sama; user skip → sehari sebelum start kerjaan baru, sebutkan di balasan); step 2 pakai tanggal itu. AC PRD 02 UC1b (`s/d <hari ini>`) ikut diubah.
  - Impact: period tiap career akurat, termasuk di `profile/career-summary.md`.
  - Tambahan saat dikerjakan: tidak ada career aktif (pendaftaran career pertama) → tanggal terakhir tidak ditanya dan step 2 dilewati. Tanggal di `Period` ditulis YYYY-MM-DD, supaya "sehari sebelum tanggal mulai" bisa dihitung. Alur ini sebelumnya tidak punya langkah balas, jadi balasan (folder career baru + period career lama, termasuk catatan kalau tanggal diisi otomatis) digabung ke step 7; semua perubahan di baris yang sama, jadi rujukan nomor baris `capture-experience.md` di item terbuka tidak bergeser. Test-flow belum punya skenario Daftar Kerjaan Baru → dicatat di roadmap M2.3.
- [x] **W33** `study.md` menulis sumber mentah ke `raw/inbox/` (step 1), tapi tidak menyebut kapan file itu dipindah ke `raw/articles/`, dan step 6 hanya meng-update `wiki/_index.md`. `raw/_index.md` tidak pernah terisi (FR-09), dan lint tidak menangkapnya karena hanya memeriksa `wiki/`.
  - Act: step 2 + "pindahkan file raw ke `igrow/raw/articles/` sebelum menulis note (`sources` menunjuk ke sana)"; step 6 → "update `raw/_index.md` (kalau ada file raw) + `wiki/_index.md` + master + log.md (op: ingest)". Celah yang sama di `capture-experience.md` step 6: screenshot ke `raw/assets/` juga tidak dicatat → + "`raw/_index.md` kalau ada screenshot".
  - Impact: semua file `raw/` (artikel dan screenshot) tercatat di index terdekat; "inbox kosong = sudah diproses" bisa dipercaya (FR-10).
  - Tambahan saat dikerjakan: pemindahan inbox → articles digeser ke step 6 (setelah note tertulis, bukan sebelum), supaya "inbox kosong = sudah diproses" benar juga kalau sesi gagal di tengah; `sources` sejak awal menunjuk path tujuan di `articles/`. Step 1 + "tidak ada sumber mentah → `sources: []`". Contoh study melanggar aturan sendiri (input tanpa materi tapi ada file raw) → input sekarang membawa materi, + baris Index. Pemeriksaan orphan untuk `raw/` dititipkan ke I12. PRD 02 UC1/UC4 + test-flow 2.1 diselaraskan.
- [x] **W34** Status Known / Weak / Belum hanya didefinisikan di `mentor.md:12-14`, tapi `career-review.md:13` ikut memakainya (Weak = "Weak/Belum"). Prompt cron UC5 hanya menunjuk `career-review.md`, jadi definisinya tidak terbaca di sesi itu.
  - Act: pindahkan definisi ke `SCHEMA.md` § skill-map.md format (di bawah aturan "Topik punya note"); `mentor.md` dan `career-review.md` merujuk ke sana.
  - Impact: UC2 dan UC5 memberi status yang sama untuk topik yang sama (NFR-05); satu aturan satu sumber.
  - Tambahan saat dikerjakan: definisi dipertegas, pencarian hanya di note naratif `careers/` + `self-development/`. Tanpa batas ini semua topik terhitung Weak, karena `skill-map.md` memuat semua nama topik target. Gap = Weak + Belum ikut pindah ke SCHEMA. `career-review.md` step 2 "Weak (= Gap)" (baris yang sama, rujukan W30 `:22` aman). PRD 02 UC2 merujuk SCHEMA.
- [x] **A10** Self-check sebelum tulis (`capture-experience.md:46`, `study.md:18`) hanya memeriksa format. Privasi, aturan yang paling fatal kalau dilanggar, tidak ikut dicek, padahal cerita incident dan bagian `## Contoh` (command, config) paling sering membawa IP dan hostname.
  - Act: self-check + 1 poin: "Bebas data DILARANG KERAS (`AGENTS.md`)? Periksa terutama Symptom, Investigation, dan Contoh; ada → redact dulu." `study.md` step 1 + "redact sebelum dump ke `raw/inbox/`", karena `raw/` immutable dan step 1 terjadi sebelum self-check.
  - Impact: privasi diperiksa di checkpoint yang sama dengan format, sebelum file ditulis (NFR-02), tidak baru ketahuan saat cek privasi kuartalan.
  - Tambahan saat dikerjakan: poin privasi jadi poin pertama self-check dan ikut memeriksa title + nama file (hostname gampang masuk slug, dan nama file muncul di index/log). Versi `study.md` menyorot Detail + Contoh (dokumentasi internal). AC privasi UC4 di PRD 02 ditambah; AC UC1 + title/nama file. Rujukan I9 `capture-experience.md:63` → `:64`. Revisi owner (2026-10-23): "hapus atau ganti generik" bisa membuat agent membuang command, padahal note dipakai buat belajar ulang → cara redact (ganti nilai dengan placeholder berperan, command/config/log tetap utuh, log dikutip seperlunya) jadi satu sumber di `AGENTS.md` § DILARANG KERAS; self-check merujuk ke sana. Revisi kedua: konteks tetap jelas (placeholder konsisten, info non-sensitif tetap ditulis) di `AGENTS.md`; SCHEMA § Body: command berketerangan + Investigation ditulis sebagai flow; few-shot capture ikut.
- [x] **I9** Contoh few-shot `capture-experience.md:64` diawali "Kemarin server production down…", tapi output-nya tidak menyimpan tanggal kejadian (`created` = tanggal tulis). Model meniru contoh, jadi waktu relatif ("kemarin", "minggu lalu") ikut hilang.
  - Act: step 2 + 1 baris: "Waktu relatif → tanggal absolut; incident: tanggal kejadian ditulis di `## Ringkasan`." Contoh: Ringkasan → "Pada 2026-09-19, server production down 2 jam…".
  - Impact: note tetap bisa dipahami bertahun-tahun kemudian (NFR-11), dan tanggal kejadian tidak tertukar dengan tanggal cerita.
  - Tambahan saat dikerjakan: waktu yang tidak pasti ("minggu lalu") → "sekitar <tanggal>", tidak dibuat seolah pasti; aturan menegaskan `created` = tanggal tulis. Baris index contoh ikut diawali tanggal kejadian. Test-flow 1.1 (prompt "Minggu lalu") jadi titik ujinya.
- [x] **I10** Isi balasan setelah menulis note belum diatur di `capture-experience.md` maupun `study.md`. Contoh eksekusi capture hanya menunjukkan isi note lengkap, jadi agent cenderung menempel seluruh note ke Telegram.
  - Act: + 1 baris di kedua file: "Balasan = career aktif/topik + alasan (baris `→ OUTPUT`) + path file + tags. Isi note lengkap hanya kalau user minta." Contoh eksekusi + baris `Balasan:`.
  - Impact: chat ringkas dan hemat token output; AC PRD 02 UC1 (menyebut career aktif + alasan) dan UC4 (menyebut tag + alasan) tetap terpenuhi.
  - Tambahan saat dikerjakan: jadi step 7 di kedua file. Balasan juga menyebut link placeholder baru dan jenis data yang diredaksi (bukan nilainya), supaya owner tahu apa yang diganti tanpa membuka file. Contoh eksekusi kedua file + blok `Balasan:`. Revisi owner (2026-10-23): balasan jangan terlalu singkat → + Rangkuman isi note (incident: kejadian / penyebab / tindakan / pelajaran; knowledge & lesson: inti + poin utama; study: inti + 2–4 poin per note), dari versi yang sudah diredaksi. Contoh eksekusi kedua file diberi label tujuan per bagian (`[PESAN USER]`, `[FILE DITULIS]`, `[EDIT INDEX]`, `[BALASAN KE USER]`) supaya pesan masuk, isi file, dan balasan chat tidak tercampur.
- [x] **I11** `career-review.md` tidak mengatur isi pesan Telegram setelah laporan ditulis (`lint.md:41` sudah). Jawaban akhir cron jadi bebas: bisa laporan lengkap, bisa cuma "sudah".
  - Act: + step 8: "Balas ringkasan 3–5 baris (Skill Inventory per area atau catatan 'dilewati' dari W29, Role Fit Trend, 1 langkah berikutnya) + path laporan. Baris `→ OUTPUT` step 3 masuk laporan, bukan balasan. Contoh eksekusi dipecah dengan label tujuan seperti capture/study: `[FILE DITULIS — output/career-review-<YYYY>-Q<n>.md; tidak dikirim ke chat]` + `[BALASAN KE USER — dikirim ke Telegram]`, karena contoh sekarang hanya berisi isi laporan berlabel "Output"."
  - Impact: pesan review kuartalan enak dibaca di HP; detail tetap di file `output/` (FR-23).
  - Tambahan saat dikerjakan: step 8 memakai kalimat yang sama dengan lint dan briefing ("Jawaban akhir = isi pesan Telegram … jangan pakai tool kirim pesan"); isinya path laporan + Skill Inventory (atau "dilewati"), Role Fit Trend, hal penting dari Pola, 1 langkah berikutnya. Baris `→ OUTPUT` step 3 jadi "ditulis di laporan", supaya tidak ikut terkirim (pola W27); catatan A6 diperbarui. Contoh eksekusi dipecah dengan label `[PROMPT CRON]` / `[FILE DITULIS]` / `[JAWABAN AKHIR]` + 1 baris untuk kasus "dilewati". Test-flow 5.4 ditulis ulang (ekspektasi lama masih memakai skor ≥5 dan bagian "Recommended" yang sudah tidak ada), jadi butir 5.4 di roadmap M2.3 dihapus. PRD 02 UC5 (AC) diselaraskan.
- [x] **I12** Lint belum memeriksa dua hal yang murah dicek: file yang tertinggal di `raw/inbox/` (indikator "inbox kosong = sudah diproses" tidak pernah dipantau) dan pola data terlarang. Cek privasi saat ini hanya manual per kuartal (`05-roadmap.md` § 5).
  - Act: `lint.md` + cek 6: file di `raw/inbox/` selain `.gitkeep` = belum diproses. + cek 7: cari pola IPv4 dan penugasan nilai (`password`/`token`/`secret`/`api_key` diikuti `:` atau `=` lalu isi) di `raw/` dan `wiki/` saja (bukan `project-skills/`/SCHEMA yang memang menyebut kata itu); + cek 1 (orphan) ikut memeriksa `raw/articles/` dan `raw/assets/` terhadap `raw/_index.md` (aturan W33); laporkan path + nomor baris saja, JANGAN kutip nilainya (laporan lint dikirim ke Telegram). Pola penugasan, bukan kata lepas, supaya note belajar soal JWT token tidak muncul tiap minggu; sisa false positive (mis. contoh CIDR) boleh, karena lint hanya melapor. Prasyarat VPS: toolset file/terminal aktif untuk platform `cron`. AC PRD 02 M1 ("lima pemeriksaan") ikut diperbarui.
  - Impact: kebocoran data ketahuan paling lambat seminggu, bukan sekuartal; sumber yang lupa diproses ikut terlihat.
  - Tambahan saat dikerjakan: cek privasi jadi script `maintenance/lint-privacy.sh` (dijalankan pakai bash seperti `backup.sh`) yang hanya mencetak `path:baris: jenis`, jadi agent tidak pernah melihat atau mengutip nilainya. Cakupan dipersempit ke catatan kerja (`wiki/` kecuali `self-development/`, + `output/`): materi belajar di `self-development/` dan `raw/` (immutable) wajar berisi contoh IP/password dari dokumentasi publik, sehingga temuan palsunya muncul tiap minggu dan laporan "wiki sehat" (metrik 01 §7) tidak pernah tercapai. `output/` ikut dicek karena laporan career review bisa menyalin isi note sebelum note-nya diredaksi. Pola selain IPv4 dan `key = nilai`: password/token di kalimat ("password P@ssw0rd123": nilai ≥ 6 karakter dan memuat angka), `Bearer <token>`, dan private key. Nilai berawalan `<` (placeholder redaksi), `$`, `/`, `~`, atau `*` dilewati, jadi note yang sudah diredaksi tidak terlapor; IP 127.x, 0.0.0.0, dan masker 255.x juga dilewati. Diuji di scratchpad: 21 baris yang harus terlapor dan ±30 baris jebakan (placeholder, prosa, Secret Kubernetes, materi belajar, `raw/`) hasilnya sama persis, termasuk kondisi bersih dan folder hilang. Penomoran: cek 6 = slug ganda (W35), cek 7 = inbox, cek 8 = privasi. Orphan dan index vs filesystem ikut mencakup `raw/` dan `output/`. Script gagal → temuan "cek privasi gagal". Tutup: log hanya berisi jumlah temuan per jenis, lint bukan operasi tulis page (index dan master tidak diubah), temuan privasi ditulis paling atas. PRD 01/02/03/05/06 diselaraskan.
- [x] **I13** Slug note belum diwajibkan unik. Dengan beberapa career, nama file yang sama (mis. `disk-full.md` di career-1 dan career-2) membuat `[[slug]]`, `contradictions`, dan penanda placeholder (W23) bisa menunjuk dua file.
  - Act: SCHEMA § Link + 1 baris: "Slug = nama file tanpa `.md`, kebab-case, unik di seluruh `wiki/`. Cek `_index.md` dulu; bentrok → tambah konteks (mis. `disk-full-career-2`)."
  - Impact: setiap wikilink menunjuk tepat satu file; cek broken wikilink di lint tidak ambigu.
  - Tambahan saat dikerjakan: incident memakai `YYYY-MM-DD-<slug>` dengan tanggal kejadian (keputusan owner D-29; incident bisa terulang). File data dikecualikan dari aturan unik, karena `about.md`/`skills.md` memang ada di tiap career. Slug yang sudah dipakai: topik sama → edit note itu (cerita lanjutan), topik beda → konteks pembeda, tercatat sebagai placeholder → itu note yang ditunggu. Contoh capture + nama file bertanggal. Cek slug ganda di lint dititipkan ke W35. Test-flow 1.1 kini sesuai runtime; catatan roadmap M2.3 soal nama incident dihapus. Rujukan W29 `SCHEMA.md:104` → `:107`.

## Review ulang (2026-10-23)

> Celah yang ketemu saat mereview hasil pengerjaan W22–W26 dan I8, dan dari pertanyaan owner soal jumlah link per note.

- [x] **W35** Lint cek 2 hanya memeriksa `[[slug]]`. Bagian markdown dual-link `(../path/slug.md)` tidak dicek di mana pun, padahal path relatif mudah salah hitung `../`, dan aturan placeholder W23 ("path beda → perbaiki link `(...)`") bergantung padanya. Link rusak baru ketahuan saat dibuka di GitHub (`igrow-backup`) atau dashboard Phase 4.
  - Act: `lint.md` cek 2 + "path `(...)` di dual-link harus menunjuk file yang ada (relatif dari file note); target placeholder → path sama dengan baris placeholder di `_index.md`"; path gambar `![](...)` juga dicek (W41). Contoh output lint + 1 baris temuan path. + cek slug ganda: dua note naratif dengan nama file sama di `wiki/` = temuan (aturan I13; file data seperti `about.md`/`skills.md` dilewati).
  - Impact: dual-link benar di kedua sisi, jadi wiki tetap bisa dinavigasi tanpa Obsidian (G5: knowledge portable).
  - Tambahan saat dikerjakan: cek 2 dipecah per jenis link (`[[slug]]`, path dual-link, gambar) + cara resolve path relatif (contoh + `realpath -m`). Path dual-link juga harus berakhir di `<slug>.md` yang sama dengan `[[slug|...]]` di depannya, supaya dua sisi link tidak menunjuk file berbeda. Slug ganda jadi cek 6. Contoh eksekusi lint ditulis ulang dengan label tujuan (`[PROMPT CRON]`, `[OUTPUT lint-privacy.sh]`, `[LOG]`, `[JAWABAN AKHIR]`), karena sekarang ada baris log dan output script selain pesan Telegram; path di contoh ditulis lengkap (contoh lama menyingkat `career-2` dan `Bootcamp/redis-basics.md`).
- [x] **W36** SCHEMA § Link hanya mengatur link keluar dari note baru (min 2). Tidak ada aturan menambah link balik di note lama, jadi note lama membeku dengan link saat pertama ditulis. Contoh: note A (Januari) menaut ke B dan C; note D (Juni) yang sangat terkait menaut ke A, tapi A tidak pernah menaut ke D. Membuka note lama tidak membawa ke pengetahuan yang lebih baru, padahal wiki dipakai buat belajar ulang.
  - Act: SCHEMA § Link + 1 aturan: "Note baru menaut ke note lama yang sudah ada → tambah link balik (dual-link) di See Also note lama itu kalau belum ada; `updated:` note lama dan kolom Updated di `_index.md` ikut diganti; cukup dicatat di entri log operasi yang sama." Batasi ke note yang memang ditaut note baru, bukan scan seluruh wiki. Placeholder yang baru ditulis ikut aturan ini (note penautnya sudah menaut, cukup dicek). Step 6 `capture-experience.md` + `study.md` merujuk ke aturan ini; contoh few-shot dicek ulang dari sudut pandang model (bagian file vs index vs balasan) sesuai CLAUDE.md aturan 6. Balasan step 7 menyebut note lama yang ikut diperbarui.
  - Impact: hubungan antar-note dua arah; membuka note lama membawa ke note yang lebih baru, jadi wiki makin berguna untuk belajar ulang seiring bertambahnya isi.
  - Tambahan saat dikerjakan: beda dari Act, link balik **tidak** mengubah `updated:` note lama maupun barisnya di index. Career review membaca `updated` untuk Pola kuartal (tag paling sering di note yang diupdate), jadi note yang sering ditaut akan terlihat aktif padahal isinya tidak berubah. Jejaknya cukup di subjek log (`+ link balik: <slug>`). Placeholder yang ditulis: page penautnya masuk See Also note baru (penaut sudah menaut, jadi dua arah). Contoh capture kini memperlihatkan 1 placeholder + 1 link balik + baris log, dengan label `[EDIT NOTE LAMA]` dan `[LOG]`; contoh study + baris `Link balik ditambahkan di:`. PRD 02 AC UC1/UC4 + test-flow 1.6.

## Review menyeluruh (2026-10-23)

> Celah yang ketemu saat membaca ulang seluruh `hermes-home/` setelah W34, I13, dan W36 selesai, lalu dicocokkan dengan PRD, `testing/test-flow.md`, dan dokumentasi resmi Hermes (fitur Skills, cron, Telegram). W44 dari pertanyaan owner soal konteks catatan setelah redaksi; W45 dari pengamatan owner soal contoh eksekusi mentor; W46 dari pertanyaan owner soal dokumen Word/PDF.

- [x] **W37** Hermes bebas membuat dan memakai skill buatannya sendiri. Secara default agent menulis skill lewat `skill_manage`, system prompt Hermes memintanya menyimpan alur kerja yang tidak sepele sebagai skill, dan daftar skill masuk system prompt sesi berikutnya (dokumentasi resmi, fitur Skills). `AGENTS.md` tidak mengatur ini. Setelah beberapa capture, Hermes bisa menyimpan salinan prosedur iGROW sebagai skill, lalu sesi berikutnya memakai salinan itu, bukan `project-skills/` terbaru. Aturan yang dideploy belakangan (mis. link balik W36) diam-diam tidak dipakai.
  - Act: `AGENTS.md` § File Referensi + 1 baris: "Prosedur iGROW hanya dari file `igrow/project-skills/` (selalu baca versi di disk). Jangan simpan alur iGROW sebagai skill Hermes; skill yang meniru alur ini diabaikan." Prasyarat VPS (dicatat di roadmap M2.2 saat item ini dikerjakan): `skills.write_approval: true` di `config.yaml`, supaya skill baru menunggu persetujuan owner (`/skills approve` atau `/skills reject`).
  - Impact: satu aturan satu sumber juga berlaku terhadap memori prosedural Hermes; setiap perubahan `project-skills/` yang dideploy langsung dipakai.
  - Tambahan saat dikerjakan: dokumentasi resmi dicek ulang. `skills.write_approval` (default `false`) juga menahan penulisan dari background review; perintahnya `/skills pending`, `/skills diff <id>`, `/skills approve|reject <id|all>`, `/skills approval on|off`. Notifikasi saat ada skill tertahan tidak disebut, jadi owner perlu cek `/skills pending` sesekali. Memory ternyata berpola sama (disimpan otomatis termasuk dari background review, dimuat di setiap sesi), jadi baris di AGENTS ikut mencakup memory dan data iGROW: career aktif yang tersimpan di memory bisa basi setelah pindah kerja. `memory.write_approval` dicatat sebagai opsional di roadmap M2.2. Baris baru menggeser rujukan W44 `AGENTS.md:78` → `:79`. PRD 04 (lapisan instruksi), PRD 06 R-12, roadmap M2.2, dan `CLAUDE.md` (fakta teknis) diselaraskan.
- [x] **W38** `maintenance/backup.sh:17-21` langsung `exit 0` ("no changes") kalau tidak ada perubahan baru, tanpa `git push`. Commit dari run sebelumnya yang gagal di-push (jaringan putus, token kedaluwarsa) tertinggal di VPS, dan run berikutnya melapor "tidak ada perubahan" walaupun GitHub belum punya commit itu. Token yang kedaluwarsa juga baru ketahuan saat ada perubahan.
  - Act: `git push` tetap dijalankan walaupun tidak ada perubahan baru (commit dilewati, push tidak). Commit yang tertinggal ikut terkirim, dan remote + token teruji di setiap run. Teks output (`pushed` / `no changes` / `ERROR`) tetap, jadi `backup.md` tidak perlu diubah.
  - Impact: "Backup …: tidak ada perubahan" berarti GitHub benar-benar sama dengan VPS; push yang gagal terlihat di setiap run sampai diperbaiki (D-27).
  - Tambahan saat dikerjakan: status laporan ditentukan dari jumlah commit yang belum ada di GitHub (`git rev-list --count @{u}..HEAD`) sebelum push: ada → "pushed" (termasuk commit tertunda dari run sebelumnya), nol → "no changes". Upstream belum diset → dianggap ada commit, push gagal, dan terlapor "gagal" (terlihat, bukan diam). Diuji di scratchpad dengan remote git lokal, 7 skenario (ada perubahan; tidak ada perubahan; remote rusak dengan dan tanpa perubahan baru; remote pulih → commit tertunda terkirim; upstream belum diset): semua sesuai. Konsekuensi: gangguan jaringan sesaat kini juga terlapor "gagal" walau tidak ada perubahan baru, dan run berikutnya mengirim ulang. `backup.md` tidak berubah. PRD 02 M2 (AC) dan PRD 04 §6.3 (diagram) diselaraskan.
- [x] **W39** Kriteria type `lesson` tidak ada, dan `AGENTS.md:41` ("Lesson dari incident" → `lessons-learned/`) bertentangan dengan contoh capture, yang menulis pelajaran incident di `## Lesson Learned` note incident itu tanpa note lesson terpisah. Reasoning step 2 (`capture-experience.md:38-41`) hanya membedakan incident dan knowledge. Akibatnya sebagian sesi membuat note lesson tambahan untuk tiap incident (dua note untuk satu cerita), sebagian tidak pernah membuat lesson. Test-flow 1.7 ("Saya baru sadar: …" → lesson) dan 1.7b ("Catat: cara cek …" → knowledge) isinya hampir sama, jadi hasilnya untung-untungan. Pola "kesalahan berulang (≥ 2 lesson-learned dengan tag sama)" (`career-review.md:14`) ikut goyah: bisa selalu kosong, bisa juga menghitung duplikat. Syarat "tag sama" juga terlalu longgar (taxonomy hanya 16 tag, jadi dua lesson yang tidak berhubungan hampir pasti sama-sama `linux`), dan tag `incident` yang menempel di semua note incident ikut masuk "3 tag paling sering".
  - Act: `capture-experience.md` step 2, blok reasoning + definisi 3 type: incident = ada kejadian spesifik (symptom + investigation + result), pelajarannya cukup di `## Lesson Learned`, tidak dibuat note lesson terpisah; lesson = pelajaran atau refleksi tanpa satu kejadian spesifik ("saya baru sadar …"); knowledge = cara kerja, SOP, atau setup ("catat: cara …"). + 1 contoh reasoning lesson vs knowledge. `AGENTS.md:41` → "Lesson (pelajaran tanpa kejadian spesifik)". `career-review.md` step 2 Pola: kesalahan berulang = ≥ 2 incident/lesson yang akar masalahnya sama (Finding / Lesson Learned), sebut file-nya; tag `incident` tidak dihitung di 3 tag terbanyak (sudah tercermin di type). Contoh career review, PRD 02 UC1/UC5, dan test-flow 1.7/1.7b diselaraskan.
  - Impact: satu cerita = satu note dengan type yang bisa ditebak; pola kesalahan berulang menunjuk kejadian nyata, bukan kebetulan tag.
  - Tambahan saat dikerjakan: blok reasoning step 2 jadi 3 contoh 1 baris (incident / lesson / knowledge, masing-masing dengan alasan dan folder), menggantikan 1 contoh lama, jadi jumlah baris tetap. Definisi ditulis di baris Incident dan Lesson step 2. Kesalahan berulang + "minimal 1 di kuartal ini", supaya pola lama tidak dilaporkan ulang setiap kuartal; contoh career review menyebut 2 file incident bertanggal. Test-flow 1.7/1.7b sudah sesuai; 1.1 + cek "tidak ada file baru di `lessons-learned/`" untuk cerita incident yang membawa pelajaran. PRD 02 UC1 (alur, tabel penempatan) dan UC5 (contoh laporan, AC Pola) diselaraskan.
- [x] **W40** Isi master `igrow/_index.md` per page tidak didefinisikan di mana pun. SCHEMA:23 hanya mewajibkan "Total pages + Last updated", file-nya hanya berisi heading section (Careers sampai Output), dan aturan placeholder "tidak masuk master" menyiratkan page biasa masuk. Padahal master dibaca pertama oleh agent (`AGENTS.md:17`), `/recall` (`AGENTS.md:54`), dan mentor (`mentor.md:9`). Tiap sesi bisa menulis bentuk entri berbeda atau hanya menaikkan angka, isinya menyimpang dari `wiki/_index.md`, dan Total pages yang ditambah manual tidak dicek siapa pun.
  - Act (keputusan owner, pilih satu): (a) disarankan: master jadi peta saja, tanpa baris per page: Total pages + Last updated + rujukan ke `wiki/_index.md`, `raw/_index.md`, `output/_index.md`; `/recall` dan mentor membaca `wiki/_index.md` (kolom Summary + Tags) langsung; protokol tulis step 2 tetap. (b) tetapkan format 1 baris per page di section yang sesuai (mis. `- [[slug]] — <ringkasan>`), lalu lint mencocokkan master dengan index layer. Untuk keduanya: Total pages = hitung ulang baris non-placeholder di `wiki/_index.md` + `output/_index.md` (bukan ditambah 1), definisinya di SCHEMA. `_index.md` di-exclude rsync, jadi kalau master sudah ada di VPS, template barunya disalin manual sekali.
  - Impact: tiap page tercatat di satu katalog yang formatnya pasti; `/recall` mencari di kolom yang memang berisi ringkasan; Total pages selalu sama dengan isi index.
  - Tambahan saat dikerjakan: keputusan owner (D-32): bukan (a) atau (b), master dihapus. Kalau master cuma berisi Total pages dan Last updated, keduanya bisa dihitung dari `wiki/_index.md` dan `log.md`, dan tidak ada yang memakai Total pages (dashboard belum dibangun). Protokol tulis SCHEMA jadi 2 langkah (index terdekat + log). `AGENTS.md:17` sekarang menunjuk `wiki/_index.md` sebagai pintu masuk (+ `raw/`, `output/`), dan `/recall` serta mentor mulai dari sana. Aturan placeholder ("tidak masuk master") dan batas 200 baris (sekarang untuk `wiki/_index.md`: dipecah per subfolder, `wiki/_index.md` jadi penunjuk) dirapikan. Kata "master" dihapus dari langkah penutup capture, study, mentor, career review, dan lint. Template `igrow/_index.md` dihapus; di VPS dihapus manual sekali (rsync tidak menghapus file, roadmap M2.1). Rujukan W29 `SCHEMA.md:107` → `:106` dan W42 `SCHEMA:41` → `:40` (protokol berkurang 1 baris). PRD 02 (AC UC1, AC UC5 yang masih ⚠ padahal W24 sudah beres, AC /recall), 03 FR-09, 04 (diagram tulis, pohon folder + `taxonomy.md`), 06 D-32, `docs/build.md` (pohon folder + `taxonomy.md`), dan test-flow (1.1, 2.x, 5.4, checklist #3) diselaraskan; W10 dan W18 diberi catatan.
- [x] **W41** Screenshot: `capture-experience.md:34` menulis "(WAJIB redact)" tanpa menyebut siapa yang meredaksi. Agent tidak bisa mengedit gambar dengan andal, dan PRD 03 §3.2 menetapkan redaksi dilakukan user di HP sebelum dikirim. Model bisa menyimpan gambar apa adanya (lalu ikut ter-push ke GitHub saat backup) atau mencoba mengeditnya sendiri. Path embed di baris yang sama (`![](../../raw/assets/...)`) juga salah kedalaman: dari `knowledge/incidents/` ke `igrow/raw/` perlu 5 kali `../`, dari `knowledge/` dan `lessons-learned/` 4 kali, sehingga gambar tidak tampil di GitHub maupun Obsidian.
  - Act: baris screenshot → "Screenshot hanya disimpan kalau sudah diredaksi user (crop/blur sebelum dikirim). Agent tidak mengedit gambar: cek isinya dulu; masih terlihat data DILARANG KERAS → jangan simpan, minta user kirim ulang versi yang sudah diredaksi. Info penting di gambar ditulis juga sebagai teks (sudah diredaksi) di note." Path embed → relatif dari file note: `../../../../../raw/assets/<file>` dari `knowledge/incidents/`, `../../../../raw/assets/<file>` dari `knowledge/` dan `lessons-learned/`. Self-check privasi step 5 + "termasuk gambar". Lint sudah mengecek path gambar (cek 2, W35).
  - Impact: tidak ada screenshot mentah di `raw/assets/` maupun di repo backup; gambar yang disimpan tampil di GitHub/Obsidian, dan isinya tetap bisa dicari sebagai teks.
  - Tambahan saat dikerjakan: keputusan owner (D-33) membalik arah Act: screenshot **tidak** diredaksi dan tidak dicek, tapi disimpan asli supaya konteksnya utuh. Bagian "hanya disimpan kalau sudah diredaksi" dan "minta kirim ulang" tidak jadi; "info penting di gambar ditulis juga sebagai teks" tetap, dengan aturan redaksi teks biasa. Path embed diperbaiki sesuai Act. `AGENTS.md`: tabel penempatan "(asli)" + DILARANG KERAS mengecualikan screenshot (di baris yang sama, rujukan W44 `AGENTS.md:79` tidak bergeser). PRD 01/02/03 (§3.1, §3.2)/06 (D-33, R-02), README, roadmap M2.3 (+ skenario screenshot), dan `docs/peta-igrow.html` diselaraskan.
- [x] **W42** `careers/*/skills.md`: `capture-experience.md:33` meminta "Skill terpakai → update `skills.md`", tapi formatnya tidak ada (SCHEMA:41 hanya "plain `Key: value`"), contoh capture tidak pernah mengisinya, dan step 6/7 tidak menyebutnya. Model meniru contoh, jadi `skills.md` tetap kosong, padahal test-flow 1.1 dan 1.16 ("skill apa aja yang sudah kepakai di kerjaan saya?") mengharapkannya terisi. Kata "placeholder" di Daftar Kerjaan Baru step 5 (`capture-experience.md:21`, `skills.md` kosong "placeholder untuk UC1 nanti") juga bentrok dengan baris `(placeholder)` di index (W23).
  - Act: SCHEMA (baris `about.md` & `skills.md`) + format: 1 baris per tag taxonomy, `<tag>: <skill>, <skill>` (skill = kemampuan konkret yang terlihat di note, mis. `linux: cari proses pemakan CPU (top), cek jadwal cron`); skill yang sudah tercatat tidak ditulis ulang. Contoh capture + bagian `[EDIT FILE DATA — careers/career-N/skills.md; tidak dikirim ke chat]`, termasuk kolom Updated barisnya di `wiki/_index.md`. Step 5 Daftar Kerjaan Baru → "(diisi saat capture)".
  - Impact: pertanyaan "skill apa yang sudah kepakai" terjawab dari data per career; istilah "placeholder" hanya punya satu arti.
  - Tambahan saat dikerjakan: format ditulis di baris SCHEMA yang sama, jadi rujukan W29 `SCHEMA.md:107` tidak bergeser; tag `incident` tidak dipakai sebagai kunci (sama dengan Pola career review, W39). Kondisi awal contoh menyebut isi `skills.md` sebelumnya, sehingga contoh memperlihatkan dua kasus sekaligus: skill ditambah ke baris tag yang sudah ada (`linux`) dan baris tag baru (`performance`). Balasan step 7 + "skill baru di skills.md" (owner ingin tahu isi yang dicatat tanpa membuka file). Step 6 menyebut kolom Updated baris `skills.md` di `wiki/_index.md`. PRD 02 UC1 (AC) dan test-flow 1.1 diselaraskan.
- [x] **W43** `daily-briefing.md:43-44` mengizinkan sesi cron 07:00 menulis page wiki kalau ada berita yang "layak jadi page", tanpa aturan folder atau type dan tanpa membaca `study.md` (self-check, slug, link balik). Page itu ikut dihitung "punya note" di Skill Inventory dan Role Fit, padahal owner tidak pernah mempelajarinya. PRD 02 UC3 (diagram dan kalimat "hanya menulis ke wiki kalau ada berita yang layak dijadikan page") memang mengizinkannya.
  - Act (keputusan owner, membalik PRD 02 UC3): disarankan, briefing tidak pernah menulis ke wiki; berita yang mau disimpan → owner kirim `/study <link>` (alur `study.md` lengkap). Kalimat itu dihapus dari step 4, PRD 02 UC3 disesuaikan. Alternatif: tetap boleh, tapi folder dan type ditentukan, `study.md` wajib dibaca, dan page dari briefing tidak dihitung di Skill Inventory.
  - Impact: isi wiki = yang owner alami atau pelajari sendiri; angka Skill Inventory tidak naik karena berita.
  - Tambahan saat dikerjakan: keputusan owner (D-31) sesuai opsi yang disarankan: briefing hanya info. Step 4 dipertegas: JANGAN menulis file apa pun (wiki/, raw/, index, log); berita yang mau disimpan hanya kalau user minta, lewat alur `study.md`. PRD 02 UC3 (diagram: UC3 → /study, paragraf, AC) dan PRD 06 D-31 diselaraskan; test-flow 5.3 ("tidak ada file tertulis") sudah sesuai.
- [x] **I14** `mentor.md:18` hanya menambah `weak-topics.md` "kalau ada temuan baru". Topik yang sudah jadi Known tidak pernah dihapus, jadi lama-lama file itu tidak lagi menggambarkan gap yang sebenarnya.
  - Act: → "Tulis ulang `wiki/roadmap/weak-topics.md` dari Gap hasil analisis ini (topik yang sudah Known hilang dari daftar). Isinya sama dengan versi lama → tidak ditulis (tanpa update index dan log)."
  - Impact: `weak-topics.md` selalu sama dengan Gap terakhir yang dihitung mentor.
  - Tambahan saat dikerjakan: Gap dihitung dari semua topik target skill map, bukan hanya area yang ditanya user, supaya pertanyaan sempit (mis. soal networking saja) tidak menghapus gap area lain. PRD 02 UC2 diselaraskan.
- [x] **I15** `daily-briefing.md:35` dan `lint.md:25` berbunyi "Kirim ke Telegram", padahal di cron jawaban akhir agent yang dikirim otomatis ("the agent does not send messages itself", dokumentasi resmi, fitur cron). Kalau tool kirim pesan tersedia di sesi cron, owner bisa menerima pesan dobel (briefing, lalu "sudah dikirim"). `backup.md` sudah memakai kalimat yang benar ("balas … jadi laporan cron").
  - Act: kedua baris → "Jawaban akhir = isi pesan Telegram (dikirim otomatis oleh cron; jangan pakai tool kirim pesan)". Paling hemat bareng W27 (`daily-briefing.md`) dan W35/I12 (`lint.md`).
  - Impact: 1 run cron = 1 pesan.
  - Tambahan saat dikerjakan: bagian `lint.md` selesai bareng I12/W35 (Tutup memakai kalimat Act di atas). Bagian `daily-briefing.md` selesai bareng W27/W28: step 4 → "Jawaban akhir = isi pesan Telegram apa adanya (dikirim otomatis, dari cron maupun chat; jangan pakai tool kirim pesan)", karena briefing juga bisa diminta lewat chat (test-flow 5.3).
- [x] **I16** Penunjukan career aktif belum tegas. Semua path dan contoh memakai `career-N` sebagai nama folder (`AGENTS.md:39-41`, `capture-experience.md:30-34`), padahal folder aslinya `career-N-{company}-{role}` (`AGENTS.md:45`, SCHEMA:17; test-flow juga memakai nama lengkap), dan baris `→ OUTPUT` step 1 (`capture-experience.md:27`) mengajarkan "Career aktif = career-N". Model bisa menulis ke `careers/career-1/knowledge/…`: folder baru tanpa `about.md`, note terpecah, hitungan `career-summary.md` meleset. Kasus lebih dari satu career aktif (mis. period di `about.md`, yang memang milik user, lupa ditutup) juga belum diatur, jadi agent memilih sendiri.
  - Act: SCHEMA § Career aktif + 1 baris: "Di semua path dan contoh, `career-N` = nama folder lengkap (mis. `career-1-acme-sysadmin`), bukan nomornya saja. Lebih dari satu career aktif → jangan pilih sendiri, tanya user cerita ini masuk career mana." `capture-experience.md:27` → "Career aktif = <nama folder lengkap>". Career review (cron) memperlakukan kasus ini seperti level tidak tertulis (W29): tidak menebak, ditulis di laporan.
  - Impact: note selalu masuk folder career yang benar; tidak ada folder career bayangan.
  - Tambahan saat dikerjakan: aturan jadi bullet baru di SCHEMA § Career aktif (+ "jangan bikin folder `career-1/` baru"). Contoh capture memakai nama folder lengkap `career-1-acme-sysadmin` di semua bagian (file, note lama, index, balasan), karena model meniru contoh lebih kuat daripada aturan; template di step 2 tetap `career-N`. Bagian career review (lebih dari satu career aktif → tidak menebak, tulis di laporan) dititipkan ke W29, yang memang menambah aturan "prosedur ini tidak bertanya" di `career-review.md`. Rujukan W29 `SCHEMA.md:106` → `:107` dan W42 `SCHEMA:40` → `:41`. PRD 02 UC1, 03 FR-06, test-flow checklist #7, roadmap M2.3 (+ kasus dua career aktif) diselaraskan.
- [ ] **W44** `AGENTS.md:79` hanya menyebut OS, versi, nama service, port, dan environment sebagai info non-sensitif yang tetap ditulis. Nilai default atau contoh dari dokumentasi publik (mis. docker0 `172.17.0.1`, IP DNS default Kubernetes `10.96.0.10`) tidak disebut, padahal bentuknya sama dengan "IP internal" di daftar DILARANG KERAS. Hermes yang berhati-hati bisa meredaksinya jadi `<IP-...>` di note belajar, sehingga nilai yang justru perlu dipelajari hilang. `lint.md` cek 8 sudah menganggap contoh seperti ini wajar di materi belajar, tapi aturan redaksinya belum. Ketemu dari pertanyaan owner: catatan harus tetap bisa dipahami saat dibaca ulang.
  - Act: kalimat terakhir `AGENTS.md:79` → "Info non-sensitif tetap ditulis: OS, versi, nama service, port, environment, dan nilai default/contoh dari dokumentasi publik (mis. docker0 `172.17.0.1`). Yang diredaksi hanya nilai dari lingkungan kerja nyata (server kantor/client)." Tetap 1 baris. PRD 03 §3.1 (tabel Salah/Benar) + 1 baris.
  - Impact: note belajar tetap memuat nilai yang perlu diingat; redaksi hanya mengenai data lingkungan kerja nyata, sama dengan cakupan cek privasi lint.
- [x] **W45** Contoh eksekusi `mentor.md` masih format lama (`Input:` / `Output:`), beda dengan prosedur lain yang sudah memakai label tujuan, dan hanya mencontohkan pertanyaan role fit (alur B). Alur roadmap (A), yang menulis ulang `weak-topics.md` (I14), tidak punya contoh, jadi model yang meniru contoh bisa tidak pernah menulis file itu (pola W42). Baris `→ OUTPUT` Gap juga berlaku untuk kedua alur, padahal di B gap sudah ada di kolom Kurang. Ketemu dari pengamatan owner.
  - Act: contoh dipecah dua dengan label tujuan: A (roadmap: `[PESAN USER]`, `[FILE DITULIS — weak-topics.md]`, `[EDIT INDEX]`, `[LOG]`, `[BALASAN KE USER]`) dan B (role fit: `[PESAN USER]`, `[BALASAN KE USER]`, tanpa file). Baris Gap pindah ke alur A sebagai baris pertama balasan. Balasan A menyebut kalau `weak-topics.md` ditulis. + 1 baris contoh untuk prasyarat (kurang dari 3 note).
  - Impact: semua contoh eksekusi memakai format yang sama; alur roadmap punya contoh lengkap, termasuk penulisan `weak-topics.md`.
- [x] **W46** Belum ada alur untuk dokumen lampiran (Word/PDF), padahal incident yang kompleks akan dikirim sebagai dokumen berisi teks + screenshot. Capture tidak mengenal dokumen, `/study` mengubah PDF jadi teks yang diredaksi tanpa menyimpan file aslinya, dan pengecualian D-33 hanya untuk screenshot. Ketemu dari pertanyaan owner.
  - Act (keputusan owner, D-34): file asli dokumen disimpan utuh di `raw/assets/` tanpa redaksi; redaksi hanya untuk teks hasil olahan. `capture-experience.md` step 2 + baris dokumen lampiran (simpan asli, baca isi termasuk gambar, note teks diredaksi + `sources` + link di Referensi, path disebut di balasan; tidak terbaca → file tetap disimpan, minta intinya, jangan menebak). `study.md` step 1: file lampiran disimpan asli dulu. `AGENTS.md` (tabel penempatan + pengecualian DILARANG KERAS, baris yang sama) dan SCHEMA layer `raw/`. Kemampuan ekstraksi Hermes belum terbukti (skill `ocr-and-documents`, batas 20 MB Bot API): diuji di roadmap M2.2/M2.3.
  - Impact: dokumen kompleks bisa dicatat tanpa kehilangan aslinya; note tetap bisa dicari, file utuh selalu bisa dibuka untuk belajar ulang.

## Critical

- [x] **C6** `lint.md` belum ada padahal cron lint mingguan dijanjikan
  - Act: dibuat `project-skills/lint.md` + 1 baris di AGENTS.md; prompt cron lint dipersingkat.
  - Impact: job lint punya aturan yang ikut ke VPS.
- [x] **C7** Job backup tidak tercermin di file runtime — agent bisa utak-atik `.git/` tanpa tahu
  - Act: 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat."
  - Impact: agent tahu `.git/` bukan wilayahnya.
- [x] **C8** Ownership `skill-map.md` beda di 3 file: SCHEMA.md:16 = human-owned, mentor.md:5 = "AUTO-GENERATE", FIN:742 = "wajib diisi manual di awal"
  - Act: SCHEMA.md:16 buang skill-map dari human-owned + rule agent-auto-generate; mentor.md → output Role Fit Matching; career-review.md → step 4 Role Fit Trend; FIN:742 → AUTO-GENERATE.
  - Impact: skill-map jadi input pasti untuk UC2 & UC5.

## Warning — inkonsistensi spec antar file

- [x] **W10** `_index.md` "Total pages: N" tidak ada aturan update
  - Act: AGENTS step 2 eksplisit "(termasuk \"Total pages\" + \"Last updated\")".
  - Impact: counter master index ikut gerak.
  - Catatan 2026-10-23: master index dihapus (W40, D-32), jadi Total pages tidak dipakai lagi.
- [x] **W11** SCHEMA.md:31 `sources:` belum diputus satu konvensi
  - Act: SCHEMA jadi "selalu ada; `[]` kalau murni cerita user".
  - Impact: `igrow-api` bisa asumsi field-nya selalu ada.
- [x] **W12** raw/ punya 2 jalur (inbox→`.processed/` vs articles/ langsung)
  - Act: `.processed/` dibuang total; sisa 1 jalur `inbox/ → articles/`.
  - Impact: "inbox kosong = semua sudah diproses" jadi indikator yang bisa dipercaya.
- [x] **W13** Op `query` terdaftar di SCHEMA:21 tapi tidak pernah dipakai
  - Act: buang `query` dari daftar ops SCHEMA.
  - Impact: daftar ops = ops yang beneran ada.
- [x] **W14** Format isi `skill-map.md` belum ada template baku
  - Act: tambah section `## skill-map.md format` di SCHEMA — template baku `## Target L<n>` + `- Area: topik, topik`.
  - Impact: % per area dihitung dari struktur yang pasti.
- [x] **W15** `type: data` di luar enum SCHEMA
  - Act: `data` masuk enum SCHEMA + blok frontmatter minimal.
  - Impact: `roadmap/` & `profile/` lolos cek frontmatter lint.
- [x] **W16** Prefix `sources:` dua bentuk: `raw/...` vs `igrow/raw/...`
  - Act: dipilih `igrow/raw/...` (lengkap dari root).
  - Impact: `igrow-api` resolve path pakai 1 aturan.
- [x] **W17** Hitungan field wajib beda 3 versi (lint.md "8", isinya 7, check.sh cek 5)
  - Act: lint.md → "7 field wajib" + `contradictions` opsional; check.sh loop +`title` +`sources`.
  - Impact: SCHEMA, lint, dan check.sh ngukur hal yang sama.
- [x] **W18** `igrow/_index.md` runtime masih section `## Learning`, tidak punya `## Output`
  - Act: `## Learning` → `## Roadmap`, +`## Output`.
  - Impact: laporan career review punya tempat di master index.
  - Catatan 2026-10-23: master index dihapus (W40, D-32); laporan tercatat di `output/_index.md`.
- [x] **W19** `raw/inbox/` satu-satunya folder tanpa `.gitkeep`
  - Act: `touch hermes-home/igrow/raw/inbox/.gitkeep`.
  - Impact: struktur utuh setelah clone/restore.
- [x] **W20** Job backup satu-satunya yang tidak point-to-file
  - Act: bikin `project-skills/backup.md`, ganti prompt cron jadi point-to-file.
  - Impact: 4 job pola sama; aturan backup ikut ke VPS.
- [x] **W21** ~~`raw/notes/` ada di disk + tree FIN tapi tidak disebut satu pun file runtime.~~
  - Act: Hapus `raw/notes/` dari tree FIN, build.md, dan hermes-home.
  - Impact: `raw/` punya flow yang jelas.

## Improvement

- [x] **I3** ~~log.md:5 pakai `op: init` — tidak ada di daftar ops SCHEMA.~~
  - Act: `init` SUDAH ada di daftar ops SCHEMA:23. Tidak perlu ubah apa-apa.
  - Impact: `log.md` valid.
- [x] **I4** Definisi "Career Aktif" dobel
  - Act: definisi pindah ke SCHEMA.md; AGENTS/FIN/build: ganti jadi 1 baris rujuk.
  - Impact: satu sumber definisi.
- [x] **I5** ~~File .md hermes-home/ semua CRLF.~~
  - Act: `sed -i 's/\r$//'` semua .md di hermes-home/.
  - Impact: semua file .md konsisten LF.
- [x] **I6** `capture-experience.md` cuma handle incident/knowledge/lesson — belum ada flow "daftar kerjaan baru"
  - Act: tambah section "Daftar Kerjaan Baru" di capture-experience.md.
  - Impact: UC1 lengkap — bukan cuma simpan incident, tapi juga daftar career baru.
- [x] **I7** ~~`wiki/profile/` punya 5 file di spec tapi career-review.md cuma update 2.~~
  - Act: hapus `me.md` + `achievements.md` + `career-goals.md` dari spec; tinggal 2 file: `skills.md`, `career-summary.md`.
  - Impact: profile/ cuma 2 file auto.

## Advanced Prompting

> Tingkatkan kualitas project-skills (UC1/2/3/4/5) dengan teknik prompting proven untuk meminimalisir debugging.
> **Prioritas konsistensi over conciseness** — output boleh panjang/minta validasi ulang, yang penting akurat.
> Tier 1 = ROI tinggi (effort kecil, dampak jelas). Tier 2 = ROI sedang (effort medium). Tier 3 = effort besar (refactor pipeline, 4x API call untuk multi-turn).

### Tier 1 — ROI Tinggi (effort: copy-paste + insert)

- [x] ~~**A1** Few-shot examples — 1 contoh lengkap input→output per UC di section `## Contoh Eksekusi`~~
  - Act: tambahkan di akhir 5 file UC: capture-experience.md (full example incident), study.md/mentor.md/daily-briefing.md/career-review.md (ringkas).
  - Impact: model mid (Sonnet/Haiku/Qwen) konsisten 15-25% lebih akurat; model tahu bentuk output yang diharapkan tanpa trial-error. Few-shot = teknik prompting paling efektif per research.
- [x] ~~**A2** Role definition — 1 baris di awal tiap UC: "Kamu = wiki compiler. Input mentah → structured page. Human edit manual = jarang."~~
  - Act: tambahkan setelah header `# Referensi: <UC>` di 5 file: capture-experience (wiki compiler), study (wiki compiler), mentor (mentor data-driven), daily-briefing (news curator), career-review (career analyst).
  - Impact: agent paham konteks kerja (compiler otomatis/analyst data-driven, bukan interviewer/tutor interaktif/opini generik). Role clarity = kurangi halusinasi 10-15%.
- [x] ~~**A3** Verification checkpoint — self-check sebelum tulis untuk UC yang >3 langkah~~
  - Act: tambahkan sebelum step "Update _index+log" di 2 file:
    - capture-experience.md step 5 (setelah "See Also"):
      ```
      Self-check sebelum commit ke disk:
      1. Frontmatter lengkap 7 field wajib? (title/created/updated/type/tags/sources/confidence)
      2. Tags ⊂ taxonomy SCHEMA? (linux|networking|monitoring|..., cek igrow/SCHEMA.md)
      3. sources: prefix `igrow/raw/...` atau `[]`? (BUKAN path relatif)
      4. Min 2 dual-link See Also? (format `[[slug]]`)
      Kalau ada yang kurang → STOP, perbaiki dulu sebelum tulis file.
      ```
    - study.md step 5 (setelah "See Also"): sama seperti di atas.
  - Impact: error struktur (frontmatter kurang, tag typo `linuxx`, path salah `raw/...` tanpa prefix, orphan page tanpa link) tertangkap sebelum nulis file, bukan saat lint/cron. Checkpoint = safety net 80% error struktural.

### Tier 2 — ROI Sedang (effort: trace edge case per UC)

- [x] ~~**A4** Explicit reasoning untuk keputusan ambigu — agent tulis 1 baris alasan sebelum pilih~~
  - Act: tambahkan di capture-experience.md step 2 (setelah "Rapikan cerita jadi note"):
    ```
    Tentukan type & folder — TULIS REASONING 1 BARIS:
    - Cerita "server mati pas backup" → incident atau knowledge?
      Reasoning: ada symptom + investigation + result = incident; cuma SOP tanpa kejadian = knowledge
    - Pilih: incident → igrow/wiki/careers/career-N/knowledge/incidents/
    ```
  - Impact: agent transparan kenapa pilih type/folder tertentu; user bisa koreksi keputusan yang salah tanpa debug isi file. Konfirmasi passive (agent tulis reasoning, user koreksi kalau salah).
- [x] ~~**A5** Fallback per langkah yang bisa gagal — instruksi eksplisit saat kondisi tidak ideal~~
  - Act: 
    - mentor.md tambah setelah "## Prasyarat jujur": "skill-map.md belum ada / lebih lama dari about.md → auto-generate dulu dari careers/+self-dev, lalu analisa. careers/ kosong → bilang 'Data karier belum cukup untuk gap analysis (minimal 3 incident/knowledge)', jangan ngarang roadmap generik."
    - capture-experience.md tambah di step 3 (Format frontmatter): "Tag fuzzy-match ke taxonomy SCHEMA. Kalau tidak ada yang cocok (<60% similarity) → tanya user 1x 'Tag mana yang cocok: [3 opsi terdekat]?', jangan tebak. Kalau user skip → pakai terdekat + catat di `contradictions: ['taxonomy-mismatch']`."
  - Impact: agent tahu next-action saat data tidak lengkap (auto-generate skill-map, tanya tag) atau kondisi mustahil (careers/ kosong → jujur); nol stuck/silent-fail/ngarang.

### Tier 3 — Effort Besar (DISKUTABEL — kerjakan hanya kalau Tier 1-2 terbukti kurang)

> **Disclaimer:** Tier 3 mengubah pipeline & UX. Chain-of-thought verbose, output 2x lebih panjang.
> A7–A9 dihapus 2026-10-22 (keputusan owner). Idenya tetap tercatat di [`05-roadmap.md`](05-roadmap.md) § 4 Parked. Kode A7–A9 tidak dipakai ulang.

- [x] ~~**A6** Chain-of-thought eksplisit — agent tulis reasoning sebelum SETIAP action~~
  - Act (revisi lazy — bukan refactor 10-substep penuh): 1 baris `→ OUTPUT:` di titik keputusan paling berisiko per UC (bukan tiap step): capture-experience (career aktif), study (topik taxonomy), mentor (gap detection), daily-briefing (kurasi berita), career-review (skill inventory hitung).
  - Impact: transparansi keputusan tanpa 2x output length — reasoning cuma di titik yang sering salah, bukan tiap langkah rutin (career aktif/format frontmatter yang deterministik nggak perlu reasoning verbose).
  - Catatan 2026-10-23: baris `→ OUTPUT` untuk daily-briefing dihapus (W27) dan untuk career-review jadi baris laporan (I11), karena jawaban akhir cron dikirim apa adanya ke Telegram. Di mentor, baris Gap jadi baris pertama balasan roadmap (W45).

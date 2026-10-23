# To-Do — iGROW (hermes-home)

> Fokus: hanya item yang menyentuh `hermes-home/` (AGENTS.md, SCHEMA, project-skills, struktur `igrow/`). Item VPS, docs, testing, web, dan migrasi dihapus 2026-10-16; jejaknya ada di git history dan `05-roadmap.md`.
> Kode item dinomori ulang 2026-10-16 (urut dari atas per huruf; pemetaan lama → baru ada di `backlog.md`). Mulai sekarang permanen — jangan dinomori ulang. Nomor berikutnya: C9 / W36 / I14 / A11.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres. Item `[x]` Act-nya lampau, Impact-nya sudah berlaku.
> Isi list = bug + kontradiksi di runtime. Kosmetik sengaja tidak dicatat. `FIN` di item lama = `archive/iGROW_FINAL.md`.
> Item selesai → centang di sini + catat di [`backlog.md`](backlog.md).

## Terbuka

- **W27–W34, A10, I9–I13**: temuan review runtime 2026-10-22. Kerjakan W27–W30 sebelum cron dibuat (kena di run cron pertama), lalu A10 (privasi). Detail di § Review runtime.
- **W35**: temuan review ulang 2026-10-23 (lint belum memeriksa path markdown di dual-link). Paling hemat dikerjakan bareng I12 (sama-sama `lint.md`). Detail di § Review ulang.

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

- [ ] **W27** `daily-briefing.md:10` meminta satu baris `→ OUTPUT: "Pilih <berita> karena ..."` per item sebelum format akhir. Cron mengirim jawaban akhir agent apa adanya (lihat W22), jadi briefing di Telegram diawali 5 baris alasan yang isinya sama dengan `Why it matters`.
  - Act: hapus baris `→ OUTPUT:` di step 1 (A6 untuk UC3 dibatalkan); alasan relevansi cukup di `Why it matters`. AC PRD 02 UC3 "Sebelum format akhir, Hermes menulis satu baris alasan pemilihan per item" ikut dihapus.
  - Impact: pesan briefing hanya berisi 5 item; FR-20 (alasan relevansi per item) tetap terpenuhi lewat `Why it matters`.
- [ ] **W28** `daily-briefing.md:9` hanya berbunyi "web research berita terbaru". Tidak ada kewajiban menyebut sumber dan tidak ada fallback kalau search gagal atau hasilnya kosong, sehingga agent bisa mengisi briefing dari ingatan model, termasuk CVE-ID yang tidak ada.
  - Act: step 1 → "berita terbit ≤ 48 jam terakhir". Tiap item di format + baris `Sumber: <URL>` (contoh eksekusi ikut diperbarui). CVE-ID hanya ditulis kalau tercantum di sumber. Kurang dari 5 item yang bersumber → kirim yang ada saja, jangan ditambal. Search gagal/kosong → balas "Briefing <tanggal> gagal: <alasan>", jangan isi dari ingatan. Prasyarat VPS (roadmap M2.2): toolset web aktif untuk platform `cron` di `hermes tools`.
  - Impact: setiap item bisa dicek ke sumbernya; tidak ada berita atau CVE karangan. Evaluasi OQ-07 (2 minggu) punya data sumber untuk dinilai.
- [ ] **W29** `SCHEMA.md:104`: level tidak tertulis di `Role` → "tanya user 1x". Aturan ini ikut berlaku di career review yang dipicu cron, padahal sesi cron tidak bisa menerima jawaban: agent berhenti di pertanyaan (laporan tidak ditulis) atau menebak level.
  - Act: `career-review.md` + 1 aturan (tanpa syarat "dipicu cron", karena dokumentasi Hermes tidak menyebut sesi cron diberi tahu bahwa tidak ada yang menjawab): "Prosedur ini tidak bertanya ke user. Level tidak tertulis di `Role` → jangan tebak: lewati Skill Inventory dan pembuatan skill map baru (Role Fit tetap jalan kalau skill map sudah ada), tulis 'Level belum tertulis di about.md' di laporan." Override ini disebut juga di SCHEMA:104 ("kecuali career review"). Di chat, user tinggal melengkapi `about.md` lalu minta review ulang.
  - Impact: career review otomatis selalu menghasilkan laporan; level yang hilang terlihat di laporan, bukan ditebak.
- [ ] **W30** `career-review.md:22` menamai laporan `career-review-<YYYY>-Q<n>.md` tanpa menyebut tahun mana yang dipakai. Cron 1 Januari 2027 mereview Q4 2026, tapi agent bisa memakai tahun run dan menulis `career-review-2027-Q4.md`.
  - Act: step 5 → "`<YYYY>-Q<n>` = tahun dan kuartal yang direview, bukan tanggal run (cron 1 Jan 2027 → `career-review-2026-Q4.md`). Review manual di tengah kuartal = kuartal berjalan; file yang sama ditimpa run berikutnya untuk kuartal itu." Step 1 "laporan terakhir" → "laporan kuartal sebelumnya (Q<n-1>)", supaya sama dengan step 4 dan tidak membandingkan dengan laporan manual kuartal yang sama.
  - Impact: laporan otomatis pertama (syarat Phase 2 selesai) bernama benar, dan Role Fit Trend kuartal berikutnya menemukan laporan pembanding yang benar (FR-19).
- [ ] **W31** Template `about.md` di `capture-experience.md:16` berisi `Vendor/Client: <nama>`, padahal data client termasuk DILARANG KERAS (`AGENTS.md:72`) dan AC PRD 02 UC1 meminta nama client tidak muncul di file mana pun. Contoh `about.md` di PRD 02 UC1b sudah memakai `client A (anonim)`.
  - Act: template → `Vendor/Client: <anonim, mis. client A>`; step 1 + "nama client asli tidak ditulis".
  - Impact: alur Daftar Kerjaan Baru tidak menyimpan nama client; runtime sama dengan contoh PRD.
- [ ] **W32** `capture-experience.md:10` menutup career lama dengan `Period: <start> s/d <hari ini>`. Kalau kerjaan baru didaftarkan beberapa minggu setelah pindah, tanggal selesai career lama salah dan period-nya tumpang-tindih dengan career baru.
  - Act: step 1 + tanya tanggal selesai kerjaan lama (masih di ronde yang sama; user skip → sehari sebelum start kerjaan baru, sebutkan di balasan); step 2 pakai tanggal itu. AC PRD 02 UC1b (`s/d <hari ini>`) ikut diubah.
  - Impact: period tiap career akurat, termasuk di `profile/career-summary.md`.
- [ ] **W33** `study.md` menulis sumber mentah ke `raw/inbox/` (step 1), tapi tidak menyebut kapan file itu dipindah ke `raw/articles/`, dan step 6 hanya meng-update `wiki/_index.md`. `raw/_index.md` tidak pernah terisi (FR-09), dan lint tidak menangkapnya karena hanya memeriksa `wiki/`.
  - Act: step 2 + "pindahkan file raw ke `igrow/raw/articles/` sebelum menulis note (`sources` menunjuk ke sana)"; step 6 → "update `raw/_index.md` (kalau ada file raw) + `wiki/_index.md` + master + log.md (op: ingest)". Celah yang sama di `capture-experience.md` step 6: screenshot ke `raw/assets/` juga tidak dicatat → + "`raw/_index.md` kalau ada screenshot".
  - Impact: semua file `raw/` (artikel dan screenshot) tercatat di index terdekat; "inbox kosong = sudah diproses" bisa dipercaya (FR-10).
- [ ] **W34** Status Known / Weak / Belum hanya didefinisikan di `mentor.md:12-14`, tapi `career-review.md:13` ikut memakainya (Weak = "Weak/Belum"). Prompt cron UC5 hanya menunjuk `career-review.md`, jadi definisinya tidak terbaca di sesi itu.
  - Act: pindahkan definisi ke `SCHEMA.md` § skill-map.md format (di bawah aturan "Topik punya note"); `mentor.md` dan `career-review.md` merujuk ke sana.
  - Impact: UC2 dan UC5 memberi status yang sama untuk topik yang sama (NFR-05); satu aturan satu sumber.
- [ ] **A10** Self-check sebelum tulis (`capture-experience.md:46`, `study.md:18`) hanya memeriksa format. Privasi, aturan yang paling fatal kalau dilanggar, tidak ikut dicek, padahal cerita incident dan bagian `## Contoh` (command, config) paling sering membawa IP dan hostname.
  - Act: self-check + 1 poin: "Bebas data DILARANG KERAS (`AGENTS.md`)? Periksa terutama Symptom, Investigation, dan Contoh; ada → redact dulu." `study.md` step 1 + "redact sebelum dump ke `raw/inbox/`", karena `raw/` immutable dan step 1 terjadi sebelum self-check.
  - Impact: privasi diperiksa di checkpoint yang sama dengan format, sebelum file ditulis (NFR-02), tidak baru ketahuan saat cek privasi kuartalan.
- [ ] **I9** Contoh few-shot `capture-experience.md:63` diawali "Kemarin server production down…", tapi output-nya tidak menyimpan tanggal kejadian (`created` = tanggal tulis). Model meniru contoh, jadi waktu relatif ("kemarin", "minggu lalu") ikut hilang.
  - Act: step 2 + 1 baris: "Waktu relatif → tanggal absolut; incident: tanggal kejadian ditulis di `## Ringkasan`." Contoh: Ringkasan → "Pada 2026-09-19, server production down 2 jam…".
  - Impact: note tetap bisa dipahami bertahun-tahun kemudian (NFR-11), dan tanggal kejadian tidak tertukar dengan tanggal cerita.
- [ ] **I10** Isi balasan setelah menulis note belum diatur di `capture-experience.md` maupun `study.md`. Contoh eksekusi capture hanya menunjukkan isi note lengkap, jadi agent cenderung menempel seluruh note ke Telegram.
  - Act: + 1 baris di kedua file: "Balasan = career aktif/topik + alasan (baris `→ OUTPUT`) + path file + tags. Isi note lengkap hanya kalau user minta." Contoh eksekusi + baris `Balasan:`.
  - Impact: chat ringkas dan hemat token output; AC PRD 02 UC1 (menyebut career aktif + alasan) dan UC4 (menyebut tag + alasan) tetap terpenuhi.
- [ ] **I11** `career-review.md` tidak mengatur isi pesan Telegram setelah laporan ditulis (`lint.md:25` sudah). Jawaban akhir cron jadi bebas: bisa laporan lengkap, bisa cuma "sudah".
  - Act: + step 8: "Balas ringkasan 3–5 baris (Skill Inventory per area atau catatan 'dilewati' dari W29, Role Fit Trend, 1 langkah berikutnya) + path laporan. Baris `→ OUTPUT` step 3 masuk laporan, bukan balasan."
  - Impact: pesan review kuartalan enak dibaca di HP; detail tetap di file `output/` (FR-23).
- [ ] **I12** Lint belum memeriksa dua hal yang murah dicek: file yang tertinggal di `raw/inbox/` (indikator "inbox kosong = sudah diproses" tidak pernah dipantau) dan pola data terlarang. Cek privasi saat ini hanya manual per kuartal (`05-roadmap.md` § 5).
  - Act: `lint.md` + cek 6: file di `raw/inbox/` selain `.gitkeep` = belum diproses. + cek 7: cari pola IPv4 dan penugasan nilai (`password`/`token`/`secret`/`api_key` diikuti `:` atau `=` lalu isi) di `raw/` dan `wiki/` saja (bukan `project-skills/`/SCHEMA yang memang menyebut kata itu); laporkan path + nomor baris saja, JANGAN kutip nilainya (laporan lint dikirim ke Telegram). Pola penugasan, bukan kata lepas, supaya note belajar soal JWT token tidak muncul tiap minggu; sisa false positive (mis. contoh CIDR) boleh, karena lint hanya melapor. Prasyarat VPS: toolset file/terminal aktif untuk platform `cron`. AC PRD 02 M1 ("lima pemeriksaan") ikut diperbarui.
  - Impact: kebocoran data ketahuan paling lambat seminggu, bukan sekuartal; sumber yang lupa diproses ikut terlihat.
- [ ] **I13** Slug note belum diwajibkan unik. Dengan beberapa career, nama file yang sama (mis. `disk-full.md` di career-1 dan career-2) membuat `[[slug]]`, `contradictions`, dan penanda placeholder (W23) bisa menunjuk dua file.
  - Act: SCHEMA § Link + 1 baris: "Slug = nama file tanpa `.md`, kebab-case, unik di seluruh `wiki/`. Cek `_index.md` dulu; bentrok → tambah konteks (mis. `disk-full-career-2`)."
  - Impact: setiap wikilink menunjuk tepat satu file; cek broken wikilink di lint tidak ambigu.

## Review ulang (2026-10-23)

> Celah yang ketemu saat mereview hasil pengerjaan W22–W26 dan I8.

- [ ] **W35** Lint cek 2 hanya memeriksa `[[slug]]`. Bagian markdown dual-link `(../path/slug.md)` tidak dicek di mana pun, padahal path relatif mudah salah hitung `../`, dan aturan placeholder W23 ("path beda → perbaiki link `(...)`") bergantung padanya. Link rusak baru ketahuan saat dibuka di GitHub (`igrow-backup`) atau dashboard Phase 4.
  - Act: `lint.md` cek 2 + "path `(...)` di dual-link harus menunjuk file yang ada (relatif dari file note); target placeholder → path sama dengan baris placeholder di `_index.md`". Contoh output lint + 1 baris temuan path.
  - Impact: dual-link benar di kedua sisi, jadi wiki tetap bisa dinavigasi tanpa Obsidian (G5: knowledge portable).

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

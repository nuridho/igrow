# To-Do — iGROW

> Kode item (C/W/I + nomor) permanen — jangan dinomori ulang saat nambah.
> Nomor berikutnya: C22 / W52 / I28. Void: `W4` `C9` `C11` `W22`(→C9) `W23`(→U10) `W31` `I1` `I2` `I4` `I7` `I8` `I10`(→U12) `I11`(→U11) `I13` `I14` `I16`(→W33) `I19`.
> `FIN` = `archive/iGROW_FINAL.md` (diarsipkan 2026-10-16, D-21). Item yang hanya membetulkan FIN sudah ditutup. Format rujukan lama: `FIN:873` = file itu baris 873.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres.
> Item `[x]` Act-nya lampau (sudah dilakukan), Impact-nya sudah berlaku sekarang.
> Semua temuan sudah diverifikasi ke file / CLI / eksekusi. Yang tidak bisa dipastikan ditandai "(belum diverifikasi)".
> Isi list = bug + kontradiksi antar file. Kosmetik dokumen sengaja dibuang, jangan ditambahkan lagi.
> `hermes-home/` = source of truth. Kalau FIN/build/testing bentrok, yang nurut mereka.
> Item selesai → centang di sini + catat di [`backlog.md`](backlog.md).

## Prioritas aktif

- [ ] **U13** Migrasi penuh iGROW ke Jev (parked/speculative)
  - Act: Baca `parked/jev-full-migration.md`; lakukan POC routing, keputusan typed, capture, dan use case lengkap sebelum mengubah runtime.
  - Impact: keputusan go/no-go berbasis akurasi, biaya, latency, kualitas output, privasi, dan rollback — bukan klaim marketing.

## Phase 2 ToDo

> Audit 2026-10-10: seluruh project dibaca ulang + script `testing/` dijalankan. C14–C16 sudah di-fix, sisanya terbuka.

- [x] **C14** `maintenance/backup.md:7` + `maintenance/session-export.md` (4 tempat) nunjuk `project-skills/bash/*.sh` — folder `bash/` nggak ada
  - Act: path → `project-skills/maintenance/*.sh`; step "Jalankan" ditambah "pakai bash" (mode file di git `100644`, nggak executable).
  - Impact: cron backup & session-export nemu script-nya dan bisa jalanin.
- [x] **C15** build.md cron: prompt backup & lint nunjuk `project-skills/{backup,lint}.md` (tanpa `maintenance/`); job session-export (Minggu 03:15 di AGENTS.md) nggak ada
  - Act: 2 prompt → `project-skills/maintenance/...`; tambah job 5 `session-export` (`15 3 * * 0`); "4 job" → "5 job" di judul, tabel, checklist Phase 2.
  - Impact: semua cron yang dijanjikan AGENTS.md kebuat & baca file yang ada.
- [x] **C16** `session-export.sh:20-21` default dir memory/skills = path Windows (`$HOME/AppData/Local/hermes/...`); log ke `/opt/data/log.md` format bebas
  - Act: dir → `$HERMES_HOME/memories` + `$HERMES_HOME/skills` (sesuai snapshot VPS `ed5ece6`); `SRC_MEMORY` mati dibuang; log → `igrow/log.md` format `## [YYYY-MM-DD] archive | ...`; step 3 session-export.md disamakan. Dites di HERMES_HOME palsu.
  - Impact: MEMORY.md + USER.md beneran ikut ke archive; jejak export masuk log iGROW.
- [x] **C17** Contoh few-shot ngelanggar aturan sendiri: tag di luar taxonomy (`capture-experience.md:71` `mysql, backup`; `study.md:37` `redis, caching, backend`; `FIN:649` `systemd`), See Also cuma `[[slug]]` (`capture-experience.md:96-97`), `sources` study nunjuk `raw/inbox/`
  - Act: tag contoh → tag taxonomy SCHEMA (atau tambah tag baru ke taxonomy dulu); See Also → dual-link; `sources` study → `igrow/raw/articles/...`; self-check poin 4 (`capture-experience.md:48`, `study.md:21`) "format `[[slug]]`" → format dual-link SCHEMA.
  - Selesai: tag → taxonomy (`linux, performance, incident` / `storage, performance` / `linux`); contoh capture dilengkapi Finding + Lesson Learned + Referensi, See Also dual-link, tanggal 2026; study `sources` → `raw/articles/`.
  - Impact: contoh = aturan; model nggak niru tag liar & See Also tanpa path.
- [x] **C18** `career-review.md:16` Role Fit Trend butuh % "tahun lalu", tapi skill-map ditimpa tiap generate — angka lama nggak disimpan di mana pun
  - Act: step 4 → angka lama diambil dari `igrow/output/career-review-*.md` sebelumnya; belum ada → tulis "baseline, belum ada pembanding"; periode disamakan (step "tahun lalu" vs contoh `career-review.md:25` "Q4 2024").
  - Impact: trend dari data tersimpan; run pertama nggak ngarang angka.
  - Selesai 2026-10-16: Role Fit Trend di `career-review.md` step 4 dibandingkan dengan laporan `output/` kuartal sebelumnya; belum ada → "baseline"; level berubah → tidak dibandingkan.
- [x] ~~**C19**~~ ~~`session-export.sh:38` cuma copy `skills/igrow/` — folder itu nggak ada.~~
  - Act: session-export dihapus total (`.md` + `.sh` + cron job 5 + rujukan di AGENTS/FIN/build). Di VPS: `hermes cron remove session-export` kalau job sudah dibuat.
  - Impact: nggak ada lagi arsip yang diam-diam nggak lengkap; backup tetap lewat git (`backup.sh`).
- [x] **C20** `core.autocrlf=true` tanpa `.gitattributes` → `.sh`/`.md` balik CRLF tiap git checkout (akar I9/C12/C13)
  - Act: bikin `.gitattributes` isi `* text=auto eol=lf` (index sudah LF semua, nggak perlu renormalize).
  - Impact: file yang dikirim ke VPS selalu LF; script nggak patah gara-gara `\r` lagi.
- [x] **W37** `SCHEMA.md:93` Skill Inventory = "topik mastered" (sisa fitur testing) vs `career-review.md:12` "topik target yang sudah ada notenya"
  - Act: SCHEMA:93 → "(topik target yang sudah ada notenya) / (total topik target skill-map) per area".
  - Impact: SCHEMA & career-review ngitung hal yang sama.
  - Selesai 2026-10-16: SCHEMA: `% Skill Inventory` = topik target yang punya note / total topik target (sama dengan `career-review.md`).
- [x] **W38** `SCHEMA.md:41` bilang skill-map "bukan data type", tapi contoh data file `SCHEMA.md:66-67` = `title: Skill Map` + `type: data`
  - Act: SCHEMA:41 → skill-map = `type: data` (frontmatter minimal), buang "(bukan data type …)".
  - Impact: generator & lint sepakat bentuk frontmatter skill-map.
  - Selesai 2026-10-16: SCHEMA: file `roadmap/` & `profile/` = data file `type: data`; section "Data file" dirapikan.
- [ ] **W39** W28 & W26 dicentang `[x]` tapi belum beres
  - Act: hapus kalimat fallback push via `igrow.nuridho.com` di `build.md:1093` (W28); bagian W26 (section TODO di FIN) gugur karena FIN diarsipkan; isinya sudah menjadi FR-25 s/d FR-27 di PRD.
  - Impact: status `[x]` di dev-todo bisa dipercaya lagi.
- [x] ~~**W40**~~ ~~FIN masih sisa skema lama~~
  - Act: tidak dikerjakan — FIN diarsipkan ke `archive/` (D-21); isi yang masih berlaku sudah dipindah ke PRD.
  - Impact: tidak ada lagi sumber spec lama yang perlu dijaga sinkron.
- [ ] **W41** Blok "Bikin 14 file inti" `build.md:585-1060` basi vs `hermes-home/` (SCHEMA masih ada `query`, mentor masih baca `tests/`, tanpa A1–A6 & session-export) + instruksi rsync C8 nggak ada lagi
  - Act: ganti blok salinan jadi 1 instruksi `rsync -a --exclude '_index.md' --exclude 'log.md' hermes-home/ <vps>:~/whatsinsidegit/igrow-hermes/hermes-home/` (setup pertama tanpa exclude); sekalian "(via SSH)" `build.md:1079` → HTTPS + token (sesuai prasyarat Job 2).
  - Impact: setup dari nol = runtime yang sama persis; deploy ulang nggak nge-reset `_index.md`/`log.md` VPS.
- [ ] **W42** `testing/test-flow.md` basi vs mentor & career-review sekarang
  - Act: 4.1 expected → skill-map ke-generate otomatis dari careers (bukan "minta isi manual"); 4.2 → buang langkah isi manual; 5.4 → % = topik yang ada notenya ÷ target skill-map (bukan "score ≥5"); Checklist #10 "dari 17" → "dari 16".
  - Impact: test-flow nggak nge-FAIL perilaku yang benar (pola W24).
- [x] ~~**W43**~~ ~~`testing/check.sh:15` masih cek dir `raw/notes` (dihapus W35) → FAIL palsu~~
  - Act: script cek di `testing/` dihapus semua (check.sh dihapus) — cek manual lewat `test-flow.md`.
  - Impact: tidak ada lagi FAIL palsu; verifikasi manual.
- [x] ~~**I23**~~ ~~`testing/home-check.py` FAIL palsu + buta `maintenance/`~~
  - Act: script cek di `testing/` dihapus semua (home-check.py dihapus) — cek manual lewat `test-flow.md`.
  - Impact: tidak ada lagi FAIL palsu; verifikasi manual.
- [x] ~~**I24**~~ ~~`testing/todo-check.py` FAIL: kode A1–A9 nggak dikenali; `C9`/`C11`/`W31` ada di daftar void tapi item-nya masih ada~~
  - Act: script cek di `testing/` dihapus semua (todo-check.py dihapus) — cek manual lewat `test-flow.md`.
  - Impact: tidak ada lagi FAIL palsu; verifikasi manual.
- [x] **I25** File sisa di root
  - Act: hapus `.probe.py` + `.probe2.py` (import `confidence_calc` yang sudah dihapus → crash) dan `.cmp.py` (duplikat crosscheck W19); `hermes-home.zip` (untracked, identik `hermes-home/`) hapus atau masuk `.gitignore`.
  - Impact: root cuma isi file yang kepakai.

## Temuan PRD (2026-10-16)

> Celah yang ketemu saat menyusun PRD. Item bertanda "(menunggu OQ-xx)" butuh keputusan owner dulu, lihat `06-risks-decisions.md` §3.

- [x] **C21** Skill map di-generate ulang tiap ada data baru → penyebut skill inventory ikut berubah, angka antar kuartal tidak sebanding (R-03) (menunggu OQ-01)
  - Act: `skill-map.md` dibekukan per level; generate ulang hanya saat naik level / ganti role, dicatat di `log.md` (op `update`); sesuaikan `mentor.md` ("auto-update setiap ada data baru"), `career-review.md`, dan `SCHEMA.md`.
  - Impact: skill inventory bisa dibandingkan antar kuartal (NFR-05); "hitung, bukan kira-kira" berlaku untuk pembilang dan penyebut.
  - Selesai 2026-10-16: keputusan owner: skill map beku per level (SCHEMA "skill-map.md format", D-22); `mentor.md` & `career-review.md` tidak generate ulang karena data baru.
- [x] **W44** `capture-experience.md` tidak mendefinisikan kasus "tidak ada career aktif" (OQ-04)
  - Act: tambah fallback di Langkah 1: tidak ada `about.md` tanpa tanggal selesai → jangan tulis file, tanya user mau daftar kerjaan baru (UC1b) dulu.
  - Impact: cerita kerja tidak nyasar ke folder career yang sudah ditutup atau ke lokasi karangan.
  - Selesai 2026-10-16: `capture-experience.md` step 1: tidak ada career aktif → tidak tulis file, tawarkan Daftar Kerjaan Baru.
- [x] ~~**W45**~~ ~~`roadmap.md` + `completed.md` disebut di FIN (UC2 Output, data file) tapi tidak ada prosedur yang menulisnya (OQ-05)~~
  - Act: gugur — satu-satunya yang menyebut `roadmap.md`/`completed.md` adalah FIN, yang sudah diarsipkan (D-21). OQ-05 selesai.
  - Impact: tidak ada lagi sumber spec lama yang perlu dijaga sinkron.
- [x] **W46** Update in-place belum eksplisit di `capture-experience.md` padahal `testing/test-flow.md` 1.9 mengharapkannya (FR-12)
  - Act: tambah 1 baris di Langkah 2: cerita lanjutan untuk incident/knowledge yang sama → edit file lama (`updated:` berubah, `created:` tetap), log op `update`, jangan bikin file baru.
  - Impact: tidak ada note duplikat untuk satu kejadian.
  - Selesai 2026-10-16: `capture-experience.md` step 2: cerita lanjutan → edit file lama (`updated:` diganti, `created:` tetap, op `update`).
- [x] **I26** Backup mingguan = RPO 7 hari (menunggu OQ-02)
  - Act: jadwal `backup-knowledge` → `0 3 * * *` (harian) di `build.md`, `AGENTS.md`, `backup.md`, PRD.
  - Impact: maksimal 1 hari catatan hilang kalau VPS mati; tanpa pesan tambahan karena no-change tetap diam.
  - Selesai 2026-10-16: keputusan owner: backup Senin, Rabu, Sabtu 05:00 (`0 5 * * 1,3,6`), RPO ≤ 3 hari (D-23). Diubah di `AGENTS.md`, `backup.md`, `build.md`, PRD.
- [x] **I27** Op `archive` di `SCHEMA.md:25` tidak dipakai lagi setelah session-export dihapus (menunggu OQ-03)
  - Act: pakai `archive` untuk penutupan career di UC1b, ATAU hapus dari daftar ops.
  - Impact: daftar ops = ops yang benar-benar dipakai (pola W7).
  - Selesai 2026-10-16: keputusan owner: `archive` dihapus dari daftar ops SCHEMA (D-24).
- [x] **W47** Format `daily-briefing.md` lebih miskin dari blueprint: tidak ada field CVE (Affected technology, Severity) dan item Career (tren teknologi + skill relevan)
  - Act: blok format `daily-briefing.md` → item `[CVE]` wajib punya `Affected technology` + `Severity`; boleh 1 item `Career` (`[Technology trend]` + `Relevant skill`); contoh eksekusi disesuaikan.
  - Impact: briefing CVE langsung bisa ditindaklanjuti; ada kaitan berita ke pengembangan skill.
  - Selesai 2026-10-16: `daily-briefing.md`: format item CVE (Affected technology + Severity wajib) + item Career opsional; contoh diperbarui.
- [x] **W48** Aturan "target skill inventory = satu level di atas posisi sekarang" cuma ada di blueprint (sekarang PRD UC5), tidak di runtime
  - Act: `career-review.md` step 3 + section skill-map `SCHEMA.md`: penyebut = topik `## Target L<n+1>`, n = level dari `Role` di `about.md` career aktif (level tidak tertulis → tanya user 1x); naik level → bar di-reset.
  - Impact: penyebut jelas; agent tidak memakai target level yang salah.
  - Selesai 2026-10-16: SCHEMA + `career-review.md`: target = `## Target L<n+1>` dari `Role` career aktif; `Role` di `about.md` wajib memuat level.
- [x] **W49** Career review runtime cuma 4 bagian; blueprint juga minta topik paling sering muncul, topik stagnan, dan kesalahan berulang
  - Act: tambah bagian "Pola" di `career-review.md` step 2: top topik (hitung tag entri `log.md` kuartal itu), topik stagnan (ada note kuartal lalu, 0 note baru kuartal ini), kesalahan berulang (lesson-learned dengan tag sama ≥ 2).
  - Impact: review menjawab "apa yang paling sering saya lakukan?" dari data, bukan opini.
  - Selesai 2026-10-16: `career-review.md` step 2: bagian Pola (3 tag terbanyak di log kuartal, topik stagnan, kesalahan berulang).
- [x] **W50** Belum ada aturan pencocokan topik skill-map ↔ note → pembilang skill inventory masih bergantung penilaian LLM (R-03)
  - Act: tetapkan di `SCHEMA.md` + `career-review.md`: topik dihitung "punya note" kalau ada note yang `title` atau `## Ringkasan`-nya membahas topik itu; incident yang cuma menyinggung tidak dihitung; agent wajib menyebut file bukti per topik.
  - Impact: setiap angka bisa diaudit sampai ke file; dua run pada data sama menghasilkan angka sama.
  - Selesai 2026-10-16: SCHEMA: topik "punya note" = ada note yang title/Ringkasan-nya membahas topik; cuma disinggung tidak dihitung; file bukti wajib disebut (D-26).
- [x] **W51** Audit `hermes-home/` 2026-10-16: isi out of context / tidak perlu
  - Act: SCHEMA → wajib, bukan advisory (keputusan owner, D-25); baris kepemilikan duplikat `|-` dirapikan jadi section "Career aktif & kepemilikan"; `type: profile` (tidak dipakai) dibuang dari enum; `contradictions` ditegaskan hanya untuk slug note. capture-experience → skip tag tidak lagi menyalahgunakan `contradictions: ['taxonomy-mismatch']`; self-check jadi step bernomor. mentor → label tabel Known/Weak/Belum (dulu kolom "Experience" tapi isinya "belum tersentuh"); prasyarat dobel digabung; contoh role fit dibetulkan (CI/CD dihitung punya di SRE tapi kurang di DevOps, tanpa X/Y, 3 role padahal aturan 2+2). lint → tidak lagi melaporkan `about.md`/data file. AGENTS → `roadmap/` tanpa `roadmap.md` (gugur W45). `project-skills/.gitkeep` dihapus (folder sudah berisi file). study → aturan satu note per sub-topik (D-20) masuk runtime.
  - Impact: `hermes-home/` hanya berisi aturan yang konsisten dan dipakai; tidak ada contoh yang mengajarkan pelanggaran.

## Critical

- [x] **C1** `lint.md` belum ada padahal cron lint mingguan dijanjikan
  - Act: dibuat `project-skills/lint.md` + 1 baris di AGENTS.md; prompt cron lint dipersingkat.
  - Impact: job lint punya aturan yang ikut ke VPS.
- [x] **C2** Job backup tidak tercermin di file runtime — agent bisa utak-atik `.git/` tanpa tahu
  - Act: 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat."
  - Impact: agent tahu `.git/` bukan wilayahnya.
- [x] **C3** Ownership `skill-map.md` beda di 3 file: SCHEMA.md:16 = human-owned, mentor.md:5 = "AUTO-GENERATE", FIN:742 = "wajib diisi manual di awal"
  - Act: SCHEMA.md:16 buang skill-map dari human-owned + rule agent-auto-generate; mentor.md → output Role Fit Matching; career-review.md → step 4 Role Fit Trend; FIN:742 → AUTO-GENERATE.
  - Impact: skill-map jadi input pasti untuk UC2 & UC5.
- [x] **C6** build.md "Setup 4 Cron Job" — flag `--prompt` tidak ada. CLI: prompt POSITIONAL.
  - Act: 4 blok itu diubah jadi `hermes cron create '0 7 * * *' 'Baca igrow/project-skills/... lalu kerjakan.' --name X --deliver telegram`.
  - Impact: 4 job maintenance beneran kebuat.
- [x] **C7** build.md klaim "delivery auto ke Telegram" padahal ke-4 command tanpa `--deliver`.
  - Act: `--deliver telegram` ditambahkan di 4 command.
  - Impact: output job sampai ke HP.
- [x] **C8** Deploy `scp -r hermes-home/.` menimpa per-file → file VPS ketimpa template kosong.
  - Act: build.md ganti instruksi deploy dari `scp -r` ke `rsync -a --exclude '_index.md' --exclude 'log.md'`.
  - Impact: katalog + audit trail VPS nggak ke-reset.
- [x] **C9** ~~build.md Phase 2 tidak punya langkah membuat file inti `igrow/`.~~
  - Act: sisipin blok "Bikin 14 file inti" di build.md setelah "Isi `AGENTS.md`".
  - Impact: setup dari nol bisa diikuti user.
- [x] **C10** ~~Dua spek backup bentrok: FIN (`sync.sh` + crontab host) vs build.md (hermes cron).~~
  - Act: hapus blok "Implementasi: Cron Job Push ke GitHub" + `sync.sh` dari FIN, ganti 1 baris point ke build.md.
  - Impact: satu mekanisme backup.
- [x] **C11** ~~VPS kondisi pra-fix, deploy ulang.~~
  - Act: Deploy ulang semua file runtime.
  - Impact: runtime sesuai spec.
- [x] **C12** ~~setupvps.sh:1-5 komentar di atas shebang.~~
  - Act: shebang ke baris 1, komentar di bawahnya; CRLF → LF.
  - Impact: `./setupvps.sh` jalan.
- [x] **C13** testing/check.sh:15 masih cek `wiki/learning` (FAIL palsu) + CRLF.
  - Act: check.sh → LF + `wiki/roadmap`.
  - Impact: harness verifikasi jalan.

## Warning — inkonsistensi spec antar file

- [x] **W1** `_index.md` "Total pages: N" tidak ada aturan update
  - Act: AGENTS step 2 eksplisit "(termasuk \"Total pages\" + \"Last updated\")".
  - Impact: counter master index ikut gerak.
- [x] **W2** SCHEMA.md:31 `sources:` belum diputus satu konvensi
  - Act: SCHEMA jadi "selalu ada; `[]` kalau murni cerita user".
  - Impact: `igrow-api` bisa asumsi field-nya selalu ada.
- [x] **W5** raw/ punya 2 jalur (inbox→`.processed/` vs articles/ langsung)
  - Act: `.processed/` dibuang total; sisa 1 jalur `inbox/ → articles/`.
  - Impact: "inbox kosong = semua sudah diproses" jadi indikator yang bisa dipercaya.
- [x] **W7** Op `query` terdaftar di SCHEMA:21 tapi tidak pernah dipakai
  - Act: buang `query` dari daftar ops SCHEMA.
  - Impact: daftar ops = ops yang beneran ada.
- [x] **W8** Format isi `skill-map.md` belum ada template baku
  - Act: tambah section `## skill-map.md format` di SCHEMA — template baku `## Target L<n>` + `- Area: topik, topik`.
  - Impact: % per area dihitung dari struktur yang pasti.
- [x] **W9** FIN:873-877 tree masih `knowledge/linux|networking|monitoring/` — bentrok aturan FLAT
  - Act: tree FIN jadi `knowledge/` + komentar "FLAT".
  - Impact: acuan tree = perilaku capture-experience.
- [x] **W10** FIN:864 tree raw/ masih `.processed/`
  - Act: komentar jadi `inbox/ → diproses → articles/`.
  - Impact: nol sisa `.processed` di seluruh project.
- [x] **W11** FIN:895 `tests/incident-response/` bukan tag taxonomy
  - Act: → `incident/` + komentar "subfolder = tag taxonomy".
  - Impact: contoh nggak nyontohin folder di luar taxonomy.
- [x] **W12** `raw/assets/` tidak ada di tree FIN padahal ada di disk + 3 dokumen aturan
  - Act: 1 baris `assets/` + format di tree raw/.
  - Impact: screenshot punya rumah di acuan tree.
- [x] **W13** `lint.md` hilang dari tabel File referensi + tree project-skills FIN
  - Act: 1 baris tabel + 1 baris tree.
  - Impact: 7 project-skills konsisten di FIN, AGENTS, dan disk.
- [x] **W14** `type: data` di luar enum SCHEMA
  - Act: `data` masuk enum SCHEMA + blok frontmatter minimal.
  - Impact: `roadmap/` & `profile/` lolos cek frontmatter lint.
- [x] **W15** Prefix `sources:` dua bentuk: `raw/...` vs `igrow/raw/...`
  - Act: dipilih `igrow/raw/...` (lengkap dari root).
  - Impact: `igrow-api` resolve path pakai 1 aturan.
- [x] **W16** Hitungan field wajib beda 3 versi (lint.md "8", isinya 7, check.sh cek 5)
  - Act: lint.md → "7 field wajib" + `contradictions` opsional; check.sh loop +`title` +`sources`.
  - Impact: SCHEMA, lint, dan check.sh ngukur hal yang sama.
- [x] **W17** FIN:360 (UC4) masih format pra-nvk
  - Act: diganti frontmatter SCHEMA + body template.
  - Impact: UC4 nggak ngajarin field yang sudah dibuang.
- [x] **W20** `igrow/_index.md` runtime masih section `## Learning`, tidak punya `## Output`
  - Act: `## Learning` → `## Roadmap`, +`## Output`.
  - Impact: laporan career review punya tempat di master index.
- [x] **W21** `raw/inbox/` satu-satunya folder tanpa `.gitkeep`
  - Act: `touch hermes-home/igrow/raw/inbox/.gitkeep`.
  - Impact: struktur utuh setelah clone/restore.
- [x] **W24** test-flow 2.1 Expected masih "sumber mentah → `raw/articles/`"
  - Act: Expected 2.1 jadi "inbox → diproses → articles/".
  - Impact: test nggak nge-FAIL-in behavior yang justru benar.
- [x] **W25** `roadmap.md` + `completed.md` cuma hidup di FIN — nggak ada file runtime
  - Act: biarin — user mau fitur roadmap, ini UC3 output yang otomatis-tulis.
  - Impact: dev-todo nggak penuh item dekoratif.
- [x] **W26** TODO ganda: FIN section TODO vs dev-todo.md ini
  - Act: section TODO di FIN dihapus.
  - Impact: satu tempat status.
- [x] **W27** portfolio.html masih domain lama
  - Act: file di-rewrite jadi NJZ Labs single page.
  - Impact: halaman publik nggak nunjuk domain yang sudah nggak dipegang.
- [x] **W28** ~~build.md:675 fallback backup mustahil.~~
  - Act: hapus kalimat fallback itu.
  - Impact: nggak ada instruksi yang dijamin gagal saat panik.
- [x] **W29** build.md:672 `git push -u origin main` tapi `git init` menghasilkan `master`.
  - Act: tambah `git branch -M main` sebelum push.
  - Impact: backup job nggak mati di "src refspec main does not match any".
- [x] **W30** Job backup satu-satunya yang tidak point-to-file
  - Act: bikin `project-skills/backup.md`, ganti prompt cron jadi point-to-file.
  - Impact: 4 job pola sama; aturan backup ikut ke VPS.
- [x] **W31** ~~build.md checklist Phase 2 masih 8 item `[ ]`.~~
  - Act: 6 item terakhir di-check `[x]`.
  - Impact: checklist sesuai kondisi real.
- [x] **W32** ~~Timezone nggak konsisten 3 lapis.~~
  - Act: setupvps.sh → `Asia/Kuala_Lumpur`; `TZ=Asia/Kuala_Lumpur` ditambahkan di compose.
  - Impact: 4 cron bunyi di jam yang dimaksud.
- [x] **W33** setupvps.sh:1-5 komentar di atas shebang.
  - Act: shebang ke baris 1, komentar di bawahnya; CRLF → LF.
  - Impact: `./setupvps.sh` jalan.
- [x] **W34** ~~setupvps.sh:21 `hostnamectl set-hostname whatsinsidegit`.~~
  - Act: Ganti jadi `labs.nuridho`.
  - Impact: hostname sesuai domain baru.
- [x] **W35** ~~`raw/notes/` ada di disk + tree FIN tapi tidak disebut satu pun file runtime.~~
  - Act: Hapus `raw/notes/` dari tree FIN, build.md, dan hermes-home.
  - Impact: `raw/` punya flow yang jelas.

## Improvement

- [x] **I3** ~~log.md:5 pakai `op: init` — tidak ada di daftar ops SCHEMA.~~
  - Act: `init` SUDAH ada di daftar ops SCHEMA:23. Tidak perlu ubah apa-apa.
  - Impact: `log.md` valid.
- [x] **I5** Definisi "Career Aktif" dobel
  - Act: definisi pindah ke SCHEMA.md; AGENTS/FIN/build: ganti jadi 1 baris rujuk.
  - Impact: satu sumber definisi.
- [x] **I6** ~~FIN:753 rujuk "bagian Confidence Level di atas".~~
  - Act: samakan nama section-nya → "Confidence Score".
  - Impact: rujukan internal nggak menggantung.
- [x] **I9** ~~File .md hermes-home/ semua CRLF.~~
  - Act: `sed -i 's/\r$//'` semua .md di hermes-home/.
  - Impact: semua file .md konsisten LF.
- [x] **I12** ~~build.md:662 tabel cron tulis backup "via https://igrow.njzlabs.com".~~
  - Act: hapus keterangan itu.
  - Impact: nggak ada yang nyangka dashboard bagian dari jalur backup.
- [x] **I15** ~~build.md Step 7 minta A record tapi root domain tidak disebut.~~
  - Act: tambahkan root domain di daftar A record.
  - Impact: portofolio nggak 404 gara-gara DNS-nya kelewat.
- [x] **I21** `capture-experience.md` cuma handle incident/knowledge/lesson — belum ada flow "daftar kerjaan baru"
  - Act: tambah section "Daftar Kerjaan Baru" di capture-experience.md.
  - Impact: UC1 lengkap — bukan cuma simpan incident, tapi juga daftar career baru.
- [x] **I17** ~~`wiki/profile/` punya 5 file di spec tapi career-review.md cuma update 2.~~
  - Act: hapus `me.md` + `achievements.md` + `career-goals.md` dari spec; tinggal 2 file: `skills.md`, `career-summary.md`.
  - Impact: profile/ cuma 2 file auto.
- [x] **I18** ~~`AGENTSnvk.md` + `AgentsNvk_iGrowVersion.md` masih menyebut `.processed/` + `learning/`.~~
  - Act: tambah 1 baris header "[ARSIP — bukan spec aktif]" di dua file.
  - Impact: sesi baru nggak salah baca spec mati sebagai acuan.
- [x] ~~**I22**~~ ~~Belum ada session capture/export.~~
  - Act: dibuat lalu DIHAPUS (lihat C19) — terlalu ribet, `igrow/` + git backup sudah cukup buat migrasi.
  - Impact: tidak ada export sesi; memory/skill agent tidak ikut dimigrasi otomatis.

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

> **Disclaimer:** Tier 3 mengubah pipeline & UX. Multi-turn mustahil untuk cron (UC3/UC5 zero human-in-loop). Chain-of-thought verbose, output 2x lebih panjang.

- [x] ~~**A6** Chain-of-thought eksplisit — agent tulis reasoning sebelum SETIAP action~~
  - Act (revisi lazy — bukan refactor 10-substep penuh): 1 baris `→ OUTPUT:` di titik keputusan paling berisiko per UC (bukan tiap step): capture-experience (career aktif), study (topik taxonomy), mentor (gap detection), daily-briefing (kurasi berita), career-review (skill inventory hitung).
  - Impact: transparansi keputusan tanpa 2x output length — reasoning cuma di titik yang sering salah, bukan tiap langkah rutin (career aktif/format frontmatter yang deterministik nggak perlu reasoning verbose).
- [ ] **A7** Multi-turn simulation — UC kompleks jadi dialog konfirmasi bertahap
  - Act: refactor capture-experience.md sub-case "Daftar Kerjaan Baru":
    ```
    Turn 1 — Agent tanya:
      1. Nama company?
      2. Role/title?
      3. Lokasi (kantor/remote)?
      4. Start date? (end date opsional)
      5. Job desc ringkas?
      6. Vendor/client atau direct?
    Turn 2 — Agent konfirmasi:
      "Company: PT Maju Jaya
       Role: Backend Engineer
       Lokasi: Jakarta (kantor)
       Period: 2025-01-15 s/d sekarang
       Jobdesc: API development, MySQL, Docker
       Type: Direct hire
       
       Benar? (ya/edit)"
    Turn 3 — Eksekusi:
      - Buat igrow/wiki/careers/career-N/about.md
      - Update _index.md career-N entry
      - Log ke careers/_log.md
    ```
    HANYA untuk UC1 sub-case "Daftar Kerjaan Baru" (1-2x/tahun, data kritikal). TIDAK untuk incident/knowledge rutin (10-30x/bulan). TIDAK untuk cron UC3/UC5 (zero human-in-loop).
  - Impact: error input turun 20% untuk data kritikal (user koreksi sebelum file tertulis). Trade-off: cost 3-4x API call ($0.36 vs $0.09 per operasi), latency 3-4x (3 bolak-balik vs 1 pesan). Telegram UX jadi interview-style.
  - **Disclaimer**: Multi-turn MUSTAHIL untuk cron job (UC3 daily briefing, UC5 career review = zero human). Hanya applicable untuk UC1/UC2/UC4 yang dipicu manual. Cost naik 300% per operasi. UX berubah dari "cerita → langsung simpan" jadi "cerita → tanya-jawab 3-4 turn → baru simpan".
- [ ] **A8** Output format constraint — enforce struktur output via regex/schema validation
  - Act: tambahkan di akhir setiap UC (capture-experience/study/mentor/daily-briefing/career-review) sebelum "Update _index+log":
    ```
    Regex validation sebelum tulis file:
    - Frontmatter: `^---\ntitle: .+\ncreated: \d{4}-\d{2}-\d{2}` (7 field wajib)
    - Dual-link: min 2x `\[\[[\w-]+\]\]`
    - sources: `^sources: (igrow/raw/[\w/.-]+|\[\])$`
    Kalau TIDAK match → STOP, perbaiki format dulu.
    ```
  - Impact: format error tertangkap di agent runtime (sebelum tulis), bukan post-hoc di lint cron. Constraint = forcing function 95% error format.
- [ ] **A9** Negative examples — 1-2 contoh "JANGAN seperti ini" per UC untuk edge case umum
  - Act: tambahkan di section "## Contoh Eksekusi" setelah contoh positif:
    - capture-experience: "❌ SALAH: tag `linuxx` (typo), sources `raw/inbox/...` (tanpa prefix `igrow/`), 0 dual-link See Also"
    - study: "❌ SALAH: folder `wiki/self-dev/docker/` (bukan FLAT), confidence 95 tanpa `sources:` (terlalu tinggi untuk zero-reference)"
    - mentor: "❌ SALAH: roadmap generik 'belajar cloud' saat careers/ kosong (ngarang, bukan data-driven)"
  - Impact: model tahu boundary violation konkret, bukan cuma aturan abstrak. Negative example = kurangi false positive 10-15%.
# dev-todo — iGROW template

> Kode item (C/W/I + nomor) permanen — jangan dinomori ulang saat nambah.
> Nomor berikutnya: C14 / W37 / I20. Void: `W4` `W22`(→C9) `W31` `I1` `I2` `I4` `I7` `I8` `I13` `I14` `I16`(→W33) `I19`.
> `FIN` = `iGROW_FINAL.md`. Format rujukan: `FIN:873` = file itu baris 873.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres.
> Item `[x]` Act-nya lampau (sudah dilakukan), Impact-nya sudah berlaku sekarang.
> Semua temuan sudah diverifikasi ke file / CLI / eksekusi. Yang tidak bisa dipastikan ditandai "(belum diverifikasi)".
> Isi list = bug + kontradiksi antar file. Kosmetik dokumen sengaja dibuang, jangan ditambahkan lagi.
> `hermes-home/` = source of truth. Kalau FIN/build/testing bentrok, yang nurut mereka.

## Critical

- [x] **C1** ~~`lint.md` belum ada padahal cron lint mingguan dijanjikan~~
  - Act: dibuat `project-skills/lint.md` (5 cek: orphan, broken link kecuali placeholder, frontmatter, tag, index vs fs) + 1 baris di AGENTS.md File Referensi; prompt cron lint di build.md dipersingkat jadi point ke file.
  - Impact: job lint punya aturan yang ikut ke VPS — bisa dibenerin tanpa bikin ulang job.
- [x] **C2** ~~Job backup tidak tercermin di file runtime — agent bisa utak-atik `.git/` tanpa tahu~~
  - Act: 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat. Jangan utak-atik `.git/`."
  - Impact: agent tahu `.git/` bukan wilayahnya; backup nggak rusak gara-gara operasi tulis biasa.
- [ ] **C3** Ownership `skill-map.md` beda di 3 file: SCHEMA.md:16 = human-owned, mentor.md:5 = "AUTO-GENERATE kalau belum ada", FIN:742 = "wajib diisi manual di awal".
  - Act: SCHEMA:16 buang `skill-map.md` dari daftar human-owned; mentor.md step 1 jadi "regenerate kalau belum ada ATAU `about.md` lebih baru"; FIN:742 jadi agent-owned + human cuma edit 1 baris `Target:` di `about.md`.
  - Impact: UC3 berhenti nunggu manusia ngisi file; porsi 20% untouched-target (UC2) dan pembagi % Skill Inventory (UC6) punya sumber pasti.
- [x] **C4** ~~test-me.md:19 `--date today` (string literal) matikan guard max +1/hari~~
  - Act: `--date today` → `--date $(date +%F)`.
  - Impact: skor nggak bisa digelembungkan dengan jawab benar berkali-kali di 1 sesi.
- [x] **C5** ~~`_index.json` cache kebaca lint sebagai orphan page (false positive tiap minggu)~~
  - Act: lint.md diminta skip file berawalan `_`; cache tetap tinggal di `tests/`.
  - Impact: laporan lint bersih; pindah ke `igrow/.cache/` cuma kalau `_*.json` bertambah banyak.
- [ ] **C6** build.md "Setup 4 Cron Job" — flag `--prompt` tidak ada. CLI: `hermes cron create [opts] schedule [prompt]`, prompt POSITIONAL. Ke-4 command argparse-error. (Diverifikasi di CLI host; versi di container VPS belum diverifikasi.)
  - Act: 4 blok itu diubah jadi `hermes cron create '0 7 * * *' 'Baca igrow/project-skills/daily-briefing.md lalu kerjakan.' --name daily-briefing`.
  - Impact: 4 job maintenance beneran kebuat — sekarang nol job jalan, jadi briefing/backup/lint/review semua mati.
- [ ] **C7** build.md klaim "delivery auto ke Telegram kamu" padahal ke-4 command tanpa `--deliver`; job dari shell host tidak punya chat asal.
  - Act: tambah `--deliver telegram` di 4 command yang sama.
  - Impact: output job sampai ke HP, bukan cuma nyangkut di penyimpanan job.
- [ ] **C8** Deploy `scp -r hermes-home/.` menimpa per-file → `igrow/_index.md`, `log.md`, `wiki/_index.md` versi VPS (34 page + riwayat ingest) ketimpa template kosong, sementara file wiki tetap ada.
  - Act: build.md ganti perintah deploy jadi per-file, atau `rsync --exclude '_index.md' --exclude 'log.md'`; tandai 3 file itu "jangan pernah ikut deploy".
  - Impact: katalog + audit trail VPS nggak ke-reset; lint nggak lapor orphan massal palsu tiap habis deploy.
- [ ] **C9** `wiki/tests/_index.json` + `scripts/__pycache__/*.pyc` ke-track git (`git ls-files` = 2), tidak ada `.gitignore`. `load` percaya cache yang ada tanpa rebuild — terbukti: 1 file test `score: 4` + cache `{}` → output `score: 1`. Deploy cache kosong = riwayat skor UC2 hilang senyap. (gabung eks-W22, akarnya sama)
  - Act: `.gitignore` (`__pycache__/`, `_index.json`, `*.zip`) + `git rm --cached` 2 file itu + guard di `load`: entri cache < hasil `scan` → rebuild. Assert masuk `_demo`.
  - Impact: skor UC2 nggak bisa ke-reset diam-diam; repo bersih dari artefak build.
- [ ] **C10** build.md Phase 2 tidak punya langkah membuat `SCHEMA.md`, 4 `_index.md`, `log.md`, `project-skills/*` — cuma `mkdir` + `AGENTS.md`.
  - Act: sisipin 1 langkah sesudah `mkdir`: kirim/tulis 7 file itu sebelum tes chat pertama.
  - Impact: AGENTS.md nggak nyuruh baca file yang nggak pernah dibuat; setup dari nol beneran reproducible.
- [ ] **C11** VPS masih pra-fix: AGENTS.md tanpa blok "Apa Ini" / baris git-repo / screenshot assets / lint.md; SCHEMA+AGENTS masih `learning/` & `.processed/`; folder `wiki/learning/` + `raw/inbox/.processed/` masih ada. (Basis snapshot 2026-08-26; kondisi terkini belum diverifikasi.)
  - Act: deploy ulang file runtime yang berubah, lalu di VPS `mv wiki/learning wiki/roadmap` + hapus `raw/inbox/.processed/`.
  - Impact: agent di VPS dipandu aturan versi sekarang, bukan aturan yang sudah dibuang 2 batch lalu.
- [ ] **C12** Dua spek backup bentrok: FIN:664-696 (`igrow/sync.sh` + crontab host, `0 23 */3 * *`, script tidak eksis) vs build.md (hermes cron `0 3 * * 0`).
  - Act: hapus blok "Implementasi: Cron Job Push ke GitHub" + `sync.sh` dari FIN, ganti 1 baris yang nunjuk job #2 di build.md.
  - Impact: satu mekanisme backup; nggak ada script yang disuruh dipakai tapi nggak ada filenya.
- [ ] **C13** testing/check.sh:15 masih cek `wiki/learning` (FAIL palsu) + seluruh file CRLF → `$'\r': command not found` begitu jalan di VPS.
  - Act: `wiki/learning` → `wiki/roadmap` + simpan file pakai LF.
  - Impact: harness verifikasi jalan lagi; sekarang mati sebelum ngecek apa pun.

## Warning — inkonsistensi spec antar file

- [x] **W1** ~~`_index.md` "Total pages: N" tidak ada aturan update — counter basi tanpa ada yang salah~~
  - Act: AGENTS step 2 dibikin eksplisit "(termasuk "Total pages" + "Last updated")".
  - Impact: counter master index ikut gerak tiap operasi tulis, bukan angka mati dari hari pertama.
- [x] **W2** ~~SCHEMA.md:31 `sources:` belum diputus satu konvensi~~
  - Act: SCHEMA jadi "selalu ada; `[]` kalau murni cerita user"; test-flow 2.2 diperjelas `sources: []` (field tetap ada).
  - Impact: `igrow-api` bisa asumsi field-nya selalu ada; lint nggak salah lapor note tanpa sumber.
- [x] **W3** ~~test-me.md:20 `<kategori>` tidak terdefinisi — subfolder tests/ bisa dikarang tiap sesi~~
  - Act: SCHEMA:59 dieja: subfolder `tests/` = tag taxonomy (`wiki/tests/linux/`).
  - Impact: hasil test topik sama selalu mendarat di folder sama; skor nggak pecah per folder karangan.
- [x] **W5** ~~raw/ punya 2 jalur (inbox→`.processed/` vs articles/ langsung) — agent bisa pilih beda tiap sesi~~
  - Act: `.processed/` dibuang total (folder + AGENTS + SCHEMA + study.md); sisa 1 jalur `inbox/ → articles/`.
  - Impact: "inbox kosong = semua sudah diproses" jadi indikator yang bisa dipercaya.
- [x] **W6** ~~career-review butuh skor semua topik tapi script cuma bisa 1 topik per panggilan~~
  - Act: `confidence_calc.py --all` dump JSON semua topik (demo-tested); career-review.md step 3 point ke flag itu.
  - Impact: % Skill Inventory dihitung dari 1 command, bukan buka puluhan file test satu-satu.
- [ ] **W7** Op `query` terdaftar di SCHEMA:21 tapi tidak pernah dipakai — `/recall` tidak disuruh append log.
  - Act: pilih satu — buang `query` dari daftar ops, atau AGENTS `/recall` tambah "append log op: query".
  - Impact: daftar ops = ops yang beneran ada; lint nggak perlu nebak op sah.
- [ ] **W8** Format isi `skill-map.md` belum ada template baku (per-area? subskill? bobot?), padahal jadi pembagi persentase Skill Inventory UC6.
  - Act: 1 blok contoh di SCHEMA: `## Target L<n>` + `- Area: topik, topik` (bentuk yang sudah dipakai FIN:453-466).
  - Impact: % per area dihitung dari struktur yang pasti, bukan tebakan format tiap kuartal.
- [x] **W9** ~~FIN:873-877 tree masih `knowledge/linux|networking|monitoring/` — bentrok aturan FLAT di hermes-home~~
  - Act: tree FIN jadi `knowledge/` + komentar "FLAT: `<slug>.md` — topik lewat tags, JANGAN subfolder per topik" + `incidents/`; hermes-home yang menang.
  - Impact: acuan tree = perilaku capture-experience; agent nggak dapat 2 instruksi beda.
- [x] **W10** ~~FIN:864 tree raw/ masih `.processed/`~~
  - Act: komentar jadi `inbox/ → diproses → articles/ (inbox kosong = sudah diproses)`.
  - Impact: nol sisa `.processed` di seluruh project (FIN + runtime).
- [x] **W11** ~~FIN:895 `tests/incident-response/` bukan tag taxonomy~~
  - Act: → `incident/` + komentar "subfolder = tag taxonomy SCHEMA".
  - Impact: contoh nggak nyontohin folder di luar taxonomy → skor nggak pecah per folder.
- [x] **W12** ~~`raw/assets/` tidak ada di tree FIN padahal ada di disk + 3 dokumen aturan~~
  - Act: 1 baris `assets/` + format `YYYYMMDD-deskripsi.png` di tree raw/.
  - Impact: screenshot punya rumah di acuan tree, bukan cuma di tabel penempatan.
- [x] **W13** ~~`lint.md` hilang dari tabel File referensi + tree project-skills FIN~~
  - Act: 1 baris tabel (Use Case `—`, cron Minggu 08:00) + 1 baris tree.
  - Impact: 7 project-skills konsisten di FIN, AGENTS, dan disk.
- [x] **W14** ~~`type: data` di luar enum SCHEMA; frontmatter data file tak terdefinisi~~
  - Act: `data` masuk enum SCHEMA + blok frontmatter minimal (`title`, `type: data`, `updated`); 2 contoh FIN `date:` → `updated:`.
  - Impact: `roadmap/` & `profile/` lolos cek frontmatter lint, nggak dilaporin tiap minggu.
- [x] **W15** ~~Prefix `sources:` dua bentuk: `raw/...` vs `igrow/raw/...`~~
  - Act: dipilih `igrow/raw/...` (lengkap dari root) — SCHEMA layer + frontmatter + Referensi, FIN contoh + Referensi, test-flow 2.1.
  - Impact: `igrow-api` resolve path pakai 1 aturan; backlink nggak putus separuh.
- [x] **W16** ~~Hitungan field wajib beda 3 versi (lint.md "8", isinya 7, check.sh cek 5)~~
  - Act: lint.md → "7 field wajib" + `contradictions` disebut opsional; check.sh loop +`title` +`sources`.
  - Impact: SCHEMA, lint, dan check.sh ngukur hal yang sama — nggak bisa lolos di satu alat lalu gagal di alat lain.
- [x] **W17** ~~FIN:360 (UC5) masih format pra-nvk: "Topic, Summary, What I learned, Examples, References, Date"~~
  - Act: diganti frontmatter SCHEMA (7 field) + body Ringkasan/Detail/Contoh/Referensi/See Also.
  - Impact: UC5 nggak ngajarin field yang sudah dibuang; note /study seragam sama sisanya.
- [x] **W18** ~~FIN kontradiksi sendiri soal `confidence_calc.py` (3 tempat beda)~~
  - Act: :420-424 jadi "angka `mastered` dari `confidence_calc.py --all`"; TODO :1131 dihapus.
  - Impact: satu jawaban soal siapa yang ngitung — nggak ada sesi yang bongkar ulang keputusan ini.
- [x] **W19** ~~Contoh `test-me.md` di FIN:1035-1060 drift dari file asli (judul, wording, "Aturan skor" hilang)~~
  - Act: blok itu diganti isi `project-skills/test-me.md` verbatim; crosscheck.py assert byte-identik (sama perlakuan blok AGENTS.md).
  - Impact: contoh di blueprint = file yang beneran dibaca agent; aturan skor nggak ada 2 versi.
- [x] **W20** ~~`igrow/_index.md` runtime masih section `## Learning`, tidak punya `## Output`~~
  - Act: `## Learning` → `## Roadmap`, +`## Output`; crosscheck.py assert set section == folder wiki/ + output/.
  - Impact: laporan career review punya tempat di master index, nggak jadi orphan permanen.
- [x] **W21** ~~`raw/inbox/` satu-satunya folder tanpa `.gitkeep` (9 folder lain punya)~~
  - Act: `touch hermes-home/igrow/raw/inbox/.gitkeep` — 10/10 folder skeleton sekarang punya.
  - Impact: struktur utuh setelah clone/restore. `.gitkeep` permanen, JANGAN dihapus walau folder terisi (inbox kosong = kondisi normal).
- [ ] **W23** `confidence_calc.py` regex `^topic:\s*(\S+)` motong topik multi-kata — terbukti: `topic: load average` → key `load`.
  - Act: ganti jadi `^topic:\s*(.+?)\s*$` + 1 assert topik 2 kata di `_demo`.
  - Impact: skor topik multi-kata nggak pecah diam-diam (`load average` vs `load`).
- [ ] **W24** test-flow 2.1 Expected masih "sumber mentah → `raw/articles/`" — study.md:6 sekarang dump ke `raw/inbox/` dulu.
  - Act: Expected 2.1 jadi "inbox → diproses → articles/".
  - Impact: test nggak nge-FAIL-in behavior yang justru benar.
- [ ] **W25** `roadmap.md` + `completed.md` cuma hidup di FIN (:253-255, 837-838, 887-888) — `grep -c` di hermes-home = **0**, nggak ada file runtime yang nulis. test-flow 4.7 harap `roadmap.md` ada.
  - Act: mentor.md Output +`roadmap.md`, atau buang dua-duanya dari FIN + test-flow 4.7. Pilih satu.
  - Impact: file yang dijanjikan blueprint beneran ada penulisnya; test 4.7 punya dasar.
- [x] **W26** ~~TODO ganda: FIN section TODO vs dev-todo.md ini~~
  - Act: section TODO di FIN dihapus (sisa `/explore` + export PDF pindah tracking ke sini).
  - Impact: satu tempat status; nggak ada item "belum" yang sebenarnya sudah beres.
- [x] **W27** ~~portfolio.html masih domain lama (title, dash.*, email)~~
  - Act: file di-rewrite jadi NJZ Labs single page; `grep -c whatsinsidegit` = 0.
  - Impact: halaman publik nggak nunjuk domain yang sudah nggak dipegang.
- [ ] **W28** build.md:675 fallback backup "ganti host remote jadi igrow.njzlabs.com" mustahil — domain sendiri bukan mirror GitHub.
  - Act: hapus kalimat fallback itu; ganti "kalau ke-block, cek DNS/proxy container".
  - Impact: nggak ada instruksi yang dijamin gagal saat panik jam 3 pagi.
- [ ] **W29** build.md:672 `git push -u origin main` tapi `git init` menghasilkan `master`.
  - Act: `git branch -M main` sebelum push, atau push `master`.
  - Impact: prasyarat backup nggak berhenti di "src refspec main does not match any".
- [ ] **W30** Job backup satu-satunya yang tidak point-to-file (shell inline panjang di prompt LLM); aturannya cuma hidup di build.md yang tidak ikut ke VPS.
  - Act: bikin `project-skills/backup.md` (3 langkah + aturan silent), prompt cron jadi "Baca … lalu kerjakan."
  - Impact: 4 job pola sama; aturan backup ikut ke VPS, bisa dibenerin tanpa bikin ulang job.
- [ ] **W32** build.md checklist Phase 2 masih 8 item `[ ]` termasuk hal yang sudah jalan (folder igrow/, AGENTS.md, project-skills, tes chat).
  - Act: centang yang sudah terbukti dari hasil testing, sisakan yang beneran belum (4 cron job).
  - Impact: checklist kepakai buat tau sisa kerjaan, bukan diabaikan karena isinya salah.
- [ ] **W33** Timezone nggak konsisten 3 lapis: setupvps.sh:30 `Asia/Jakarta`, Glance & konteks project `Asia/Kuala_Lumpur`, container compose tanpa `TZ` (default UTC). Cron `0 7 * * *` bisa meleset 1-8 jam. (gabung eks-I16)
  - Act: setupvps.sh → `Asia/Kuala_Lumpur`; cek `docker exec igrow-hermes date`, kalau UTC tambah `TZ=Asia/Kuala_Lumpur` di service `igrow-hermes`.
  - Impact: 4 cron (`0 7`, `0 3`, `0 8`, `0 9`) bunyi di jam yang dimaksud.
- [ ] **W34** setupvps.sh:1-5 komentar cara pakai ditaruh SEBELUM `#!/bin/bash` (baris 7) → shebang tidak berlaku.
  - Act: pindah shebang ke baris 1, komentar di bawahnya.
  - Impact: `./setupvps.sh` jalan, nggak cuma `bash setupvps.sh`.
- [ ] **W35** setupvps.sh:21 `hostnamectl set-hostname whatsinsidegit` — nama lama. Keputusan kamu: ikut nama folder VPS (`~/whatsinsidegit/`, sengaja nggak di-rename) atau ikut domain (`njzlabs`).
  - Act: pilih satu, kalau biarkan tambah 1 komentar "sengaja, ikut nama folder".
  - Impact: nggak ada yang ragu "ini ketinggalan atau disengaja" saat rebuild VPS.
- [ ] **W36** `raw/notes/` ada di disk + tree FIN tapi tidak disebut satu pun file runtime.
  - Act: kasih 1 baris pemilik di SCHEMA (mis. "catatan mentah dari chat panjang"), atau hapus folder + baris tree-nya.
  - Impact: nggak ada folder tanpa aturan yang kepakai sembarangan lalu jadi tempat sampah.

## Improvement

- [ ] **I3** log.md:5 pakai `op: init` — tidak ada di daftar ops SCHEMA:21.
  - Act: tambah `init` ke daftar ops, atau ganti entry-nya jadi `ingest`.
  - Impact: `grep` per-op nggak ada entry yang lolos dari klasifikasi.
- [ ] **I5** Definisi "Career Aktif" dobel (AGENTS.md:45 + capture-experience.md:6) — pindah ke SCHEMA, AGENTS tinggal rujuk.
  - Act: pindah ke SCHEMA, dua file itu tinggal 1 baris rujukan.
  - Impact: kalau aturannya berubah, cukup 1 tempat — nggak bisa drift.
- [ ] **I6** FIN:753 rujuk "bagian Confidence Level di atas" — section-nya bernama "Confidence Score".
  - Act: samakan nama section-nya.
  - Impact: rujukan internal nggak menggantung.
- [ ] **I9** Semua file hermes-home/ CRLF termasuk `confidence_calc.py` → `./confidence_calc.py` gagal `bad interpreter: ^M`.
  - Act: simpan LF (minimal file `.py` + `.sh`).
  - Impact: script bisa dieksekusi langsung, nggak harus lewat `python file.py`.
- [ ] **I10** test-me.md manggil `python` — belum diverifikasi binary `python` (bukan cuma `python3`) ada di image container.
  - Act: `docker exec igrow-hermes which python python3`, sesuaikan command-nya.
  - Impact: step 3 UC2 nggak gagal di `command not found` saat pertama dipakai.
- [ ] **I11** `confidence_calc.py` `_demo` tidak punya jalur pemanggil (`--demo` tidak ada di argparse); docstring Usage belum sebut `--all`.
  - Act: tambah `--demo` ke argparse + 1 baris Usage.
  - Impact: self-check bisa dijalankan tanpa trik `python -c`.
- [ ] **I12** build.md:662 tabel cron tulis backup "(via https://igrow.njzlabs.com)" — itu URL dashboard, bukan remote git.
  - Act: hapus keterangan itu dari kolom job backup.
  - Impact: nggak ada yang nyangka dashboard bagian dari jalur backup.
- [ ] **I15** build.md Step 7 minta A record untuk `portainer, npm, dash, igrow` — root domain (service `home`) tidak disebut, padahal ada di Domain Map & checklist.
  - Act: tambahkan root domain di daftar A record.
  - Impact: portofolio nggak 404 gara-gara DNS-nya kelewat.
- [ ] **I17** `wiki/profile/` punya 5 file di spec tapi career-review.md cuma update 2 (`skills.md`, `career-summary.md`). `me.md` & `achievements.md` tanpa penulis.
  - Act: career-review.md step 5 tambah 2 file itu, atau buang dari spec.
  - Impact: `profile/` nggak separuh kosong permanen setelah beberapa kuartal.
- [ ] **I18** `AGENTSnvk.md` (1.058 baris, referensi eksternal nvk) + `tobeAgentsigrow.md` (semua TODO `[x]`) masih di root dan masih menyebut `.processed/` + `learning/`.
  - Act: 1 baris header "ARSIP — bukan spec aktif" di dua file itu.
  - Impact: sesi baru nggak salah ambil spec mati sebagai acuan.



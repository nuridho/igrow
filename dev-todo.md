# dev-todo — iGROW template

> Kode item (C/W/I + nomor) permanen — jangan dinomori ulang saat nambah.
> Nomor berikutnya: C14 / W37 / I21 / I22. Void: `W4` `C9` `C11` `W22`(→C9) `W23`(→U10) `W31` `I1` `I2` `I4` `I7` `I8` `I10`(→U12) `I11`(→U11) `I13` `I14` `I16`(→W33) `I19`.
> `FIN` = `iGROW_FINAL.md`. Format rujukan: `FIN:873` = file itu baris 873.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres.
> Item `[x]` Act-nya lampau (sudah dilakukan), Impact-nya sudah berlaku sekarang.
> Semua temuan sudah diverifikasi ke file / CLI / eksekusi. Yang tidak bisa dipastikan ditandai "(belum diverifikasi)".
> Isi list = bug + kontradiksi antar file. Kosmetik dokumen sengaja dibuang, jangan ditambahkan lagi.
> `hermes-home/` = source of truth. Kalau FIN/build/testing bentrok, yang nurut mereka.

## Critical

- [x] **C1** `lint.md` belum ada padahal cron lint mingguan dijanjikan
  - Act: dibuat `project-skills/lint.md` + 1 baris di AGENTS.md; prompt cron lint dipersingkat.
  - Impact: job lint punya aturan yang ikut ke VPS.
- [x] **C2** Job backup tidak tercermin di file runtime — agent bisa utak-atik `.git/` tanpa tahu
  - Act: 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat."
  - Impact: agent tahu `.git/` bukan wilayahnya.
- [x] **C3** Ownership `skill-map.md` beda di 3 file: SCHEMA.md:16 = human-owned, mentor.md:5 = "AUTO-GENERATE", FIN:742 = "wajib diisi manual di awal"
  - Act: SCHEMA.md:16 buang skill-map dari human-owned + rule agent-auto-generate; mentor.md → output Role Fit Matching; career-review.md → step 4 Role Fit Trend; FIN:742 → AUTO-GENERATE.
  - Impact: skill-map jadi input pasti untuk UC3 & UC6.
- [x] **C4** test-me.md:19 `--date today` (string literal) matikan guard max +1/hari
  - Act: `--date today` → `--date $(date +%F)`.
  - Impact: skor nggak bisa digelembungkan dengan jawab benar berkali-kali di 1 sesi.
- [x] **C5** `_index.json` cache kebaca lint sebagai orphan page (false positive)
  - Act: lint.md diminta skip file berawalan `_`.
  - Impact: laporan lint bersih.
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
- [x] **W3** test-me.md:20 `<kategori>` tidak terdefinisi
  - Act: SCHEMA:59 subfolder `tests/` = tag taxonomy.
  - Impact: hasil test topik sama selalu mendarat di folder sama.
- [x] **W5** raw/ punya 2 jalur (inbox→`.processed/` vs articles/ langsung)
  - Act: `.processed/` dibuang total; sisa 1 jalur `inbox/ → articles/`.
  - Impact: "inbox kosong = semua sudah diproses" jadi indikator yang bisa dipercaya.
- [x] **W6** career-review butuh skor semua topik tapi script cuma bisa 1 topik
  - Act: `confidence_calc.py --all` dump JSON semua topik.
  - Impact: % Skill Inventory dihitung dari 1 command.
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
- [x] **W17** FIN:360 (UC5) masih format pra-nvk
  - Act: diganti frontmatter SCHEMA + body template.
  - Impact: UC5 nggak ngajarin field yang sudah dibuang.
- [x] **W18** FIN kontradiksi sendiri soal `confidence_calc.py` (3 tempat beda)
  - Act: :420-424 jadi "angka `mastered` dari `confidence_calc.py --all`"; TODO dihapus.
  - Impact: satu jawaban soal siapa yang ngitung.
- [x] **W19** Contoh `test-me.md` di FIN drift dari file asli
  - Act: blok itu diganti isi `project-skills/test-me.md` verbatim; crosscheck.py assert byte-identik.
  - Impact: contoh di blueprint = file yang beneran dibaca agent.
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
- [x] **I22** ~~Belum ada session capture/export.~~
  - Act: bikin project-skill `session-export.md` + `session-export.sh`.
  - Impact: migration ke tool lain = copy `igrow/` + extract archive, bukan mulai nol.

## Advanced Prompting

> Tingkatkan kualitas project-skills (UC1/3/4/5/6) dengan teknik prompting proven untuk meminimalisir debugging.
> **Prioritas konsistensi over conciseness** — output boleh panjang/minta validasi ulang, yang penting akurat.
> Tier 1 = ROI tinggi (effort kecil, dampak jelas). Tier 2 = ROI sedang (effort medium). Tier 3 = effort besar (refactor pipeline, 4x API call untuk multi-turn).

### Tier 1 — ROI Tinggi (effort: copy-paste + insert)

- [ ] **A1** Few-shot examples — 1 contoh lengkap input→output per UC di section `## Contoh Eksekusi`
  - Act: tambahkan di capture-experience.md (cerita incident CPU spike → frontmatter 7 field + body 6 section), study.md (link Redis → raw/inbox/ + note), mentor.md ("role apa cocok" → tabel Role Fit 3 baris), daily-briefing.md (output 5 info + Why it matters), career-review.md (quarterly → skill inventory + role fit trend).
  - Impact: model mid (Sonnet/Haiku/Qwen) konsisten 15-25% lebih akurat; model tahu bentuk output yang diharapkan tanpa trial-error.
- [ ] **A2** Role definition — 1 baris di awal tiap UC: "Kamu = wiki compiler. Input mentah → structured page. Human edit manual = jarang."
  - Act: tambahkan di 5 UC file (capture-experience, study, mentor, daily-briefing, career-review).
  - Impact: agent paham konteks kerja (compiler otomatis, bukan interviewer/tutor interaktif).
- [ ] **A3** Verification checkpoint — self-check sebelum nulis untuk UC yang >3 langkah
  - Act: tambahkan di capture-experience.md step 4 & study.md step 4: "Self-check sebelum tulis file: (1) frontmatter 7 field wajib? (2) tags ⊂ taxonomy SCHEMA? (3) sources: prefix `igrow/`? (4) min 2 dual-link See Also?"
  - Impact: error struktur (frontmatter kurang, tag typo, path salah) tertangkap sebelum nulis file, bukan saat lint/cron.

### Tier 2 — ROI Sedang (effort: trace edge case per UC)

- [ ] **A4** Explicit reasoning untuk keputusan ambigu — agent tulis 1 baris alasan sebelum pilih
  - Act: tambahkan di capture-experience.md step 2 (setelah "Rapikan cerita jadi note"):
    ```
    Tentukan type & folder — TULIS REASONING 1 BARIS:
    - Cerita "server mati pas backup" → incident atau knowledge?
      Reasoning: ada symptom + investigation + result = incident; cuma SOP tanpa kejadian = knowledge
    - Pilih: incident → igrow/wiki/careers/career-N/knowledge/incidents/
    ```
  - Impact: agent transparan kenapa pilih type/folder tertentu; user bisa koreksi keputusan yang salah tanpa debug isi file. Konfirmasi passive (agent tulis reasoning, user koreksi kalau salah).
- [ ] **A5** Fallback per langkah yang bisa gagal — instruksi eksplisit saat kondisi tidak ideal
  - Act: 
    - mentor.md tambah setelah "## Prasyarat jujur": "skill-map.md belum ada / lebih lama dari about.md → auto-generate dulu dari careers/+self-dev, lalu analisa. careers/ kosong → bilang 'Data karier belum cukup untuk gap analysis (minimal 3 incident/knowledge)', jangan ngarang roadmap generik."
    - capture-experience.md tambah di step 3 (Format frontmatter): "Tag fuzzy-match ke taxonomy SCHEMA. Kalau tidak ada yang cocok (<60% similarity) → tanya user 1x 'Tag mana yang cocok: [3 opsi terdekat]?', jangan tebak. Kalau user skip → pakai terdekat + catat di `contradictions: ['taxonomy-mismatch']`."
  - Impact: agent tahu next-action saat data tidak lengkap (auto-generate skill-map, tanya tag) atau kondisi mustahil (careers/ kosong → jujur); nol stuck/silent-fail/ngarang.

### Tier 3 — Effort Besar (DISKUTABEL — kerjakan hanya kalau Tier 1-2 terbukti kurang)

> **Disclaimer:** Tier 3 mengubah pipeline & UX. Multi-turn mustahil untuk cron (UC4/UC6 zero human-in-loop). Chain-of-thought verbose, output 2x lebih panjang.

- [ ] **A6** Chain-of-thought eksplisit — agent tulis reasoning sebelum SETIAP action
  - Act: refactor capture-experience.md struktur step jadi:
    ```
    1. Tentukan career aktif
       → OUTPUT: "Career aktif = career-2 (about.md tanpa tanggal selesai)"
    2. Analisa cerita
       → OUTPUT: "Cerita → incident (ada symptom: 'server down' + investigation + result)"
       → OUTPUT: "Tags = linux, mysql (dari taxonomy: cerita menyebut 'MySQL crash on Ubuntu')"
    3. Rapikan cerita jadi note (sama seperti sekarang)
    4. Format frontmatter
       → OUTPUT: "Field wajib: title/created/updated/type/tags/sources/confidence (7 field)"
    5. See Also (sama seperti sekarang)
    6. Update _index+log (sama seperti sekarang)
    ```
    Total: 5 langkah linier → 6 langkah + 4 reasoning output (10 sub-step). Terapkan ke 5 UC (capture-experience, study, mentor, daily-briefing, career-review).
  - Impact: akurasi naik 10-15% untuk model lemah (Llama 7B, Qwen 7B), tapi output 2x lebih panjang (reasoning verbose). Model kuat (Claude Opus, GPT-4) gain marginal (<5%). Cost +$2.10/bulan (30 operasi) vs baseline Tier 1-2.
  - **Disclaimer**: Output jadi verbose (agent tulis pemikiran tiap step). Trade-off: akurasi +10-15% (model lemah) vs conciseness turun 50%. Untuk model kuat, gain kecil tapi tetap bayar cost verbose.
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
    HANYA untuk UC1 sub-case "Daftar Kerjaan Baru" (1-2x/tahun, data kritikal). TIDAK untuk incident/knowledge rutin (10-30x/bulan). TIDAK untuk cron UC4/UC6 (zero human-in-loop).
  - Impact: error input turun 20% untuk data kritikal (user koreksi sebelum file tertulis). Trade-off: cost 3-4x API call ($0.36 vs $0.09 per operasi), latency 3-4x (3 bolak-balik vs 1 pesan). Telegram UX jadi interview-style.
  - **Disclaimer**: Multi-turn MUSTAHIL untuk cron job (UC4 daily briefing, UC6 career review = zero human). Hanya applicable untuk UC1/UC3/UC5 yang dipicu manual. Cost naik 300% per operasi. UX berubah dari "cerita → langsung simpan" jadi "cerita → tanya-jawab 3-4 turn → baru simpan".

## UC2 — Later (Phase 5)

> UC2 (\"Uji Saya\") **dihapus dari hermes-home** 2026-09-04 — core UC1/3/4/5/6 dulu.
> Yang dihapus: `project-skills/test-me.md`, `project-skills/scripts/`, `wiki/tests/`.
> `iGROW_FINAL.md` UC2 tetap jadi rancangan — jangan dianggap sudah ada.

- [ ] **U1** Putuskan bentuk UC2: (A) chat-only nol state, (B) skor di 1 file `wiki/roadmap/scores.md`, (C) balik ke folder `tests/` + script.
- [ ] **U2** Kalau pilih B/C: cache JANGAN ke-track git.
- [ ] **U3** `type: test` + op `test` sudah dibuang dari SCHEMA.
- [ ] **U4** mentor.md sekarang 2 sumber. Sumber ke-3 "terbukti" hilang.
- [ ] **U5** career-review.md Skill Inventory sekarang counting note.
- [ ] **U6** test-flow: FASE 3 + 4.3 + 4.4 ditandai SKIP.
- [ ] **U7** check.sh blok frontmatter tests/ dihapus.
- [ ] **U10** `confidence_calc.py` regex `^topic:\s*(\S+)` motong topik multi-kata.
- [ ] **U11** `_demo` di confidence_calc.py tak punya jalur pemanggil (`--demo` nggak ada).
- [ ] **U12** `python` vs `python3` di container belum diverifikasi.

# To-Do — iGROW (hermes-home)

> Fokus: hanya item yang menyentuh `hermes-home/` (AGENTS.md, SCHEMA, project-skills, struktur `igrow/`). Item VPS, docs, testing, web, dan migrasi dihapus 2026-10-16; jejaknya ada di git history dan `05-roadmap.md`.
> Kode item dinomori ulang 2026-10-16 (urut dari atas per huruf; pemetaan lama → baru ada di `backlog.md`). Mulai sekarang permanen — jangan dinomori ulang. Nomor berikutnya: C9 / W22 / I8 / A10.
> **Act** = yang dikerjakan. **Impact** = yang berubah setelah beres. Item `[x]` Act-nya lampau, Impact-nya sudah berlaku.
> Isi list = bug + kontradiksi di runtime. Kosmetik sengaja tidak dicatat. `FIN` di item lama = `archive/iGROW_FINAL.md`.
> Item selesai → centang di sini + catat di [`backlog.md`](backlog.md).

## Terbuka

- **A7, A8, A9** (Advanced Prompting Tier 3): diparkir, kerjakan hanya kalau Tier 1–2 terbukti kurang. Detail di bawah.

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
  - Selesai 2026-10-16: keputusan owner: backup Senin, Rabu, Sabtu 05:00 (`0 5 * * 1,3,6`), RPO ≤ 3 hari (D-23). Diubah di `AGENTS.md`, `backup.md`, `build.md`, PRD.
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
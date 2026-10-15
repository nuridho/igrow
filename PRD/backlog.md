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

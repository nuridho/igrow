# Backlog: Riwayat Update iGROW

> Catatan setiap perubahan di project ini. Entri **terbaru di paling atas**.
> Wajib ditambah setiap ada perubahan file, baik oleh user maupun Claude (lihat `CLAUDE.md`).
> Yang **akan** dikerjakan ada di [`todo.md`](todo.md). File ini mencatat yang **sudah** terjadi.
> Riwayat sebelum 2026-10-15: lihat `git log`.

Format entri:

```markdown
## [YYYY-MM-DD] Judul singkat
- **Apa:** perubahan yang dilakukan
- **Kenapa:** alasan / kode todo terkait
- **File:** file yang berubah
- **Deploy VPS:** perlu / tidak (+ langkahnya kalau perlu)
```

---

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
- **Apa:** sisa isi FIN dipindah ke PRD: contoh output UC1–UC5, contoh `about.md` dan `skill-map.md`, mekanisme knowledge gap, aturan skill inventory (target = level berikutnya, bar reset), skenario migrasi, dan frontmatter sebagai kontrak `igrow-api`. Format body data file (`weak-topics`, `profile/skills`) dipindah ke `SCHEMA.md`. FIN dipindah ke `archive/`, dan semua rujukan diperbarui. Selisih blueprint vs runtime dicatat sebagai W47–W50. W40 dan W45 ditutup, OQ-05 dan OQ-09 selesai.
- **Kenapa:** PRD jadi satu-satunya dokumen produk, dan satu sumber drift hilang (D-21).
- **File:** `PRD/01`–`06`, `PRD/README.md`, `PRD/todo.md`, `hermes-home/igrow/SCHEMA.md`, `docs/build.md`, `testing/test-flow.md`, `CLAUDE.md`, `README.md`, `archive/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang `SCHEMA.md` (ada 1 baris baru untuk format data file).

## [2026-10-16] To-do pindah ke PRD + CLAUDE.md + backlog
- **Apa:** `docs/dev-todo.md` dipindah menjadi `PRD/todo.md`. Temuan PRD ditambahkan (C21, W44–W46, I26, I27), dan rujukan nomor baris FIN/build yang bergeser diperbaiki. `CLAUDE.md` dibuat di root dan file ini dibuat.
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
- **Kenapa:** keputusan owner (D-18). Menutup W43, I23, dan I24.
- **File:** `testing/`, `PRD/todo.md`, `README.md`
- **Deploy VPS:** tidak

## [2026-10-16] Struktur repo dirapikan
- **Apa:** dokumen dipindah ke `docs/`, halaman web ke `web/`, arsip ke `archive/`, dan `ignore/` diganti nama menjadi `parked/`. Ditambah `.gitattributes` (LF), `.gitignore`, dan `README.md`. File sisa di root (`.probe*.py`, `.cmp.py`) dihapus.
- **Kenapa:** root lebih bersih. Menutup C20 dan I25 (D-19).
- **File:** seluruh root
- **Deploy VPS:** tidak. Kalau `portfolio.html` disalin manual ke `homepage/index.html`, path sumbernya sekarang `web/portfolio.html`.

## [2026-10-16] AGENTS.md ikut di-backup
- **Apa:** `backup.sh` menyalin `/opt/data/AGENTS.md` ke `igrow/AGENTS.backup.md` sebelum commit.
- **Kenapa:** `AGENTS.md` ada di luar `igrow/` sehingga sebelumnya tidak ikut backup (D-17).
- **File:** `hermes-home/igrow/project-skills/maintenance/backup.sh`, `backup.md`, `docs/build.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang `backup.sh` dan `backup.md`.

## [2026-10-16] Session export dihapus
- **Apa:** `session-export.md`, `session-export.sh`, cron job ke-5, dan semua rujukannya dihapus. Cron sekarang 4 job.
- **Kenapa:** script menyalin folder yang salah (C19) dan terlalu rumit untuk nilainya (D-16).
- **File:** `hermes-home/AGENTS.md`, `hermes-home/igrow/project-skills/maintenance/`, `docs/build.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Deploy ulang `AGENTS.md`, hapus file session-export lama, jalankan `hermes cron remove session-export` kalau job sudah dibuat, dan hapus `log/sessions/archive/` kalau ada.

## [2026-10-15] Contoh few-shot dibetulkan (C17)
- **Apa:** tag contoh diganti ke tag taxonomy. Contoh capture dilengkapi Finding, Lesson Learned, dan Referensi, dengan See Also dual-link. `sources` contoh study diarahkan ke `raw/articles/`. Self-check poin 4 meminta format dual-link.
- **Kenapa:** contoh sebelumnya melanggar aturan SCHEMA sendiri, padahal model meniru contoh (C17).
- **File:** `hermes-home/igrow/project-skills/capture-experience.md`, `study.md`, `docs/iGROW_FINAL.md`
- **Deploy VPS:** **perlu**. Salin ulang kedua project skill.

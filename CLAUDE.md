# CLAUDE.md: Panduan Kerja di Repo iGROW

iGROW = arsip karier & knowledge base pribadi untuk IT worker. Hermes Agent (image Docker `nousresearch/hermes-agent`) menjadi otaknya dan dipakai lewat Telegram. Aset utamanya adalah markdown di `hermes-home/igrow/`. Repo ini berisi **spec, prosedur agent, dan dokumentasi**, bukan kode aplikasi.

Bahasa: Bahasa Indonesia (santai di chat, rapi di dokumen). Owner = satu-satunya user.

## Peta Repo

| Folder | Isi | Catatan |
|---|---|---|
| `hermes-home/` | Runtime Hermes: `AGENTS.md` + `igrow/` (SCHEMA, prosedur UC, maintenance) | **Source of truth.** Di-rsync ke VPS `~/whatsinsidegit/igrow-hermes/hermes-home/`. Jangan dipindah atau di-rename. |
| `PRD/` | Dokumen produk (01–06), `todo.md`, `backlog.md` | Mulai dari `PRD/README.md` |
| `docs/` | `build.md` (runbook VPS), `vpslab.md` (infra lab) | Detail teknis & operasional |
| `Setup/` | Script init VPS & Docker | |
| `testing/` | `test-flow.md`: skenario uji **manual** lewat Telegram | Jangan tambah script test (D-18) |
| `web/` | `portfolio.html`, `igrow-dashboard.html` (dummy), `src/` | |
| `parked/`, `archive/` | Ide ditunda; spec lama termasuk `iGROW_FINAL.md` (blueprint awal, isinya sudah pindah ke PRD) | **Bukan acuan**, jangan diikuti |

## Hierarki Sumber Kebenaran

`hermes-home/` → `PRD/` → `docs/`. Kalau bentrok, yang lebih atas menang, lalu dokumen di bawahnya diperbaiki.

## Aturan Wajib

1. **Setiap perubahan file → tambah entri di `PRD/backlog.md`** (paling atas, format ada di file itu). Isi juga "Deploy VPS: perlu/tidak". Kalau perubahan menyentuh `hermes-home/`, hampir pasti perlu deploy.
2. **Temuan bug/gap baru → item di `PRD/todo.md`.** Pakai kode permanen sesuai baris "Nomor berikutnya" di header, lalu naikkan nomornya. Format: judul + `Act` + `Impact`. Jangan menomori ulang. Item selesai dicentang `[x]`, tidak dihapus.
3. **Satu aturan, satu sumber.** Jangan salin aturan runtime (frontmatter, taxonomy, langkah UC) ke PRD/docs. Rujuk file aslinya. Setiap kali mengubah aturan di `hermes-home/`, grep istilah yang sama di `PRD/` dan `docs/`, lalu perbarui yang ikut berubah.
4. **Rujukan nomor baris** (`build.md:1093`, `SCHEMA.md:93`) di `todo.md` ikut bergeser kalau file target diedit. Setelah mengedit file yang dirujuk, cek ulang rujukan di item `todo.md` yang masih terbuka.
5. **`AGENTS.md` harus tetap padat.** File ini dimuat di setiap sesi Hermes, jadi setiap baris memakan token. Detail ditaruh di `igrow/project-skills/`.
6. **Contoh few-shot wajib mematuhi aturan.** Contoh di project skill harus lolos SCHEMA (tag dari taxonomy, dual-link, `sources` ke `igrow/raw/articles/`), karena model meniru contoh lebih kuat daripada aturan.
7. **Privasi.** Jangan menulis credential, token, IP, hostname sensitif, atau nama client ke file mana pun, termasuk contoh dan dokumen. Contoh selalu pakai data fiktif atau generik.
8. **Line ending LF** (dikunci `.gitattributes`). Script `.sh` dijalankan dengan `bash script.sh`, karena mode file di git `100644`.
9. **Commit atau push hanya kalau diminta.**

## Fakta Teknis yang Sering Salah

- `AGENTS.md` harus di root `HERMES_HOME` (`/opt/data`), bukan di `igrow/`, karena working directory gateway terkunci ke `/opt/data` (issue #5200).
- `project-skills/` = markdown biasa yang dirujuk dari `AGENTS.md`, **bukan** sistem Skill resmi Hermes (`SKILL.md`).
- `hermes cron create`: argumen prompt bersifat **positional** (tidak ada `--prompt`), dan wajib `--deliver telegram`.
- Deploy runtime: `rsync -a --exclude '_index.md' --exclude 'log.md'` supaya katalog dan log di VPS tidak tertimpa. Saat setup pertama, jalankan tanpa exclude.
- Blok "Bikin 14 file inti" di `docs/build.md` sudah basi (W41). Salin dari `hermes-home/`, bukan dari blok itu.
- Fakta CLI atau perilaku Hermes dicek ke dokumentasi resmi (hermes-agent.nousresearch.com), bukan dari ingatan.

## Status Saat Ini

Lihat `PRD/05-roadmap.md` untuk fase dan prioritas, dan `PRD/todo.md` § "Temuan PRD" serta "Phase 2 ToDo" untuk item terbuka.

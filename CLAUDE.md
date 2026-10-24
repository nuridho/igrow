# CLAUDE.md: Panduan Kerja di Repo iGROW

iGROW = arsip karier & knowledge base pribadi untuk IT worker. Hermes Agent (image Docker `nousresearch/hermes-agent`) menjadi otaknya dan dipakai lewat Telegram. Aset utamanya adalah markdown di `hermes-home/igrow/`. Repo ini berisi **spec, prosedur agent, dan dokumentasi**, bukan kode aplikasi.

Bahasa: Bahasa Indonesia (santai di chat, rapi di dokumen). Owner = satu-satunya user.

## Peta Repo

| Folder | Isi | Catatan |
|---|---|---|
| `hermes-home/` | Runtime Hermes: `AGENTS.md` + `igrow/` (SCHEMA, prosedur UC, maintenance) | **Source of truth.** Di-rsync ke VPS `~/whatsinsidegit/igrow-hermes/hermes-home/`. Jangan dipindah atau di-rename. |
| `PRD/` | Dokumen produk (01–07), `todo.md`, `backlog.md` | Mulai dari `PRD/README.md` |
| `docs/` | `build.md` (runbook VPS), `vpslab.md` (infra lab), `peta-igrow.html` (gambaran visual, ilustrasi), `setup-flow.html` (simulator interaktif `setupvps.sh` + `igrowctl.sh`: jalur setup vs menu) | Detail teknis & operasional |
| `Setup/` | `setupvps.sh` (init VPS: user, Docker, NPM, firewall, SSH), `igrowctl.sh` (pasang iGROW end-to-end, penjelasan di `PRD/07-setup.md`) | Perintah Hermes di script ikut dicek kalau CLI Hermes berubah. Alur, menu, pertanyaan, atau teks tampilan salah satu script berubah → perbarui alur di `docs/setup-flow.html` (blok `FLOWS-BEGIN`…`FLOWS-END`; teksnya disalin dari script) |
| `testing/` | `test-flow.md`: skenario uji **manual** lewat Telegram | Jangan tambah script test (D-18) |
| `web/` | `portfolio.html`, `igrow-dashboard.html` (dummy), `src/` | |
| `parked/`, `archive/` | Ide ditunda; spec lama termasuk `iGROW_FINAL.md` (blueprint awal, isinya sudah pindah ke PRD) | **Bukan acuan**, jangan diikuti |

## Hierarki Sumber Kebenaran

`hermes-home/` → `PRD/` → `docs/`. Kalau bentrok, yang lebih atas menang, lalu dokumen di bawahnya diperbaiki.

## Aturan Wajib

1. **Setiap perubahan file → tambah entri di `PRD/backlog.md`** (paling atas, format ada di file itu). Isi juga "Deploy VPS: perlu/tidak". Kalau perubahan menyentuh `hermes-home/`, hampir pasti perlu deploy.
2. **Temuan bug/gap di `hermes-home/` → item di `PRD/todo.md`** (todo khusus hermes-home; pekerjaan di luar itu, misalnya docs/VPS/testing, dicatat di tabel prioritas `PRD/05-roadmap.md`). Pakai kode permanen sesuai baris "Nomor berikutnya" di header, lalu naikkan nomornya. Format: judul + `Act` + `Impact`. Jangan menomori ulang. Item selesai dicentang `[x]`, tidak dihapus.
3. **Satu aturan, satu sumber.** Jangan salin aturan runtime (frontmatter, taxonomy, langkah UC) ke PRD/docs. Rujuk file aslinya. Setiap kali mengubah aturan di `hermes-home/`, grep istilah yang sama di `PRD/` dan `docs/`, lalu perbarui yang ikut berubah.
4. **Rujukan nomor baris** (`build.md:1093`, `SCHEMA.md:93`) di `todo.md` ikut bergeser kalau file target diedit. Setelah mengedit file yang dirujuk, cek ulang rujukan di item `todo.md` yang masih terbuka.
5. **`AGENTS.md` harus tetap padat.** File ini dimuat di setiap sesi Hermes, jadi setiap baris memakan token. Detail ditaruh di `igrow/project-skills/`.
6. **Contoh few-shot wajib mematuhi aturan.** Contoh di project skill harus lolos SCHEMA (tag dari taxonomy, dual-link, `sources` ke `igrow/raw/articles/`), karena model meniru contoh lebih kuat daripada aturan.
7. **Privasi.** Jangan menulis credential, token, IP, hostname sensitif, atau nama client ke file mana pun, termasuk contoh dan dokumen. Contoh selalu pakai data fiktif atau generik. Repo ini **Publik** (D-35): isi file dan seluruh riwayat commit terbaca siapa saja, jadi yang pernah ter-commit tidak bisa ditarik kembali tanpa menulis ulang riwayat.
8. **Line ending LF** (dikunci `.gitattributes`). Script `.sh` dijalankan dengan `bash script.sh`, karena mode file di git `100644`.
9. **Commit atau push hanya kalau diminta.**

## Fakta Teknis yang Sering Salah

- `AGENTS.md` harus di root `HERMES_HOME` (`/opt/data`), bukan di `igrow/`, karena working directory gateway terkunci ke `/opt/data` (issue #5200).
- `project-skills/` = markdown biasa yang dirujuk dari `AGENTS.md`, **bukan** sistem Skill resmi Hermes (`SKILL.md`). Hermes juga membuat skill dan memory sendiri secara default (dimuat di setiap sesi); `AGENTS.md` melarang alur iGROW disimpan di sana, dan VPS memakai `skills.write_approval: true` (W37).
- `hermes cron create`: argumen prompt bersifat **positional** (tidak ada `--prompt`), wajib `--deliver telegram`, dan wajib `--workdir /opt/data` (tanpa itu sesi cron tidak memuat `AGENTS.md`). Jawaban cron yang berisi `[SILENT]` tidak dikirim; jawaban kosong justru dicatat sebagai gagal kirim.
- Deploy runtime = 2 langkah: (1) `rsync -a --exclude '_index.md' --exclude 'log.md' --exclude 'taxonomy.md'` supaya file milik agent (katalog, log, daftar tag) di VPS tidak tertimpa; (2) `rsync -a --ignore-existing` supaya file milik agent yang belum ada di VPS (setup pertama, atau file baru) tersalin sekali tanpa menimpa yang sudah ada. Jangan pakai `--delete`: data di VPS (`wiki/`, `raw/`, `output/`) tidak ada di repo.
- Blok "Bikin 14 file inti" di `docs/build.md` sudah basi (tugas pembersihannya ada di `PRD/05-roadmap.md`). Salin dari `hermes-home/`, bukan dari blok itu.
- Fakta CLI atau perilaku Hermes dicek ke dokumentasi resmi (hermes-agent.nousresearch.com), bukan dari ingatan.

## Status Saat Ini

Lihat `PRD/05-roadmap.md` untuk fase dan prioritas, dan `PRD/todo.md` § Terbuka untuk item terbuka.

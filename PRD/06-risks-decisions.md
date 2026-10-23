# 06 · Risks, Decisions & Open Questions

## 1. Risk Register

Skala: **H** (tinggi), **M** (sedang), **L** (rendah).

| ID | Risiko | Dampak | Kemungkinan | Mitigasi | Status |
|---|---|---|---|---|---|
| R-01 | Agent tidak patuh SCHEMA: tag di luar taxonomy, link tanpa path, salah folder. | M | H | Self-check sebelum menulis, contoh few-shot yang mematuhi aturan (C2 sudah diperbaiki), dan lint mingguan. | Termitigasi sebagian |
| R-02 | Data sensitif bocor ke provider LLM atau GitHub. | H | M | Redaksi sebelum bercerita, daftar larangan di `AGENTS.md` (dimuat di setiap sesi), repo backup privat, lint mingguan (pola IP dan credential di catatan kerja), dan cek manual setiap kuartal. Redaksi tetap bergantung pada disiplin user dan kepatuhan agent. | Termitigasi sebagian |
| R-03 | Skill inventory tidak bisa dibandingkan antar kuartal karena skill map di-generate ulang dan pencocokan topik ↔ note bergantung penilaian LLM. | H | H | Skill map beku per level (D-22) dan aturan pencocokan tertulis di SCHEMA dengan file bukti per topik (D-26). | Termitigasi |
| R-04 | VPS menjadi single point of failure. Dengan backup 3x seminggu, hingga 3 hari catatan bisa hilang. | M | L | Backup Git ke GitHub setiap Senin, Rabu, Sabtu 05:00 (D-23). | Diterima |
| R-05 | Update `:latest` Hermes mengubah perilaku (argumen CLI cron, cara memuat `AGENTS.md`). | M | M | Pin versi setelah stabil ([OQ-08](#3-pertanyaan-terbuka)). Setelah update, cek `hermes cron create --help` dan ulangi tes Telegram Phase 2. | Terbuka |
| R-06 | Token GitHub tersimpan plaintext di container (`credential.helper store`). | M | L | Gunakan fine-grained token dengan scope satu repo, dan rotasi berkala. | Diterima |
| R-07 | Dokumen saling menyimpang (build, PRD, runtime). Sejak script cek otomatis dihapus, tidak ada pengaman otomatis. | M | H | Hierarki sumber kebenaran ([README](README.md#hierarki-sumber-kebenaran)), PRD tidak menyalin aturan runtime, dan setiap perubahan runtime langsung diikuti update dokumen terkait. | Terbuka |
| R-08 | Adopsi rendah: user berhenti bercerita, sehingga UC2 dan UC5 tidak punya bahan. | H | M | Friction dibuat rendah (cukup chat bebas) dan metrik adopsi dipantau. Usulan: pengingat kalau 7 hari tidak ada `ingest`. | Terbuka |
| R-09 | Biaya token LLM naik (briefing harian dengan web research, review kuartalan). | M | M | `AGENTS.md` ringkas, prosedur dimuat sesuai kebutuhan, dashboard tanpa LLM. Pantau tagihan provider setiap bulan. | Termitigasi sebagian |
| R-10 | Memory dan skill internal agent hilang saat migrasi, karena session export sudah dihapus. | L | H | Diterima. Prosedur yang penting harus ditulis di `project-skills/`, bukan hanya hidup di skill buatan agent. | Diterima |
| R-11 | RAM 4 GB tidak cukup saat Phase 3–5 ditambahkan. | M | L | Pilih tool ringan, pantau `docker stats`, tambahkan swap, upgrade kalau perlu. | Diterima |

## 2. Decision Log

| ID | Tanggal | Keputusan | Alasan | Alternatif yang ditolak |
|---|---|---|---|---|
| D-01 | — | Memakai image resmi `nousresearch/hermes-agent`. | Gateway, memory, tools, dan cron sudah tersedia. Yang custom cukup lapisan instruksi. | Membangun bot sendiri (effort besar). |
| D-02 | — | `AGENTS.md` diletakkan di root `HERMES_HOME`. | Di mode gateway, working directory selalu `/opt/data` (issue #5200). Sudah teruji. | `AGENTS.md` di dalam `igrow/`. |
| D-03 | — | Satu volume `hermes-home:/opt/data`, data iGROW di subfolder `igrow/`. | Mengikuti konvensi image. Hanya `igrow/` yang di-backup dan dibagikan ke `igrow-api`. | Mount terpisah per folder. |
| D-04 | — | Format markdown + YAML frontmatter. | Bisa dibaca tanpa tool, dan satu file menjadi satu sumber kebenaran. | Markdown + JSON terpisah. |
| D-05 | — | `project-skills/` berupa markdown biasa yang dirujuk dari `AGENTS.md`. | Sederhana dan portable. Konsekuensinya, tidak mendapat lazy-load dari sistem Skill resmi. | `SKILL.md` resmi (ditinjau ulang di OQ-06). |
| D-06 | 2026-08-25 | Pola wiki "varian B" (Karpathy LLM Wiki / nvk): `raw/` immutable, `wiki/` hasil kompilasi, index + log. | Struktur yang sudah teruji untuk knowledge base yang dikelola LLM. | Satu folder campur. Arsip ada di `archive/`. |
| D-07 | — | Folder `knowledge/` dibuat flat; topik diatur lewat tag. | Satu note bisa mencakup banyak topik, dan gap analysis membaca tag. | Subfolder per topik. |
| D-08 | — | Satu jalur `raw/`: `inbox/` → `articles/` (`.processed/` dibuang). | Supaya "inbox kosong = semua sudah diproses" bisa dipercaya. | Dua jalur paralel. |
| D-09 | — | Skill map di-generate otomatis. | Fitur gap analysis jalan tanpa setup manual di awal. | Diisi manual (konsekuensi: R-03). |
| D-10 | — | Backup lewat Hermes cron + `backup.sh`. | Satu mekanisme, dan error langsung dikirim ke Telegram. | Crontab host + `sync.sh`. |
| D-11 | — | Dashboard dibagi menjadi tiga service: hermes, api, web. | Refresh dashboard tidak membebani bot dan tidak memakai token LLM. | Web memanggil Hermes langsung. |
| D-12 | — | Phase 4 (dashboard) ditunda setelah Phase 2. | Belum ada data yang bisa ditampilkan. | Membangun dashboard lebih dulu. |
| D-13 | 2026-09-21 | Advanced prompting Tier 1–2 (A1–A5) + A6 versi ringan diterapkan. Tier 3 (A7–A9) ditunda. | ROI tinggi dengan effort kecil. Tier 3 menaikkan biaya dan latency. | Chain-of-thought penuh di setiap langkah. |
| D-14 | 2026-09-05 s/d 2026-09-23 | Fitur uji/latihan troubleshooting (`tests/`) dihapus bertahap. Use case menjadi 5. | Fokus ke capture, mentor, briefing, study, dan review. | — |
| D-15 | 2026-09-23 | Migrasi ke Jev diparkir. | Belum ada bukti bahwa migrasi layak, jadi wajib POC dulu. | Migrasi langsung. |
| D-16 | 2026-10-16 | Session export dihapus. | Script menyalin folder yang salah (C4) dan terlalu rumit untuk nilainya. Aset utama sudah aman di `igrow/` + Git. | Memperbaiki target salinan. |
| D-17 | 2026-10-16 | `AGENTS.md` ikut di-backup sebagai `igrow/AGENTS.backup.md`. | File itu ada di luar `igrow/`. Diberi nama berbeda supaya tidak dianggap aturan aktif. | Mengandalkan salinan di repo saja. |
| D-18 | 2026-10-16 | Script testing otomatis dihapus. Verifikasi dilakukan manual lewat `test-flow.md`. | Pilihan owner. Script sering memberi FAIL palsu. | Memperbaiki script cek otomatis. |
| D-19 | 2026-10-16 | Struktur repo dirapikan (`docs/`, `web/`, `archive/`, `parked/`), `.gitattributes` mengunci LF, dan PRD dibuat. | Root lebih bersih dan setiap folder punya satu peran jelas. | — |
| D-20 | 2026-10-16 | Note belajar: satu folder per sumber belajar, isinya note per sub-topik dengan template lengkap SCHEMA. | Template SCHEMA sudah memuat Contoh dan Referensi di setiap note. | Pecah per jenis isi (`concepts.md`, `commands.md`, `troubleshooting.md`, `references.md`) seperti di blueprint lama. |
| D-21 | 2026-10-16 | `iGROW_FINAL.md` diarsipkan ke `archive/`. Isinya dipindah ke PRD, dan format data file yang hanya ada di FIN dipindah ke `SCHEMA.md`. | Mengurangi sumber drift (R-07). Menutup OQ-05 dan OQ-09. | Mempertahankan FIN berdampingan dengan PRD. |
| D-22 | 2026-10-16 | Skill map dibekukan per level. Generate ulang hanya saat file belum ada, naik level, atau ganti role. | Penyebut skill inventory stabil sehingga angka antar kuartal bisa dibandingkan. | Generate ulang setiap ada data baru. |
| D-23 | 2026-10-16 | Backup setiap Senin, Rabu, Sabtu 05:00 (`0 5 * * 1,3,6`). | Pilihan owner. RPO turun dari 7 hari ke ≤ 3 hari. | Mingguan; harian. |
| D-24 | 2026-10-16 | Op `archive` dihapus dari daftar ops SCHEMA. | Tidak dipakai lagi sejak session export dihapus. | Dipakai untuk penutupan career. |
| D-25 | 2026-10-16 | SCHEMA menjadi wajib, bukan advisory. Kasus yang tidak tercakup → ikuti aturan terdekat dan sebutkan. | Status advisory bentrok dengan self-check "STOP" dan prinsip hitung, bukan kira-kira. | Tetap advisory. |
| D-26 | 2026-10-16 | Topik dihitung "punya note" kalau ada note yang judul atau Ringkasan-nya membahas topik itu. Role Fit disimpan sebagai daftar topik, persentasenya dihitung saat dipakai. | Pembilang skill inventory dan role fit bisa diaudit sampai ke file. | Penilaian bebas oleh LLM. |
| D-27 | 2026-10-23 | Backup selalu lapor ke Telegram tiap run: berhasil, tidak ada perubahan, atau gagal. | Owner ingin konfirmasi setiap run. Tidak ada pesan di hari backup jadi tanda cron/Hermes mati. Tidak perlu trik `[SILENT]`. | Diam kalau tidak ada perubahan (`[SILENT]`, W22 lama). |
| D-28 | 2026-10-23 | Taxonomy tag dipindah ke `igrow/taxonomy.md`, agent-owned, tidak ditimpa deploy (W26). | Agent boleh langsung memakai tag yang disetujui user, tanpa menunggu deploy, dan tag itu tidak hilang saat rsync. Deploy jadi 2 langkah (exclude + `--ignore-existing`) supaya file itu tetap sampai ke VPS. | Agent tidak edit SCHEMA (tag baru baru bisa dipakai setelah deploy); tarik SCHEMA dari VPS sebelum deploy (gampang lupa). |
| D-29 | 2026-10-23 | Nama file incident = `YYYY-MM-DD-<slug>.md` (tanggal kejadian); knowledge, lesson, learning = slug topik saja. | Incident bisa terulang (CPU spike berkali-kali), jadi nama unik otomatis dan folder `incidents/` urut kronologis. Sesuai harapan test-flow 1.1. | Slug biasa + konteks pembeda karangan agent (mis. `cpu-spike-logrotate-2`). |
| D-30 | 2026-10-23 | Nama client asli boleh ditulis, tapi hanya di field `Vendor/Client` `about.md`. Di note dan file lain, client tetap disebut generik (`client A`). | Nama client diperlukan sebagai konteks karier, seperti di CV. Di note, nama client bercampur dengan detail sistem (IP, hostname, kejadian), jadi lebih sensitif. `about.md` ikut ter-backup ke GitHub privat dan terbaca provider LLM. | Anonim di semua file (W31, tidak jadi); nama client boleh di semua file. |

Tanggal "—" berarti keputusan diambil sebelum ada pencatatan tanggal.

## 3. Pertanyaan Terbuka

| ID | Pertanyaan | Kenapa penting | Usulan default |
|---|---|---|---|
| OQ-01 | ~~Skill map dibekukan per level, atau di-generate ulang setiap ada data baru?~~ | **Selesai (D-22):** dibekukan per level. | — |
| OQ-02 | ~~Apakah backup mingguan cukup?~~ | **Selesai (D-23):** backup Senin, Rabu, Sabtu 05:00. RPO ≤ 3 hari. | — |
| OQ-03 | ~~Op `archive` di SCHEMA masih perlu?~~ | **Selesai (D-24):** dihapus dari daftar ops. | — |
| OQ-04 | ~~Apa yang terjadi kalau tidak ada career aktif?~~ | **Selesai:** Hermes tidak menulis file dan menawarkan alur Daftar Kerjaan Baru (W3). | — |
| OQ-05 | ~~`roadmap.md` dan `completed.md` dipertahankan atau tidak?~~ | **Selesai (D-21):** hanya disebut di FIN yang sudah diarsipkan, jadi keduanya tidak ada lagi di spec. | Kalau fitur roadmap/completed dibutuhkan lagi, buka item baru di `todo.md`. |
| OQ-06 | Apakah `project-skills/` dipindah ke sistem Skill resmi Hermes (`SKILL.md`, `external_dirs`)? | Hemat token karena lazy-load, dan setiap skill otomatis menjadi slash command di Telegram. | Evaluasi setelah Phase 2 selesai. |
| OQ-07 | Sumber daily briefing: web research bebas, atau skill RSS/watchers resmi Hermes? | Kualitas dan konsistensi briefing. | Jalankan versi sekarang selama 2 minggu, nilai relevansinya, baru putuskan. Tiap item kini membawa URL sumber (W28), jadi kualitas sumbernya ikut bisa dinilai. |
| OQ-08 | Pin versi Hermes, atau tetap `:latest`? | Stabilitas versus update otomatis (R-05). | Pin setelah Phase 2 stabil. |
| OQ-09 | ~~Bagaimana nasib `docs/iGROW_FINAL.md` setelah PRD ada?~~ | **Selesai (D-21):** diarsipkan ke `archive/iGROW_FINAL.md`. | — |
| OQ-10 | Apakah target metrik di [01 · §7](01-overview.md#7-ukuran-sukses) disetujui? | Tanpa target yang disepakati, sukses tidak bisa dinilai. | Tinjau setelah 1 bulan pemakaian nyata. |

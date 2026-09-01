# dev-todo — hermes-home

## Critical
- [x] ~~Tulis `lint.md` + daftarkan di AGENTS.md File Referensi~~ — dibuat `project-skills/lint.md` (5 cek: orphan, broken link kecuali placeholder, frontmatter, tag, index vs fs) + 1 baris di AGENTS.md + prompt cron lint di build.md dipersingkat jadi point ke file
- [x] ~~Catat job backup di AGENTS.md / project-skills~~ — 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat. Jangan utak-atik `.git/`."
- [ ] SCHEMA.md:16 — `skill-map.md` human-owned vs mentor.md auto-generate. Ubah jadi: "agent generate pertama kali; setelah itu human-owned".
- [x] ~~test-me.md:19 — `--date today` salah~~ → `--date $(date +%F)`
- [x] ~~Exclude `_*.json` dari lint~~ — lint.md skip file berawalan `_`; cache tetap di tests/. Pindah ke `igrow/.cache/` kalau `_*.json` bertambah.

## Warning
- [x] ~~`_index.md` "Total pages: N"~~ — AGENTS step 2 sekarang eksplisit update counter tiap operasi tulis.
- [ ] SCHEMA.md:31 `sources:` — tentukan satu konvensi (field wajib, boleh `[]`).
- [x] ~~test-me.md:20 `<kategori>`~~ — SCHEMA: subfolder tests/ = tag taxonomy (`wiki/tests/linux/`).
- [x] ~~raw pipeline dua jalur~~ — `.processed/` dibuang (folder + AGENTS/SCHEMA/study); inbox → articles/ satu-satunya jalur.
- [x] ~~career-review perlu semua skor~~ — `confidence_calc.py --all` dump JSON semua topik (demo-tested); career-review.md step 3 point ke flag itu.
- [ ] Op `query` di SCHEMA tidak pernah dipakai — /recall tidak disuruh append log.

- [ ] Definisikan format isi skill-map.md (per-area, subskill, bobot?) — sekarang cuma "daftar skill per level", belum ada template baku.

## Improvement
- [ ] AGENTS.md File Referensi — rapikan kata kunci pemicu per baris.
- [ ] `_index.md` raw/wiki/output boilerplate identik — cukup tabel di master, subfolder opsional sampai >20 entri.
- [ ] log.md entry pertama pakai op `init` — tidak ada di daftar ops SCHEMA.
- [ ] Hapus `.gitkeep` begitu folder terisi file asli.
- [ ] Definisi "Career Aktif" dobel (AGENTS.md:44 + capture-experience.md:6) — pindah ke SCHEMA, AGENTS link.

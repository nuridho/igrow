# dev-todo — hermes-home

## Critical
- [ ] Tulis `lint.md` + daftarkan di AGENTS.md File Referensi — cron lint-mingguan sekarang jalan tanpa aturan.
- [x] ~~Catat job backup di AGENTS.md / project-skills~~ — 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat. Jangan utak-atik `.git/`."
- [ ] SCHEMA.md:16 — `skill-map.md` human-owned vs mentor.md auto-generate. Ubah jadi: "agent generate pertama kali; setelah itu human-owned".
- [x] ~~test-me.md:19 — `--date today` salah~~ → `--date $(date +%F)`
- [ ] Exclude `_*.json` dari lint / pindah cache ke `igrow/.cache/` — `_index.json` jadi false-positive orphan tiap Minggu.

## Warning
- [ ] `_index.md` "Total pages: N" — tidak ada aturan kapan counter di-update → drift.
- [ ] SCHEMA.md:31 `sources:` — tentukan satu konvensi (field wajib, boleh `[]`).
- [ ] test-me.md:20 `wiki/tests/<kategori>/` — `<kategori>` tidak terdefinisi di mana pun.
- [ ] raw pipeline: AGENTS/SCHEMA pakai `inbox/ → .processed/`, study.md dump langsung `raw/articles/` — satukan.
- [ ] career-review.md step 3 — `confidence_calc.py` cuma per-topik; tambah flag `--all` atau parse tests/ langsung.
- [ ] Op `query` di SCHEMA tidak pernah dipakai — /recall tidak disuruh append log.

## Improvement
- [ ] AGENTS.md File Referensi — rapikan kata kunci pemicu per baris.
- [ ] `_index.md` raw/wiki/output boilerplate identik — cukup tabel di master, subfolder opsional sampai >20 entri.
- [ ] log.md entry pertama pakai op `init` — tidak ada di daftar ops SCHEMA.
- [ ] Hapus `.gitkeep` begitu folder terisi file asli.
- [ ] Definisi "Career Aktif" dobel (AGENTS.md:44 + capture-experience.md:6) — pindah ke SCHEMA, AGENTS link.

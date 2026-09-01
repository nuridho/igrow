# dev-todo — hermes-home

## Critical
- [x] ~~Tulis `lint.md` + daftarkan di AGENTS.md File Referensi~~ — dibuat `project-skills/lint.md` (5 cek: orphan, broken link kecuali placeholder, frontmatter, tag, index vs fs) + 1 baris di AGENTS.md + prompt cron lint di build.md dipersingkat jadi point ke file
- [x] ~~Catat job backup di AGENTS.md / project-skills~~ — 1 baris di AGENTS.md: "`igrow/` adalah git repo — di-backup cron mingguan ke GitHub privat. Jangan utak-atik `.git/`."
- [ ] SCHEMA.md:16 — `skill-map.md` human-owned vs mentor.md auto-generate. Ubah jadi: "agent generate pertama kali; setelah itu human-owned".
- [x] ~~test-me.md:19 — `--date today` salah~~ → `--date $(date +%F)`
- [x] ~~Exclude `_*.json` dari lint~~ — lint.md skip file berawalan `_`; cache tetap di tests/. Pindah ke `igrow/.cache/` kalau `_*.json` bertambah.

## Warning
- [ ] `_index.md` "Total pages: N" — tidak ada aturan kapan counter di-update → drift.
- [ ] SCHEMA.md:31 `sources:` — tentukan satu konvensi (field wajib, boleh `[]`).
- [ ] test-me.md:20 `wiki/tests/<kategori>/` — `<kategori>` tidak terdefinisi di mana pun.
- [ ] raw pipeline: AGENTS/SCHEMA pakai `inbox/ → .processed/`, study.md dump langsung `raw/articles/` — satukan.
- [ ] career-review.md step 3 — `confidence_calc.py` cuma per-topik; tambah flag `--all` atau parse tests/ langsung.
- [ ] Op `query` di SCHEMA tidak pernah dipakai — /recall tidak disuruh append log.

- [ ] Definisikan format isi skill-map.md (per-area, subskill, bobot?) — sekarang cuma "daftar skill per level", belum ada template baku.

## Improvement
- [ ] AGENTS.md File Referensi — rapikan kata kunci pemicu per baris.
- [ ] `_index.md` raw/wiki/output boilerplate identik — cukup tabel di master, subfolder opsional sampai >20 entri.
- [ ] log.md entry pertama pakai op `init` — tidak ada di daftar ops SCHEMA.
- [ ] Hapus `.gitkeep` begitu folder terisi file asli.
- [ ] Definisi "Career Aktif" dobel (AGENTS.md:44 + capture-experience.md:6) — pindah ke SCHEMA, AGENTS link.

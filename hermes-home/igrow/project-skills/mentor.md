# Referensi: Mentor (UC2)

Kamu = mentor iGROW berbasis data. Analisa gap dari wiki/ yang ada, BUKAN roadmap generik.

Dipakai kalau user tanya roadmap belajar, kelemahan, "harus belajar apa", atau "role apa cocok buat saya".

## Input data
1. Target: `igrow/wiki/roadmap/skill-map.md`. Belum ada → generate dulu (aturan di SCHEMA "skill-map.md format"). Sudah ada → pakai apa adanya; skill map beku per level, data baru BUKAN alasan generate ulang.
2. Bukti: mulai dari `igrow/_index.md`, lalu note di `careers/*/knowledge/` (termasuk `incidents/`), `careers/*/lessons-learned/`, `self-development/`.

Status tiap topik target (aturan "punya note" di SCHEMA):
- Known = ada note yang membahas topik itu
- Weak = cuma disinggung di note lain (mis. incident), belum ada note sendiri
- Belum = tidak muncul sama sekali

Gap = Weak + Belum.
→ OUTPUT: "Gap = <topik> (<Weak|Belum>: <file bukti atau 0 note>)" sebelum tulis tabel/rekomendasi.

## Output

### A. Jika user tanya "harus belajar apa" / roadmap
- Tabel per topik target: Status (Known/Weak/Belum) · Bukti (nama note/incident + tanggal, atau "0 note") · Experience (incident terkait yang pernah dialami, kalau ada) · Kenapa gap (dibutuhkan level target tapi Weak/Belum)
- Update `wiki/roadmap/weak-topics.md` (format di SCHEMA) kalau ada temuan baru
- Rekomendasi personal dari Experience ("kamu sudah pernah kena X, mulai dari Y") + sebut note/incident dasarnya. BUKAN roadmap generik.

### B. Jika user tanya "role apa cocok" / kecocokan karier
- Role Fit dari section `## Role Fit` skill map: % = topik role yang Known / total topik role itu. Selalu tulis X/Y.
- Tiap topik yang kurang: Weak atau Belum + kenapa penting buat role itu
- 2 role paling cocok + 2 role paling jauh, masing-masing dengan gap spesifik
- Rekomendasi personal ("kamu 6/8 cocok untuk SRE karena sudah punya networking + incident, tapi kurang terraform — mulai dari situ")

## Prasyarat jujur
- Kurang dari 3 note di `careers/` → jawab "Data karier belum cukup untuk gap analysis (minimal 3 incident/knowledge)". Jangan ngarang roadmap generik.
- Skill map belum ada BUKAN alasan menolak — generate dulu.

## Tutup
Kalau ada file ditulis/diupdate (skill-map, weak-topics): ikut aturan wajib SCHEMA (update wiki/_index.md + master _index.md + log.md, op: update).

## Contoh Eksekusi

Input: "role apa cocok buat saya?"

Output:

| Role | Cocok | Kurang |
|---|---|---|
| SRE | 6/8 = 75% | terraform [Belum, 0 note], prometheus [Weak, disinggung di incident 2026-09-12] |
| DevOps | 4/6 = 67% | ansible [Belum, 0 note], terraform [Belum, 0 note] |
| Cloud Engineer | 2/6 = 33% | aws-core [Belum], iam [Belum], vpc [Weak], terraform [Belum] |
| Security Analyst | 1/5 = 20% | siem [Belum], threat-hunting [Belum], vulnerability-management [Belum], iam [Belum] |

Rekomendasi: "Paling dekat ke SRE (6/8). Mulai dari terraform: gap yang sama muncul di SRE, DevOps, dan Cloud Engineer."

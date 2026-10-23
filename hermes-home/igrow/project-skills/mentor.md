# Referensi: Mentor (UC2)

Kamu = mentor iGROW berbasis data. Analisa gap dari wiki/ yang ada, BUKAN roadmap generik.

Dipakai kalau user tanya roadmap belajar, kelemahan, "harus belajar apa", atau "role apa cocok buat saya".

## Input data
1. Target: `igrow/wiki/roadmap/skill-map.md`. Belum ada → generate dulu (aturan di SCHEMA "skill-map.md format"). Sudah ada → pakai apa adanya; skill map beku per level, data baru BUKAN alasan generate ulang.
2. Bukti: mulai dari `igrow/wiki/_index.md`, lalu note di `careers/*/knowledge/` (termasuk `incidents/`), `careers/*/lessons-learned/`, `self-development/`.

Status tiap topik target (Known / Weak / Belum) dan Gap: definisi di SCHEMA § skill-map.md format (sama dengan yang dipakai career review).

## Output

### A. Jika user tanya "harus belajar apa" / roadmap
- Baris pertama balasan: "Gap = <topik> (<Weak|Belum>: <file bukti atau 0 note>), ...", sebelum tabel dan rekomendasi.
- Tabel per topik target: Status (Known/Weak/Belum) · Bukti (nama note/incident + tanggal, atau "0 note") · Experience (incident terkait yang pernah dialami, kalau ada) · Kenapa gap (dibutuhkan level target tapi Weak/Belum)
- Tulis ulang `wiki/roadmap/weak-topics.md` (format di SCHEMA) dari Gap semua topik target skill map, bukan hanya area yang ditanya: topik yang sudah Known hilang dari daftar. Isinya sama dengan versi lama → tidak ditulis (tanpa update index dan log). Ditulis → sebut di balasan.
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
Kalau ada file ditulis/diupdate (skill-map, weak-topics): ikut aturan wajib SCHEMA (update wiki/_index.md + log.md, op: update).

## Contoh Eksekusi
Dua contoh, satu per jenis pertanyaan. Tiap bagian diberi label tujuan `[...]`; yang dikirim ke chat HANYA bagian [BALASAN KE USER], isi file tidak ditempel ke chat.

Contoh A (roadmap):
````
[PESAN USER — masuk dari Telegram]
"harus belajar apa biar naik ke L2?"

[FILE DITULIS — wiki/roadmap/weak-topics.md; ditulis ulang dari Gap terbaru (isi sama dengan versi lama → tidak ditulis); tidak dikirim ke chat]
---
title: Weak Topics
type: data
updated: 2026-10-23
---
- prometheus — Weak: cuma disinggung di 2026-09-12-disk-alert-telat.md
- terraform — Belum: 0 note, dibutuhkan target L2
- routing — Belum: 0 note, dibutuhkan target L2

[EDIT INDEX — wiki/_index.md: baris roadmap/weak-topics.md, kolom Updated diganti; tidak dikirim ke chat]
| roadmap/weak-topics.md | Gap terbaru vs target L2 | - | 2026-10-23 |

[LOG — append igrow/log.md; tidak dikirim ke chat]
## [2026-10-23] update | weak-topics (3 gap vs target L2)

[BALASAN KE USER — dikirim ke Telegram]
Gap = prometheus (Weak: 2026-09-12-disk-alert-telat.md), terraform (Belum: 0 note), routing (Belum: 0 note)

| Topik | Status | Bukti | Experience | Kenapa gap |
|---|---|---|---|---|
| linux-performance | Known | performance-tuning.md | incident CPU spike 2026-09-19 | - |
| prometheus | Weak | disinggung di 2026-09-12-disk-alert-telat.md | alert disk telat 2026-09-12 | L2 bikin alert sendiri |
| terraform | Belum | 0 note | - | IaC dipakai di target L2 |
| routing | Belum | 0 note | - | troubleshooting jaringan L2 |

Rekomendasi: mulai dari prometheus. Kamu sudah pernah kena alert disk yang telat (2026-09-12), jadi bikin alert rule sendiri langsung kepakai. Setelah itu terraform.
weak-topics.md diperbarui (3 gap).
````

Contoh B (role fit):
````
[PESAN USER — masuk dari Telegram]
"role apa cocok buat saya?"

[BALASAN KE USER — dikirim ke Telegram; tidak ada file yang ditulis]
| Role | Cocok | Kurang |
|---|---|---|
| SRE | 6/8 = 75% | terraform [Belum, 0 note], prometheus [Weak, disinggung di incident 2026-09-12] |
| DevOps | 4/6 = 67% | ansible [Belum, 0 note], terraform [Belum, 0 note] |
| Cloud Engineer | 2/6 = 33% | aws-core [Belum], iam [Belum], vpc [Weak], terraform [Belum] |
| Security Analyst | 1/5 = 20% | siem [Belum], threat-hunting [Belum], vulnerability-management [Belum], iam [Belum] |

Rekomendasi: Paling dekat ke SRE (6/8). Mulai dari terraform: gap yang sama muncul di SRE, DevOps, dan Cloud Engineer.
````
Kurang dari 3 note di `careers/` → [BALASAN KE USER] cukup `Data karier belum cukup untuk gap analysis (minimal 3 incident/knowledge).`

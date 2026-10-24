# 08 · Import Catatan Lama (SEMENTARA)

> **Dokumen sementara.** Hapus (atau arsipkan) setelah catatan lama selesai masuk ke Hermes. Bukan bagian spec produk.

## 1. Masalah

Owner punya catatan kerja setahun, banyak, dan bingung mulai dari mana. iGROW belum punya prosedur impor massal: alur UC1 menerima cerita satu per satu lewat Telegram ([`02-use-cases.md`](02-use-cases.md), prosedur di `hermes-home/igrow/project-skills/capture-experience.md`).

## 2. Keputusan

- **Tidak ada fitur baru di `hermes-home/`.** Pemilahan dikerjakan manual-dibantu Claude Code di folder staging, lalu hasilnya dikirim ke Hermes lewat alur UC1/UC3 yang sudah ada.
- **Staging di dalam repo, di-gitignore** (`import-staging/`, baris di `.gitignore`). Alasan: repo Publik (D-35), catatan mentah bisa memuat IP, credential, atau nama client; yang pernah ter-commit tidak bisa ditarik. Pengaman ini hanya melindungi file yang belum pernah di-track: jangan `git add -f` isinya, dan jangan hapus baris `import-staging/` dari `.gitignore`.
- **Hermes tetap penulis note final** (frontmatter, tag, dual-link, index, log). Claude Code tidak menulis ke `wiki/`.
- **Bertahap.** 10 catatan terbaik dulu, cek hasilnya, baru lanjut 5–10 per sesi, dari yang terbaru.

## 3. Alur

| # | Langkah | Siapa |
|---|---|---|
| 1 | Salin catatan lama ke `00-mentah/` (jangan diedit) | Owner |
| 2 | Pilah ke `siap-kirim/{tshoot,sop,lesson,study,perlu-dicek}` atau `dibuang`; rename; ganti IP/credential/nama client dengan placeholder | Claude Code |
| 3 | Tulis `triase.md` (file asal → file hasil, jenis, alasan, apa yang diredaksi) | Claude Code |
| 4 | Owner periksa `triase.md`, koreksi jenis yang salah | Owner |
| 5 | Daftarkan kerjaan (`Daftar kerjaan baru`), lalu kirim file ke Hermes 5–10 per sesi | Owner |
| 6 | Baca balasan Hermes, koreksi lewat chat kalau perlu | Owner |

Pemetaan jenis ke tipe note dan folder wiki: lihat `capture-experience.md` § Langkah (tshoot = incident, sop = knowledge, lesson = lesson). `study` lewat `raw/inbox/` (UC3). Aturan nama file ikut baris itu juga; jangan disalin ke sini.

## 4. Batasan

- Screenshot dan dokumen lampiran disimpan Hermes **apa adanya tanpa redaksi** (keputusan owner). Jangan kirim yang memuat credential.
- Dokumen Word/PDF maksimal 20 MB (Bot API publik); hasil scan tanpa teks sulit dibaca.
- Catatan lama dari beberapa kerjaan: daftarkan kerjaan dari yang terlama; Hermes bertanya kalau ada lebih dari satu career aktif.

## 5. Selesai kalau

- [ ] 10 catatan pertama masuk dan hasilnya dinilai layak (tag cocok, isi benar).
- [ ] Sisa tumpukan A (pengalaman kerja) masuk atau sengaja dibuang.
- [ ] `lint` mingguan tidak melaporkan temuan baru dari hasil impor.
- [ ] Dokumen ini dihapus/diarsipkan, baris di `README.md` dan `05-roadmap.md` ikut dibersihkan.

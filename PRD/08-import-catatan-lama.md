# 08 · Import Catatan Lama (SEMENTARA)

> **Dokumen sementara.** Hapus (atau arsipkan) setelah catatan lama selesai masuk ke Hermes. Bukan bagian spec produk.

## 1. Masalah

Owner punya catatan kerja setahun, banyak, dan bingung mulai dari mana. iGROW belum punya prosedur impor massal: alur UC1 menerima cerita satu per satu lewat Telegram ([`02-use-cases.md`](02-use-cases.md), prosedur di `hermes-home/igrow/project-skills/capture-experience.md`).

## 2. Keputusan

- **Tidak ada fitur baru di `hermes-home/`.** Pemilahan dikerjakan manual-dibantu Claude Code di folder staging, lalu hasilnya dikirim ke Hermes lewat alur UC1/UC3 yang sudah ada.
- **Staging di dalam repo, di-gitignore** (`import-staging/`, baris di `.gitignore`). Alasan: repo Publik (D-35), catatan mentah bisa memuat IP, credential, atau nama client; yang pernah ter-commit tidak bisa ditarik. Pengaman ini hanya melindungi file yang belum pernah di-track: jangan `git add -f` isinya, dan jangan hapus baris `import-staging/` dari `.gitignore`.
- **Dua peran dipisah: MSO dan DSM** (keputusan owner 2026-10-24). Satu tim shift punya dua peran: **MSO** (Midrange System Operation, handle server) dan **DSM** (Data Storage Management, handle storage dan SANDIR = SAN Director, mis. Brocade X6/X7). Catatan tiap peran tidak dicampur: staging punya `siap-kirim/mso/` dan `siap-kirim/dsm/`, masing-masing berisi `tshoot/sop/lesson/study`. Catatan yang perannya tidak jelas masuk `siap-kirim/perlu-dicek/`, bukan ditebak. Cara memisahkannya di wiki Hermes (career terpisah atau tag) belum diputuskan: lihat §7.
- **Hermes tetap penulis note final** (frontmatter, tag, dual-link, index, log). Claude Code tidak menulis ke `wiki/`.
- **Bertahap.** 10 catatan terbaik dulu, cek hasilnya, baru lanjut 5–10 per sesi, dari yang terbaru.

## 3. Alur

| # | Langkah | Siapa |
|---|---|---|
| 1 | Salin catatan lama ke `00-mentah/` (jangan diedit) | Owner |
| 2 | Pecah catatan jadi **satu kasus satu PDF** (format di §4), pilah per peran dan jenis ke `siap-kirim/{mso,dsm}/{tshoot,sop,lesson,study}`, `siap-kirim/perlu-dicek`, atau `dibuang`. **Isi tidak diredaksi sama sekali** (keputusan owner 2026-10-24) | Claude Code |
| 3 | Tulis `triase.md`, satu baris per PDF (kolom di §4) | Claude Code |
| 4 | Owner periksa `triase.md`, koreksi jenis yang salah | Owner |
| 5 | Daftarkan kerjaan (`Daftar kerjaan baru`), lalu kirim PDF ke Hermes 5–10 per sesi, satu PDF per pesan (1-1 dengan satu note) | Owner |
| 6 | Baca balasan Hermes, koreksi lewat chat kalau perlu | Owner |

Pemetaan jenis ke tipe note dan folder wiki: lihat `capture-experience.md` § Langkah (tshoot = incident, sop = knowledge, lesson = lesson). `study` lewat `raw/inbox/` (UC3). Aturan nama file ikut baris itu juga; jangan disalin ke sini.

## 4. Format PDF per kasus

Dibuat dengan reportlab (Python 3.12 terpisah di `import-staging/.venv-pdf`, bukan `python` di PATH yang milik Hermes). Satu kejadian/SOP/lesson = satu PDF, supaya masuk 1-1 ke Hermes dan tiap note punya rujukan ke file aslinya.

**Nama file**
- `tshoot`: `YYYY-MM-DD-slug.pdf` (tanggal = tanggal kejadian). `sop` dan `lesson`: `slug.pdf`. Slug huruf kecil, pakai tanda hubung. Aturan penamaan note di wiki ada di `capture-experience.md`, jangan disalin ke sini.
- Gambar yang dipakai kasus disalin di folder yang sama dengan nama `<nama-pdf>-1.png`, `-2.png`, dan seterusnya; nama aslinya (mis. `IMG-...jpg`) dicatat di bagian Rujukan.

**Isi PDF (urutan tetap, A4, Indonesia)**

| Bagian | Isi | Dibaca Hermes? |
|---|---|---|
| Judul | sama dengan nama file tanpa ekstensi | ya |
| Rujukan | tabel: Peran (+ alasan singkat), Jenis (`tshoot`→incident, `sop`→knowledge, `lesson`→lesson), Sumber (file chat + nomor baris + rentang tanggal/jam), Lampiran (nama gambar + nama aslinya), Keyakinan peran (tinggi/sedang/rendah) | ya |
| Cerita | kejadian atau cara kerja dalam suara owner, runut, tanpa redaksi. Inilah bahan note | ya |
| Lampiran | gambar yang menempel di kasus itu, ukuran lebar halaman, dengan keterangan | ya (disimpan apa adanya di `raw/assets/`) |
| Cuplikan chat asli | potongan chat dengan jam, sebagai bukti | ya |

Karena Hermes membaca seluruh PDF, bagian Rujukan dan Cuplikan ikut menjadi konteks note; tidak perlu disaring.

**`triase.md`** (satu file untuk seluruh batch, di `import-staging/`): satu baris per PDF dengan kolom `#` (urutan kirim), File hasil, Peran, Jenis, Sumber (chat), Lampiran, Peringatan. Kolom Peringatan hanya menandai bagian yang memuat data sensitif (mis. "screenshot memuat nama switch asli"); isinya tidak diubah. Dari baris ini owner bisa melacak tiap kasus ke chat aslinya dan mengoreksi peran/jenis yang salah sebelum dikirim.

**Pembagian peran:** DSM = storage, SAN, zoning, port, ISL, firmware switch FC, LUN; MSO = server, OS, aplikasi di server, patching, backup server. Ragu peran atau jenis → `perlu-dicek/`, tidak ditebak.

## 5. Batasan

- **Redaksi hanya dikerjakan Hermes**, saat menulis note di wiki (aturan `AGENTS.md` § DILARANG KERAS). Staging dan PDF hasil analisis berisi data asli, jadi folder `import-staging/` jangan pernah di-commit atau dibagikan.
- Screenshot dan dokumen lampiran (termasuk PDF hasil analisis) disimpan Hermes **apa adanya tanpa redaksi** di `raw/assets/` (keputusan owner), lalu ikut ke repo backup privat. Hanya note-nya yang diredaksi.
- Dokumen Word/PDF maksimal 20 MB (Bot API publik); hasil scan tanpa teks sulit dibaca.
- Catatan lama dari beberapa kerjaan: daftarkan kerjaan dari yang terlama; Hermes bertanya kalau ada lebih dari satu career aktif.

## 6. Selesai kalau

- [ ] 10 catatan pertama masuk dan hasilnya dinilai layak (tag cocok, isi benar).
- [ ] Sisa tumpukan A (pengalaman kerja) masuk atau sengaja dibuang.
- [ ] `lint` mingguan tidak melaporkan temuan baru dari hasil impor.
- [ ] Dokumen ini dihapus/diarsipkan, baris di `README.md` dan `05-roadmap.md` ikut dibersihkan.

## 7. Pertanyaan terbuka

- **Bagaimana MSO dan DSM dipisah di wiki Hermes?** Wiki sekarang mengelompokkan per career (`careers/career-N-{company}-{role}/`), dan `taxonomy.md` hanya punya tag `storage`, tanpa tag untuk server midrange atau SAN. Opsi: (a) satu career per peran, supaya `skills.md` dan folder benar-benar terpisah; (b) satu career dengan peran dibedakan lewat tag. Sampai diputuskan, staging sudah terpisah per peran dan itu tidak perlu diubah. Kalau (b) dipilih dan perlu tag baru, tambahkan lewat aturan SCHEMA § Tag taxonomy; kalau perlu perubahan prosedur di `hermes-home/`, catat sebagai item di `todo.md`.

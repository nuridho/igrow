# Referensi: Daily Briefing (UC3)

Kamu = infra news curator. Maks 5 berita penting yang bersumber + alasan peduli, bukan banyak berita tanpa konteks.

Dipicu cron 07:00 (atau user minta briefing di chat). Topik (bagian dari `igrow/taxonomy.md`): linux, windows-server, kubernetes, docker, vmware,
cloud, networking, monitoring, devops, sre, security, cve.

## Langkah
1. Web search berita yang terbit ≤ 24 jam terakhir (menyambung dari briefing kemarin) untuk topik di atas, lalu pilih
   maks 5 yang paling penting buat infra/karier user. Isi briefing HANYA dari hasil search hari ini, JANGAN dari
   ingatan. Tanggal terbit tidak jelas atau lebih dari 24 jam → lewati.
2. Format jawaban akhir:

```
DAILY INFRA BRIEFING
<tanggal>

1. <Topik>
   [News | Release/update] <berita>
   Why it matters: ...
   Sumber: <URL>

2. Security
   [CVE] <CVE-ID>: <ringkasan>
   Affected technology: ...
   Severity: <Critical|High|Medium|Low> (+ skor CVSS kalau ada)
   Why you should care: ...
   Sumber: <URL>

5. Career
   [Technology trend] <tren>
   Relevant skill: ...
   Sumber: <URL>
```

   - Tiap item WAJIB punya `Sumber:` = URL dari hasil search hari ini, bukan URL yang diingat atau dikarang.
   - Item CVE WAJIB punya Affected technology + Severity. CVE-ID, severity, dan skor CVSS hanya ditulis kalau
     tercantum di sumber: tanpa CVE-ID → tulis sebagai `[News]`; severity belum ada → `Severity: belum dinilai di sumber`.
   - Item Career opsional, maks 1.
3. Kurang dari 5 item yang bersumber → kirim yang ada saja, jangan ditambal. Tidak ada satu pun (search gagal atau
   hasil kosong) → jawaban akhir cukup `Briefing <tanggal> gagal: <alasan>`.
4. Jawaban akhir = isi pesan Telegram apa adanya (dikirim otomatis, dari cron maupun chat; jangan pakai tool kirim
   pesan): briefing saja, tanpa alasan pemilihan atau catatan proses. Tidak menulis ke wiki/ kecuali ada yg layak jadi page
   (kalau iya, ikut aturan wajib SCHEMA, op: ingest).

## Contoh Eksekusi
Blok di bawah dibagi per tujuan (lihat label `[...]`). Yang terkirim ke Telegram HANYA bagian [JAWABAN AKHIR], tanpa baris lain sebelum atau sesudahnya.
````
[PROMPT CRON — tiap hari 07:00]
Baca igrow/project-skills/daily-briefing.md lalu kerjakan.

[JAWABAN AKHIR — dikirim cron ke Telegram]
DAILY INFRA BRIEFING
16 October 2026

1. Kubernetes
   [Release/update] Patch release baru memperbaiki bug kubelet yang bikin pod restart berulang.
   Why it matters: cluster production perlu dijadwalkan upgrade minggu ini.
   Sumber: <URL dari hasil search, mis. changelog kubernetes.io>

2. Security
   [CVE] CVE-YYYY-NNNNN: remote code execution di OpenSSH server
   Affected technology: OpenSSH server (Linux)
   Severity: High (CVSS 8.1)
   Why you should care: semua server Linux dengan SSH terbuka wajib dicek versinya.
   Sumber: <URL dari hasil search, mis. advisory vendor atau NVD>

3–4. [...]

5. Career
   [Technology trend] Permintaan skill platform engineering naik.
   Relevant skill: kubernetes, devops
   Sumber: <URL artikel dari hasil search>
````
Search gagal → [JAWABAN AKHIR] `Briefing 16 October 2026 gagal: web search error (timeout)`.

# Referensi: Daily Briefing (UC3)

Kamu = infra news curator. 5 berita penting + alasan peduli, bukan banyak berita tanpa konteks.

Dipicu cron 07:00. Topik (bagian dari `igrow/taxonomy.md`): linux, windows-server, kubernetes, docker, vmware,
cloud, networking, monitoring, devops, sre, security, cve.

## Langkah
1. Web research berita terbaru (maks 5 info penting).
   → OUTPUT: "Pilih <berita> karena <relevan ke topik/infra kamu>" — 1 baris per item sebelum masuk format akhir.
2. Format output:

```
DAILY INFRA BRIEFING
<tanggal>

1. <Topik>
   [News | Release/update] <berita>
   Why it matters: ...

2. Security
   [CVE] <CVE-ID>: <ringkasan>
   Affected technology: ...
   Severity: <Critical|High|Medium|Low> (+ skor CVSS kalau ada)
   Why you should care: ...

5. Career
   [Technology trend] <tren>
   Relevant skill: ...
```

   - Item CVE WAJIB punya Affected technology + Severity.
   - Item Career opsional, maks 1.
3. Prinsip: 5 info penting + alasan peduli. Bukan berita banyak.
4. Kirim ke Telegram. Tidak menulis ke wiki/ kecuali ada yg layak jadi page
   (kalau iya, ikut aturan wajib SCHEMA, op: ingest).

## Contoh Eksekusi

```
DAILY INFRA BRIEFING
16 October 2026

1. Kubernetes
   [Release/update] Patch release baru memperbaiki bug kubelet yang bikin pod restart berulang.
   Why it matters: cluster production perlu dijadwalkan upgrade minggu ini.

2. Security
   [CVE] CVE-YYYY-NNNNN: remote code execution di OpenSSH server
   Affected technology: OpenSSH server (Linux)
   Severity: High (CVSS 8.1)
   Why you should care: semua server Linux dengan SSH terbuka wajib dicek versinya.

3–4. [...]

5. Career
   [Technology trend] Permintaan skill platform engineering naik.
   Relevant skill: kubernetes, devops
```

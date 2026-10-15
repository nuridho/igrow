# TODO: Evaluasi migrasi penuh iGROW ke Jev

Status: PARKED — jangan migrasi sebelum POC membuktikan layak.

## TL;DR

Jev adalah AI decision model, bukan chatbot atau coding agent. Ia cocok untuk `choice`, `score`, dan `yes/no` dengan probabilitas + confidence.

Migrasi full hanya mungkin jika iGROW diubah menjadi aplikasi workflow terstruktur:

```text
Telegram → parser/form → Jev → confidence gate → kode workflow → Markdown/index/log
```

Hermes/LLM sekarang menangani percakapan bebas, parsing cerita panjang, dan penulisan narasi. Jev tidak melakukan itu.

## Memory dan session checkpoint

Jev tidak otomatis mengingat percakapan atau berkembang seperti Hermes. Jika Jev menjadi engine utama, aplikasi harus mengelola memory sendiri.

- [ ] Simpan `session state`: session ID, workflow aktif, field yang sudah terkumpul, dan langkah berikutnya.
- [ ] Simpan `user memory`: fakta stabil tentang karier dan preferensi.
- [ ] Gunakan Markdown sebagai knowledge utama iGROW.
- [ ] Tambahkan storage kecil untuk session/checkpoint; SQLite atau PostgreSQL cukup, jangan jadikan database pengganti wiki.
- [ ] Setiap request n8n mengambil state relevan + pesan baru lalu mengirimkannya ke Jev.
- [ ] Simpan keputusan Jev, confidence, dan action yang diambil untuk audit/rollback.
- [ ] Buat fallback jika checkpoint hilang, state terlalu besar, Jev timeout, atau confidence rendah.
- [ ] Uji percakapan lintas session: Jev harus tetap memahami career aktif, pending action, dan field yang belum lengkap.

Contoh state minimum:

```json
{
  "session_id": "telegram-123",
  "active_workflow": "capture_incident",
  "active_career": "career-2-example",
  "collected_fields": {"symptom": "...", "investigation": null},
  "pending_action": "ask_investigation"
}
```

Checkpoint ini bukan dump percakapan verbose seperti session export agent. Ia adalah state ringkas yang bisa dipakai untuk melanjutkan workflow.

## Penerapan dengan n8n

n8n dipakai sebagai orkestrator workflow, bukan sebagai pengganti Jev atau memory engine.

### Arsitektur kandidat

```text
Telegram Trigger / Webhook
  → ambil session state + memory + konteks Markdown
  → Jev API (HTTP Request)
  → validasi typed answer + confidence gate
  → Switch/IF: route workflow
  → Code node atau writer service terbatas
  → tulis Markdown + update _index.md + log.md
  → Telegram response template
```

### Peran komponen

| Komponen | Tanggung jawab |
|---|---|
| Telegram Trigger | Input/output chat |
| n8n | Routing, branching, retry, scheduler, API wiring |
| HTTP Request node | Memanggil Jev API |
| Jev | Choice, Score, Noul, probabilitas, confidence |
| SQLite/PostgreSQL | Session state, checkpoint, decision log |
| Markdown writer service | Validasi dan tulis file iGROW secara deterministic |
| Git/filesystem | Knowledge Markdown dan backup |

### Workflow n8n minimum

- [ ] `WF-01 Inbound`: terima Telegram, normalisasi user/session ID, redaction awal.
- [ ] `WF-02 Context`: baca checkpoint, user memory, career aktif, dan index relevan.
- [ ] `WF-03 Decision`: kirim state + pertanyaan typed ke Jev.
- [ ] `WF-04 Gate`: cek schema answer, confidence, timeout, dan rate limit.
- [ ] `WF-05 Route`: arahkan ke UC1 Capture, UC2 Mentor, UC3 Daily Briefing, UC4 Study, atau UC5 Career Review.
- [ ] `WF-06 Checkpoint`: simpan workflow aktif, field terkumpul, pending action, dan keputusan terakhir.
- [ ] `WF-07 Write`: panggil writer service atau Code node untuk Markdown/index/log.
- [ ] `WF-08 Reply`: kirim template balasan ke Telegram.
- [ ] `WF-09 Error`: fallback saat Jev gagal, confidence rendah, state korup, atau writer gagal.
- [ ] `WF-10 Scheduled`: cron daily briefing dan career review dengan n8n Schedule Trigger.

### Batas desain n8n

- [ ] Jangan taruh seluruh logic iGROW di satu workflow raksasa.
- [ ] Pecah workflow per tahap atau UC; gunakan sub-workflow hanya jika benar-benar dipakai ulang.
- [ ] Jangan menjadikan Code node sebagai tempat menyimpan secret atau menjalankan command shell bebas.
- [ ] Batasi writer service ke folder `igrow/`, validasi path untuk mencegah path traversal, dan gunakan allowlist operasi.
- [ ] Setiap write harus atomic atau punya rollback; index dan log tidak boleh rusak jika proses berhenti di tengah.
- [ ] Persist execution errors dan decision log, tetapi jangan menyimpan token/API key atau data sensitif mentah.
- [ ] Atur retry/idempotency agar pesan Telegram tidak membuat note duplikat.
- [ ] Ukur biaya Jev per workflow, bukan hanya biaya satu request.
- [ ] Uji import/export workflow n8n dan backup credential secara aman.

### POC n8n

- [ ] Mulai satu workflow kecil: Telegram → Jev routing → template reply.
- [ ] Lanjutkan: routing → checkpoint → writer Markdown → index/log.
- [ ] Uji confidence rendah dengan pertanyaan klarifikasi.
- [ ] Uji Jev timeout, duplicate Telegram update, API 429, dan writer failure.
- [ ] Uji satu end-to-end UC1 sebelum membuat workflow UC2–UC5.
- [ ] Bandingkan n8n dengan service Python kecil untuk bagian writer; pilih yang paling kecil dan mudah diverifikasi.

### Pro n8n

- Wiring Telegram, HTTP API, cron, retry, dan branching cepat dibuat.
- Execution history memudahkan debugging workflow.
- Cocok untuk prototipe dan cron UC3/UC5.
- Mengurangi kode glue custom.

### Kontra n8n

- Workflow visual bisa menjadi sulit direview dan version-control jika terlalu besar.
- File write, locking, idempotency, dan transaksi multi-file tetap butuh kode khusus.
- n8n menambah service, RAM, backup, credential, dan attack surface.
- Debugging decision + state + retry bisa lebih rumit daripada satu service kecil.
- Self-hosted n8n bukan otomatis aman; webhook dan credential perlu hardening.

### Keputusan arsitektur awal

Gunakan n8n hanya sebagai orchestrator POC. Jev tetap decision engine, Markdown tetap knowledge utama, dan writer tetap komponen deterministic yang sempit. Jika workflow mulai penuh Code node atau membutuhkan transaction/locking kompleks, pindahkan writer dan state manager ke service kecil; jangan memaksa semua logic masuk n8n.

## Yang wajib dibuktikan

- [ ] Routing pesan: capture / study / recall / mentor / briefing / career-review.
- [ ] Klasifikasi: type note, folder, tag, career aktif.
- [ ] Capture incident tanpa LLM penulis: input terstruktur → Markdown valid.
- [ ] Semua 5 use case iGROW tetap menghasilkan output yang berguna.
- [ ] Confidence rendah punya fallback/human review.
- [ ] Output lolos SCHEMA, index, log, dan guard iGROW.
- [ ] Biaya total, latency, rate limit, dan akurasi lebih baik.
- [ ] Data sensitif aman saat dikirim ke API eksternal.
- [ ] Rollback ke Hermes tetap mudah.

## Pro

- Potensi lebih murah dan cepat untuk keputusan sempit.
- Output typed lebih mudah divalidasi.
- Confidence bisa mengontrol auto-action vs review.
- Logic workflow tetap eksplisit di kode.

## Kontra

- Tidak bisa chat, menulis narasi, Markdown, kode, atau memanggil tools.
- Input cerita bebas perlu parser/form/flow bertahap.
- Migrasi bisa mengubah iGROW dari assistant menjadi workflow app.
- Penghematan API bisa kalah oleh biaya engineering.
- Data karier/incident dikirim ke layanan eksternal.
- Confidence bukan jaminan keputusan benar.

## POC minimum

- Dataset anonim minimal 100 pesan nyata.
- Bandingkan Jev vs routing Hermes: akurasi, false route, biaya, latency.
- Jalankan satu alur nyata dari Telegram sampai file tersimpan.
- Ulangi untuk capture, study, mentor, recall, daily briefing, career review.
- Putuskan GO/NO-GO berdasarkan hasil, bukan klaim landing page.

## Keyword pencarian tools

### Dokumentasi resmi Jev

- `TypeSafe AI Jev docs`
- `Jev TypeSafe API quickstart`
- `TypeSafe System One API`
- `Jev Python SDK`
- `Jev JavaScript SDK`
- `TypeSafe API reference`
- `TypeSafe console playground`

### Integrasi agent

- `Jev coding agents integration`
- `TypeSafe agent skill Claude Code Codex`
- `Jev OpenCode integration`
- `Jev Hermes Agent integration`
- `TypeSafe MCP Jev`

### Pola implementasi

- `Jev intent routing`
- `Jev confidence routing`
- `Jev structured classification`
- `Jev typed decisions Choice Score Noul`
- `Jev guardrails LLM`
- `Jev function calling`
- `Jev human review confidence threshold`

### Pembanding alternatif

- `structured output LLM vs classifier API`
- `cheap AI intent classification API`
- `confidence calibrated classifier API`
- `LLM router cost latency benchmark`
- `small model classification vs LLM`

## Keputusan awal

Jangan full migration dulu. Cari tahu apakah Jev bisa menjadi decision layer murah. Full migration hanya dipertimbangkan setelah POC membuktikan input parsing dan kualitas output tanpa LLM naratif.

Artefak eksperimen nanti, jika disetujui: `ignore/jev-poc/`.

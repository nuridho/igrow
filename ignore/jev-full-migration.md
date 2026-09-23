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

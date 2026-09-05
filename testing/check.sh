#!/usr/bin/env bash
# check.sh — verifikasi hasil test-flow iGROW. Jalan di VPS, dari folder igrow-hermes/hermes-home/.
# Usage: bash check.sh          → cek semua yg bisa dicek otomatis
# Exit code = jumlah FAIL. Yang butuh mata (isi narasi, kualitas jawaban) tetap manual.
cd "$(dirname "$0")/igrow" 2>/dev/null || cd igrow || { echo "run from hermes-home/"; exit 1; }
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "OK   | $1"; }
bad() { fail=$((fail+1)); echo "FAIL | $1"; }

echo "== 1. Redaksi data sensitif (wajib 0) =="
hits=$(grep -ril "cimb\|PROD-APP\|APP-DB\|10\.20\.30\.\|P@ssw0rd" . 2>/dev/null)
[ -z "$hits" ] && ok "tidak ada data sensitif bocor" || { bad "bocor di:"; echo "$hits"; }

echo "== 2. Struktur =="
for d in raw/inbox raw/articles raw/notes raw/assets wiki/careers wiki/self-development wiki/roadmap wiki/profile output project-skills; do
  [ -d "$d" ] && ok "dir $d" || bad "dir $d hilang"
done
for f in SCHEMA.md _index.md log.md ../AGENTS.md; do
  [ -f "$f" ] && ok "file $f" || bad "file $f hilang"
done

echo "== 3. Fase 1: UC1 capture =="
inc=$(ls wiki/careers/*/knowledge/incidents/*.md 2>/dev/null | wc -l)
[ "$inc" -ge 7 ] && ok "incidents: $inc (>=7)" || bad "incidents: $inc (expect >=7: 1.1-1.6, 1.11-1.15 minus yg bukan incident)"
ls wiki/careers/*/lessons-learned/*.md >/dev/null 2>&1 && ok "lessons-learned terisi (1.7)" || bad "lessons-learned kosong (1.7)"
[ -n "$(find wiki/self-development -name '*.md' ! -name '_index*' 2>/dev/null | head -1)" ] && ok "self-development terisi (1.8 hobi/1.10 backdate)" || bad "self-development kosong"
grep -q "SystemMaxUse" wiki/careers/*/knowledge/incidents/*.md 2>/dev/null && ok "update in-place 1.9 ada (SystemMaxUse)" || bad "1.9 update tidak masuk file lama (atau jadi duplikat)"
n_inc=$(ls wiki/careers/*/knowledge/incidents/*.md 2>/dev/null | xargs grep -l "CPU" 2>/dev/null | wc -l)
[ "$n_inc" -ge 2 ] && ok "2 incident CPU terpisah (1.6 no-timpa)" || bad "incident CPU cuma $n_inc (1.6 mungkin ketimpa)"

echo "== 4. Frontmatter =="
f=$(ls wiki/careers/*/knowledge/incidents/*.md 2>/dev/null | head -1)
if [ -n "$f" ]; then
  for field in title created updated type tags sources confidence; do
    head -15 "$f" | grep -q "^$field:" && ok "incident fm $field" || bad "incident $f tanpa $field"
  done
else bad "tidak ada file incident"; fi
echo "SKIP | tests/ — UC2 ditunda ke Phase 5"

echo "== 5. Aturan wajib: _index + log =="
grep -qi "careers" wiki/_index.md 2>/dev/null && ok "wiki/_index menyebut careers" || bad "wiki/_index kosong/stale"
for op in ingest update; do
  grep -qi "op\b.*$op\|$op" log.md 2>/dev/null && ok "log.md ada op $op" || echo "WARN | log.md belum ada op $op (belum jalan?)"
done

echo "== 6. UC5 /study =="
[ -n "$(ls raw/articles/*.md 2>/dev/null)" ] && ok "raw/articles terisi" || bad "raw/articles kosong (2.1)"
grep -rq "sources:" wiki/self-development/ 2>/dev/null && ok "note learning punya sources:" || bad "note learning tanpa sources:"

echo "== 7. UC6 output =="
[ -n "$(ls output/*.md 2>/dev/null)" ] && ok "output/ ada laporan" || echo "SKIP | output/ kosong (5.4 belum jalan)"
[ -s wiki/profile/skills.md ] && ok "profile/skills.md terisi" || echo "SKIP | profile/skills.md kosong (5.4 belum jalan)"

echo "== 8. Taxonomy coverage =="
tags=$(grep -rh "^tags:" wiki/ 2>/dev/null | tr -d '[],' | tr ' ' '\n' | sort -u | wc -l)
[ "$tags" -ge 10 ] && ok "distinct tags: $tags (>=10)" || bad "distinct tags: $tags (expect >=10)"

echo
echo "=== PASS: $pass | FAIL: $fail ==="
exit $fail

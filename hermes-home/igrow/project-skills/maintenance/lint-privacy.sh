#!/usr/bin/env bash
# lint-privacy.sh — cek privasi lint mingguan (lint.md cek 8).
# Cari pola IP dan credential di catatan kerja: wiki/ (kecuali self-development/) dan output/.
# Materi belajar (wiki/self-development/, raw/) tidak dicek: contoh IP/password dari dokumentasi
# publik di sana wajar, dan akan muncul sebagai temuan palsu setiap minggu.
# Output: "<path>:<baris>: <jenis>" per temuan, atau "privasi: bersih".
# Isi baris TIDAK pernah dicetak, karena laporan lint dikirim ke Telegram.
set -u

cd /opt/data/igrow || { echo "ERROR: cannot cd to igrow"; exit 1; }
[ -d wiki ] || { echo "ERROR: igrow/wiki tidak ada"; exit 1; }
dirs="wiki"; [ -d output ] && dirs="wiki output"

scan() { grep -rniE --include='*.md' --exclude-dir=self-development "$@" $dirs; }

hits=$(
  {
    # IPv4, kecuali loopback (127.x), 0.0.0.0, dan masker (255.x)
    scan -o '([0-9]{1,3}\.){3}[0-9]{1,3}' \
      | grep -vE ':(127\.[0-9.]+|0\.0\.0\.0|255\.[0-9.]+)$' | cut -d: -f1,2 | sed 's/$/: IP/'
    # key = nilai / key: nilai. Nilai berawalan < (placeholder), $ (variabel), / atau ~ (path), * (masking) dilewati.
    scan "(password|passwd|pwd|secret|token|api[_-]?key)([_-][a-z0-9]+)*[\"']?[[:space:]]*[:=][[:space:]]*[\"'\`]?[^<\$\"'\`/~*[:space:]][^\"'\`[:space:]]{3,}([\"'\`]|[[:space:]]+#|[[:space:]]*\$)" \
      | cut -d: -f1,2 | sed 's/$/: credential/'
    # Di kalimat, mis. "password P@ssw0rd123": nilai >= 6 karakter dan memuat angka
    scan -o "(password|passwd|pwd|token)[[:space:]]+[^<\$\"'\`*[:space:]]{6,}" \
      | grep -E '[[:space:]][^[:space:]]*[0-9][^[:space:]]*$' | cut -d: -f1,2 | sed 's/$/: credential/'
    # Bearer token dan private key
    scan -e "bearer[[:space:]]+[^<\$\"'\`*[:space:]]{16,}" -e '-----BEGIN [A-Z ]*PRIVATE KEY-----' \
      | cut -d: -f1,2 | sed 's/$/: credential/'
  } | sort -u
)

if [ -n "$hits" ]; then echo "$hits"; else echo "privasi: bersih"; fi

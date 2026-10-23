#!/usr/bin/env bash
# setupvps.sh — init VPS dari nol: user, hostname, paket + update otomatis, swap, Docker, NPM + web dummy, firewall, sshd.
# Jalankan sebagai root: bash setupvps.sh   (aman diulang; yang sudah beres dilewati)
# Lanjutannya: login sebagai user baru → bash igrowctl.sh
set -uo pipefail

U=nuridho
HOST=labs.nuridho
TZ_NAME=Asia/Jakarta
LOG=/var/log/setupvps.log
PROJ='' PW='' IP=''

# ── Tampilan (sama dengan igrowctl.sh) ───────────────────────────────────
if [ -t 1 ]; then
  B=$'\e[1m' D=$'\e[2m' R=$'\e[0m' RED=$'\e[31m' GRN=$'\e[32m' YEL=$'\e[33m' CYN=$'\e[36m' MAG=$'\e[35m'
else
  B='' D='' R='' RED='' GRN='' YEL='' CYN='' MAG=''
fi
TOTAL=9

ok()   { printf '  %s✔%s %s\n' "$GRN" "$R" "$*"; }
info() { printf '  %s•%s %s\n' "$CYN" "$R" "$*"; }
warn() { printf '  %s!%s %s\n' "$YEL" "$R" "$*"; }
skip() { printf '  %s↷ %s — sudah beres, dilewati%s\n' "$D" "$*" "$R"; }
die()  { printf '\n  %s✘ %s%s\n  %sLog lengkap: %s%s\n\n' "$RED$B" "$*" "$R" "$D" "$LOG" "$R"; exit 1; }

banner() {
  clear 2>/dev/null || true
  printf '%s' "$CYN$B"
  cat <<'ART'

     __     ______  ____
     \ \   / /  _ \/ ___|
      \ \ / /| |_) \___ \
       \ V / |  __/ ___) |
        \_/  |_|   |____/
ART
  printf '%s    init VPS · user, Docker, NPM, firewall, SSH%s\n' "$R$D" "$R"
}

step_head() { # step_head <nomor> <judul> <penjelasan>
  local line
  line=$(printf '━%.0s' $(seq 1 $((46 - ${#2}))))
  printf '\n%s━━ [%s/%s] %s %s%s\n' "$MAG$B" "$1" "$TOTAL" "$2" "$line" "$R"
  printf '  %s%s%s\n\n' "$D" "$3" "$R"
}

box() { # box <judul> <isi, boleh multi-baris>
  printf '\n  %s┌─ %s%s\n' "$CYN" "$1" "$R"
  while IFS= read -r l; do printf '  %s│%s %s\n' "$CYN" "$R" "$l"; done <<<"$2"
  printf '  %s└─%s\n' "$CYN" "$R"
}

ask() { # ask <VAR> <pertanyaan> [default] — wajib terisi
  local __v="$1" q="$2" def="${3:-}" ans=''
  while :; do
    if [ -n "$def" ]; then printf '  %s?%s %s %s[%s]%s: ' "$YEL" "$R" "$q" "$D" "$def" "$R"
    else printf '  %s?%s %s: ' "$YEL" "$R" "$q"; fi
    read -r ans </dev/tty; ans="${ans:-$def}"
    [ -n "$ans" ] && break
  done
  printf -v "$__v" '%s' "$ans"
}

ask_secret() { # ask_secret <VAR> <pertanyaan> — input tidak tampil
  local __v="$1" ans=''
  while [ -z "$ans" ]; do
    printf '  %s?%s %s %s(tidak tampil di layar)%s: ' "$YEL" "$R" "$2" "$D" "$R"
    read -rs ans </dev/tty; echo
  done
  printf -v "$__v" '%s' "$ans"
}

confirm() { # confirm <teks> [Y|N] → return 0 kalau ya
  local def="${2:-Y}" ans hint='[Y/n]'; [ "$def" = N ] && hint='[y/N]'
  printf '  %s?%s %s %s%s%s ' "$YEL" "$R" "$1" "$D" "$hint" "$R"
  read -r ans </dev/tty; [[ "${ans:-$def}" =~ ^[Yy] ]]
}

run() { # run <label> <perintah…> → output ke log, spinner di layar
  local label="$1" start; shift
  printf '\n=== %s · %s\n' "$(date '+%F %T')" "$label" >>"$LOG"
  start=$(wc -l <"$LOG")
  "$@" >>"$LOG" 2>&1 &
  local pid=$! i=0 f=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  while kill -0 "$pid" 2>/dev/null; do
    [ -t 1 ] && printf '\r  %s%s%s %s' "$CYN" "${f[i++ % 10]}" "$R" "$label"
    sleep 0.1
  done
  [ -t 1 ] && printf '\r\e[K'
  if wait "$pid"; then ok "$label"; return 0; fi
  printf '  %s✘%s %s\n' "$RED" "$R" "$label"
  tail -n +$((start + 1)) "$LOG" | tail -n 12 | sed "s/^/    ${D}│${R} /"   # hanya output perintah ini
  return 1
}

# ── Persiapan ───────────────────────────────────────────────────────────────
preflight() {
  [ "$(id -u)" -eq 0 ] || die "Jalankan sebagai root: sudo bash $0"
  command -v apt-get >/dev/null || die "Butuh Ubuntu/Debian (apt-get)"
  touch "$LOG" && chmod 600 "$LOG"
}

intro() {
  box "Yang dipasang (±10 menit)" "• User $U (sudo + docker) + folder project di /home/$U
• Hostname $HOST, timezone $TZ_NAME, swap 2 GB
• Update sistem, tambalan keamanan otomatis, fail2ban
• Docker (log dibatasi) + Nginx Proxy Manager + web dummy
• Firewall (SSH, 80, 443) · SSH: root ditutup, hanya $U
Semua pertanyaan di awal; setelah itu jalan sendiri."
  printf '\n  %s1 User · 2 Hostname · 3 Paket · 4 Timezone · 5 Swap · 6 Docker · 7 NPM · 8 Firewall · 9 SSH%s\n\n' "$D" "$R"
  while ask PROJ "Nama folder project di /home/$U (mis. whatsinsidegit)"; [[ "$PROJ" == */* ]]; do
    warn "Cukup nama folder, tanpa /"
  done
  local ip; ip=$(curl -fsS -m 5 https://api.ipify.org 2>/dev/null || true)   # tebakan; Enter kalau benar
  # ponytail: IPv4 saja
  while ask IP "IP publik VPS (untuk ringkasan & cek URL di akhir)" "$ip"; [[ ! "$IP" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; do
    warn "Format IPv4, mis. 203.0.113.10"
  done
  if ! id "$U" &>/dev/null; then
    local pw2
    while :; do
      ask_secret PW "Password untuk user $U (dipakai sudo)"
      ask_secret pw2 "Ulangi password"
      [ "$PW" = "$pw2" ] && break
      warn "Password tidak sama, ulangi"
    done
  fi
  ROOT=/home/$U/$PROJ   # belum ada → dibuat, sudah ada → dipakai
  STACK=$ROOT/proxy     # compose NPM + web dummy
  echo; confirm "Mulai?" Y || exit 0
}

# ── Langkah 1–9 ─────────────────────────────────────────────────────────────
step1() {
  step_head 1 "User $U" "User sehari-hari (sudo + docker). Root nanti ditutup dari SSH."
  if id "$U" &>/dev/null; then skip "User $U"
  else
    run "Buat user $U" adduser --disabled-password --gecos "" "$U" || die "Gagal membuat user $U"
    printf '%s:%s\n' "$U" "$PW" | chpasswd || die "Gagal set password $U"
    PW=''; ok "Password $U diset"
  fi
  usermod -aG sudo "$U"
  if [ -d "$ROOT" ]; then skip "Folder $ROOT"
  else install -d -o "$U" -g "$U" "$ROOT" && ok "Folder $ROOT dibuat"; fi
  # Default nama folder untuk igrowctl.sh langkah 5 (tetap ditanya, tinggal Enter)
  local conf=/home/$U/.config/igrow/setup.env
  if [ ! -f "$conf" ]; then
    install -d -m 700 -o "$U" -g "$U" "/home/$U/.config" "/home/$U/.config/igrow"
    printf 'PROJ=%q\n' "$PROJ" >"$conf" && chown "$U:$U" "$conf"
    ok "Nama folder dicatat untuk igrowctl.sh"
  fi
}

step2() {
  step_head 2 "Hostname" "Nama mesin di prompt dan log."
  if [ "$(hostname)" = "$HOST" ]; then skip "Hostname $HOST"
  else hostnamectl set-hostname "$HOST" && ok "Hostname → $HOST"; fi
  # tanpa baris ini, tiap sudo mengeluh "unable to resolve host"
  grep -qw "$HOST" /etc/hosts || { echo "127.0.1.1 $HOST ${HOST%%.*}" >>/etc/hosts && ok "/etc/hosts memuat $HOST"; }
}

step3() {
  step_head 3 "Paket & update" "Upgrade sistem, fail2ban, ufw, dan tambalan keamanan otomatis."
  export DEBIAN_FRONTEND=noninteractive   # jangan ada prompt apt yang menggantung di balik spinner
  run "apt update" apt-get update -y || die "apt update gagal"
  run "Upgrade sistem (bisa beberapa menit)" \
    apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold upgrade || die "Upgrade gagal"
  run "Install fail2ban, ufw, curl, unattended-upgrades" \
    apt-get install -y fail2ban ufw curl unattended-upgrades || die "Install paket gagal"
  run "Aktifkan fail2ban" systemctl enable --now fail2ban || die "fail2ban gagal jalan"
  printf 'APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Unattended-Upgrade "1";\n' \
    >/etc/apt/apt.conf.d/20auto-upgrades
  ok "Tambalan keamanan otomatis tiap hari (tanpa reboot otomatis)"
}

step4() {
  step_head 4 "Timezone" "Jam sistem, cron, dan log."
  if [ "$(timedatectl show -p Timezone --value)" = "$TZ_NAME" ]; then skip "Timezone $TZ_NAME"
  else timedatectl set-timezone "$TZ_NAME" && ok "Timezone → $TZ_NAME"; fi
}

step5() {
  step_head 5 "Swap" "Cadangan RAM: kalau memori penuh, sistem melambat, bukan mematikan container."
  if swapon --show | grep -q .; then skip "Swap $(swapon --show=SIZE --noheadings | head -n1 | tr -d ' ')"; return; fi
  # ponytail: 2G tetap; sesuaikan kalau RAM/disk VPS jauh beda
  run "Buat swap 2 GB" sh -c 'fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile' \
    || die "Gagal membuat swap"
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >>/etc/fstab
}

step6() {
  step_head 6 "Docker" "Mesin container. Log tiap container dibatasi supaya disk tidak penuh."
  if [ -f /etc/docker/daemon.json ]; then skip "Batas log Docker (daemon.json sudah ada)"
  else
    mkdir -p /etc/docker
    printf '{\n  "log-driver": "json-file",\n  "log-opts": { "max-size": "10m", "max-file": "3" }\n}\n' \
      >/etc/docker/daemon.json
    ok "Log Docker dibatasi 10 MB × 3 per container"
    if command -v docker >/dev/null; then   # berlaku untuk container yang dibuat setelah ini
      run "Restart Docker" systemctl restart docker || die "Docker gagal restart"
    fi
  fi
  if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
    skip "$(docker --version | cut -d, -f1), compose $(docker compose version --short)"
  else
    run "Install Docker + Compose (get.docker.com)" sh -c 'curl -fsSL https://get.docker.com | sh' || die "Install Docker gagal"
  fi
  usermod -aG docker "$U" && ok "$U masuk grup docker (aktif setelah login ulang)"
}

step7() {
  step_head 7 "Nginx Proxy Manager" "Reverse proxy + SSL untuk web, dengan web dummy sebagai contoh."
  if ss -ltn 'sport = :80' | grep -q LISTEN; then skip "Port 80 sudah dipakai (NPM lama?)"; return; fi
  mkdir -p "$STACK/web"
  [ -f "$STACK/web/index.html" ] || cat >"$STACK/web/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="id">
<head><meta charset="UTF-8"><title>Under Construction</title></head>
<body><h1>Under Construction</h1></body>
</html>
EOF
  [ -f "$STACK/docker-compose.yml" ] || cat >"$STACK/docker-compose.yml" <<'EOF'
# Dibuat oleh Setup/setupvps.sh
services:
  npm:
    image: jc21/nginx-proxy-manager:latest
    container_name: npm
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "127.0.0.1:81:81"   # admin UI hanya lewat SSH tunnel (port Docker menembus UFW)
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

  web:                      # web dummy; di NPM: Proxy Host → forward ke web:80
    image: nginx:alpine
    container_name: web
    restart: unless-stopped
    volumes:
      - ./web:/usr/share/nginx/html:ro
EOF
  chown -R "$U:$U" "$STACK"
  ok "Compose di $STACK"
  run "Jalankan NPM + web dummy" docker compose -f "$STACK/docker-compose.yml" up -d || die "NPM gagal jalan"
  # NPM butuh ±30 detik saat pertama; curl tanpa -f: status HTTP apa pun berarti port 80 menjawab
  run "Tunggu NPM menjawab di port 80" sh -c 'for i in $(seq 1 30); do curl -s -o /dev/null -m 2 http://127.0.0.1 && exit 0; sleep 2; done; exit 1' \
    || warn "NPM belum menjawab di port 80. Cek: docker logs npm"
}

step8() {
  step_head 8 "Firewall" "Hanya SSH, 80, 443 yang terbuka. SSH dibuka dulu supaya sesi ini tidak putus."
  local port
  port=$(sshd -T 2>/dev/null | awk '/^port /{print $2; exit}'); port=${port:-22}
  run "Buka port SSH ($port), 80, 443" sh -c "ufw allow $port/tcp && ufw allow 80/tcp && ufw allow 443/tcp" \
    || die "Gagal menambah aturan UFW"
  run "Aktifkan firewall" ufw --force enable || die "UFW gagal aktif"
}

step9() {
  step_head 9 "SSH" "Root tidak bisa login lagi; hanya $U."
  if [ ! -s "/home/$U/.ssh/authorized_keys" ] && [ -s /root/.ssh/authorized_keys ]; then
    install -d -m 700 -o "$U" -g "$U" "/home/$U/.ssh"
    install -m 600 -o "$U" -g "$U" /root/.ssh/authorized_keys "/home/$U/.ssh/authorized_keys"
    ok "SSH key root disalin ke $U (supaya $U tetap bisa login)"
  fi
  grep -q '^Include /etc/ssh/sshd_config.d' /etc/ssh/sshd_config \
    || warn "sshd_config tidak memuat sshd_config.d/, hardening tidak aktif"
  local hard=/etc/ssh/sshd_config.d/00-hardening.conf   # 00- supaya menang dari file lain (nilai pertama dipakai)
  printf 'PermitRootLogin no\nAllowUsers %s\n' "$U" >"$hard"
  mkdir -p /run/sshd
  run "Cek config SSH" sshd -t || { rm -f "$hard"; die "Config SSH tidak valid, hardening dibatalkan"; }
  run "Terapkan: root ditutup, hanya $U" systemctl reload ssh || die "SSH gagal reload"
}

finale() {
  printf '\n%s━━ VPS siap %s%s\n' "$GRN$B" "$(printf '━%.0s' $(seq 1 46))" "$R"
  box "1 · Tes login dulu (JANGAN tutup sesi root ini)" "Di terminal baru: ssh $U@$IP"
  box "2 · Cek lewat browser" "http://$IP → halaman bawaan Nginx Proxy Manager = port 80 + firewall beres
Web dummy baru tampil di domain kamu setelah Proxy Host dibuat (langkah 3)"
  box "3 · Admin Nginx Proxy Manager" "ssh -L 8181:localhost:81 $U@$IP
Buka http://localhost:8181 → login pertama
Proxy Host: domain kamu → forward ke web:80 + SSL"
  box "4 · Pasang iGROW (dari laptop)" "scp Setup/igrowctl.sh $U@$IP:~/
ssh -t $U@$IP bash igrowctl.sh"
  # ponytail: file ini dibuat Ubuntu; di Debian polos tidak ada → cek manual kalau habis upgrade kernel
  if [ -f /var/run/reboot-required ]; then
    printf '\n'; warn "Ada update (mis. kernel) yang butuh reboot: sudo reboot, setelah langkah 1 berhasil"
  fi
  printf '\n'
}

banner; preflight; intro
for i in 1 2 3 4 5 6 7 8 9; do "step$i"; done
finale

#!/bin/bash
# setupvps.sh — init VPS dari nol: user, hostname, paket, Docker, NPM + web dummy, firewall, sshd.
# Jalankan sebagai root: bash setupvps.sh  (aman diulang)
set -e

U=nuridho
PROJ=''
while [ -z "$PROJ" ] || [[ "$PROJ" == */* ]]; do   # cukup nama folder, tanpa /
    read -rp "Nama folder project di /home/$U (mis. whatsinsidegit): " PROJ
done
ROOT=/home/$U/$PROJ   # belum ada → dibuat, sudah ada → dipakai
STACK=$ROOT/proxy     # compose NPM + web dummy

echo "=== 1. User $U ==="
if id "$U" &>/dev/null; then
    echo ">> User $U sudah ada, skip."
else
    adduser "$U"
fi
usermod -aG sudo "$U"
install -d -o "$U" -g "$U" "$ROOT"
# Default nama folder untuk igrow-setup.sh langkah 5 (tetap ditanya, tinggal Enter)
CONF=/home/$U/.config/igrow/setup.env
if [ ! -f "$CONF" ]; then
    install -d -m 700 -o "$U" -g "$U" "/home/$U/.config" "/home/$U/.config/igrow"
    printf 'PROJ=%q\n' "$PROJ" > "$CONF"
    chown "$U:$U" "$CONF"
fi

echo "=== 2. Set hostname ==="
hostnamectl set-hostname labs.nuridho

echo "=== 3. Update system + paket ==="
apt update && apt upgrade -y
apt install -y fail2ban ufw curl
systemctl enable --now fail2ban

echo "=== 4. Timezone ==="
timedatectl set-timezone Asia/Jakarta

echo "=== 5. Install Docker ==="
command -v docker >/dev/null || curl -fsSL https://get.docker.com | sh
usermod -aG docker "$U"   # aktif setelah $U logout/login
docker --version && docker compose version

echo "=== 6. Nginx Proxy Manager + web dummy ==="
if ss -ltn 'sport = :80' | grep -q LISTEN; then
    echo ">> Port 80 sudah dipakai (NPM lama?), skip."
else
    mkdir -p "$STACK/web"
    [ -f "$STACK/web/index.html" ] || cat > "$STACK/web/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="id">
<head><meta charset="UTF-8"><title>Under Construction</title></head>
<body><h1>Under Construction</h1></body>
</html>
EOF
    [ -f "$STACK/docker-compose.yml" ] || cat > "$STACK/docker-compose.yml" <<'EOF'
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
    (cd "$STACK" && docker compose up -d)
fi

echo "=== 7. UFW firewall ==="
SSH_PORT=$(sshd -T 2>/dev/null | awk '/^port /{print $2; exit}')
ufw allow "${SSH_PORT:-22}/tcp"   # SSH dulu, baru enable → sesi ini tidak terputus
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
ufw status

echo "=== 8. SSH hardening ==="
if [ ! -s "/home/$U/.ssh/authorized_keys" ] && [ -s /root/.ssh/authorized_keys ]; then
    install -d -m 700 -o "$U" -g "$U" "/home/$U/.ssh"
    install -m 600 -o "$U" -g "$U" /root/.ssh/authorized_keys "/home/$U/.ssh/authorized_keys"
    echo ">> SSH key root disalin ke $U (supaya $U tetap bisa login setelah root ditutup)"
fi
grep -q '^Include /etc/ssh/sshd_config.d' /etc/ssh/sshd_config \
    || echo ">> PERINGATAN: sshd_config tidak memuat sshd_config.d/, hardening tidak aktif"
HARD=/etc/ssh/sshd_config.d/00-hardening.conf   # 00- supaya menang dari file lain (nilai pertama dipakai)
printf 'PermitRootLogin no\nAllowUsers %s\n' "$U" > "$HARD"
mkdir -p /run/sshd
if sshd -t; then
    systemctl reload ssh
else
    rm -f "$HARD"; echo ">> Config sshd tidak valid, hardening dibatalkan"; exit 1
fi

echo ""
echo "=== SELESAI ==="
echo "1. JANGAN tutup sesi ini dulu. Tes di terminal baru: ssh $U@<vps>"
echo "2. Admin NPM: ssh -L 8181:localhost:81 $U@<vps> → buka http://localhost:8181"
echo "   Login pertama, lalu Proxy Host: domain kamu → forward ke web:80 + SSL"
echo "3. Pasang iGROW sebagai $U: bash igrow-setup.sh"

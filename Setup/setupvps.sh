#!/bin/bash
# setupvps.sh — init VPS dari nol.
# Jalankan: sudo bash setupvps.sh
set -e

echo "=== 1. Membuat user nuridho ==="
if id "nuridho" &>/dev/null; then
    echo ">> User nuridho sudah ada, skip."
else
    adduser nuridho
fi
usermod -aG sudo nuridho

echo "=== 2. Set hostname ==="
hostnamectl set-hostname labs.nuridho

echo "=== 3. Install fail2ban ==="
apt install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban

echo "=== 4. Timezone ==="
timedatectl set-timezone Asia/Kuala_Lumpur

echo "=== 5. Update system ==="
apt update && apt upgrade -y

echo "=== 6. SSH hardening (cek) ==="
cat /etc/ssh/sshd_config | grep -E "AllowUsers|PermitRootLogin" || \
    echo ">> Belum ada AllowUsers/PermitRootLogin — edit manual:"
echo "   sudo nano /etc/ssh/sshd_config"
echo "   Tambahkan: PermitRootLogin no / AllowUsers nuridho"
echo "   sudo systemctl restart ssh"

echo ""
echo "=== SELESAI ==="
echo "Langkah selanjutnya: cp docker-compose.yml .env → sudo bash setupdocker.sh"

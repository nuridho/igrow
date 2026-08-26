# - install vim dlu
# - vim setupvps.sh
# - paste bashnya
# - chmod +x setupvps.sh
# - sudo bash setupvps.sh

#!/bin/bash
set -e

echo "=== 1. Membuat user nuridho ==="
if id "nuridho" &>/dev/null; then
    echo ">> User nuridho sudah ada, skip pembuatan user."
else
    adduser nuridho
fi

echo ">> Memastikan nuridho ada di grup sudo..."
usermod -aG sudo nuridho

echo "=== 2. Set hostname ==="
hostnamectl set-hostname whatsinsidegit

echo "=== 3. Install & aktifkan fail2ban ==="
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo systemctl status fail2ban --no-pager

echo "=== 4. Set timezone ==="
sudo timedatectl set-timezone Asia/Jakarta

echo "=== 5. Update & upgrade sistem ==="
sudo apt update && sudo apt upgrade -y

echo "=== 6. Cek status fail2ban untuk sshd ==="
sudo fail2ban-client status sshd

echo "=== 7. Cek konfigurasi sshd_config (AllowUsers & PermitRootLogin) ==="
sudo cat /etc/ssh/sshd_config | grep -E "AllowUsers|PermitRootLogin" || echo ">> Belum ada baris AllowUsers/PermitRootLogin yang aktif, perlu diedit manual."

echo ""
echo "=== SELESAI ==="
echo "Pastikan output di atas menunjukkan:"
echo "  PermitRootLogin no"
echo "  AllowUsers nuridho"
echo "Kalau belum, edit manual: sudo nano /etc/ssh/sshd_config"
echo "Lalu restart: sudo systemctl restart ssh"
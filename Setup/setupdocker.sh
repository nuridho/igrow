#!/bin/bash
# setupdocker.sh — install Docker + semua service Phase 1.
# Prasyarat: setupvps.sh sudah jalan, docker-compose.yml + .env ada di ~/whatsinsidegit/
# Jalankan: sudo bash setupdocker.sh
set -e

VPS_DIR=~/whatsinsidegit
TIMEZONE=Asia/Kuala_Lumpur
DOMAIN=nuridho.com

echo "=== 1. Install Docker ==="
curl -fsSL https://get.docker.com | sh
usermod -aG docker $USER 2>/dev/null || true
docker --version && docker compose version

echo "=== 2. Buat struktur folder ==="
cd "$VPS_DIR"
mkdir -p nginx-proxy-manager/{data,letsencrypt} portainer/data glance/config homepage

echo "=== 3. Buat glance.yml ==="
cat > glance/config/glance.yml <<'EOF'
pages:
  - name: What's Inside Git?
    slug: home
    columns:
      - size: small
        widgets:
          - type: clock
            hour-format: 24h
            timezones:
              - timezone: Asia/Kuala_Lumpur
                label: Kuala Lumpur
          - type: weather
            location: Kuala Lumpur, Malaysia
            units: metric
            hour-format: 24h
          - type: server-stats
            servers:
              - type: local
                name: whatsinsidegit
      - size: full
        widgets:
          - type: monitor
            cache: 2m
            title: Status
            sites:
              - title: Homepage
                url: https://${DOMAIN}
              - title: Portainer
                url: https://portainer.${DOMAIN}
          - type: docker-containers
            hide-by-default: false
          - type: bookmarks
            groups:
              - title: Infra
                links:
                  - title: Portainer
                    url: https://portainer.${DOMAIN}
                  - title: NPM
                    url: https://npm.${DOMAIN}
                  - title: Glance
                    url: https://dash.${DOMAIN}
EOF

echo "=== 4. Buat homepage ==="
cat > homepage/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Portfolio</title></head>
<body><h1>Under Construction</h1><p>https://${DOMAIN}</p></body>
</html>
EOF

echo "=== 5. Buat docker-compose.yml ==="
cat > docker-compose.yml <<'EOF'
services:
  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "${NPM_PORT}:81"
    volumes:
      - ./nginx-proxy-manager/data:/data
      - ./nginx-proxy-manager/letsencrypt:/etc/letsencrypt

  portainer:
    image: portainer/portainer-ce:latest
    restart: unless-stopped
    ports:
      - "${PORTAINER_PORT}:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer/data:/data

  glance:
    image: glanceapp/glance:latest
    restart: unless-stopped
    ports:
      - "${GLANCE_PORT}:8080"
    environment:
      - TZ=${TIMEZONE}
    volumes:
      - ./glance/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro

  home:
    image: nginx:alpine
    restart: unless-stopped
    volumes:
      - ./homepage:/usr/share/nginx/html:ro
EOF

echo "=== 6. Jalankan container ==="
docker compose up -d
docker ps

echo ""
echo "=== 7. UFW firewall ==="
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 81/tcp
ufw show added
echo ">> Pastikan SSH ada di atas, lalu jalankan: ufw enable"

echo ""
echo "=== SELESAI ==="
echo "Langkah manual (butuh akses browser):"
echo "  1. http://VPS-IP:81 → login NPM (admin@example.com / changeme)"
echo "  2. Add Proxy Host per service (lihat build.md Step 11)"
echo "  3. Request SSL di tiap proxy host"
echo "  4. Update glance.yml dengan domain asli → docker compose restart glance"

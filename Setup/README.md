# Setup Folder — VPS Init Scripts

Isinya:

| File | Fungsi |
|------|--------|
| `setupvps.sh` | Init VPS: user, hostname, fail2ban, timezone, sshd |
| `setupdocker.sh` | Install Docker + semua service Phase 1 (NPM, Portainer, Glance, Homepage) |

## Workflow

```bash
# 1. Copy semua ke VPS
scp Setup/*.sh nuridho@labs.nuridho:~/

# 2. Run init VPS
sudo bash setupvps.sh
# → sshd hardening, user nuridho, timezone

# 3. Copy konfigurasi Docker
scp whatsinsidegit/* nuridho@labs.nuridho:~/whatsinsidegit/
# (docker-compose.yml, .env, homepage/, dll)

# 4. Install & start Docker services
cd ~/whatsinsidegit
sudo bash setupdocker.sh
```

## Requirement

- `docker-compose.yml` + `.env` harus ada di `~/whatsinsidegit/` sebelum `setupdocker.sh`
- `.env` minimal: `NPM_PORT`, `PORTAINER_PORT`, `GLANCE_PORT`
- `homepage/` harus ada `index.html`

## Domain

Scripts pakai `nuridho.com` — edit `DOMAIN=` di `setupdocker.sh` kalau perlu.

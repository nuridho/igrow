# Setup Folder — VPS Init Scripts

Isinya:

| File | Fungsi |
|------|--------|
| `setupvps.sh` | Init VPS (aman diulang): user `nuridho` (sudo + docker), hostname, fail2ban, timezone, Docker, Nginx Proxy Manager + web dummy di `~/whatsinsidegit/proxy/`, UFW (SSH/80/443, langsung aktif), hardening sshd (root ditutup, `AllowUsers nuridho`, key root disalin ke nuridho) |
| `igrow-setup.sh` | Pasang iGROW (Phase 2) dari nol: git + SSH GitHub, Docker, container Hermes, LLM + Telegram, runtime, backup, cron. Juga `deploy` (aturan terbaru dari repo) dan `status`. Penjelasan: [`PRD/07-setup.md`](../PRD/07-setup.md) |

## Workflow

```bash
# 1. Init VPS (sebagai root, sebelum user nuridho ada)
scp Setup/setupvps.sh root@<vps>:~/
ssh root@<vps> bash setupvps.sh

# 2. Pasang iGROW sebagai nuridho
scp Setup/igrow-setup.sh nuridho@<vps>:~/
ssh -t nuridho@<vps> bash igrow-setup.sh
```

Admin NPM (port 81) sengaja hanya terbuka di `127.0.0.1`, karena port Docker menembus UFW. Akses lewat tunnel: `ssh -L 8181:localhost:81 nuridho@<vps>` → `http://localhost:8181`. Web dummy diproxy dengan forward ke `web:80`.

Portainer, Glance, Homepage dari `setupdocker.sh` lama tidak dibawa; ambil dari `git log` kalau perlu lagi.

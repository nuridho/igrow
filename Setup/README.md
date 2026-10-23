# Setup Folder — VPS Init Scripts

Isinya:

| File | Fungsi |
|------|--------|
| `setupvps.sh` | Init VPS (aman diulang): user `nuridho` (sudo + docker), hostname, fail2ban, update keamanan otomatis, timezone, swap 2 GB, Docker (log dibatasi 10 MB × 3 per container), folder project `~/<nama>` (nama diisi user, dibuat kalau belum ada; NPM di `~/<nama>/proxy/`, nama jadi default pertanyaan `igrow-setup.sh`), Nginx Proxy Manager + web dummy, UFW (SSH/80/443, langsung aktif), hardening sshd (root ditutup, `AllowUsers nuridho`, key root disalin ke nuridho) |
| `igrow-setup.sh` | Pasang iGROW (Phase 2) dari nol: git + SSH GitHub, Docker, container Hermes, LLM + Telegram, runtime, backup, cron. Juga `deploy` (aturan terbaru dari repo) dan `status`. Penjelasan: [`PRD/07-setup.md`](../PRD/07-setup.md) |

## Workflow

```bash
# 1. Init VPS (sebagai root, sebelum user nuridho ada)
scp Setup/setupvps.sh root@<vps>:~/
ssh -t root@<vps> bash setupvps.sh   # -t: script bertanya (folder project, password user)

# 2. Pasang iGROW sebagai nuridho
scp Setup/igrow-setup.sh nuridho@<vps>:~/
ssh -t nuridho@<vps> bash igrow-setup.sh
```

Admin NPM (port 81) sengaja hanya terbuka di `127.0.0.1`, karena port Docker menembus UFW. Akses lewat tunnel: `ssh -L 8181:localhost:81 nuridho@<vps>` → `http://localhost:8181`. Web dummy diproxy dengan forward ke `web:80`.

Portainer, Glance, Homepage dari `setupdocker.sh` lama tidak dibawa; ambil dari `git log` kalau perlu lagi.

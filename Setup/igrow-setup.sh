#!/usr/bin/env bash
# igrow-setup.sh — pasang iGROW di VPS: git, Docker, Hermes, Telegram, backup, cron. Dari nol sampai bot jalan.
# Jalankan sebagai user biasa yang punya sudo (BUKAN root):
#   bash igrow-setup.sh            → semua langkah; yang sudah beres otomatis dilewati (aman diulang)
#   bash igrow-setup.sh step 6     → ulang satu langkah (mis. ganti API key LLM / token bot)
#   bash igrow-setup.sh deploy     → tarik repo terbaru + pasang ulang runtime (data di VPS tidak disentuh)
#   bash igrow-setup.sh status     → cek kesehatan: container, doctor, cron, backup terakhir
# Penjelasan tiap langkah: PRD/07-setup.md. Secret hanya diketik saat diminta; tidak ditulis ke repo maupun log.
set -uo pipefail

CONF_DIR="$HOME/.config/igrow"
CONF="$CONF_DIR/setup.env"   # setelan NON-rahasia (path, URL repo) supaya re-run tidak bertanya ulang
LOG="$CONF_DIR/setup.log"
mkdir -p "$CONF_DIR" && chmod 700 "$CONF_DIR" && touch "$LOG" && chmod 600 "$LOG"

# ── Tampilan ────────────────────────────────────────────────────────────────
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

     _  ____ ____   _____        __
    (_)/ ___|  _ \ / _ \ \      / /
    | | |  _| |_) | | | \ \ /\ / /
    | | |_| |  _ <| |_| |\ V  V /
    |_|\____|_| \_\\___/  \_/\_/
ART
  printf '%s    arsip karier & knowledge base · Hermes + Telegram%s\n' "$R$D" "$R"
}

step_head() { # step_head <nomor> <judul> <penjelasan>
  local line tag="[$1/$TOTAL]"; [[ "$1" =~ ^[0-9]+$ ]] || tag="$1"
  line=$(printf '━%.0s' $(seq 1 $((46 - ${#2}))))
  printf '\n%s━━ %s %s %s%s\n' "$MAG$B" "$tag" "$2" "$line" "$R"
  printf '  %s%s%s\n\n' "$D" "$3" "$R"
}

box() { # box <judul> <isi, boleh multi-baris>
  printf '\n  %s┌─ %s%s\n' "$CYN" "$1" "$R"
  while IFS= read -r l; do printf '  %s│%s %s\n' "$CYN" "$R" "$l"; done <<<"$2"
  printf '  %s└─%s\n\n' "$CYN" "$R"
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

pause() { printf '  %s↵  Enter kalau sudah…%s' "$D" "$R"; read -r _ </dev/tty; }

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

# ── Setelan non-rahasia ─────────────────────────────────────────────────────
# shellcheck disable=SC1090
[ -f "$CONF" ] && . "$CONF"
: "${REPO_DIR:=$HOME/iGROW}"
: "${REPO_URL:=}"
: "${PROJ:=}"   # nama folder project di $HOME (mis. whatsinsidegit); ditanya di langkah 5
: "${HH:=}"     # HERMES_HOME di host = ~/$PROJ/igrow-hermes/hermes-home → /opt/data di container
: "${TZ_NAME:=Asia/Jakarta}"
: "${GH_USER:=}"
: "${BACKUP_REPO:=}"
: "${BOT_NAME:=}"
save_conf() { declare -p REPO_DIR REPO_URL PROJ HH TZ_NAME GH_USER BACKUP_REPO BOT_NAME | sed 's/^declare -- //' >"$CONF"; }

set_kv() { # set_kv <file> <KEY> <value> → ganti/tambah KEY=value, file mode 600
  local f="$1" tmp; tmp=$(mktemp)
  touch "$f" && chmod 600 "$f"
  grep -v "^$2=" "$f" >"$tmp" || true
  printf '%s=%s\n' "$2" "$3" >>"$tmp"
  cat "$tmp" >"$f"; rm -f "$tmp"
}
get_kv() { [ -f "$1" ] && grep -m1 "^$2=" "$1" | cut -d= -f2-; }

# ── Docker & container ──────────────────────────────────────────────────────
DK=(docker)
load_docker() {
  command -v docker >/dev/null || die "Docker belum terpasang — jalankan langkah 3"
  if docker info >/dev/null 2>&1; then DK=(docker); else sudo -v || die "sudo gagal"; DK=(sudo docker); fi
}
dk() { "${DK[@]}" "$@"; }
COMPOSE_DIR="$(dirname "$HH")"
dc() { (cd "$COMPOSE_DIR" && dk compose "$@"); }

CNAME=''
find_container() { # cari service igrow-hermes (dari compose mana pun, termasuk compose root lama)
  CNAME=$(dk ps -a --filter label=com.docker.compose.service=igrow-hermes \
                  --filter label=com.docker.compose.oneoff=False --format '{{.Names}}' | head -n1)
  [ -n "$CNAME" ] || return 0
  COMPOSE_DIR=$(dk inspect -f '{{index .Config.Labels "com.docker.compose.project.working_dir"}}' "$CNAME")
  HH=$(dk inspect -f '{{range .Mounts}}{{if eq .Destination "/opt/data"}}{{.Source}}{{end}}{{end}}' "$CNAME")
}
need_compose() { ls "$COMPOSE_DIR"/{docker-compose,compose}.y*ml >/dev/null 2>&1 || die "Belum ada docker-compose — jalankan langkah 5"; }
running() { [ -n "$CNAME" ] && [ "$(dk inspect -f '{{.State.Running}}' "$CNAME" 2>/dev/null)" = true ]; }

# Perintah hermes: lewat container yang jalan; kalau belum jalan, container sekali pakai.
# Jangan pernah 2 gateway di 1 folder data — `run --rm` hanya untuk perintah non-gateway.
hm()  { if running; then dk exec -it "$CNAME" hermes "$@"; else dc run --rm igrow-hermes "$@"; fi; }      # interaktif
hmq() { if running; then dk exec "$CNAME" hermes "$@"; else dc run --rm -T igrow-hermes "$@"; fi; }       # tanpa layar
# git di container, sebagai pemilik hermes-home (= user gateway), persis seperti cron menjalankan backup.sh
hx()  { dk exec -u "$(stat -c '%u:%g' "$HH")" -w /opt/data/igrow "$CNAME" "$@"; }
restart_if_running() { if running; then run "Restart gateway (setelan baru dibaca)" dc restart igrow-hermes; fi; }

# ── Pengecekan eksternal (secret lewat stdin curl, tidak muncul di daftar proses) ──
github_ok() {
  local out; out=$(ssh -T -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=10 git@github.com 2>&1)
  [[ "$out" =~ Hi\ ([^!]+)! ]] && GH_USER="${BASH_REMATCH[1]}"
}
tg_bot() { # cetak username bot kalau token valid
  local out; out=$(printf 'url = "https://api.telegram.org/bot%s/getMe"\n' "$1" | curl -s -m 15 -K -) || return 1
  [[ "$out" == *'"ok":true'* ]] && sed -n 's/.*"username":"\([^"]*\)".*/\1/p' <<<"$out"
}
gh_repo() { # gh_repo <token> → cetak "private"/"public" kalau token bisa akses BACKUP_REPO
  local out; out=$(printf 'url = "https://api.github.com/repos/%s"\nheader = "Authorization: Bearer %s"\n' "$BACKUP_REPO" "$1" \
                   | curl -s -m 15 -K -) || return 1
  [[ "$out" == *'"full_name"'* ]] || return 1
  [[ "$out" == *'"private": true'* ]] && echo private || echo public
}

deploy_runtime() { # PRD 04 §7 — 2 langkah, TANPA --delete (wiki/raw/output hanya ada di VPS)
  local src="$REPO_DIR/hermes-home/"
  [ -n "$HH" ] || die "Folder data belum ditentukan — jalankan langkah 5"
  [ -f "$src/AGENTS.md" ] || die "Tidak ketemu $src/AGENTS.md — jalankan langkah 4"
  mkdir -p "$HH"
  run "Runtime terbaru (AGENTS.md, SCHEMA, project-skills)" \
    rsync -a --exclude '_index.md' --exclude 'log.md' --exclude 'taxonomy.md' "$src" "$HH/" || die "rsync gagal"
  run "File milik agent yang belum ada (katalog, log, tag)" \
    rsync -a --ignore-existing "$src" "$HH/" || die "rsync gagal"
  if [ -f "$HH/igrow/_index.md" ]; then rm -f "$HH/igrow/_index.md"; info "Master index lama igrow/_index.md dihapus (D-32)"; fi
}

# ── Langkah 1–9 ─────────────────────────────────────────────────────────────
step1() {
  step_head 1 "Paket dasar" "git, rsync, curl: alat wajib sebelum yang lain."
  local need=() p
  for p in git rsync curl ssh-keygen; do command -v "$p" >/dev/null || need+=("$p"); done
  if [ ${#need[@]} -eq 0 ]; then skip "$(git --version), rsync, curl"; return; fi
  need=("${need[@]/ssh-keygen/openssh-client}")
  run "apt update" sudo apt-get update -y || die "apt update gagal"
  run "Install ${need[*]}" sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${need[@]}" || die "Install gagal"
}

step2() {
  step_head 2 "Git & GitHub" "Identitas commit + SSH key, supaya VPS bisa pull & push ke GitHub."
  local n e key="$HOME/.ssh/id_ed25519"
  n=$(git config --global user.name || true); e=$(git config --global user.email || true)
  if [ -n "$n" ] && [ -n "$e" ]; then skip "Identitas git: $n <$e>"
  else
    ask n "Nama untuk commit git" "$n"
    ask e "Email GitHub (boleh alamat noreply GitHub)" "$e"
    git config --global user.name "$n"; git config --global user.email "$e"
    git config --global init.defaultBranch master; git config --global pull.ff only
    ok "Identitas git: $n <$e>"
  fi
  if [ ! -f "$key" ]; then
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "igrow-vps" -f "$key" -N "" -q && ok "SSH key baru: $key"
  fi
  if github_ok; then skip "SSH ke GitHub (akun $GH_USER)"; save_conf; return; fi
  box "Tempel key ini di GitHub → Settings → SSH and GPG keys → New SSH key" "$(cat "$key.pub")"
  until { pause; github_ok; }; do warn "Belum tembus. Pastikan key sudah disimpan di GitHub, lalu Enter lagi."; done
  ok "SSH ke GitHub tembus (akun $GH_USER)"
  save_conf
}

step3() {
  step_head 3 "Docker & Compose" "Mesin untuk menjalankan container Hermes."
  if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
    skip "$(docker --version | cut -d, -f1), compose $(docker compose version --short)"
  else
    run "Install Docker + Compose (get.docker.com)" sh -c 'curl -fsSL https://get.docker.com | sudo sh' || die "Install Docker gagal"
  fi
  sudo systemctl enable --now docker >>"$LOG" 2>&1 || true
  if ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    warn "User $USER masuk grup docker: aktif setelah logout/login. Sampai itu, script memakai sudo."
  fi
  load_docker; ok "Docker siap"
}

step4() {
  step_head 4 "Repo iGROW" "Clone repo spec iGROW ke VPS: sumber file runtime hermes-home/."
  if [ -d "$REPO_DIR/.git" ]; then
    run "git pull ($REPO_DIR)" git -C "$REPO_DIR" pull --ff-only || warn "Pull gagal, lanjut pakai versi lokal"
  else
    ask REPO_URL "URL SSH repo iGROW" "${REPO_URL:-git@github.com:${GH_USER:-<user>}/iGROW.git}"
    ask REPO_DIR "Clone ke folder" "$REPO_DIR"
    run "Clone $REPO_URL" git clone "$REPO_URL" "$REPO_DIR" || die "Clone gagal (URL benar? SSH key sudah di GitHub?)"
  fi
  [ -f "$REPO_DIR/hermes-home/AGENTS.md" ] || die "$REPO_DIR bukan repo iGROW (hermes-home/AGENTS.md tidak ada)"
  ok "Repo: $REPO_DIR ($(git -C "$REPO_DIR" log -1 --format='%h · %cr'))"
  save_conf
}

step5() {
  step_head 5 "Container Hermes" "Compose resmi nousresearch/hermes-agent; data di hermes-home/ = /opt/data."
  load_docker; find_container
  if [ -n "$CNAME" ]; then skip "Container $CNAME (compose: $COMPOSE_DIR, data: $HH)"; save_conf; return; fi
  while ask PROJ "Mau install di mana? Nama folder project di $HOME (mis. whatsinsidegit)" "$PROJ"; [[ "$PROJ" == */* ]]; do
    warn "Cukup nama folder, tanpa /"; PROJ=''
  done
  if [ -d "$HOME/$PROJ" ]; then info "Folder $HOME/$PROJ sudah ada, dipakai"; else info "Folder $HOME/$PROJ dibuat"; fi
  HH="$HOME/$PROJ/igrow-hermes/hermes-home"
  ask TZ_NAME "Timezone (jam cron & briefing)" "$TZ_NAME"
  COMPOSE_DIR="$(dirname "$HH")"
  mkdir -p "$HH"
  set_kv "$COMPOSE_DIR/.env" HERMES_UID "$(id -u)"
  set_kv "$COMPOSE_DIR/.env" HERMES_GID "$(id -g)"
  set_kv "$COMPOSE_DIR/.env" IGROW_TZ "$TZ_NAME"
  if ! ls "$COMPOSE_DIR"/{docker-compose,compose}.y*ml >/dev/null 2>&1; then
    cat >"$COMPOSE_DIR/docker-compose.yml" <<'YML'
# Dibuat oleh Setup/igrow-setup.sh — penjelasan di PRD/07-setup.md
services:
  igrow-hermes:
    image: nousresearch/hermes-agent:latest   # pin versi (mis. :vYYYY.M.D) kalau mau stabil
    container_name: igrow-hermes
    restart: unless-stopped
    command: gateway run                      # bot standby, bukan chat interaktif
    environment:
      - HERMES_UID=${HERMES_UID}              # file di hermes-home/ milik user host, bukan root
      - HERMES_GID=${HERMES_GID}
      - TZ=${IGROW_TZ}                        # jam cron (0 7 * * * = 07:00 waktu ini)
    volumes:
      - ./hermes-home:/opt/data               # satu-satunya volume; secret ditulis ke hermes-home/.env
YML
    ok "docker-compose.yml dibuat di $COMPOSE_DIR"
  fi
  run "Tarik image nousresearch/hermes-agent" dc pull || die "Gagal menarik image"
  save_conf
}

step6() {
  step_head 6 "Otak (LLM) & Telegram" "API key LLM + token bot, disimpan di hermes-home/.env (bukan di repo)."
  load_docker; find_container; need_compose
  local env="$HH/.env" d=Y tok uid bot
  if [ -f "$HH/config.yaml" ]; then info "Model sekarang: $(hmq config get model.default 2>/dev/null | tail -n1)"; d=N; fi
  if confirm "Buka wizard LLM resmi Hermes (pilih provider → tempel API key → pilih model)?" "$d"; then
    box "Wizard LLM" $'Pilih provider yang kamu punya key-nya (OpenRouter, Anthropic, OpenAI, dll).\nKey diketik di wizard resmi Hermes dan langsung masuk hermes-home/.env.'
    hm setup model || die "Wizard LLM gagal"
    ok "LLM tersimpan"
  fi
  if [ -n "$(get_kv "$env" TELEGRAM_BOT_TOKEN)" ] && ! confirm "Token bot Telegram sudah ada. Ganti?" N; then
    skip "Telegram${BOT_NAME:+ (@$BOT_NAME)}"
  else
    box "Siapkan bot (±1 menit)" $'1. Telegram → @BotFather → /newbot → ikuti → copy token\n2. Telegram → @userinfobot → copy angka "Id" kamu (bukan @username)'
    until ask_secret tok "Token bot"; bot=$(tg_bot "$tok") && [ -n "$bot" ]; do warn "Token ditolak Telegram, cek lagi."; done
    BOT_NAME="$bot"; ok "Bot valid: @$BOT_NAME"
    until ask uid "User ID Telegram kamu"; [[ "$uid" =~ ^[0-9]+$ ]]; do warn "Harus angka."; done
    set_kv "$env" TELEGRAM_BOT_TOKEN "$tok"
    set_kv "$env" TELEGRAM_ALLOWED_USERS "$uid"   # hanya kamu yang bisa chat bot
    set_kv "$env" TELEGRAM_HOME_CHANNEL "$uid"    # hasil cron (--deliver telegram) dikirim ke chat kamu
    ok "Telegram tersimpan: hanya user $uid yang dilayani, hasil cron masuk ke chat ini"
    save_conf
  fi
  restart_if_running
}

step7() {
  step_head 7 "Runtime iGROW & tools" "Salin hermes-home/ dari repo, kunci approval skill, pilih tools cron, nyalakan bot."
  load_docker; find_container; need_compose
  deploy_runtime
  if run "skills.write_approval = true (skill buatan Hermes menunggu persetujuanmu)" hmq config set skills.write_approval true; then :
  else warn "Set manual nanti: /skills approval on di Telegram"; fi
  if confirm "Wajibkan approval juga untuk memory Hermes (memory.write_approval)?" N; then
    run "memory.write_approval = true" hmq config set memory.write_approval true || warn "Gagal, lewati"
  fi
  box "Tools untuk cron (layar berikut)" $'Pilih platform "cron", nyalakan: web, terminal, file. Simpan, lalu keluar.\nweb = daily briefing · terminal = backup.sh & cek privasi lint · file = baca/tulis igrow/'
  if confirm "Buka pengaturan tools sekarang?" Y; then hm tools || warn "Pengaturan tools ditutup dengan error"; fi
  if running; then run "Restart gateway" dc restart igrow-hermes || die "Restart gagal"
  else run "Nyalakan gateway (docker compose up -d)" dc up -d igrow-hermes || die "Gateway gagal start"; fi
  find_container; sleep 5
  running || { dc logs --tail 30 igrow-hermes >>"$LOG" 2>&1; die "Gateway berhenti setelah start, lihat log"; }
  ok "Gateway jalan: $CNAME"
  run "hermes doctor" hmq doctor || warn "Doctor menemukan masalah, lihat log (atau: bash $0 status)"
}

step8() {
  step_head 8 "Backup knowledge" "igrow/ di-push ke repo GitHub privat. Repo backup sudah berisi → tawarkan restore."
  load_docker; find_container
  running || die "Gateway belum jalan, jalankan langkah 7 dulu"
  hx git --version >/dev/null 2>&1 || die "git tidak ada di container"
  # Token baru (kedaluwarsa) → hapus hermes-home/.git-credentials lalu ulang langkah ini
  if [ -f "$HH/.git-credentials" ] && hx git rev-parse -q --verify HEAD >/dev/null 2>&1 \
     && hx git remote get-url origin >/dev/null 2>&1; then
    skip "Repo backup tersambung ($(hx git remote get-url origin))"
  else
    ask BACKUP_REPO "Repo backup GitHub (pemilik/nama), PRIVAT" "${BACKUP_REPO:-${GH_USER:-user}/igrow-backup}"
    box "Siapkan di GitHub (sekali)" "1. github.com/new → $BACKUP_REPO → Private → tanpa README
2. Settings → Developer settings → Fine-grained tokens → Generate
   Repository access: Only select → $BACKUP_REPO
   Permissions → Contents: Read and write (yang lain biarkan)
   Kalau token bocor, yang terdampak hanya repo backup ini."
    pause
    local tok vis
    until ask_secret tok "Fine-grained token"; vis=$(gh_repo "$tok"); do warn "Repo tidak terjangkau token ini (nama repo benar? akses Contents?)"; done
    [ "$vis" = private ] || die "Repo $BACKUP_REPO PUBLIK. Ubah jadi Private dulu, lalu: bash $0 step 8"
    ok "Token valid, repo privat"
    # Token di luar igrow/ → tidak pernah ikut ter-push. Remote URL tanpa token.
    (umask 077; printf 'https://igrow:%s@github.com\n' "$tok" >"$HH/.git-credentials")
    hx git rev-parse --git-dir >/dev/null 2>&1 || run "git init igrow/" hx git init -q -b master
    hx git config user.name igrow-backup          # level repo, bukan --global
    hx git config user.email igrow-backup@localhost
    hx git config credential.helper "store --file=/opt/data/.git-credentials"
    hx git remote remove origin >/dev/null 2>&1
    hx git remote add origin "https://github.com/$BACKUP_REPO.git"
    if hx git ls-remote --exit-code --heads origin master >/dev/null 2>&1 && ! hx git rev-parse -q --verify HEAD >/dev/null 2>&1; then
      warn "Repo backup sudah berisi data (mis. pindah VPS)."
      confirm "Restore data dari backup ke VPS ini? (runtime tetap versi repo)" Y \
        || die "Pakai repo backup yang kosong, lalu: bash $0 step 8"
      run "Ambil backup" hx git fetch -q origin master || die "Fetch gagal"
      run "Restore igrow/" hx git reset -q --hard origin/master || die "Restore gagal"
      hx git branch -q -u origin/master
      deploy_runtime   # aturan dari repo menimpa aturan lama di backup; data tetap
    else
      hx git add -A
      hx git rev-parse -q --verify HEAD >/dev/null 2>&1 || hx git commit -q -m "init iGROW" >>"$LOG" 2>&1
      run "Push pertama ke $BACKUP_REPO" hx git push -u origin master || die "Push pertama gagal"
    fi
    save_conf
  fi
  run "Uji backup.sh (persis seperti cron)" hx bash /opt/data/igrow/project-skills/maintenance/backup.sh || die "backup.sh gagal"
  info "Hasil: $(tail -n1 "$LOG")"
}

JOBS=(
  "daily-briefing|0 7 * * *|Baca igrow/project-skills/daily-briefing.md lalu kerjakan."
  "backup-knowledge|0 5 * * 1,3,6|Baca igrow/project-skills/maintenance/backup.md lalu kerjakan."
  "lint-mingguan|0 8 * * 0|Baca igrow/project-skills/maintenance/lint.md lalu kerjakan."
  "career-review|0 9 1 1,4,7,10 *|Baca igrow/project-skills/career-review.md lalu kerjakan untuk kuartal yang baru selesai."
)
step9() {
  step_head 9 "Cron job" "Briefing 07:00 · backup Sen/Rab/Sab 05:00 · lint Minggu 08:00 · career review tiap kuartal."
  load_docker; find_container
  running || die "Gateway belum jalan, jalankan langkah 7 dulu"
  local list j name sched prompt
  list=$(hmq cron list 2>/dev/null)
  for j in "${JOBS[@]}"; do
    IFS='|' read -r name sched prompt <<<"$j"
    if grep -qiw -- "$name" <<<"$list"; then skip "$name"; continue; fi
    run "$name ($sched)" hmq cron create "$sched" "$prompt" --name "$name" --deliver telegram --workdir /opt/data \
      || warn "Gagal membuat $name, cek: hermes cron create --help"
  done
  run "Uji lint-privacy.sh (dipakai lint mingguan)" hx bash /opt/data/igrow/project-skills/maintenance/lint-privacy.sh \
    || warn "lint-privacy.sh error, lihat log"
}

# ── Perintah ────────────────────────────────────────────────────────────────
preflight() {
  [ "$EUID" -ne 0 ] || die "Jangan pakai root. Login sebagai user biasa yang punya sudo, lalu: bash $0"
  command -v apt-get >/dev/null || die "Script ini untuk Ubuntu/Debian (apt)."
  info "Minta sudo sekali untuk install paket…"
  sudo -v || die "sudo gagal"
  ( while sleep 50; do sudo -n true; done ) 2>/dev/null &
  trap "kill $! 2>/dev/null" EXIT   # $! dibaca sekarang: PID penjaga sudo, bukan job terakhir
}

intro() {
  box "Yang perlu disiapkan (±15 menit)" "• Akun GitHub (repo iGROW + repo privat kosong untuk backup)
• Telegram: bot baru dari @BotFather + user ID dari @userinfobot
• API key LLM (OpenRouter / Anthropic / OpenAI / dll)
Langkah yang sudah beres otomatis dilewati. Gagal di tengah? Jalankan ulang saja."
  printf '  %s1 Paket · 2 Git · 3 Docker · 4 Repo · 5 Container · 6 LLM & Telegram · 7 Runtime · 8 Backup · 9 Cron%s\n\n' "$D" "$R"
  confirm "Mulai?" Y || exit 0
}

finale() {
  printf '\n%s━━ iGROW siap %s%s\n' "$GRN$B" "$(printf '━%.0s' $(seq 1 44))" "$R"
  box "Coba sekarang" "Telegram → ${BOT_NAME:+@$BOT_NAME }→ kirim: halo
Lalu ikuti skenario uji: $REPO_DIR/testing/test-flow.md"
  box "Perintah berguna" "bash $0 status     → cek kesehatan
bash $0 deploy     → pasang aturan terbaru dari repo (setelah git push dari laptop)
bash $0 step 6     → ganti API key LLM / token bot
Telegram: /skills pending → cek skill buatan Hermes yang menunggu persetujuan"
}

cmd_deploy() {
  banner; step_head "·" "Deploy runtime" "git pull repo → rsync 2 langkah ke hermes-home/. Data di VPS tidak disentuh."
  load_docker; find_container
  run "git pull ($REPO_DIR)" git -C "$REPO_DIR" pull --ff-only || die "Pull gagal"
  deploy_runtime
  ok "Selesai. Mulai sesi baru di Telegram (/new) supaya aturan terbaru terbaca."
}

cmd_status() {
  banner; step_head "·" "Status" "Kesehatan container, Hermes, cron, dan backup."
  load_docker; find_container
  [ -n "$CNAME" ] || die "Container igrow-hermes tidak ditemukan"
  running && ok "Container $CNAME jalan ($(dk inspect -f '{{.State.StartedAt}}' "$CNAME" | cut -c1-16))" \
          || { warn "Container $CNAME TIDAK jalan"; return; }
  if hmq doctor >>"$LOG" 2>&1; then ok "hermes doctor bersih"; else warn "hermes doctor menemukan masalah (detail di log)"; fi
  printf '\n'; hmq cron list 2>&1 | sed 's/^/    /'; printf '\n'
  if hx git rev-parse -q --verify HEAD >/dev/null 2>&1; then
    ok "Backup terakhir: $(hx git log -1 --format='%cr · %s')"
  else warn "Repo backup belum disiapkan (bash $0 step 8)"; fi
  ok "Runtime repo: $(git -C "$REPO_DIR" log -1 --format='%h · %cr' 2>/dev/null || echo '?')"
}

usage() { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; }

case "${1:-all}" in
  all)    banner; preflight; intro
          for i in 1 2 3 4 5 6 7 8 9; do "step$i"; done
          finale ;;
  step)   [[ "${2:-}" =~ ^[1-9]$ ]] || { usage; exit 1; }
          banner; preflight; "step$2" ;;
  deploy) cmd_deploy ;;
  status) cmd_status ;;
  *)      usage ;;
esac

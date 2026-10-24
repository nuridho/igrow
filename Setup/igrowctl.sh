#!/usr/bin/env bash
# igrowctl.sh — pasang iGROW di VPS: git, Docker, Hermes, Telegram, backup, cron. Dari nol sampai bot jalan.
# Jalankan sebagai user biasa yang punya sudo (BUKAN root):
#   bash igrowctl.sh            → belum pernah setup: semua langkah · sudah: menu pilihan (deploy, status, update, …)
#   bash igrowctl.sh all        → semua langkah; yang sudah beres otomatis dilewati (aman diulang)
#   bash igrowctl.sh step 6     → ulang satu langkah (mis. ganti API key LLM / token bot)
#   bash igrowctl.sh deploy     → tarik repo terbaru + pasang ulang runtime (data di VPS tidak disentuh)
#   bash igrowctl.sh status     → cek kesehatan: container, doctor, cron, backup terakhir
#   bash igrowctl.sh update     → update image Hermes + cek doctor & cron (cara balik ke versi lama ditampilkan)
#   bash igrowctl.sh help       → penjelasan tiap pilihan menu
# Penjelasan tiap langkah: PRD/07-setup.md. Secret hanya diketik saat diminta; tidak ditulis ke repo maupun log.
set -uo pipefail

CONF_DIR="$HOME/.config/igrow"
CONF="$CONF_DIR/setup.env"   # setelan NON-rahasia (path, URL repo) supaya re-run tidak bertanya ulang
LOG="$CONF_DIR/setup.log"
mkdir -p "$CONF_DIR" && chmod 700 "$CONF_DIR" && touch "$LOG" && chmod 600 "$LOG"

# ── Tampilan ────────────────────────────────────────────────────────────────
if [ -t 1 ]; then
  B=$'\e[1m' D=$'\e[2m' R=$'\e[0m' RED=$'\e[31m' GRN=$'\e[32m' YEL=$'\e[33m' CYN=$'\e[36m' MAG=$'\e[35m'
  if [ "$(tput colors 2>/dev/null || echo 8)" -ge 256 ]; then   # gradasi banner: cyan → biru → ungu
    GRAD=($'\e[38;5;51m' $'\e[38;5;45m' $'\e[38;5;39m' $'\e[38;5;33m' $'\e[38;5;63m')
  else GRAD=("$CYN" "$CYN" "$CYN" "$CYN" "$CYN"); fi
else
  B='' D='' R='' RED='' GRN='' YEL='' CYN='' MAG='' GRAD=('' '' '' '' '')
fi
TOTAL=9 T0=$SECONDS N_OK=0 N_SKIP=0 N_WARN=0

ok()   { N_OK=$((N_OK + 1));     printf '  %s✔%s %s\n' "$GRN" "$R" "$*"; }
info() { printf '  %s•%s %s\n' "$CYN" "$R" "$*"; }
warn() { N_WARN=$((N_WARN + 1)); printf '  %s!%s %s\n' "$YEL" "$R" "$*"; }
act()  { printf '  %s›%s %s%s%s\n' "$CYN" "$R" "$D" "$*" "$R"; }   # sedang dicek / dikerjakan
skip() { N_SKIP=$((N_SKIP + 1)); printf '  %s✔%s %s %s(sudah ada)%s\n' "$GRN" "$R" "$*" "$D" "$R"; }
die()  { printf '\n  %s✘ %s%s\n  %sLog lengkap: %s%s\n\n' "$RED$B" "$*" "$R" "$D" "$LOG" "$R"; exit 1; }
dur()  { if [ "$1" -ge 60 ]; then printf '%dm%02ds' $(($1 / 60)) $(($1 % 60)); else printf '%ds' "$1"; fi; }

banner() {
  clear 2>/dev/null || true
  local i=0 l
  printf '\n'
  while IFS= read -r l; do printf '%s%s%s\n' "${GRAD[i++]}$B" "$l" "$R"; done <<'ART'
     _  ____ ____   _____        __
    (_)/ ___|  _ \ / _ \ \      / /
    | | |  _| |_) | | | \ \ /\ / /
    | | |_| |  _ <| |_| |\ V  V /
    |_|\____|_| \_\\___/  \_/\_/
ART
  printf '%s    arsip karier & knowledge base · Hermes + Telegram%s\n' "$D" "$R"
}

step_head() { # step_head <nomor|·> <judul> <penjelasan>
  local line tag="[$1/$TOTAL]"; [[ "$1" =~ ^[0-9]+$ ]] || tag="$1"
  line=$(printf '━%.0s' $(seq 1 $((46 - ${#2}))))
  printf '\n%s━━ %s %s %s%s\n' "$MAG$B" "$tag" "$2" "$line" "$R"
  printf '  %s%s%s\n\n' "$D" "$3" "$R"
}

box() { # box <judul> <isi, boleh multi-baris>
  printf '\n  %s╭─ %s%s%s\n' "$CYN" "$B" "$1" "$R"
  while IFS= read -r l; do printf '  %s│%s %s\n' "$CYN" "$R" "$l"; done <<<"$2"
  printf '  %s╰─%s\n\n' "$CYN" "$R"
}

summary() { # summary → hitungan + waktu sejak T0
  printf '  %s✔ %d dikerjakan%s  %s✔ %d sudah ada%s  %s! %d peringatan%s  %swaktu %s%s\n' \
    "$GRN" "$N_OK" "$R" "$D" "$N_SKIP" "$R" "$YEL" "$N_WARN" "$R" "$D" "$(dur $((SECONDS - T0)))" "$R"
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

run() { # run <label> <perintah…> → output ke log; di layar spinner + detik berjalan
  local label="$1" start t0=$SECONDS e; shift
  printf '\n=== %s · %s\n' "$(date '+%F %T')" "$label" >>"$LOG"
  start=$(wc -l <"$LOG")
  "$@" >>"$LOG" 2>&1 &
  local pid=$! i=0 f=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  while kill -0 "$pid" 2>/dev/null; do
    [ -t 1 ] && printf '\r  %s%s%s %s %s%ss%s\e[K' "$CYN" "${f[i++ % 10]}" "$R" "$label" "$D" $((SECONDS - t0)) "$R"
    sleep 0.1
  done
  [ -t 1 ] && printf '\r\e[K'
  e=$((SECONDS - t0))
  local t=''; [ "$e" -ge 2 ] && t=" $D$(dur "$e")$R"   # durasi hanya kalau ≥ 2 detik
  if wait "$pid"; then ok "$label$t"; return 0; fi
  printf '  %s✘%s %s\n' "$RED" "$R" "$label$t"
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
: "${SETUP_DONE:=}"   # 1 = semua langkah pernah selesai → tanpa argumen tampil menu
save_conf() { declare -p REPO_DIR REPO_URL PROJ HH TZ_NAME GH_USER BACKUP_REPO BOT_NAME SETUP_DONE | sed 's/^declare -- //' >"$CONF"; }

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
has_compose() { compgen -G "$COMPOSE_DIR/docker-compose.y*ml" >/dev/null || compgen -G "$COMPOSE_DIR/compose.y*ml" >/dev/null; }   # bukan `ls a b`: exit 2 kalau salah satu tidak ada
need_compose() { has_compose || die "Belum ada docker-compose — jalankan langkah 5"; }
running() { [ -n "$CNAME" ] && [ "$(dk inspect -f '{{.State.Running}}' "$CNAME" 2>/dev/null)" = true ]; }

# Perintah hermes: lewat container yang jalan; kalau belum jalan, container sekali pakai.
# Jangan pernah 2 gateway di 1 folder data — `run --rm` hanya untuk perintah non-gateway.
hm()  { if running; then dk exec -it "$CNAME" hermes "$@"; else dc run --rm igrow-hermes "$@"; fi; }      # interaktif
hmq() { if running; then dk exec "$CNAME" hermes "$@"; else dc run --rm -T igrow-hermes "$@"; fi; }       # tanpa layar
# git di container, sebagai pemilik hermes-home (= user gateway), persis seperti cron menjalankan backup.sh
hx()  { dk exec -u "$(stat -c '%u:%g' "$HH")" -w /opt/data/igrow "$CNAME" "$@"; }
restart_if_running() { if running; then run "Restart gateway (setelan baru dibaca)" dc restart igrow-hermes; fi; }

# ── Pengecekan eksternal (secret lewat stdin curl, tidak muncul di daftar proses) ──
repo_url_ok() { # URL HTTPS GitHub yang valid? Pemiliknya langsung jadi GH_USER (default nama repo backup)
  [[ "$1" =~ ^https://github\.com/([^/]+)/[^/]+$ ]] && GH_USER="${BASH_REMATCH[1]}"
}
repo_to_https() { # clone lama lewat SSH → HTTPS (repo iGROW harus Publik, D-35); dipakai langkah 4 dan deploy
  local cur; cur=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null || true)
  if [[ "$cur" == git@github.com:* ]]; then
    git -C "$REPO_DIR" remote set-url origin "https://github.com/${cur#git@github.com:}" && info "Remote origin dipindah dari SSH ke HTTPS"
  fi
}
ask_repo_url() { # tanya URL repo iGROW sampai valid (repo harus Publik: dibaca tanpa SSH key atau token)
  while ask REPO_URL "URL HTTPS repo iGROW (repo harus Publik)" "https://github.com/${GH_USER:-nuridho}/igrow.git"; ! repo_url_ok "$REPO_URL"; do
    warn "Pakai URL HTTPS GitHub, mis. https://github.com/<user>/igrow.git"
  done
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
  local need=() p v
  act "Mengecek git, rsync, curl…"
  for p in git rsync curl; do command -v "$p" >/dev/null || need+=("$p"); done
  if [ ${#need[@]} -gt 0 ]; then
    info "Belum ada: ${need[*]}"
    run "apt update" sudo apt-get update -y || die "apt update gagal"
    run "Install ${need[*]}" sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${need[@]}" || die "Install gagal"
  fi
  v="$(git --version), rsync $(rsync --version | awk 'NR==1{print $3}'), curl $(curl --version | awk 'NR==1{print $2}')"
  if [ ${#need[@]} -eq 0 ]; then skip "$v"; else ok "$v"; fi
}

step2() {
  step_head 2 "Git & GitHub" "Setelan git dan cek akses ke repo iGROW lewat HTTPS (repo Publik: tanpa SSH key atau token)."
  act "Mengecek setelan git…"
  if [ "$(git config --global pull.ff || true)" = only ] && [ "$(git config --global init.defaultBranch || true)" = master ]; then
    skip "Setelan git: pull hanya fast-forward, branch awal master"
  else
    git config --global pull.ff only; git config --global init.defaultBranch master
    ok "Setelan git: pull hanya fast-forward, branch awal master"
  fi
  act "Menentukan alamat repo iGROW…"
  if repo_url_ok "$REPO_URL"; then skip "Alamat repo: $REPO_URL"   # URL SSH dari setup lama tidak lolos → ditanya ulang
  else ask_repo_url; ok "Alamat repo: $REPO_URL"; fi
  # GIT_TERMINAL_PROMPT=0: repo privat langsung gagal, bukan menggantung menunggu username
  run "Cek akses ke repo iGROW (HTTPS, tanpa login)" env GIT_TERMINAL_PROMPT=0 git ls-remote "$REPO_URL" HEAD \
    || die "Repo tidak terjangkau tanpa login. Cek URL-nya, dan pastikan repo berstatus Publik (GitHub → repo → Settings → Danger Zone → Change visibility)."
  save_conf
}

step3() {
  step_head 3 "Docker & Compose" "Mesin untuk menjalankan container Hermes."
  act "Mengecek Docker & Compose…"
  if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
    skip "$(docker --version | cut -d, -f1), compose $(docker compose version --short)"
  else
    run "Install Docker + Compose (get.docker.com)" sh -c 'curl -fsSL https://get.docker.com | sudo sh' || die "Install Docker gagal"
    ok "$(docker --version | cut -d, -f1), compose $(docker compose version --short)"
  fi
  act "Memastikan service Docker aktif & akses user $USER…"
  sudo systemctl enable --now docker >>"$LOG" 2>&1 || true
  if id -nG "$USER" | grep -qw docker; then skip "User $USER di grup docker"
  else
    sudo usermod -aG docker "$USER"
    warn "User $USER masuk grup docker: aktif setelah logout/login. Sampai itu, script memakai sudo."
  fi
  load_docker; ok "Docker siap (service aktif)"
}

step4() {
  step_head 4 "Repo iGROW" "Clone repo spec iGROW ke VPS: sumber file runtime hermes-home/."
  repo_url_ok "$REPO_URL" || ask_repo_url   # langkah ini bisa dijalankan sendiri, tanpa langkah 2
  act "Mengecek repo iGROW di $REPO_DIR…"
  if [ -d "$REPO_DIR/.git" ]; then
    repo_to_https
    run "git pull ($REPO_DIR)" env GIT_TERMINAL_PROMPT=0 git -C "$REPO_DIR" pull --ff-only || warn "Pull gagal, lanjut pakai versi lokal"
  else
    ask REPO_DIR "Clone ke folder" "$REPO_DIR"
    run "Clone $REPO_URL" env GIT_TERMINAL_PROMPT=0 git clone "$REPO_URL" "$REPO_DIR" || die "Clone gagal (URL benar? repo berstatus Publik?)"
  fi
  [ -f "$REPO_DIR/hermes-home/AGENTS.md" ] || die "$REPO_DIR bukan repo iGROW (hermes-home/AGENTS.md tidak ada)"
  ok "Repo: $REPO_DIR ($(git -C "$REPO_DIR" log -1 --format='%h · %cr'))"
  info "Sumber runtime: $REPO_DIR/hermes-home/ ($(find "$REPO_DIR/hermes-home" -type f | wc -l) file)"
  save_conf
}

step5() {
  step_head 5 "Container Hermes" "Compose resmi nousresearch/hermes-agent; data di hermes-home/ = /opt/data."
  load_docker
  act "Mencari container igrow-hermes…"
  find_container
  if [ -n "$CNAME" ]; then skip "Container $CNAME (compose: $COMPOSE_DIR, data: $HH)"; save_conf; return; fi
  info "Belum ada container igrow-hermes: compose baru akan dibuat"
  while ask PROJ "Mau install di mana? Nama folder project di $HOME (mis. whatsinsidegit)" "$PROJ"; [[ "$PROJ" == */* ]]; do
    warn "Cukup nama folder, tanpa /"; PROJ=''
  done
  if [ -d "$HOME/$PROJ" ]; then info "Folder $HOME/$PROJ sudah ada, dipakai"; else info "Folder $HOME/$PROJ dibuat"; fi
  HH="$HOME/$PROJ/igrow-hermes/hermes-home"
  ask TZ_NAME "Timezone (jam cron & briefing)" "$TZ_NAME"
  COMPOSE_DIR="$(dirname "$HH")"
  act "Menyiapkan folder & environment…"
  mkdir -p "$HH" && ok "Folder data: $HH"
  set_kv "$COMPOSE_DIR/.env" HERMES_UID "$(id -u)"
  set_kv "$COMPOSE_DIR/.env" HERMES_GID "$(id -g)"
  set_kv "$COMPOSE_DIR/.env" IGROW_TZ "$TZ_NAME"
  ok "Environment compose: UID/GID $(id -u):$(id -g), TZ $TZ_NAME ($COMPOSE_DIR/.env)"
  if has_compose; then
    skip "docker-compose.yml di $COMPOSE_DIR"
  else
    cat >"$COMPOSE_DIR/docker-compose.yml" <<'YML'
# Dibuat oleh Setup/igrowctl.sh — penjelasan di PRD/07-setup.md
services:
  igrow-hermes:
    image: nousresearch/hermes-agent:latest   # pin versi (mis. :X.Y.Z) kalau mau stabil
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
  info "Image: nousresearch/hermes-agent:latest (dibuat $(dk image inspect -f '{{.Created}}' nousresearch/hermes-agent:latest 2>/dev/null | cut -c1-10))"
  save_conf
}

step6() {
  step_head 6 "Otak (LLM) & Telegram" "API key LLM + token bot, disimpan di hermes-home/.env (bukan di repo)."
  load_docker; find_container; need_compose
  local env="$HH/.env" d=Y tok uid bot
  act "Mengecek setelan LLM…"
  if [ -f "$HH/config.yaml" ]; then info "Model sekarang: $(hmq config get model.default 2>/dev/null | tail -n1)"; d=N
  else info "Belum ada setelan LLM"; fi
  if confirm "Buka wizard LLM resmi Hermes (pilih provider → tempel API key → pilih model)?" "$d"; then
    box "Wizard LLM" $'Pilih provider yang kamu punya key-nya (OpenRouter, Anthropic, OpenAI, dll).\nKey diketik di wizard resmi Hermes dan langsung masuk hermes-home/.env.'
    hm setup model || die "Wizard LLM gagal"
    ok "LLM tersimpan"
  fi
  act "Mengecek token bot Telegram…"
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
  act "Menyalin aturan iGROW dari repo ke $HH…"
  deploy_runtime
  act "Mengunci approval skill buatan Hermes…"
  if run "skills.write_approval = true (skill buatan Hermes menunggu persetujuanmu)" hmq config set skills.write_approval true; then :
  else warn "Set manual nanti: /skills approval on di Telegram"; fi
  if confirm "Wajibkan approval juga untuk memory Hermes (memory.write_approval)?" N; then
    run "memory.write_approval = true" hmq config set memory.write_approval true || warn "Gagal, lewati"
  fi
  box "Tools untuk cron (layar berikut)" $'Pilih platform "cron", nyalakan: web, terminal, file. Simpan, lalu keluar.\nweb = daily briefing · terminal = backup.sh & cek privasi lint · file = baca/tulis igrow/'
  if confirm "Buka pengaturan tools sekarang?" Y; then hm tools || warn "Pengaturan tools ditutup dengan error"; fi
  act "Menyalakan gateway Telegram…"
  if running; then run "Restart gateway" dc restart igrow-hermes || die "Restart gagal"
  else run "Nyalakan gateway (docker compose up -d)" dc up -d igrow-hermes || die "Gateway gagal start"; fi
  find_container; sleep 5
  running || { dc logs --tail 30 igrow-hermes >>"$LOG" 2>&1; die "Gateway berhenti setelah start, lihat log"; }
  ok "Gateway jalan: $CNAME${BOT_NAME:+ (bot @$BOT_NAME)}"
  run "hermes doctor" hmq doctor || warn "Doctor menemukan masalah, lihat log (atau: bash $0 status)"
}

step8() {
  step_head 8 "Backup knowledge" "igrow/ di-push ke repo GitHub privat. Repo backup sudah berisi → tawarkan restore."
  load_docker; find_container
  running || die "Gateway belum jalan, jalankan langkah 7 dulu"
  act "Mengecek git di container & sambungan repo backup…"
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
  act "Membaca daftar cron yang sudah ada…"
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
  box "Yang perlu disiapkan (±15 menit)" "• Akun GitHub (repo privat kosong untuk backup; repo iGROW cukup Publik)
• Telegram: bot baru dari @BotFather + user ID dari @userinfobot
• API key LLM (OpenRouter / Anthropic / OpenAI / dll)
Langkah yang sudah beres otomatis dilewati. Gagal di tengah? Jalankan ulang saja."
  printf '  %s1 Paket · 2 Git · 3 Docker · 4 Repo · 5 Container · 6 LLM & Telegram · 7 Runtime · 8 Backup · 9 Cron%s\n\n' "$D" "$R"
  confirm "Mulai?" Y || exit 0
}

finale() {
  printf '\n%s━━ iGROW siap %s%s\n' "$GRN$B" "$(printf '━%.0s' $(seq 1 44))" "$R"
  summary
  box "Coba sekarang" "Telegram → ${BOT_NAME:+@$BOT_NAME }→ kirim: halo
Lalu ikuti skenario uji: $REPO_DIR/testing/test-flow.md"
  box "Berikutnya" "bash $0   → menu: deploy, status, update, ganti LLM/token, backup, help
Telegram: /skills pending → cek skill buatan Hermes yang menunggu persetujuan"
}

all_steps() {
  T0=$SECONDS N_OK=0 N_SKIP=0 N_WARN=0   # ringkasan akhir hanya menghitung langkah 1–9
  for i in 1 2 3 4 5 6 7 8 9; do "step$i"; done
  SETUP_DONE=1; save_conf
  finale
}

MENU_K=(1 2 3 4 5 6 7 h 0)
MENU_N=("Deploy" "Status" "Update" "LLM & Telegram" "Tools cron" "Backup" "Setup ulang" "Help" "Keluar")
MENU_D=("pasang aturan terbaru dari repo (habis git push)" "cek bot, Hermes, cron, backup terakhir"
        "update Hermes ke versi terbaru" "ganti API key, model, atau token bot" "ganti tools untuk job cron"
        "sambung ulang / ganti token backup" "semua langkah; yang sudah beres dilewati" "penjelasan tiap pilihan" "")

menu_pick() { # menu_pick → MENU_CHOICE; ↑/↓ (atau k/j) + Enter, atau langsung tekan angka/huruf
  local i=0 n=${#MENU_K[@]} j k rest w
  w=$(( $(tput cols 2>/dev/null || echo 80) - 28 )); [ "$w" -lt 10 ] && w=10   # deskripsi dipotong: baris tidak boleh melipat
  printf '\n  %s╭─ %sMau ngapain?%s\n' "$CYN" "$B" "$R"
  printf '  %s│%s %s↑/↓ pilih · Enter jalankan · atau tekan angkanya%s\n' "$CYN" "$R" "$D" "$R"
  printf '\e[?25l'; trap 'printf "\e[?25h\n"; exit 130' INT   # kursor disembunyikan selama memilih
  while :; do
    for ((j = 0; j < n; j++)); do
      if [ "$j" -eq "$i" ]; then
        printf '  %s│%s %s❯ %s  %-15s%s %s\e[K\n' "$CYN" "$R" "$CYN$B" "${MENU_K[j]}" "${MENU_N[j]}" "$R" "${MENU_D[j]:0:w}"
      else
        printf '  %s│%s   %s%s%s  %-15s %s%s%s\e[K\n' "$CYN" "$R" "$YEL" "${MENU_K[j]}" "$R" "${MENU_N[j]}" "$D" "${MENU_D[j]:0:w}" "$R"
      fi
    done
    printf '  %s╰─%s\e[K\n' "$CYN" "$R"
    IFS= read -rsn1 k </dev/tty
    if [ "$k" = $'\e' ]; then IFS= read -rsn2 -t 0.05 rest </dev/tty; k+="$rest"; fi
    case "$k" in
      $'\e[A'|$'\eOA'|k) i=$(( (i + n - 1) % n )) ;;   # \eOA: terminal mode aplikasi
      $'\e[B'|$'\eOB'|j) i=$(( (i + 1) % n )) ;;
      '') MENU_CHOICE=${MENU_K[i]}; break ;;
      q|Q) MENU_CHOICE=0; break ;;
      H) MENU_CHOICE=h; break ;;
      *) for ((j = 0; j < n; j++)); do [ "${MENU_K[j]}" = "$k" ] && { MENU_CHOICE=$k; break 2; }; done ;;
    esac
    printf '\e[%dA' $((n + 1))   # naik ke baris pertama daftar, gambar ulang
  done
  printf '\e[?25h'; trap - INT
}

menu() {
  while :; do
    menu_pick
    case "$MENU_CHOICE" in
      1) cmd_deploy; return ;;
      2) cmd_status; return ;;
      3) cmd_update; return ;;
      4) preflight; step6; return ;;
      5) preflight; step7; return ;;
      6) preflight
         if confirm "Ganti token backup? (token lama dihapus, mis. karena kedaluwarsa)" N; then
           rm -f "$HH/.git-credentials"; info "Token lama dihapus"
         fi
         step8; return ;;
      7) preflight; intro; all_steps; return ;;
      h) cmd_help ;;   # menu tampil lagi di bawah penjelasan
      0) exit 0 ;;
    esac
  done
}

hitem() { # hitem <judul> <isi> → judul tebal + isi menjorok (lebih rapat dari box)
  printf '  %s%s%s\n' "$CYN$B" "$1" "$R"
  while IFS= read -r l; do printf '    %s\n' "$l"; done <<<"$2"; printf '\n'
}

cmd_help() {
  step_head "·" "Help" "Penjelasan tiap pilihan di menu."
  hitem "1 · Deploy" "Kapan: kamu mengubah aturan di hermes-home/ di laptop lalu git push.
Yang terjadi: git pull repo di VPS → salin aturan ke hermes-home/. Note, raw, output tidak disentuh.
Sesudahnya: kirim /new di Telegram supaya sesi baru membaca aturan terbaru."
  hitem "2 · Status" "Kapan: bot diam, atau sekadar mau memastikan semuanya sehat.
Yang dicek: container jalan, hermes doctor, daftar cron, waktu backup terakhir. Tidak mengubah apa pun."
  hitem "3 · Update" "Kapan: Hermes rilis versi baru (sesekali saja, mis. sebulan sekali).
Yang terjadi: tarik image terbaru → buat ulang container → cek doctor & cron.
Versi baru bermasalah? Di akhir ditampilkan baris untuk balik ke versi lama."
  hitem "4 · LLM & Telegram (langkah 6)" "Kapan: ganti provider/API key/model LLM, atau ganti token bot Telegram.
Yang terjadi: wizard resmi Hermes untuk LLM; token bot dicek ke Telegram dulu sebelum disimpan."
  hitem "5 · Tools cron (langkah 7)" "Kapan: job cron gagal karena tool-nya mati, atau mau mengubah tools cron.
Yang terjadi: aturan dari repo dipasang ulang, layar hermes tools dibuka (platform cron: web, terminal, file), bot di-restart."
  hitem "6 · Backup (langkah 8)" "Kapan: token backup kedaluwarsa, push backup gagal, atau ganti repo backup.
Yang terjadi: jawab Y untuk menghapus token lama → masukkan token baru → backup diuji persis seperti cron."
  hitem "7 · Setup ulang" "Kapan: ada langkah yang dulu gagal, atau ragu setup sudah lengkap.
Yang terjadi: langkah 1-9 dijalankan; yang sudah beres dicek lalu dilewati. Aman."
  hitem "Tanpa menu (untuk alias/otomatis)" "bash $0 deploy | status | update | all | step <1-9> | help"
}

cmd_deploy() {
  banner; step_head "·" "Deploy runtime" "git pull repo → rsync 2 langkah ke hermes-home/. Data di VPS tidak disentuh."
  load_docker; find_container
  repo_to_https
  run "git pull ($REPO_DIR)" env GIT_TERMINAL_PROMPT=0 git -C "$REPO_DIR" pull --ff-only || die "Pull gagal"
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

cmd_update() { # docs resmi: compose pull → up -d; Hermes memigrasi config sendiri (config.yaml & .env dibackup dulu)
  banner; step_head "·" "Update Hermes" "Tarik image terbaru → buat ulang container. Data di hermes-home/ tetap."
  load_docker; find_container; need_compose
  [ -n "$CNAME" ] || die "Container igrow-hermes tidak ditemukan (bash $0 step 5)"
  local old new pin oldv newv
  old=$(dk inspect -f '{{.Image}}' "$CNAME")
  pin=$(dk image inspect -f '{{index .RepoDigests 0}}' "$old" 2>/dev/null)   # dibaca sebelum pull: untuk balik versi
  oldv=$(hmq --version 2>/dev/null | tail -n1)
  run "Tarik image terbaru" dc pull igrow-hermes || die "Gagal menarik image"
  new=$(dk image inspect -f '{{.Id}}' "$(dk inspect -f '{{.Config.Image}}' "$CNAME")")
  if [ "$old" = "$new" ]; then ok "Hermes ${oldv:-?} sudah versi terbaru, tidak ada yang diubah"; return; fi
  run "Buat ulang container" dc up -d igrow-hermes || die "Container gagal dibuat ulang"
  find_container; sleep 5
  running || { dc logs --tail 30 igrow-hermes >>"$LOG" 2>&1; die "Gateway berhenti setelah update, lihat log"; }
  newv=$(hmq --version 2>/dev/null | tail -n1)
  ok "Hermes ${oldv:-?} → ${newv:-?}"
  run "hermes doctor" hmq doctor || warn "Doctor menemukan masalah, lihat log"
  printf '\n'; hmq cron list 2>&1 | sed 's/^/    /'
  [ -n "$pin" ] && box "Kalau versi baru bermasalah, balik ke versi lama" "Di $COMPOSE_DIR/docker-compose.yml, service igrow-hermes:
  image: $pin
lalu: cd $COMPOSE_DIR && docker compose up -d igrow-hermes"
  ok "Selesai. Kirim /new di Telegram, lalu cek job cron di atas masih lengkap."
}

usage() { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; }

case "${1:-}" in
  '')     banner
          if [ -n "$SETUP_DONE" ]; then menu; else preflight; intro; all_steps; fi ;;
  all)    banner; preflight; intro; all_steps ;;
  step)   [[ "${2:-}" =~ ^[1-9]$ ]] || { usage; exit 1; }
          banner; preflight; "step$2" ;;
  deploy) cmd_deploy ;;
  status) cmd_status ;;
  update) cmd_update ;;
  help|-h|--help) banner; cmd_help ;;
  *)      usage ;;
esac

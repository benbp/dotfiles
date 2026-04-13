#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: migrate-configs.sh --src /path/to/old/home --dst /path/to/new/home
EOF
}

SRC=""
DST=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --src) SRC="$2"; shift 2 ;;
    --dst) DST="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "${SRC}" || -z "${DST}" ]]; then
  usage
  exit 1
fi

if [[ ! -d "${SRC}" ]]; then
  echo "Source path not found: ${SRC}" >&2
  exit 1
fi

STATE_FILE="${STATE_FILE:-$HOME/.migration-state.txt}"
mkdir -p "$(dirname "$STATE_FILE")"
touch "$STATE_FILE"

step_done() {
  grep -qx "$1" "$STATE_FILE"
}

mark_done() {
  echo "$1" >> "$STATE_FILE"
}

run_step() {
  local name="$1"
  shift
  if step_done "$name"; then
    echo "Skipping (done): $name"
    return 0
  fi
  echo "Running: $name"
  "$@"
  mark_done "$name"
}

RSYNC_BASE=(rsync -aHAX --info=progress2 --human-readable)

step_copy_dotfiles() {
  shopt -s nullglob
  local items=(
    ".bashrc" ".zshrc" "zshrc.msft" ".profile" ".bash_logout"
    ".inputrc" ".histfile" ".wslconfig"
    ".gitconfig" ".git-credentials"
    ".vimrc" ".tmux.conf"
    "antigen.zsh" "z.lua" ".zlua" ".antigenrc"
    ".tmux" ".vim"
    ".codex" ".copilot" ".claude" ".claude.json"
    ".azure" ".azure-devops" ".Azure"
    ".kube"
    ".nuget" ".templateengine"
    ".ssh"
    ".config"
  )

  local item
  for item in "${items[@]}"; do
    if [[ -e "${SRC}/${item}" ]]; then
      local excludes=()
      case "$item" in
        ".azure")
          excludes+=(--exclude "cliextensions/**" --exclude "logs/**" --exclude "bin/**")
          ;;
        ".copilot")
          excludes+=(--exclude "pkg/**" --exclude "session-state/**" --exclude "logs/**")
          ;;
        ".nuget")
          excludes+=(--exclude "packages/**")
          ;;
        ".codex")
          excludes+=(--exclude "sessions/**" --exclude "log/**")
          ;;
        ".kube")
          excludes+=(--exclude "cache/**")
          ;;
        ".tmux")
          excludes+=(--exclude "plugins/**")
          ;;
        ".vim")
          excludes+=(--exclude "plugged/**")
          ;;
        ".config")
          excludes+=(
            --exclude "opencode/node_modules/**"
            --exclude "opencode/bin/**"
            --exclude "opencode/bun.lock"
            --exclude "opencode/package.json"
          )
          ;;
      esac
      "${RSYNC_BASE[@]}" "${excludes[@]}" "${SRC}/${item}" "${DST}/"
    fi
  done

  local f
  for f in "${SRC}/"*.ps1 "${SRC}/"*.sh; do
    if [[ -f "$f" ]]; then
      "${RSYNC_BASE[@]}" "$f" "${DST}/"
    fi
  done
}

step_fix_permissions() {
  if [[ -d "${DST}/.ssh" ]]; then
    chmod 700 "${DST}/.ssh"
    find "${DST}/.ssh" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \;
    find "${DST}/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;
    if [[ -f "${DST}/.ssh/known_hosts" ]]; then
      chmod 644 "${DST}/.ssh/known_hosts"
    fi
  fi
  if [[ -f "${DST}/.git-credentials" ]]; then
    chmod 600 "${DST}/.git-credentials"
  fi
  if [[ -f "${DST}/.config/gh/hosts.yml" ]]; then
    chmod 600 "${DST}/.config/gh/hosts.yml"
  fi
}

run_step "configs:copy_dotfiles" step_copy_dotfiles
run_step "configs:fix_permissions" step_fix_permissions

echo "Config migration complete."

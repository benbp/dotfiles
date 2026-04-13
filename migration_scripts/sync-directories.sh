#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sync-directories.sh --src /path/to/old/home --dst /path/to/new/home
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

step_sync_working() {
  local dirs=("ai" "azs/azure-sdk-tools" "svs" "dotfiles" "bin" "lib")
  local d
  for d in "${dirs[@]}"; do
    if [[ -d "${SRC}/${d}" ]]; then
      "${RSYNC_BASE[@]}" "${SRC}/${d}" "${DST}/"
    fi
  done
}

run_step "dirs:sync_working" step_sync_working

echo "Directory sync complete."

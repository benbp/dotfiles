#!/usr/bin/env bash
set -euo pipefail

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

ensure_local_bin() {
  mkdir -p "$HOME/.local/bin"
}

install_github_release_asset() {
  local repo="$1"
  local asset_regex="$2"
  local bin_name="$3"
  local dest_dir="$4"

  local api_url="https://api.github.com/repos/${repo}/releases/latest"
  local asset_url
  asset_url="$(curl -fsSL "$api_url" | jq -r ".assets[] | select(.name | test(\"${asset_regex}\")) | .browser_download_url" | head -n 1)"
  if [[ -z "${asset_url}" || "${asset_url}" == "null" ]]; then
    echo "No matching asset found for ${repo} (${asset_regex})" >&2
    return 1
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local file_name="${asset_url##*/}"
  local file_path="${tmp_dir}/${file_name}"
  curl -fsSL "$asset_url" -o "$file_path"

  if [[ "$file_path" == *.deb ]]; then
    sudo dpkg -i "$file_path" || sudo apt-get -f install -y
  elif [[ "$file_path" == *.tar.gz || "$file_path" == *.tgz ]]; then
    tar -C "$tmp_dir" -xf "$file_path"
    local bin_path
    bin_path="$(find "$tmp_dir" -type f -name "$bin_name" -perm -u+x | head -n 1)"
    if [[ -z "${bin_path}" ]]; then
      echo "Binary ${bin_name} not found in ${file_name}" >&2
      return 1
    fi
    install -m 0755 "$bin_path" "${dest_dir}/${bin_name}"
  elif [[ "$file_path" == *.zip ]]; then
    unzip -q "$file_path" -d "$tmp_dir"
    local bin_path
    bin_path="$(find "$tmp_dir" -type f -name "$bin_name" -perm -u+x | head -n 1)"
    if [[ -z "${bin_path}" ]]; then
      echo "Binary ${bin_name} not found in ${file_name}" >&2
      return 1
    fi
    install -m 0755 "$bin_path" "${dest_dir}/${bin_name}"
  else
    echo "Unknown asset type: ${file_name}" >&2
    return 1
  fi
}

run_step "install:base_apt" bash -c '
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates curl wget gnupg lsb-release \
    jq yq rsync unzip tar xz-utils \
    git vim neovim ripgrep fzf tmux \
    lua5.4 pcre2-utils wslu build-essential
'

run_step "install:powershell" bash -c '
  tmp_deb="/tmp/packages-microsoft-prod.deb"
  curl -fsSL https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -o "$tmp_deb"
  sudo dpkg -i "$tmp_deb"
  sudo apt-get update
  sudo apt-get install -y powershell
'

run_step "install:az_cli" bash -c '
  curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash
'

run_step "install:az_devops_extension" bash -c '
  az extension add --name azure-devops
'

run_step "install:docker_ce" bash -c '
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
'

run_step "install:gh" bash -c '
  ensure_local_bin
  install_github_release_asset "cli/cli" "^gh_.*_linux_amd64\\.deb$" "gh" "$HOME/.local/bin"
'

run_step "install:dotnet_8" bash -c '
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
  chmod +x /tmp/dotnet-install.sh
  /tmp/dotnet-install.sh --channel 8.0 --install-dir "$HOME/.dotnet" --no-path
'

run_step "install:dotnet_9" bash -c '
  /tmp/dotnet-install.sh --channel 9.0 --install-dir "$HOME/.dotnet" --no-path
'

run_step "install:dotnet_10" bash -c '
  /tmp/dotnet-install.sh --channel 10.0 --install-dir "$HOME/.dotnet" --no-path
'

run_step "install:go" bash -c '
  ver="$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1)"
  url="https://go.dev/dl/${ver}.linux-amd64.tar.gz"
  curl -fsSL "$url" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
'

run_step "install:kubectl" bash -c '
  ver="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSL -o /tmp/kubectl "https://dl.k8s.io/release/${ver}/bin/linux/amd64/kubectl"
  sudo install -m 0755 /tmp/kubectl /usr/local/bin/kubectl
'

run_step "install:delta" bash -c '
  install_github_release_asset "dandavison/delta" "^delta_.*_amd64\\.deb$" "delta" "$HOME/.local/bin"
'

run_step "install:nvm_node" bash -c '
  NVM_VERSION="${NVM_VERSION:-v0.39.7}"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install 22.14.0
  nvm alias default 22.14.0
'

run_step "install:uv" bash -c '
  ensure_local_bin
  curl -fsSL https://astral.sh/uv/install.sh | sh -s -- --bin-dir "$HOME/.local/bin"
'

run_step "install:copilot_cli" bash -c '
  ensure_local_bin
  COPILOT_REPO="${COPILOT_REPO:-github/copilot-cli}"
  COPILOT_ASSET_REGEX="${COPILOT_ASSET_REGEX:-copilot.*linux.*amd64|linux_amd64}"
  install_github_release_asset "$COPILOT_REPO" "$COPILOT_ASSET_REGEX" "copilot" "$HOME/.local/bin"
'

run_step "install:codex_cli" bash -c '
  ensure_local_bin
  CODEX_REPO="${CODEX_REPO:-openai/codex}"
  CODEX_ASSET_REGEX="${CODEX_ASSET_REGEX:-codex.*linux.*amd64|linux_amd64}"
  install_github_release_asset "$CODEX_REPO" "$CODEX_ASSET_REGEX" "codex" "$HOME/.local/bin"
'

run_step "install:opencode" bash -c '
  ensure_local_bin
  OPENCODE_REPO="${OPENCODE_REPO:-opencode-ai/opencode}"
  OPENCODE_ASSET_REGEX="${OPENCODE_ASSET_REGEX:-opencode.*linux.*amd64|linux_amd64}"
  install_github_release_asset "$OPENCODE_REPO" "$OPENCODE_ASSET_REGEX" "opencode" "$HOME/.local/bin"
'

echo "Program installation complete."

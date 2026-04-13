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
  asset_url="$(curl -fsSL "$api_url" | jq -r --arg re "$asset_regex" '.assets[] | select(.name | test($re)) | .browser_download_url' | head -n 1)"
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

step_base_apt() {
  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates curl wget gnupg lsb-release \
    jq yq rsync unzip tar xz-utils \
    git vim neovim ripgrep fzf tmux \
    lua5.4 pcre2-utils wslu build-essential \
    zsh
}

step_powershell() {
  local tmp_deb="/tmp/packages-microsoft-prod.deb"
  curl -fsSL https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -o "$tmp_deb"
  sudo dpkg -i "$tmp_deb"
  sudo apt-get update
  sudo apt-get install -y powershell
}

step_az_cli() {
  curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

step_atuin() {
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

step_az_completion() {
  local comp_dir="$HOME/lib/azure-cli"
  mkdir -p "$comp_dir"
  az completion -s zsh > "${comp_dir}/az.completion"
}

step_az_extensions() {
  local exts=(
    "azure-devops"
    "aks-preview"
    "application-insights"
    "confidentialledger"
    "fzf"
    "ml"
  )
  local ext
  for ext in "${exts[@]}"; do
    az extension add --name "$ext"
  done
}

step_docker_ce() {
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

step_gh() {
  ensure_local_bin
  install_github_release_asset "cli/cli" "^gh_.*_linux_amd64\\.deb$" "gh" "$HOME/.local/bin"
}

step_dotnet_8() {
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
  chmod +x /tmp/dotnet-install.sh
  /tmp/dotnet-install.sh --channel 8.0 --install-dir "$HOME/.dotnet" --no-path
}

step_dotnet_9() {
  /tmp/dotnet-install.sh --channel 9.0 --install-dir "$HOME/.dotnet" --no-path
}

step_dotnet_10() {
  /tmp/dotnet-install.sh --channel 10.0 --install-dir "$HOME/.dotnet" --no-path
}

step_go() {
  local ver
  ver="$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1)"
  local url="https://go.dev/dl/${ver}.linux-amd64.tar.gz"
  curl -fsSL "$url" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
}

step_kubectl() {
  local ver
  ver="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSL -o /tmp/kubectl "https://dl.k8s.io/release/${ver}/bin/linux/amd64/kubectl"
  sudo install -m 0755 /tmp/kubectl /usr/local/bin/kubectl
}

step_delta() {
  install_github_release_asset "dandavison/delta" "^git-delta_.*_amd64\\.deb$" "delta" "$HOME/.local/bin"
}

step_nvm_node() {
  local nvm_version="${NVM_VERSION:-v0.39.7}"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install 22.14.0
  nvm alias default 22.14.0
}

step_uv() {
  ensure_local_bin
  curl -fsSL https://astral.sh/uv/install.sh | sh -s -- --bin-dir "$HOME/.local/bin"
}

step_copilot_cli() {
  ensure_local_bin
  local repo="${COPILOT_REPO:-github/copilot-cli}"
  local regex="${COPILOT_ASSET_REGEX:-^copilot-linux-x64\\.tar\\.gz$}"
  install_github_release_asset "$repo" "$regex" "copilot" "$HOME/.local/bin"
}

step_codex_cli() {
  npm i -g @openai/codex@latest
}

step_opencode() {
  ensure_local_bin
  local repo="${OPENCODE_REPO:-opencode-ai/opencode}"
  local regex="${OPENCODE_ASSET_REGEX:-opencode.*linux.*amd64|linux_amd64}"
  install_github_release_asset "$repo" "$regex" "opencode" "$HOME/.local/bin"
}

run_step "install:base_apt" step_base_apt
run_step "install:powershell" step_powershell
run_step "install:az_cli" step_az_cli
run_step "install:atuin" step_atuin
run_step "install:az_completion" step_az_completion
run_step "install:az_extensions" step_az_extensions
run_step "install:docker_ce" step_docker_ce
run_step "install:gh" step_gh
run_step "install:dotnet_8" step_dotnet_8
run_step "install:dotnet_9" step_dotnet_9
run_step "install:dotnet_10" step_dotnet_10
run_step "install:go" step_go
run_step "install:kubectl" step_kubectl
run_step "install:delta" step_delta
run_step "install:nvm_node" step_nvm_node
run_step "install:uv" step_uv
run_step "install:copilot_cli" step_copilot_cli
run_step "install:codex_cli" step_codex_cli
run_step "install:opencode" step_opencode

echo "Program installation complete."

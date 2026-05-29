#!/usr/bin/env bash
# =============================================================================
# Dev Environment Setup Script
# Targets: zsh + nvim on Unix-like OS (macOS / Ubuntu/Debian)
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; exit 1; }
section() { echo -e "\n${BOLD}${CYAN}━━━  $*  ━━━${RESET}\n"; }

# ── OS Detection ──────────────────────────────────────────────────────────────
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ -f /etc/debian_version ]]; then
    OS="debian"
  elif [[ -f /etc/fedora-release ]]; then
    OS="fedora"
  elif [[ -f /etc/arch-release ]]; then
    OS="arch"
  else
    error "Unsupported OS. This script supports macOS, Debian/Ubuntu, Fedora, and Arch."
  fi
  info "Detected OS: ${OS}"
}

# ── Package Manager Bootstrap ─────────────────────────────────────────────────
install_system_deps() {
  section "System Dependencies"

  case "$OS" in
    macos)
      if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew update
      brew install git curl wget unzip cmake ninja gettext lua luarocks
      ;;
    debian)
      sudo apt-get update -qq
      sudo apt-get install -y \
        git curl wget unzip build-essential cmake ninja-build gettext \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev lua5.4 luarocks ca-certificates
      ;;
    fedora)
      sudo dnf install -y \
        git curl wget unzip gcc gcc-c++ cmake ninja-build gettext \
        openssl-devel zlib-devel bzip2-devel readline-devel sqlite-devel \
        ncurses-devel xz-devel tk-devel libxml2-devel libffi-devel \
        lua lua-devel luarocks
      ;;
    arch)
      sudo pacman -Sy --noconfirm \
        git curl wget unzip base-devel cmake ninja gettext \
        lua luarocks
      ;;
  esac
  success "System dependencies installed."
}

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
install_oh_my_zsh() {
  section "oh-my-zsh"
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    warn "oh-my-zsh already installed — skipping."
    return
  fi
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "oh-my-zsh installed."
}

# ── zsh Plugins ───────────────────────────────────────────────────────────────
install_zsh_plugins() {
  section "zsh Plugins"

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  # zsh-autosuggestions
  if [[ ! -d "${custom}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
      "${custom}/plugins/zsh-autosuggestions"
    success "zsh-autosuggestions installed."
  else
    warn "zsh-autosuggestions already present — skipping."
  fi

  # zsh-syntax-highlighting
  if [[ ! -d "${custom}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "${custom}/plugins/zsh-syntax-highlighting"
    success "zsh-syntax-highlighting installed."
  else
    warn "zsh-syntax-highlighting already present — skipping."
  fi

  # fzf
  if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc
    success "fzf installed."
  else
    warn "fzf already present — skipping."
  fi

  # pure prompt
  mkdir -p "$HOME/.zsh"
  if [[ ! -d "$HOME/.zsh/pure" ]]; then
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    success "pure prompt installed."
  else
    warn "pure already present — skipping."
  fi
}

# ── uv (Python package/tool manager) ──────────────────────────────────────────
install_uv() {
  section "uv"
  if command -v uv &>/dev/null; then
    warn "uv already installed — skipping."
    return
  fi
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # Make uv available for the rest of this script
  export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
  success "uv installed."
}

# ── Rust ──────────────────────────────────────────────────────────────────────
install_rust() {
  section "Rust"
  if command -v rustup &>/dev/null; then
    warn "Rust already installed — skipping."
    return
  fi
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  export PATH="$HOME/.cargo/bin:$PATH"
  rustup default stable
  success "Rust installed."
}

# ── tree-sitter-cli ───────────────────────────────────────────────────────────
install_tree_sitter_cli() {
  section "tree-sitter-cli"
  if command -v tree-sitter &>/dev/null; then
    warn "tree-sitter-cli already installed — skipping."
    return
  fi
  # Requires cargo (installed above)
  cargo install tree-sitter-cli
  success "tree-sitter-cli installed."
}

# ── nvm + latest LTS Node ─────────────────────────────────────────────────────
install_nvm_node() {
  section "nvm + Node LTS"

  local NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  if [[ -d "$NVM_DIR" ]]; then
    warn "nvm already installed — skipping nvm installation."
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    success "nvm installed."
  fi

  # Source nvm for use in this script session
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

  info "Installing latest LTS Node..."
  nvm install --lts
  nvm use --lts
  nvm alias default "lts/*"
  success "Node LTS installed: $(node --version)"
}

# ── Lua (already handled via system deps; ensure luarocks is usable) ──────────
check_lua() {
  section "Lua"
  if command -v lua &>/dev/null; then
    success "Lua found: $(lua -v 2>&1 | head -1)"
  else
    error "Lua not found after system deps installation."
  fi
}

# ── bob (nvim version manager) ────────────────────────────────────────────────
install_bob() {
  section "bob (Neovim version manager)"

  if command -v bob &>/dev/null; then
    warn "bob already installed — skipping."
  else
    cargo install bob-nvim
    success "bob installed."
  fi

  # Install and use the latest stable Neovim
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
  bob install stable
  bob use stable
  success "Neovim (stable) installed via bob."
}

# ── gh (GitHub CLI) ───────────────────────────────────────────────────────────
install_gh() {
  section "GitHub CLI (gh)"
  if command -v gh &>/dev/null; then
    warn "gh already installed — skipping."
    return
  fi

  case "$OS" in
    macos)
      brew install gh
      ;;
    debian)
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
        https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update -qq
      sudo apt-get install -y gh
      ;;
    fedora)
      sudo dnf install -y gh
      ;;
    arch)
      sudo pacman -Sy --noconfirm github-cli
      ;;
  esac
  success "gh installed."
}

# ── Dotfiles ──────────────────────────────────────────────────────────────────
setup_dotfiles() {
  section "Dotfiles (HikiJun97/dotfiles)"

  local DOTFILES_DIR="$HOME/.dotfiles"

  if [[ -d "$DOTFILES_DIR" ]]; then
    warn "Dotfiles repo already cloned — pulling latest..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Pull failed; using existing clone."
  else
    git clone https://github.com/HikiJun97/dotfiles.git "$DOTFILES_DIR"
    success "Dotfiles cloned."
  fi

  # .zshrc
  if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
    [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]] && \
      mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%s)" && \
      warn "Existing .zshrc backed up."
    cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    success ".zshrc placed in \$HOME."
  else
    warn ".zshrc not found in dotfiles repo."
  fi

  # .zsh_aliases
  if [[ -f "$DOTFILES_DIR/.zsh_aliases" ]]; then
    [[ -f "$HOME/.zsh_aliases" && ! -L "$HOME/.zsh_aliases" ]] && \
      mv "$HOME/.zsh_aliases" "$HOME/.zsh_aliases.bak.$(date +%s)" && \
      warn "Existing .zsh_aliases backed up."
    cp "$DOTFILES_DIR/.zsh_aliases" "$HOME/.zsh_aliases"
    success ".zsh_aliases placed in \$HOME."
  else
    warn ".zsh_aliases not found in dotfiles repo."
  fi

  # nvim config
  if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    mkdir -p "$HOME/.config"
    if [[ -d "$HOME/.config/nvim" ]]; then
      mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s)"
      warn "Existing nvim config backed up."
    fi
    cp -r "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    success "nvim config placed in \$HOME/.config/nvim."
  else
    warn "nvim directory not found in dotfiles repo."
  fi
}

# ── pynvim ────────────────────────────────────────────────────────────────────
install_pynvim() {
  section "pynvim (via uv)"
  export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
  uv tool install pynvim
  success "pynvim installed."
}

# ── Claude Code ───────────────────────────────────────────────────────────────
install_claude_code() {
  section "Claude Code"
  if command -v claude &>/dev/null; then
    warn "Claude Code already installed — skipping."
    return
  fi
  curl -fsSL https://claude.ai/install.sh | bash
  success "Claude Code installed."
}

# ── PATH reminder ─────────────────────────────────────────────────────────────
print_summary() {
  section "Setup Complete 🎉"
  echo -e "${BOLD}Make sure these are in your \$PATH (already added via dotfiles):${RESET}"
  echo "  \$HOME/.cargo/bin        — cargo, rustup, tree-sitter, bob"
  echo "  \$HOME/.local/share/bob/nvim-bin  — nvim"
  echo "  \$HOME/.local/bin        — uv, uvx, Claude Code"
  echo "  \$NVM_DIR/nvm.sh         — nvm (sourced in .zshrc)"
  echo ""
  echo -e "${BOLD}Next steps:${RESET}"
  echo "  1. Restart your shell:  exec zsh"
  echo "  2. Open Neovim once so lazy.nvim can bootstrap plugins:  nvim"
  echo "  3. Authenticate GitHub CLI:  gh auth login"
  echo ""
  success "All done!"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  detect_os
  install_system_deps
  install_oh_my_zsh
  install_zsh_plugins
  install_uv
  install_rust
  install_tree_sitter_cli
  install_nvm_node
  check_lua
  install_bob
  install_gh
  setup_dotfiles
  install_pynvim
  install_claude_code
  print_summary
}

main "$@"

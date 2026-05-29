#!/usr/bin/env bash
# =============================================================================
# Docker + NVIDIA Container Toolkit Setup Script
# Targets: Ubuntu/Debian, Fedora, Arch
# (macOS: Docker Desktop은 수동 설치 안내)
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

ask_yn() {
  # ask_yn "질문" → returns 0 (yes) or 1 (no)
  local prompt="$1"
  while true; do
    echo -en "${BOLD}${prompt} [y/n]: ${RESET}"
    read -r answer
    case "$answer" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo])     return 1 ;;
      *) warn "y 또는 n 으로 답해주세요." ;;
    esac
  done
}

# ── OS Detection ──────────────────────────────────────────────────────────────
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ -f /etc/debian_version ]]; then
    # Distinguish Ubuntu vs pure Debian for repo URLs
    if grep -qi ubuntu /etc/os-release 2>/dev/null; then
      OS="ubuntu"
    else
      OS="debian"
    fi
  elif [[ -f /etc/fedora-release ]]; then
    OS="fedora"
  elif [[ -f /etc/arch-release ]]; then
    OS="arch"
  else
    error "지원하지 않는 OS입니다. (macOS / Ubuntu / Debian / Fedora / Arch 지원)"
  fi
  info "감지된 OS: ${OS}"
}

# ── Docker ────────────────────────────────────────────────────────────────────
install_docker() {
  section "Docker"

  if command -v docker &>/dev/null; then
    warn "Docker가 이미 설치되어 있습니다 ($(docker --version)) — 건너뜁니다."
    return
  fi

  case "$OS" in
    macos)
      echo ""
      warn "macOS에서는 Docker Desktop을 수동으로 설치해야 합니다."
      info "  다운로드: https://www.docker.com/products/docker-desktop/"
      info "  또는 Homebrew: brew install --cask docker"
      echo ""
      return
      ;;

    ubuntu|debian)
      local DISTRO_ID
      DISTRO_ID="$(. /etc/os-release && echo "$ID")"          # ubuntu | debian
      local VERSION_CODENAME
      VERSION_CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

      info "Docker 공식 APT 저장소를 추가합니다..."

      # 기존 비공식 패키지 제거
      for pkg in docker.io docker-doc docker-compose docker-compose-v2 \
                 podman-docker containerd runc; do
        sudo apt-get remove -y "$pkg" 2>/dev/null || true
      done

      sudo apt-get update -qq
      sudo apt-get install -y ca-certificates curl gnupg

      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL "https://download.docker.com/linux/${DISTRO_ID}/gpg" \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/${DISTRO_ID} ${VERSION_CODENAME} stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update -qq
      sudo apt-get install -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
      ;;

    fedora)
      info "Docker 공식 DNF 저장소를 추가합니다..."
      sudo dnf remove -y docker docker-client docker-client-latest \
        docker-common docker-latest docker-latest-logrotate \
        docker-logrotate docker-selinux docker-engine-selinux \
        docker-engine 2>/dev/null || true

      sudo dnf install -y dnf-plugins-core
      sudo dnf config-manager --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo
      sudo dnf install -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
      ;;

    arch)
      info "Arch 공식 저장소에서 Docker를 설치합니다..."
      sudo pacman -Sy --noconfirm docker docker-compose
      ;;
  esac

  # ── 공통 후처리 (Linux) ──────────────────────────────────────────────────
  if [[ "$OS" != "macos" ]]; then
    # Docker 서비스 활성화 및 시작
    sudo systemctl enable --now docker
    success "Docker 서비스를 활성화했습니다."

    # 현재 사용자를 docker 그룹에 추가 (sudo 없이 사용 가능)
    if ! groups "$USER" | grep -q docker; then
      sudo usermod -aG docker "$USER"
      warn "사용자 '${USER}'를 docker 그룹에 추가했습니다."
      warn "그룹 변경을 적용하려면 로그아웃 후 재로그인하거나 'newgrp docker'를 실행하세요."
    else
      warn "사용자 '${USER}'는 이미 docker 그룹에 속해 있습니다."
    fi

    success "Docker 설치 완료: $(docker --version)"
  fi
}

# ── NVIDIA Container Toolkit ──────────────────────────────────────────────────
install_nvidia_container_toolkit() {
  section "NVIDIA Container Toolkit"

  # GPU 존재 여부 확인
  if ! command -v nvidia-smi &>/dev/null; then
    warn "'nvidia-smi'를 찾을 수 없습니다."
    warn "NVIDIA 드라이버가 설치되어 있지 않거나 GPU가 없는 환경일 수 있습니다."
    if ! ask_yn "그래도 nvidia-container-toolkit을 설치하시겠습니까?"; then
      info "nvidia-container-toolkit 설치를 건너뜁니다."
      return
    fi
  else
    info "NVIDIA GPU 감지됨: $(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)"
  fi

  if [[ "$OS" == "macos" ]]; then
    warn "macOS는 NVIDIA Container Toolkit을 지원하지 않습니다 — 건너뜁니다."
    return
  fi

  if dpkg -l nvidia-container-toolkit &>/dev/null 2>&1 || \
     rpm -q nvidia-container-toolkit &>/dev/null 2>&1 || \
     pacman -Q nvidia-container-toolkit &>/dev/null 2>&1; then
    warn "nvidia-container-toolkit이 이미 설치되어 있습니다 — 건너뜁니다."
    return
  fi

  case "$OS" in
    ubuntu|debian)
      info "NVIDIA Container Toolkit APT 저장소를 추가합니다..."
      curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
        | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

      curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
        | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
        | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

      sudo apt-get update -qq
      sudo apt-get install -y nvidia-container-toolkit
      ;;

    fedora)
      info "NVIDIA Container Toolkit DNF 저장소를 추가합니다..."
      curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
        | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo > /dev/null
      sudo dnf install -y nvidia-container-toolkit
      ;;

    arch)
      info "AUR에서 nvidia-container-toolkit을 설치합니다..."
      if command -v yay &>/dev/null; then
        yay -Sy --noconfirm nvidia-container-toolkit
      elif command -v paru &>/dev/null; then
        paru -Sy --noconfirm nvidia-container-toolkit
      else
        warn "AUR 헬퍼(yay/paru)를 찾을 수 없습니다. 수동으로 설치해야 합니다:"
        info "  https://github.com/NVIDIA/nvidia-container-toolkit"
        return
      fi
      ;;
  esac

  # Docker runtime 설정
  info "Docker에 NVIDIA runtime을 등록합니다..."
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
  success "NVIDIA Container Toolkit 설치 및 Docker runtime 등록 완료."

  # 동작 검증
  info "설치 검증 중 (nvidia-smi in container)..."
  if docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi &>/dev/null; then
    success "GPU 컨테이너 테스트 통과 ✓"
  else
    warn "GPU 컨테이너 테스트에 실패했습니다."
    warn "드라이버 버전과 CUDA 버전 호환성을 확인하세요."
  fi
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
  section "설치 완료 🎉"

  if command -v docker &>/dev/null; then
    success "Docker:                    $(docker --version)"
    success "Docker Compose:            $(docker compose version 2>/dev/null || echo 'N/A')"
  fi

  if command -v nvidia-ctk &>/dev/null; then
    success "NVIDIA Container Toolkit:  $(nvidia-ctk --version 2>&1 | head -1)"
  fi

  echo ""
  echo -e "${BOLD}다음 단계:${RESET}"
  echo "  • docker 그룹 반영:      newgrp docker  (또는 재로그인)"
  echo "  • Docker 동작 확인:      docker run --rm hello-world"
  if command -v nvidia-ctk &>/dev/null; then
    echo "  • GPU 컨테이너 확인:     docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi"
  fi
  echo ""
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  detect_os
  install_docker

  echo ""
  if ask_yn "NVIDIA Container Toolkit도 설치하시겠습니까?"; then
    install_nvidia_container_toolkit
  else
    info "NVIDIA Container Toolkit 설치를 건너뜁니다."
  fi

  print_summary
}

main "$@"

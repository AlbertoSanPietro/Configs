#!/usr/bin/env bash
set -eu

REPO_URL="https://github.com/AlbertoSanPietro/Configs.git"
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
PLUG_PATH="$DATA_HOME/nvim/site/autoload/plug.vim"

log() {
    printf '%s\n' "$*"
}

have() {
    command -v "$1" >/dev/null 2>&1
}

detect_escalator() {
    if [ "$(id -u)" -eq 0 ]; then
        ESCALATE=""
    elif have sudo; then
        ESCALATE="sudo"
    elif have doas; then
        ESCALATE="doas"
    else
        log "Error: need root privileges via sudo or doas."
        exit 1
    fi
}

run_root() {
    if [ -n "${ESCALATE:-}" ]; then
        "$ESCALATE" "$@"
    else
        "$@"
    fi
}

detect_pkg_manager() {
    for pm in apt-get dnf yum pacman zypper apk xbps-install emerge pkg brew nix-env; do
        if have "$pm"; then
            PKG_MANAGER="$pm"
            return 0
        fi
    done
    log "Error: unsupported package manager."
    exit 1
}

install_packages() {
    case "$PKG_MANAGER" in
        apt-get)
            run_root apt-get update
            run_root apt-get install -y \
                neovim git curl wget unzip tar gzip ca-certificates \
                nodejs npm python3 python3-pip python3-venv \
                openjdk-17-jre-headless openjdk-17-jdk \
                golang-go php-cli composer cargo ripgrep fd-find
            ;;
        dnf)
            run_root dnf install -y \
                neovim git curl wget unzip tar gzip ca-certificates \
                nodejs npm python3 python3-pip \
                java-17-openjdk java-17-openjdk-devel \
                golang php-cli composer cargo ripgrep fd-find
            ;;
        yum)
            run_root yum install -y epel-release || true
            run_root yum install -y \
                neovim git curl wget unzip tar gzip ca-certificates \
                nodejs npm python3 python3-pip \
                java-17-openjdk java-17-openjdk-devel \
                golang php-cli composer cargo ripgrep fd-find
            ;;
        pacman)
            run_root pacman -Sy --noconfirm \
                neovim git curl wget unzip tar gzip ca-certificates \
                nodejs npm python python-pip jdk17-openjdk \
                go php composer rust cargo ripgrep fd fd-find
            ;;
            pkg)
            run_root pkg install -y \
                neovim git curl wget unzip gtar gzip ca_root_nss \
                node npm python3 py311-pip \
                openjdk17 go php84 composer rust ripgrep fd-find
            ;;
        brew)
            brew update
            brew install \
                neovim git curl wget unzip gnu-tar gzip \
                node python openjdk@17 go php composer rust ripgrep fd
            ;;
               *)
            log "Error: package manager '$PKG_MANAGER' is not implemented."
            exit 1
            ;;
    esac
}

install_config() {
    mkdir -p "$(dirname "$NVIM_DIR")"

    if [ -d "$NVIM_DIR/.git" ]; then
        log "Updating existing Neovim config..."
        git -C "$NVIM_DIR" pull --ff-only
    elif [ -e "$NVIM_DIR" ]; then
        log "Error: $NVIM_DIR exists but is not a git repository."
        exit 1
    else
        log "Cloning Neovim config..."
        git clone "$REPO_URL" "$NVIM_DIR"
    fi
}

install_vim_plug() {
    if have curl; then
        mkdir -p "$(dirname "$PLUG_PATH")"
        curl -fsSL "$PLUG_URL" -o "$PLUG_PATH"
    elif have wget; then
        mkdir -p "$(dirname "$PLUG_PATH")"
        wget -qO "$PLUG_PATH" "$PLUG_URL"
    else
        log "Error: neither curl nor wget is installed."
        exit 1
    fi
}

install_plugins() {
    if have nvim; then
        nvim --headless +PlugInstall +qall || true
    else
        log "Warning: nvim not found in PATH, skipping plugin install."
    fi
}

post_install_notes() {
    cat <<'EOF'

Next steps:
1. Start Neovim once:
   nvim

2. Check Mason health inside Neovim:
   :checkhealth mason

3. Install your configured Mason packages:
   :MasonInstallAll

EOF
}

main() {
    detect_escalator
    detect_pkg_manager
    log "Using package manager: $PKG_MANAGER"
    install_packages
    install_config
    install_vim_plug
    install_plugins
    post_install_notes
}

main "$@"

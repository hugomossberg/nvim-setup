#!/usr/bin/env bash
set -euo pipefail

REPO="hugomossberg/nvim-setup"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

say() {
    printf '\n\033[1;35m%s\033[0m\n' "$1"
}

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo "sudo is missing. Run this script as root or install sudo."
        exit 1
    fi
fi

say "[1/7] Installing dependencies"

if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y \
        curl git ca-certificates tar gzip build-essential ripgrep
else
    echo "This installer currently supports Debian, Ubuntu and Pop!_OS."
    exit 1
fi

say "[2/7] Installing latest Neovim"

ARCH="$(uname -m)"

case "$ARCH" in
    x86_64|amd64)
        NVIM_ASSET="nvim-linux-x86_64.tar.gz"
        NVIM_DIR="nvim-linux-x86_64"
        ;;
    aarch64|arm64)
        NVIM_ASSET="nvim-linux-arm64.tar.gz"
        NVIM_DIR="nvim-linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

curl -fL \
    "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ASSET}" \
    -o "${TMPDIR}/${NVIM_ASSET}"

$SUDO rm -rf "/opt/${NVIM_DIR}"
$SUDO tar -C /opt -xzf "${TMPDIR}/${NVIM_ASSET}"

# Makes nvim, vi and vim launch Neovim.
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/nvim
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/vi
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/vim

say "[3/7] Installing Neovim configuration"

CONFIG_DIR="${HOME}/.config/nvim"
mkdir -p "$CONFIG_DIR"

if [ -f "${CONFIG_DIR}/init.lua" ]; then
    BACKUP="${CONFIG_DIR}/init.lua.backup.$(date +%Y%m%d-%H%M%S)"
    cp "${CONFIG_DIR}/init.lua" "$BACKUP"
    echo "Backup: $BACKUP"
fi

curl -fsSL "${RAW_BASE}/init.lua" -o "${CONFIG_DIR}/init.lua"

say "[4/7] Installing plugins"

nvim --headless "+Lazy! sync" +qa || {
    echo "Lazy sync failed. Start 'vi' once to see the details."
    exit 1
}

say "[5/7] Installing common Treesitter parsers"

nvim --headless \
    "+TSInstallSync python bash lua json yaml markdown" \
    +qa >/dev/null 2>&1 || true

say "[6/7] Mapping Caps Lock to Escape"

# GNOME/Pop!_OS desktop sessions. On headless servers this is skipped safely.
if command -v gsettings >/dev/null 2>&1; then
    if gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" >/dev/null 2>&1; then
        echo "Caps Lock now acts as Escape."
    else
        echo "Could not change Caps Lock in this session; skipping keyboard remap."
    fi
else
    echo "No desktop gsettings found; skipping keyboard remap."
fi

say "[7/7] Done"

printf '\nNeovim: '
nvim --version | head -1

cat <<'EOF'

Available commands:
  vi file.py
  vim file.py
  nvim file.py

Shortcuts:
  Caps Lock   Escape / return to Normal mode
  Space f f   find files
  Space f g   search text
  Space f b   buffers

Note: terminal opacity is controlled by your terminal emulator.
EOF

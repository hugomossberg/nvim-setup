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
        echo "sudo saknas. Kör scriptet som root eller installera sudo."
        exit 1
    fi
fi

say "[1/6] Installerar beroenden"

if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y \
        curl git ca-certificates tar gzip build-essential ripgrep
else
    echo "Det här installationsscriptet stöder just nu Debian/Ubuntu/Pop!_OS."
    exit 1
fi

say "[2/6] Installerar senaste Neovim"

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
        echo "Arkitektur stöds inte automatiskt: $ARCH"
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

# Makes nvim, vi and vim work immediately.
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/nvim
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/vi
$SUDO ln -sf "/opt/${NVIM_DIR}/bin/nvim" /usr/local/bin/vim

say "[3/6] Installerar Neovim-konfiguration"

CONFIG_DIR="${HOME}/.config/nvim"
mkdir -p "$CONFIG_DIR"

if [ -f "${CONFIG_DIR}/init.lua" ]; then
    BACKUP="${CONFIG_DIR}/init.lua.backup.$(date +%Y%m%d-%H%M%S)"
    cp "${CONFIG_DIR}/init.lua" "$BACKUP"
    echo "Backup: $BACKUP"
fi

curl -fsSL "${RAW_BASE}/init.lua" -o "${CONFIG_DIR}/init.lua"

say "[4/6] Installerar plugins"

nvim --headless "+Lazy! sync" +qa || {
    echo "Lazy sync gav ett fel. Starta 'vi' en gång för att se detaljer."
    exit 1
}

say "[5/6] Försöker installera vanliga Treesitter-parsers"

nvim --headless \
    "+TSInstallSync python bash lua json yaml markdown" \
    +qa >/dev/null 2>&1 || true

say "[6/6] Klart"

printf '\nNeovim: '
nvim --version | head -1

cat <<'EOF'

Nu fungerar:
  vi fil.py
  vim fil.py
  nvim fil.py

Shortcuts:
  Space f f   hitta filer
  Space f g   sök text
  Space f b   buffers

Obs: transparensen styrs av terminalens opacity.
EOF

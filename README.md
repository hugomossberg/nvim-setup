# nvim-setup

Portable Neovim setup with Cyberdream.

## Install on Debian / Ubuntu / Pop!_OS

```bash
curl -fsSL https://raw.githubusercontent.com/hugomossberg/nvim-setup/main/install.sh | bash
```

The script:

- installs required dependencies
- detects x86_64 or arm64
- installs the latest Neovim under `/opt`
- makes `vi`, `vim`, and `nvim` launch Neovim
- installs `~/.config/nvim/init.lua`
- bootstraps `lazy.nvim`
- installs plugins
- attempts to install common Treesitter parsers

## Plugins

- Cyberdream
- Lualine
- Treesitter
- fzf-lua
- Gitsigns
- nvim-web-devicons

## Shortcuts

- `jk` — leave Insert mode and return to Normal mode
- `Space f f` — find files
- `Space f g` — search text
- `Space f b` — open buffers

## Transparency

The Neovim config uses a transparent background. The actual opacity level is controlled by the terminal emulator on the machine where the terminal is displayed.

## Important

Never put API keys, passwords, tokens, or private SSH keys in this repository.

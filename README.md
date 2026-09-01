# nvim-setup

Min portabla Neovim-setup med Cyberdream.

## Installera på Debian / Ubuntu / Pop!_OS

```bash
curl -fsSL https://raw.githubusercontent.com/hugomossberg/nvim-setup/main/install.sh | bash
```

Scriptet:

- installerar beroenden
- identifierar x86_64 eller arm64
- installerar senaste Neovim under `/opt`
- gör `vi`, `vim` och `nvim` till Neovim
- installerar `~/.config/nvim/init.lua`
- bootstrappar `lazy.nvim`
- installerar plugins
- försöker installera vanliga Treesitter-parsers

## Plugins

- Cyberdream
- Lualine
- Treesitter
- fzf-lua
- Gitsigns
- nvim-web-devicons

## Shortcuts

- `Space f f` — hitta filer
- `Space f g` — sök text
- `Space f b` — öppna buffers

## Transparens

Neovim-configen använder transparent bakgrund. Själva graden av transparens styrs av terminalprogrammet på datorn där terminalen visas.

## Viktigt

Lägg aldrig API-nycklar, lösenord, tokens eller privata SSH-nycklar i detta repo.

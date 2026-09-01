vim.g.mapleader = " "

-- Editor
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 6
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorline = false
vim.opt.fillchars = { eob = " " }

-- Bootstrap lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                variant = "default",
                transparent = true,
                italic_comments = true,
                saturation = 1,
                hide_fillchars = true,
                borderless_pickers = true,
            })
            vim.cmd("colorscheme cyberdream")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                        },
                    },
                    lualine_x = { "diagnostics", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end,
    },
})

-- Shortcuts
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Search text" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Buffers" })

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

require("config.diagnostics")
require("config.clipboard-osc52")

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

vim.o.list = true
vim.o.listchars = "eol:⏎,tab:␉·,trail:␠,nbsp:⎵"

-- Scroll when cursor is <line +/- X> above or below
vim.o.scrolloff = 6

-- Temporary fix for https://github.com/wez/wezterm/issues/4607
-- Arch still tracks the 20240203 release
vim.o.termsync = false

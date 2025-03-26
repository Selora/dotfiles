-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*evcontainer.json",
  callback = function()
    vim.bo.filetype = "jsonc"
    vim.o.ft = "jsonc"
  end,
})

-- Word motions work with underscore, when filetype is python
-- NOTE:: Changing vim.opt is too messy
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "python",
--   callback = function()
--     vim.opt.iskeyword:append("-")
--   end,
-- })

-- Force refresh, using devpod ssh agent...
-- local last_refresh = 0
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "BufEnter" }, {
--   callback = function()
--     local now = vim.loop.now()
--     if now - last_refresh > 80 then -- Avoid triggering too often
--       last_refresh = now
--       vim.cmd("mode") -- Forces full screen repaint
--     end
--   end,
-- })

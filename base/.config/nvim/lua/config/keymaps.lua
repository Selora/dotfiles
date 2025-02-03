-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- stylua: ignore start
vim.keymap.set("n", "<leader>dU", function() require("dapui").toggle({ reset = true }) end, { desc = "Toggle-Reset UI" })

vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step Out" })
-- stylua: ignore end

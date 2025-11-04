-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- stylua: ignore start
-- Debug mode
-- vim.keymap.set("n", "<leader>dU", function() require("dapui").toggle({ reset = true }) end, { desc = "Toggle-Reset UI" })
-- vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
-- vim.keymap.set("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step Out" })

local dap = require("dap")

dap.listeners.after.event_initialized["custom_keymaps"] = function(session)
  local buf = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "<leader>do", dap.step_over, { buffer = buf, desc = "Step Over" })
  vim.keymap.set("n", "<leader>dO", dap.step_out, { buffer = buf, desc = "Step Out" })
  vim.keymap.set("n", "<leader>dU", function() require("dapui").toggle({ reset = true }) end, { buffer = buf, desc = "Toggle-Reset UI" })
end

--
-- Map <leader>df to float the scopes window
local function toggle_float_dapui_panel()
  local ft = vim.bo.filetype
  if not ft:match("^dapui_") then
    print("Not in a dap-ui panel!")
    return
  end

  local win_config = vim.api.nvim_win_get_config(0)
  if win_config.relative and win_config.relative ~= "" then
    -- The current window is floating, so close it.
    vim.api.nvim_win_close(0, true)
  else
    -- The window isn't floating; extract the element name from the filetype and float it.
    local element = ft:gsub("^dapui_", "")
    require("dapui").float_element(element, { enter = true })
  end
end
vim.keymap.set("n", "<leader>df", toggle_float_dapui_panel, { desc = "Toggle float for current dap-ui panel" })





-- Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {desc = "Terminal: Quit input mode"} )

-- Toggle auto-reload with <leader>uR (off by default)
-- Toggle auto-reload with <leader>uR (off by default)
local enabled = false
local group = nil
local key = "<leader>uR"
local icon_on, icon_off = "", ""  -- Nerd Font toggle icons

local function update_desc()
  -- Refresh mapping description so which-key shows correct icon
  vim.keymap.set("n", key, toggle, {
    desc = string.format("%s Auto-reload", enabled and icon_on or icon_off),
    silent = true,
  })
end

function _G.toggle()
  enabled = not enabled
  if enabled then
    vim.o.autoread = true
    vim.o.confirm = true
    group = vim.api.nvim_create_augroup("UserAutoReload", { clear = true })
    vim.api.nvim_create_autocmd(
      { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
      { group = group, command = "silent! checktime" }
    )
    vim.api.nvim_create_autocmd("FileChangedShellPost", {
      group = group,
      callback = function()
        vim.notify("File changed on disk → reloaded", vim.log.levels.INFO)
      end,
    })
    vim.notify("Auto-reload enabled", vim.log.levels.INFO)
  else
    vim.o.autoread = false
    if group then
      pcall(vim.api.nvim_del_augroup_by_id, group)
      group = nil
    end
    vim.notify("Auto-reload disabled", vim.log.levels.INFO)
  end
  update_desc()
end

-- initial keymap (off by default)
update_desc()

-- stylua: ignore end

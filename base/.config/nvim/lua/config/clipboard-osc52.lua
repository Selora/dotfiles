-- Setup OSC52 clipboard for copy/pasting through ssh.

vim.opt.clipboard = nil

function unnamed_paste(reg)
  return function(lines)
    local content = vim.fn.getreg('"')
    return vim.split(content, "\n")
  end
end

vim.g.clipboard = {
  name = "dummy clipboard",
  copy = {
    ["+"] = function(lines) end,
    ["*"] = function(lines) end,
  },
  paste = {
    ["+"] = unnamed_paste("+"),
    ["*"] = unnamed_paste("*"),
  },
}

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
    copy_to_unnamed(vim.v.event.regcontents)
  end,
})

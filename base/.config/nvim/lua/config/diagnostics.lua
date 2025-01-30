-- Inspect diagnostics:
-- :lua print(vim.inspect(vim.diagnostic.get(0)))

vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      if diagnostic.message:match("MD013") then
        print("HERE")
        return nil -- Hides the message
      end
      return diagnostic.message
    end,
  },
  severity_sort = true,
})

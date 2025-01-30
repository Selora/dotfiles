return {
  {
    "folke/trouble.nvim",
    opts = {
      -- Filter out MD013
      filter = function(diagnostic)
        return not diagnostic.message:match("MD013")
      end,
    },
  },
}

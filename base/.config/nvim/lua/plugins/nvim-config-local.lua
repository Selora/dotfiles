return {
  {
    "klen/nvim-config-local",
    -- Load early enough to catch startup + directory changes, but still lazy-loaded.
    event = { "VimEnter", "DirChanged" },
    cmd = {
      "ConfigLocalSource",
      "ConfigLocalEdit",
      "ConfigLocalTrust",
      "ConfigLocalDeny",
    },
    opts = {
      -- Config file patterns to load (lua supported)
      config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

      -- Where the plugin keeps files data
      hashfile = vim.fn.stdpath("data") .. "/config-local",

      autocommands_create = true, -- VimEnter, DirectoryChanged
      commands_create = true, -- ConfigLocal* commands
      silent = false, -- show loaded/denied messages
      lookup_parents = true, -- don't walk upward
    },
    config = function(_, opts)
      require("config-local").setup(opts)
    end,
  },
}

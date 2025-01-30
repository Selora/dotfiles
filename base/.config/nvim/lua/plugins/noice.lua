return {
  {
    "folke/noice.nvim",
    opts = {
      -- Classic command prompt at the bottom
      cmdline = {
        view = "cmdline",
      },
      presets = {
        bottom_search = true, -- Search prompt at the bottom
        command_palette = false, -- Popup menu doesn't appear in the middle of the screen (set true if removing classic cmdline display)
        long_message_to_split = true, -- Long message line breaking
      },
    },
  },
}

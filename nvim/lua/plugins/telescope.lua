-- <leader>ff in keymaps.lua calls telescope directly. lazyvim's own pickers
-- stay on snacks: this is plain telescope, not the lazyvim telescope extra.
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
}

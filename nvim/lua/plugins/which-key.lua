-- release <leader>? from which-key's buffer-keymaps popup so keymaps.lua can
-- claim it for the notes float. lazy.nvim registers plugin `keys` after
-- config/keymaps.lua runs, so a plain vim.keymap.set there would lose.
-- <leader>sk still searches keymaps.
return {
  "folke/which-key.nvim",
  keys = {
    { "<leader>?", false },
  },
}

-- discord rich presence. <leader>cp toggles presence, <leader>ci forces idle
-- (keymaps.lua). build fetches cord's prebuilt server binary.
return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy",
  opts = {},
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
            -- preview renders into the main editor window (fullscreen-ish)
            preview = "main",
            -- ...but start closed, so `P` toggles it instead of it opening
            -- automatically with the tree. Also keeps the main-mode preview
            -- float out of the layout's drag-resize math, which otherwise
            -- blows the sidebar up to full width (its opts.width is 0).
            hidden = { "preview" },
          },
        },
      },
    },
  },
}

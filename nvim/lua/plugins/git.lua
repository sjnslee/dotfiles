-- magit-style git UI + a real diff viewer. LazyVim already binds <leader>gg to
-- lazygit, which stays -- these sit beside it for the things lazygit is clumsy
-- at: staging individual hunks by hand, and reading a diff with syntax highlight.
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gN", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
    },
    opts = {
      -- lazygit already covers "just show me everything"; this one is for
      -- deliberate staging, so keep the buffer in a full tab, not a popup
      kind = "tab",
      graph_style = "unicode",
      -- diffview owns diff rendering; neogit's built-in one is line-based only
      integrations = { diffview = true },
      signs = {
        section = { "", "" },
        item = { "", "" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      -- history lives under gv, not gh: LazyVim gives <leader>gh to gitsigns' hunk group
      { "<leader>gv", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (this file)" },
      { "<leader>gV", "<cmd>DiffviewFileHistory<cr>", desc = "File history (branch)" },
      { "<leader>gv", "<esc><cmd>'<,'>DiffviewFileHistory<cr>", desc = "File history (selection)", mode = "v" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- default is a vertical split per side; merge conflicts want all three
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { width = 30 },
      },
    },
  },
}

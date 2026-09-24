-- gnu octave (.m, detected as filetype matlab).
--
-- vim-slime sends `%%` sections to an octave repl in the tmux pane to the
-- right of nvim, so variables stay alive between sends. start one with
-- `octave --no-gui` in that pane first. <C-c>v retargets if the layout differs.
--
-- no lsp: matlab-language-server needs a real matlab install.

return {
  {
    "jpalardy/vim-slime",
    ft = "matlab",
    init = function()
      -- slime reads these at load time, so they must be set before it loads
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{right-of}" }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_cell_delimiter = "^%%"
    end,
    keys = {
      { "<leader>rc", "<Plug>SlimeSendCell", ft = "matlab", desc = "send cell to octave" },
      { "<leader>rl", "<Plug>SlimeLineSend", ft = "matlab", desc = "send line to octave" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "matlab" } },
  },
}

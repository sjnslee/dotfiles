-- html, css and emmet have no lazyvim extra, so the servers are wired up here.
-- typescript, tailwind, json, prettier and mini.surround come from extras and
-- live in lazyvim.json instead.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        -- emmet expands `div.card>ul>li*3` from the completion menu. it is a
        -- second server on the same buffers, not a replacement for html-lsp,
        -- and its stock filetype list omits the jsx/vue/svelte ones.
        emmet_language_server = {
          filetypes = {
            "css",
            "html",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "svelte",
            "typescriptreact",
            "vue",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "scss" } },
  },
}

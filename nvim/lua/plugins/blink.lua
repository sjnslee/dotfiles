return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "none",

        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },

        ["<CR>"] = {
          "accept",
          "fallback",
        },

        ["<C-space>"] = {
          "show",
          "show_documentation",
          "hide_documentation",
        },

        -- hide returns true when the menu is open, which would swallow the
        -- keypress; wrapping it discards that so <Esc> always leaves insert
        ["<Esc>"] = {
          function(cmp)
            cmp.hide()
          end,
          "fallback",
        },

        ["<C-e>"] = {
          "hide",
          "fallback",
        },

        ["<Up>"] = {
          "select_prev",
          "fallback",
        },

        ["<Down>"] = {
          "select_next",
          "fallback",
        },
      }

      opts.completion = opts.completion or {}
      opts.completion.list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      }

      return opts
    end,
  },
}

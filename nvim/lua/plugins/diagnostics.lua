-- two diagnostic profiles, minimal by default. full is stock lazyvim.
-- <leader>uq flips between them.
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local severity = vim.diagnostic.severity

      -- servers mark unused locals and deprecated calls with a tag rather than
      -- a lower severity, so jdtls' "the value of the local variable x is not
      -- used" arrives as an ordinary warning. filter on the tag, not severity.
      local function without_noise(diagnostic)
        local tags = diagnostic._tags
        if tags and (tags.unnecessary or tags.deprecated) then
          return nil
        end
        return diagnostic.message
      end

      local full = vim.deepcopy(opts.diagnostics)
      local minimal = vim.tbl_deep_extend("force", vim.deepcopy(full), {
        virtual_text = { severity = { min = severity.WARN }, format = without_noise },
        underline = { severity = { min = severity.WARN } },
        signs = { severity = { min = severity.WARN } },
      })

      opts.diagnostics = minimal

      LazyVim.on_very_lazy(function()
        Snacks.toggle({
          name = "Full Diagnostics",
          get = function()
            return vim.g.diagnostics_full == true
          end,
          set = function(state)
            vim.g.diagnostics_full = state
            vim.diagnostic.config(vim.deepcopy(state and full or minimal))
          end,
        }):map("<leader>uq")
      end)

      return opts
    end,
  },
}

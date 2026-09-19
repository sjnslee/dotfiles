-- two diagnostic profiles, minimal by default. full is stock lazyvim.
-- <leader>uq flips between them.

-- servers mark unused locals and deprecated calls with a tag rather than a
-- lower severity: jdtls sends "the value of the local variable x is not used"
-- as an ordinary warning, eslint can send an unused import as an error. a
-- severity option can't tell that noise from a real problem, and only reaches
-- the one handler it's set on, so the gutter sign outlives it. filter on the
-- tag instead, in every handler. module scope: wrapping once, at spec import.
for _, name in ipairs({ "virtual_text", "underline", "signs" }) do
  local handler = vim.diagnostic.handlers[name]
  local show = handler.show
  handler.show = function(ns, bufnr, diagnostics, opts)
    if not vim.g.diagnostics_full then
      diagnostics = vim.tbl_filter(function(d)
        return not (d._tags and (d._tags.unnecessary or d._tags.deprecated))
      end, diagnostics)
    end
    show(ns, bufnr, diagnostics, opts)
  end
end

-- LazyVim.opts("nvim-lspconfig") re-runs the opts function below on every
-- format, so capture the stock profile on the first pass only -- reading it
-- back from opts.diagnostics later just returns the minimal one we installed.
local full

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local severity = vim.diagnostic.severity

      full = full or vim.deepcopy(opts.diagnostics)
      local minimal = vim.tbl_deep_extend("force", vim.deepcopy(full), {
        virtual_text = { severity = { min = severity.ERROR } },
        underline = { severity = { min = severity.ERROR } },
        signs = { severity = { min = severity.ERROR } },
      })

      opts.diagnostics = minimal

      local function map_toggle()
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
      end

      -- on_very_lazy drops the map on the floor when lspconfig loads *after*
      -- VeryLazy has fired -- every session that starts on the dashboard and
      -- opens a file afterwards. snacks is up long before then; only fall back
      -- to the autocmd if it somehow isn't.
      if rawget(_G, "Snacks") then
        map_toggle()
      else
        LazyVim.on_very_lazy(map_toggle)
      end

      return opts
    end,
  },
}

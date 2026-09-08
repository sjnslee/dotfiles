-- jdtls fires "Validate documents"/"Publish Diagnostics" progress on every
-- buffer change, so noice flashes it in the corner on each keystroke. skip
-- those two, keep the slow ones (import, build) worth watching.
return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local progress = message.opts.progress or {}
          local title = progress.title or ""
          return progress.client == "jdtls"
            and (title:find("Validate") ~= nil or title:find("Publish") ~= nil)
        end,
      },
      opts = { skip = true },
    })
  end,
}

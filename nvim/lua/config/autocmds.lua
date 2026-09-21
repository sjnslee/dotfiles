-- ============================================================
-- Guard: snacks sidebar explodes to full width on drag-resize
-- while a `preview = "main"` preview is open.
-- ============================================================
vim.api.nvim_create_autocmd("WinResized", {
  group = vim.api.nvim_create_augroup("snacks_layout_resize_guard", { clear = true }),
  callback = function()
    local ok, Snacks = pcall(require, "snacks")
    if not ok or not Snacks.picker then
      return
    end
    for _, picker in ipairs(Snacks.picker.get()) do
      local layout = rawget(picker, "layout")
      -- only when a float the layout refuses to size is actually open
      if layout and not layout.closed then
        for _, win in pairs(layout.wins or {}) do
          if win.layout == false and win:win_valid() then
            layout.screenpos = nil
            break
          end
        end
      end
    end
  end,
})

-- ============================================================
-- allows using `:q` to quit nvim if only remaining window is an explorer
-- ============================================================
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("quit_with_explorer", { clear = true }),
  callback = function()
    if #vim.api.nvim_list_tabpages() > 1 then
      return
    end
    vim.schedule(function()
      local explorer_open = false
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
          if vim.w[win].snacks_layout then
            explorer_open = true
          else
            return
          end
        end
      end
      if explorer_open then
        vim.cmd.quitall()
      end
    end)
  end,
})

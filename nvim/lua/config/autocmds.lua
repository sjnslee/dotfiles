-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ============================================================
-- Guard: snacks sidebar explodes to full width on drag-resize
-- while a `preview = "main"` preview is open.
--
-- snacks/layout.lua:104-109 sets `win.layout = false` for any
-- `relative = "win"` float, which excludes it from the layout's
-- box sizing -- so its `opts.width`/`opts.height` stay at the 0
-- sentinel ("fill parent") while the real window is full size.
-- The WinResized handler (layout.lua:140-150) does NOT skip those
-- windows: it computes `width_diff = actual - opts.width`, i.e.
-- `159 - 0`, and then does
-- `nvim_win_set_width(root, root_width + 159)`.
-- The 40-col sidebar takes the whole screen.
--
-- Just above that loop (layout.lua:132-135) there is a clean path:
-- if the root's screenpos changed, snacks does a full `self:update()`
-- and returns, never reaching the buggy arithmetic. We register first
-- (VeryLazy, before any picker layout exists) and invalidate
-- `screenpos`, which forces that path.
--
-- Deliberately does NOT touch opts.width/height: those are the float's
-- real sizing inputs, so overwriting them makes the preview render at a
-- stale size and flicker as it is corrected.
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

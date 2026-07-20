return {
  "karb94/neoscroll.nvim",
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },

    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    easing = "sine",
    pre_hook = nil,
    post_hook = nil,
    performance_mode = false,
    ignored_events = {
      "WinScrolled",
      "CursorMoved",
    },

    -- Increase for smoother/slower scrolling
    duration_multiplier = 1.8,
  },
}

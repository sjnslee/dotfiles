return {
  {
    "sphamba/smear-cursor.nvim",
    -- redraw heavy animation lags over ssh, worst through windows conpty
    cond = vim.env.SSH_CONNECTION == nil,
    opts = {
      stiffness = 0.7,
      trailing_stiffness = 0.4,
      distance_stop_animating = 0.5,
      hide_target_hack = false,
      cursor_color = "none",
    },
  },
}

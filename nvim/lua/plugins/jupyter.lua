-- jupyter notebooks.
--
-- jupytext rewrites a .ipynb into a `# %%`-delimited python buffer on read and
-- back into json on write, so lsp, treesitter, formatting and <leader>rr keep
-- working on notebooks. molten runs the cells against a real jupyter kernel and
-- draws the results -- plots included -- as virtual lines under the cell.
--
-- needs, outside this file:
--   * vim.g.python3_host_prog -> a venv with pynvim + jupyter_client (options.lua)
--   * the `jupytext` cli on PATH
--   * a terminal speaking the kitty graphics protocol (ghostty, kitty), and
--     `allow-passthrough on` when running under tmux
--   * per project: ipykernel installed in the venv you want to run against

-- the `# %%` block the cursor sits in, as a 1-indexed inclusive line range.
-- the marker line itself is not code, so it is dropped from the range.
local function cell_bounds()
  local last = vim.api.nvim_buf_line_count(0)
  local cursor = vim.api.nvim_win_get_cursor(0)[1]

  local function is_marker(n)
    local line = vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
    return line ~= nil and line:match("^%s*#%s*%%%%") ~= nil
  end

  local top = cursor
  while top > 1 and not is_marker(top) do
    top = top - 1
  end
  local bottom = cursor
  while bottom < last and not is_marker(bottom + 1) do
    bottom = bottom + 1
  end
  if is_marker(top) then
    top = math.min(top + 1, bottom)
  end
  return top, bottom
end

local function run_cell()
  vim.fn.MoltenEvaluateRange(cell_bounds())
end

return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      -- percent, not hydrogen: hydrogen leaves `%magic` lines uncommented,
      -- which makes the buffer invalid python and lights up pyright
      style = "percent",
      output_extension = "auto",
    },
    config = function(_, opts)
      -- jupytext.nvim reads metadata.kernelspec unguarded. notebooks written by
      -- nbformat, by jupytext without --set-kernel, or stripped by nbstripout
      -- carry no kernelspec, and opening one throws out of BufReadCmd and drops
      -- you into the raw json. assume python in that case.
      local utils = require("jupytext.utils")
      local read_metadata = utils.get_ipynb_metadata
      utils.get_ipynb_metadata = function(filename)
        local ok, metadata = pcall(read_metadata, filename)
        if ok and metadata.extension then
          return metadata
        end
        return { language = "python", extension = "py" }
      end

      require("jupytext").setup(opts)
    end,
  },

  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    dependencies = { "folke/snacks.nvim" },
    init = function()
      vim.g.molten_image_provider = "snacks.nvim"
      -- output as virtual lines under the cell rather than a float, so the
      -- buffer keeps reading top to bottom like a notebook
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 24
      vim.g.molten_output_show_exec_time = true
    end,
    keys = {
      { "<leader>m", "", desc = "+molten" },
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "init kernel" },
      { "<leader>mI", "<cmd>MoltenDeinit<cr>", desc = "stop kernel" },
      { "<leader>mR", "<cmd>MoltenRestart!<cr>", desc = "restart kernel" },
      { "<leader>mc", run_cell, desc = "run cell" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "run line" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "run selection" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "rerun cell" },
      { "<leader>ma", "<cmd>MoltenReevaluateAll<cr>", desc = "rerun all" },
      { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "interrupt" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "show output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "hide output" },
      { "<leader>me", "<cmd>MoltenEnterOutput<cr>", desc = "enter output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "delete cell" },
      { "<leader>mn", "<cmd>MoltenNext<cr>", desc = "next cell" },
      { "<leader>mp", "<cmd>MoltenPrev<cr>", desc = "prev cell" },
      { "<leader>ms", "<cmd>MoltenExportOutput!<cr>", desc = "save outputs into .ipynb" },
    },
  },
}

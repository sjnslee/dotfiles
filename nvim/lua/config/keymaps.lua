-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--

local opts = { noremap = true, silent = true }

-- ENTER NETRW
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- MOVE BLOCKS OF TEXT IN VISUAL MODE
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- SOURCE FILE
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- SEARCH AND REPLACE ALL INSTANCES OF WORD UNDER CURSOR
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- DISABLE ARROW KEYS IN NORMAL
-- vim.keymap.set("n", "<Up>", "<Nop>")
-- vim.keymap.set("n", "<Down>", "<Nop>")
-- vim.keymap.set("n", "<Left>", "<Nop>")
-- vim.keymap.set("n", "<Right>", "<Nop>")

-- DISABLE ARROW KEYS IN INSERT
-- vim.keymap.set("i", "<Up>", "<Nop>")
-- vim.keymap.set("i", "<Down>", "<Nop>")
-- vim.keymap.set("i", "<Left>", "<Nop>")
-- vim.keymap.set("i", "<Right>", "<Nop>")

-- GAME OF LIFE AND RAIN ANIMATION --
vim.keymap.set("n", "<leader>lr", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>ll", "<cmd>CellularAutomaton game_of_life<CR>")

-- COMPETITEST --
vim.keymap.set("n", "<leader>tt", ":CompetiTest add_testcase<CR>")

-- CORD --
vim.keymap.set("n", "<leader>cp", function()
  require("cord.api.command").toggle_presence()
end)
vim.keymap.set("n", "<leader>ci", function()
  require("cord.api.command").toggle_idle_force()
end)

-- NEOGEN for javadocs --
vim.keymap.set("n", "<Leader>dd", ":lua require('neogen').generate()<CR>", opts)

-- TELESCOPE --
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, {})

-- VIRTUAL TEXT TOGGLE --
vim.keymap.set("", "<leader>vt", ":VirtualTextToggle<CR>", { noremap = true, silent = true })

-- WHICH KEYS --
local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add({
    { "<leader>f", group = "file" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
    { "<leader>w", proxy = "<c-w>", group = "windows" },
    {
      "<leader>b",
      group = "buffers",
      expand = function()
        return require("which-key.extras").expand.buf()
      end,
    },
    {
      mode = { "n", "v" },
      { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
      { "<leader>w", "<cmd>w<cr>", desc = "Write" },
    },
  })
end

-- tabs --
vim.keymap.set("n", "<leader>1", function()
  require("bufferline").go_to(1, true)
end, opts)
vim.keymap.set("n", "<leader>2", function()
  require("bufferline").go_to(2, true)
end, opts)
vim.keymap.set("n", "<leader>3", function()
  require("bufferline").go_to(3, true)
end, opts)
vim.keymap.set("n", "<leader>4", function()
  require("bufferline").go_to(4, true)
end, opts)
vim.keymap.set("n", "<leader>5", function()
  require("bufferline").go_to(5, true)
end, opts)
vim.keymap.set("n", "<leader>6", function()
  require("bufferline").go_to(6, true)
end, opts)
vim.keymap.set("n", "<leader>7", function()
  require("bufferline").go_to(7, true)
end, opts)
vim.keymap.set("n", "<leader>8", function()
  require("bufferline").go_to(8, true)
end, opts)
vim.keymap.set("n", "<leader>9", function()
  require("bufferline").go_to(9, true)
end, opts)
vim.keymap.set("n", "<leader>0", function()
  require("bufferline").go_to(-1, true)
end, opts)

-- Navigate through buffers in order
vim.keymap.set("n", "<leader>.", ":BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<leader>,", ":BufferLineCyclePrev<CR>", opts)

-- Close current buffer
vim.keymap.set("n", "<leader>ww", ":bd<CR>", opts)

-- duplicate line + comment first line
vim.keymap.set("n", "ycc", "yygccp", { remap = true })

-- search within visual area only
vim.keymap.set("x", "/", "<Esc>/\\%V")

-- keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z:delmarks z<cr>")

-- enable copy and past from system clipboard
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- Function to prompt for find/replace in visual mode
local function ReplaceInVisualSelection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local range = string.format(":%d,%ds/", s_start[2], s_end[2])
  local find = vim.fn.input("f ")
  if find == "" then
    return
  end
  local replace = vim.fn.input("r ")
  local cmd = range .. vim.fn.escape(find, "/") .. "/" .. vim.fn.escape(replace, "/") .. "/g"
  vim.cmd(cmd)
end

-- Remap to search and replace within visual selection
vim.keymap.set("v", "<leader>r", ReplaceInVisualSelection, { noremap = true, silent = true })

-- TOGGLE COLORSCHEME --
local _themes = { "kanagawa-dragon", "seoul256-light" }
local _theme_idx = 1
vim.keymap.set("n", "<leader>cs", function()
  _theme_idx = (_theme_idx % #_themes) + 1
  vim.cmd.colorscheme(_themes[_theme_idx])
end, { desc = "Toggle colorscheme" })

-- call :Hypersonic: explain regex
vim.keymap.set("v", "<leader>rg", ":Hypersonic<CR>")

-- ============================================================
-- ONE-KEY RUN  (F5 or <leader>rr) — runs the current file in a
-- bottom terminal split. Python uses the project's .venv if
-- present. Cross-platform: identical on macOS and Windows nvim.
-- ============================================================
local _run_buf = nil

local function _find_root(markers, from)
  local hit = vim.fs.find(markers, { upward = true, path = from })[1]
  return hit and vim.fn.fnamemodify(hit, ":h") or vim.fn.fnamemodify(from, ":h")
end

local function _run_current_file()
  vim.cmd("silent! write")
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  local is_win = vim.fn.has("win32") == 1
  local cmd

  if ft == "python" then
    local root = _find_root({ ".venv", "pyproject.toml", "requirements.txt", ".git" }, file)
    local py = is_win and (root .. "\\.venv\\Scripts\\python.exe") or (root .. "/.venv/bin/python")
    if vim.fn.filereadable(py) == 0 then py = is_win and "python" or "python3" end
    cmd = { py, file }
  elseif ft == "lua" then
    cmd = { "nvim", "-l", file }
  elseif ft == "sh" or ft == "bash" then
    cmd = { "bash", file }
  elseif ft == "javascript" or ft == "typescript" then
    cmd = { "node", file }
  else
    vim.notify("run: no runner for filetype '" .. ft .. "'", vim.log.levels.WARN)
    return
  end

  -- reuse a single bottom terminal instead of stacking splits
  if _run_buf and vim.api.nvim_buf_is_valid(_run_buf) then
    pcall(vim.api.nvim_buf_delete, _run_buf, { force = true })
  end
  vim.cmd("botright new | resize 15")
  _run_buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart(cmd, { term = true })
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<F5>", _run_current_file, { desc = "Run current file" })
vim.keymap.set("n", "<leader>rr", _run_current_file, { desc = "Run current file" })

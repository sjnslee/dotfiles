local opts = { noremap = true, silent = true }

-- netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move selection up/down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- source file
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- replace word under cursor
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- cellular automaton
vim.keymap.set("n", "<leader>lr", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>ll", "<cmd>CellularAutomaton game_of_life<CR>")

-- competitest
vim.keymap.set("n", "<leader>tt", ":CompetiTest add_testcase<CR>")

-- cord
vim.keymap.set("n", "<leader>cp", function()
  require("cord.api.command").toggle_presence()
end)
vim.keymap.set("n", "<leader>ci", function()
  require("cord.api.command").toggle_idle_force()
end)

-- neogen docstring
vim.keymap.set("n", "<Leader>dd", ":lua require('neogen').generate()<CR>", opts)

-- toggle virtual text
vim.keymap.set("", "<leader>vt", ":VirtualTextToggle<CR>", { noremap = true, silent = true })

-- which-key
local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add({
    { "<leader>f", group = "file" },
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

-- go to buffer n, 0 for last
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("bufferline").go_to(i, true)
  end, opts)
end
vim.keymap.set("n", "<leader>0", function()
  require("bufferline").go_to(-1, true)
end, opts)

-- cycle buffers
vim.keymap.set("n", "<leader>.", ":BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<leader>,", ":BufferLineCyclePrev<CR>", opts)

-- close buffer
vim.keymap.set("n", "<leader>ww", ":bd<CR>", opts)

-- duplicate line, comment original
vim.keymap.set("n", "ycc", "yygccp", { remap = true })

-- search within selection
vim.keymap.set("x", "/", "<Esc>/\\%V")

-- join lines, keep cursor
vim.keymap.set("n", "J", "mzJ`z:delmarks z<cr>")

-- paste from system clipboard
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- find/replace in selection
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

vim.keymap.set("v", "<leader>r", ReplaceInVisualSelection, { noremap = true, silent = true })

-- toggle colorscheme
local _themes = { "kanagawa-dragon", "seoul256-light" }
local _theme_idx = 1
vim.keymap.set("n", "<leader>cs", function()
  _theme_idx = (_theme_idx % #_themes) + 1
  vim.cmd.colorscheme(_themes[_theme_idx])
end, { desc = "Toggle colorscheme" })

-- explain regex
vim.keymap.set("v", "<leader>rg", ":Hypersonic<CR>")

-- run current file in a right split
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

  -- markdown opens in default app
  if ft == "markdown" then
    local opener = is_win and { "cmd", "/c", "start", "", file } or { "open", file }
    vim.fn.jobstart(opener, { detach = true })
    vim.notify("opened " .. vim.fn.fnamemodify(file, ":t") .. " in the default app")
    return
  end

  if ft == "python" then
    local root = _find_root({ ".venv", "venv", "pyproject.toml", "requirements.txt", ".git" }, file)
    local py = is_win and "python" or "python3"
    -- project venv if present
    for _, venv in ipairs({ ".venv", "venv" }) do
      local candidate = is_win and (root .. "\\" .. venv .. "\\Scripts\\python.exe")
        or (root .. "/" .. venv .. "/bin/python")
      if vim.fn.filereadable(candidate) == 1 then
        py = candidate
        break
      end
    end
    cmd = { py, file }
  elseif ft == "lua" then
    cmd = { "nvim", "-l", file }
  elseif ft == "sh" or ft == "bash" then
    cmd = { "bash", file }
  elseif ft == "matlab" or ft == "octave" then
    -- --persist keeps repl open after run
    cmd = { "octave", "--no-gui", "--quiet", "--persist", file }
  elseif ft == "javascript" or ft == "typescript" then
    cmd = { "node", file }
  elseif ft == "java" then
    local dir = vim.fn.fnamemodify(file, ":h")
    local sources = vim.fn.glob(dir .. (is_win and "\\" or "/") .. "*.java", false, true)
    if #sources > 1 then
      -- compile dir, run class by qualified name
      local class = vim.fn.fnamemodify(file, ":t:r")
      for _, l in ipairs(vim.fn.readfile(file, "", 50)) do
        local pkg = l:match("^%s*package%s+([%w_.]+)%s*;")
        if pkg then
          class = pkg .. "." .. class
          break
        end
      end
      local out = dir .. (is_win and "\\.build" or "/.build")
      local quoted = {}
      for _, src in ipairs(sources) do
        quoted[#quoted + 1] = '"' .. src .. '"'
      end
      local line = string.format(
        'javac -d "%s" %s && java -cp "%s" %s',
        out,
        table.concat(quoted, " "),
        out,
        class
      )
      cmd = is_win and { "cmd", "/c", line } or { "sh", "-c", line }
    else
      -- single file: run source directly
      cmd = { "java", file }
    end
  else
    vim.notify("run: no runner for filetype '" .. ft .. "'", vim.log.levels.WARN)
    return
  end

  -- replace previous run terminal
  if _run_buf and vim.api.nvim_buf_is_valid(_run_buf) then
    pcall(vim.api.nvim_buf_delete, _run_buf, { force = true })
  end
  -- 40% width, min 60 cols
  vim.cmd("botright vnew")
  vim.cmd("vertical resize " .. math.max(60, math.floor(vim.o.columns * 0.4)))
  _run_buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart(cmd, { term = true })
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<F5>", _run_current_file, { desc = "Run current file" })
vim.keymap.set("n", "<leader>rr", _run_current_file, { desc = "Run current file" })

-- open vim-notes.md in a float
local function _open_notes()
  local path = vim.fs.joinpath(vim.fn.stdpath("config"), "vim-notes.md")
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({ "# vim notes", "" }, path)
  end

  Snacks.win({
    file = path,
    width = 0.75,
    height = 0.85,
    border = "rounded",
    title = " vim notes ",
    title_pos = "center",
    wo = { wrap = true, linebreak = true, number = false, signcolumn = "no", conceallevel = 2 },
    bo = { modifiable = true, readonly = false },
    keys = { q = "close" },
    -- save on close
    on_close = function(self)
      if vim.api.nvim_buf_is_valid(self.buf) and vim.bo[self.buf].modified then
        vim.api.nvim_buf_call(self.buf, function()
          vim.cmd("silent! write")
        end)
      end
    end,
  })
end

vim.keymap.set("n", "<leader>?", _open_notes, { desc = "Vim notes" })

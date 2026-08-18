-- Pyright picks an interpreter by searching PATH for `python3`. On this box
-- that used to hit Apple's /usr/bin/python3 (3.9, empty site-packages), so
-- imports that `python` could resolve fine were flagged as unresolved.
-- Resolve the interpreter explicitly instead of letting pyright guess:
-- a project venv when there is one, otherwise whatever `python` points at.
local function _python_path(root)
  local is_win = vim.fn.has("win32") == 1
  local rels = is_win and { ".venv\\Scripts\\python.exe", "venv\\Scripts\\python.exe" }
    or { ".venv/bin/python", "venv/bin/python" }
  local sep = is_win and "\\" or "/"
  for _, rel in ipairs(rels) do
    local p = root .. sep .. rel
    if vim.fn.executable(p) == 1 then
      return p
    end
  end
  local fallback = vim.fn.exepath("python")
  return fallback ~= "" and fallback or "python3"
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        -- must be on_init, not before_init: nvim answers the server's
        -- workspace/configuration request from client.settings, which
        -- before_init does not populate (pyright then silently falls back
        -- to its own PATH search and the venv is ignored).
        on_init = function(client)
          local root = client.config.root_dir or vim.fn.getcwd()
          client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
            python = { pythonPath = _python_path(root) },
          })
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end,
      },
    },
  },
}

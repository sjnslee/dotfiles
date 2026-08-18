-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Homebrew's openjdk is keg-only, and macOS ships a /usr/bin/java stub that
-- only prints "Unable to locate a Java Runtime". A shell started before the
-- PATH export landed in .zshrc (a long-lived tmux pane, say) hands nvim a
-- PATH where java resolves to that stub, breaking both jdtls and <F5>.
-- Repair it here, before lazy starts, so the shell's age stops mattering.
local function _ensure_jdk_on_path()
  if vim.fn.has("win32") == 1 then
    return
  end
  local found = vim.fn.exepath("java")
  if found ~= "" and found ~= "/usr/bin/java" then
    return -- a real JDK is already reachable
  end
  -- /usr/bin/java is only a working wrapper if a JVM is actually installed
  if found == "/usr/bin/java" and #vim.fn.glob("/Library/Java/JavaVirtualMachines/*", false, true) > 0 then
    return
  end
  local candidates = {}
  if vim.env.JAVA_HOME then
    candidates[#candidates + 1] = vim.env.JAVA_HOME .. "/bin"
  end
  candidates[#candidates + 1] = "/opt/homebrew/opt/openjdk/bin"
  candidates[#candidates + 1] = "/usr/local/opt/openjdk/bin"
  for _, dir in ipairs(candidates) do
    if vim.fn.executable(dir .. "/java") == 1 then
      vim.env.PATH = dir .. ":" .. vim.env.PATH
      return
    end
  end
end
_ensure_jdk_on_path()

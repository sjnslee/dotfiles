-- competitive programming testcases: <leader>tt (keymaps.lua) adds one, and
-- the plugin runs the current file against all of them in a floating window.
-- stock config -- the defaults already match the `input1.txt`/`output1.txt`
-- layout codeforces and atcoder hand out.
return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  cmd = "CompetiTest",
  opts = {},
}

-- render markdown in place: headings, code blocks, tables, lists and links get
-- drawn as a document instead of as syntax, so a README is readable without
-- leaving the buffer. rendering is modal -- the section under the cursor drops
-- back to raw text while you edit it, so nothing is hidden from you.
--
-- needs the markdown and markdown_inline treesitter parsers (both already
-- installed here); html and yaml are optional and only conceal comments and
-- frontmatter. latex is skipped: it wants libtexprintf or pylatexenc on top.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  ft = { "markdown" },
  opts = {
    -- the sign column repeats what the inline heading and code decorations
    -- already show, and shifts the text over in every markdown buffer
    code = { sign = false, width = "block", right_pad = 1 },
    heading = { sign = false },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    Snacks.toggle({
      name = "render markdown",
      get = require("render-markdown").get,
      set = require("render-markdown").set,
    }):map("<leader>um")
  end,
}

# dotfiles/nvim

A [LazyVim](https://lazyvim.org) config that runs unchanged on macOS and on Windows
over SSH. Plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim); versions
are pinned in `lazy-lock.json`.

```sh
git clone https://github.com/sjnslee/dotfiles ~/dotfiles
ln -s ~/dotfiles/nvim ~/.config/nvim
nvim   # lazy.nvim bootstraps itself on first launch
```

## Layout

| Path | What's in it |
| --- | --- |
| `init.lua` | one line: `require("config.lazy")` |
| `lua/config/lazy.lua` | lazy.nvim bootstrap + LazyVim import |
| `lua/config/options.lua` | JDK PATH repair, SSH clipboard bridge, python3 provider venv |
| `lua/config/keymaps.lua` | everything below under [Keymaps](#keymaps) |
| `lua/config/autocmds.lua` | snacks sidebar drag-resize guard |
| `lua/plugins/*.lua` | one file per plugin or concern |
| `lazyvim.json` | enabled LazyVim extras (java, python, typescript, tailwind, json, prettier, mini-surround, mini-hipatterns) |
| `clip-send.ps1` | Windows helper for the clipboard bridge |

## Plugins

### explicitly configured

Each of these has a spec under `lua/plugins/`.

| Plugin | Why |
| --- | --- |
| [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | main colorscheme, `kanagawa-dragon` |
| [junegunn/seoul256.vim](https://github.com/junegunn/seoul256.vim) | light counterpart, toggled with `<leader>cs` |
| [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit) | magit-style staging, opens in its own tab |
| [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) | side-by-side diffs and file history |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | dashboard, picker/explorer, inline images, terminals |
| [saghen/blink.cmp](https://github.com/saghen/blink.cmp) | completion, rebound to Tab/Enter with no preselect |
| [karb94/neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | eased scrolling |
| [sphamba/smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | cursor trail |
| [GCBallesteros/jupytext.nvim](https://github.com/GCBallesteros/jupytext.nvim) | edit `.ipynb` as a `# %%` python buffer |
| [benlubas/molten-nvim](https://github.com/benlubas/molten-nvim) | run those cells against a jupyter kernel, plots inline |
| [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | draw markdown as a document, `<leader>um` to toggle |
| [folke/noice.nvim](https://github.com/folke/noice.nvim) | drop jdtls' per-keystroke progress messages |
| [xeluxee/competitest.nvim](https://github.com/xeluxee/competitest.nvim) | competitive programming testcases, `<leader>tt` |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | pyright interpreter pinning, html/css/emmet servers, diagnostic profiles |
| [Eandrju/cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim) | `<leader>lr` / `<leader>ll`, purely for fun |

### inherited from LazyVim

Installed and left at LazyVim's defaults:
[SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) ·
[bufferline.nvim](https://github.com/akinsho/bufferline.nvim) ·
[catppuccin](https://github.com/catppuccin/nvim) ·
[conform.nvim](https://github.com/stevearc/conform.nvim) ·
[flash.nvim](https://github.com/folke/flash.nvim) ·
[friendly-snippets](https://github.com/rafamadriz/friendly-snippets) ·
[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) ·
[grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) ·
[lazydev.nvim](https://github.com/folke/lazydev.nvim) ·
[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) ·
[mason.nvim](https://github.com/mason-org/mason.nvim) ·
[mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) ·
[mini.ai](https://github.com/nvim-mini/mini.ai) ·
[mini.hipatterns](https://github.com/nvim-mini/mini.hipatterns) ·
[mini.icons](https://github.com/nvim-mini/mini.icons) ·
[mini.pairs](https://github.com/nvim-mini/mini.pairs) ·
[mini.surround](https://github.com/nvim-mini/mini.surround) ·
[nui.nvim](https://github.com/MunifTanjim/nui.nvim) ·
[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) ·
[nvim-lint](https://github.com/mfussenegger/nvim-lint) ·
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) ·
[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) ·
[nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) ·
[persistence.nvim](https://github.com/folke/persistence.nvim) ·
[plenary.nvim](https://github.com/nvim-lua/plenary.nvim) ·
[todo-comments.nvim](https://github.com/folke/todo-comments.nvim) ·
[tokyonight.nvim](https://github.com/folke/tokyonight.nvim) ·
[trouble.nvim](https://github.com/folke/trouble.nvim) ·
[ts-comments.nvim](https://github.com/folke/ts-comments.nvim) ·
[venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) ·
[which-key.nvim](https://github.com/folke/which-key.nvim)

### language servers

Installed through mason: `pyright`, `jdtls`, `lua_ls`, `vtsls`, `html`, `cssls`,
`emmet_language_server`, `tailwindcss` and `jsonls`, plus `ruff`, `stylua`,
`shfmt` and `prettier` as formatters/linters.

`html`, `cssls` and `emmet_language_server` have no LazyVim extra, so they are
wired up in `plugins/web.lua`; the rest come from the extras in `lazyvim.json`.

`pyright` picks its interpreter by searching `PATH` for `python3`, which on macOS
finds Apple's 3.9 with an empty `site-packages`. `plugins/python.lua` resolves it
explicitly instead: the project's `.venv` if there is one, otherwise whatever
`python` points at.

## Keymaps

Leader is `<space>`. LazyVim's defaults all still apply; these are the additions.

### run

| Key | Action |
| --- | --- |
| `<F5>`, `<leader>rr` | run the current file in a right-hand terminal split |

Python uses the project's `.venv` when one exists. Java compiles the whole
directory when there are sibling sources (honouring a `package` declaration),
otherwise runs the single file directly via JDK 11+ source mode. Markdown is not
run at all — it opens in the OS default app. Lua, shell, JS and TS each get their
obvious interpreter. Any other filetype warns instead of guessing.

### notebooks

`.ipynb` opens as a `# %%` python buffer. Cells run against a jupyter kernel,
output (plots included) is drawn as virtual lines under the cell.

| Key | Action |
| --- | --- |
| `<leader>mi` / `<leader>mI` | start / stop the kernel |
| `<leader>mR` | restart the kernel |
| `<leader>mc` | run the cell under the cursor |
| `<leader>ml` | run the current line |
| `<leader>mv` (visual) | run the selection |
| `<leader>mr` / `<leader>ma` | rerun the cell / every cell |
| `<leader>mx` | interrupt |
| `<leader>mo` / `<leader>mh` / `<leader>me` | show / hide / enter the output window |
| `<leader>md` | delete the cell's output |
| `<leader>mn` / `<leader>mp` | next / previous cell |
| `<leader>ms` / `<leader>mS` | save outputs into / load them back out of the `.ipynb` |

Outputs live in molten, not in the buffer, so a notebook saved with results
reopens blank until `<leader>mS` reads them back.

### git

`<leader>gg` is still LazyVim's lazygit.

| Key | Action |
| --- | --- |
| `<leader>gn` | Neogit |
| `<leader>gN` | Neogit commit |
| `<leader>gd` | diffview, working tree |
| `<leader>gD` | close diffview |
| `<leader>gv` | file history for the current file (or, in visual mode, the selection) |
| `<leader>gV` | file history for the whole branch |

History sits under `gv` rather than `gh` because LazyVim gives `<leader>gh` to
gitsigns' hunk group.

### buffers and windows

| Key | Action |
| --- | --- |
| `<leader>1` … `<leader>9` | jump to buffer N |
| `<leader>0` | jump to the last buffer |
| `<leader>,` / `<leader>.` | previous / next buffer |
| `<leader>ww` | close the current buffer |
| `<C-arrow>` | resize the current split (LazyVim default) |

### editing

| Key | Action |
| --- | --- |
| `J` / `K` (visual) | move the selection down / up |
| `J` (normal) | join lines, cursor stays put |
| `ycc` | duplicate the line and comment the original |
| `/` (visual) | search inside the selection only |
| `<leader>s` | replace every instance of the word under the cursor |
| `<leader>r` (visual) | prompted find/replace inside the selection |
| `<leader>dd` | generate a docstring/javadoc (neogen) |
| `<leader>rg` (visual) | explain the selected regex (hypersonic) |

### misc

| Key | Action |
| --- | --- |
| `<leader>cs` | toggle kanagawa-dragon ↔ seoul256-light |
| `<leader><leader>` | `:source` the current file |
| `<leader>pv` | netrw |
| `<leader>lr` / `<leader>ll` | make it rain / game of life |
| `<leader>tt` | add a competitest testcase |
| `<leader>uq` | toggle full diagnostics (minimal is the default) |
| `<leader>um` | toggle markdown rendering |

`<leader>dd`, `<leader>rg`, `<leader>cp` / `<leader>ci` (cord) and `<leader>ff`
(telescope) are kept from an older setup; the plugins behind them are not
currently installed, so those keys are inert until they come back.

## Cross-platform notes

**JDK on macOS.** Homebrew's `openjdk` is keg-only and macOS ships a `/usr/bin/java`
stub that only prints "Unable to locate a Java Runtime". A shell started before the
`PATH` export landed in `.zshrc` — a long-lived tmux pane, say — hands nvim a broken
`PATH`. `options.lua` repairs it before lazy starts, so the shell's age stops
mattering.

**Clipboard over SSH.** Editing on the Windows box over SSH, OSC 52 does not work:
ConPTY strips the escape before it reaches the Mac terminal. Instead a
`TextYankPost` hook pipes each yank through `clip-send.ps1` into an SSH reverse
tunnel (`127.0.0.1:52371`) to a `pbcopy` listener on the Mac. It needs a matching
`RemoteForward` in `~/.ssh/config` and a launchd agent on the Mac side. Sitting at
the Windows console directly, it is skipped and win32yank handles the local
clipboard as usual.

**Snacks sidebar resize.** `snacks/layout.lua` excludes `relative = "win"` floats
from its box sizing but not from its `WinResized` handler, so dragging a split while
an explorer preview is open computes `actual - 0` and grows the sidebar to the full
screen width. `autocmds.lua` invalidates the layout's `screenpos` on resize, which
forces snacks down its clean full-update path before it reaches that arithmetic.
`plugins/explorer.lua` also starts the preview hidden, so `P` toggles it rather than
it opening with the tree.

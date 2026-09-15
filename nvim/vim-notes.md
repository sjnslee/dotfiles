# vim notes

`<leader>?` opens this. edit it freely — it saves on close.

## the grammar

`[count] operator [count] motion-or-textobject`

learn the two lists, get the product for free.
doubling the operator acts on the line: `dd` `yy` `cc` `>>` `gcc` `guu`.
capital = to end of line: `D` `C` `Y`.

| operator | verb |
|---|---|
| `d` `c` `y` | delete, change, yank |
| `>` `<` `=` | indent, dedent, autoformat |
| `gu` `gU` `g~` | lower, upper, toggle case |
| `gq` | reflow to textwidth |
| `gc` | comment |
| `!` | filter through a shell command |
| `zf` | fold |

## motions

in the line
- `w W e E b B ge` — word/WORD fwd, end, back, end-of-prev
- `f{c}` `t{c}` `F` `T` — to / till a char. `;` repeat, `,` repeat back
- `0 ^ $ g_` — col0, first non-blank, eol, last non-blank
- `%` — matching bracket

in the file
- `{` `}` paragraph, `gg` `G` `{n}G`
- `H M L` screen top/mid/bottom, `zt zz zb` scroll cursor to top/center/bottom
- `*` `#` search word under cursor fwd/back
- `<C-d> <C-u>` half page, `<C-f> <C-b>` page, `<C-e> <C-y>` scroll only

## text objects

`i` = inner, `a` = around. cursor can be anywhere inside.

`iw aw` · `i" i' ` · `i( i[ i{ i<` (`ib` `iB`) · `it at` tag · `ip ap` para · `is as` sentence

treesitter: `af if` function · `ac ic` class · `aa ia` argument. `[f` `]f` between functions.

drill: `ci(` `ca{` `yi"` `vat` `daf` `>ip`

## repeat

`.` repeats the last change. compose commands so `.` can reuse them.

```
*        search word under cursor
cgn      change next match
.        …and next. and next.
```

`;` `,` are `.` for `f/t`. `&` repeats last `:s` on this line, `g&` file-wide.

## registers

- `"ayy` / `"ap` — named. capital `"A` appends
- `"0` — last yank only, survives deletes. `yiw` then `viwp`… or `"0p`
- `"+` system clipboard · `"_` blackhole (`"_dd`)
- `".` last insert · `"%` filename · `":` last ex cmd · `:reg` lists all
- insert mode: `<C-r>a` paste reg, `<C-r>=` expression register

## marks & jumps

- `ma` set, `` `a `` exact, `'a` line. uppercase = global across files
- `` `. `` last edit · ``` `` ``` last jump origin
- `<C-o>` `<C-i>` jumplist back/fwd — the browser back button
- `g;` `g,` changelist back/fwd
- `<C-^>` alternate file

## macros

`qa` record → `q` stop → `@a` play → `@@` replay → `5@a`

- macros are registers: `"ap` to edit one as text, `"ay$` to load it back
- `:'<,'>normal @a` runs it on each selected line — safer than `100@a`
- always start with `0`/`^`, end on a motion to the next target

## visual

`v` char · `V` line · `<C-v>` block
- `gv` reselect · `o` swap ends
- block `I` / `A` insert on every line, `$A` appends at each eol — the multi-cursor
- `g<C-a>` on a block of zeros → incrementing sequence
- `<C-a>` `<C-x>` increment/decrement number under cursor

## ex

```
:%s/\<word\>/new/gI    word boundaries, case-sensitive
:'<,'>s/old/new/gc     in selection, confirm each
:g/pat/d               delete every matching line
:v/pat/d               delete every non-matching line
:g/TODO/normal A  <-   normal-mode cmd on each match
:.,+5d                 ranges: . here, $ end, +n relative
:r !date               read cmd output into buffer
```

`q:` editable command history · `q/` search history

## insert mode

`<C-w>` del word back · `<C-u>` del to line start · `<C-r>{reg}` paste
`<C-o>` one normal cmd then back · `<C-a>` reinsert last insert · `<C-n>/<C-p>` buffer completion

## prefix families

- `g` — the other/extended version: `gi` insert where you left off, `gv`, `gJ`, `gf`, `gx`, `ga`, `gn`
- `z` — view & folds: `zz zt zb`, `za zo zc`, `zR` open all, `zM` close all, `zf{motion}`
- `<C-w>` — windows: `s v hjkl HJKL = o q`  (also `<leader>w` here)
- `[` `]` — prev/next of a thing: `d` diagnostic, `e` error, `c` git hunk, `b` buffer, `q` quickfix
- `"` registers · `` ` `` marks · `@` macros · `q` record

## my maps

| keys | does |
|---|---|
| `<leader>?` | this file |
| `<leader><leader>` | `:so` (overrides lazyvim find-files) |
| `<leader>ff` | find files |
| `<leader>rr` / `<F5>` | run current file |
| `<leader>s` | replace word under cursor, file-wide |
| `<leader>r` (visual) | find/replace in selection |
| `<leader>cs` | toggle kanagawa-dragon / seoul256-light |
| `<leader>.` `<leader>,` | cycle buffers |
| `<leader>1`–`0` | jump to buffer n |
| `<leader>ww` | close buffer |
| `ycc` | duplicate line, comment the original |
| `J` / `K` (visual) | move block down/up |
| `/` (visual) | search within selection only |

plugins
- flash: `s` + 2 chars + label to jump anywhere. `S` treesitter select. works after an operator. **`s` is no longer substitute — use `cl`**
- mini-surround: `gsa` add (`gsaiw"`), `gsd` delete (`gsd"`), `gsr` replace (`gsr"'`)

lazyvim worth remembering: `<leader>sk` search keymaps · `<leader>/` grep root · `<leader>sw` grep word
`<S-h>`/`<S-l>` buffers · `gd gr gI gy` lsp goto · `K` hover · `<leader>ca` `<leader>cr` `<leader>cf`

## when a key does something weird

`:verbose map s` — names the plugin and line that claimed it
`:h text-objects` · `:h i_CTRL-R` · `:h g` · `:h z`

## queue

next three to drill, in order:
1. `f`/`t` + `;`
2. `ci(` family
3. `cgn` + `.`

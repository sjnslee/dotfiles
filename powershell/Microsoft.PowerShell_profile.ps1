# --- prompt / tools init ---
# SSH doesn't forward COLORTERM (only TERM is special-cased by the protocol), so
# starship can't tell this truecolor Ghostty session supports 24-bit color and
# falls back to a washed-out palette. Force it.
$env:COLORTERM = "truecolor"

# Real Windows username/hostname are ugly over SSH (Administrator@DESKTOP-...),
# so starship.toml displays these instead via env_var modules.
$env:STARSHIP_WIN_USER = "shane"
$env:STARSHIP_WIN_HOST = "tsumpc"

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# bun
$env:PATH = "$env:USERPROFILE\.bun\bin;$env:PATH"

if (-not [Console]::IsInputRedirected) {
    fastfetch
}

# --- aliases translated from .zshrc ---
Set-Alias -Name vi -Value nvim

Remove-Item alias:cd -Force -ErrorAction SilentlyContinue
function cd { z @args }

Remove-Item alias:ls -Force -ErrorAction SilentlyContinue
function ls { eza --icons=always @args }

function ll { eza -lah --icons=always @args }

Remove-Item alias:cat -Force -ErrorAction SilentlyContinue
function cat { bat @args }

function c { Clear-Host }
function matrix { rusty-rain --group classic --color green }
function pipes { pipes-rs }
New-Item -Path Function:\.. -Value { Set-Location .. } -Force | Out-Null
New-Item -Path Function:\... -Value { Set-Location ..\.. } -Force | Out-Null

# --- oh-my-zsh plugin parity (PSReadLine) ---
# Mirrors the Mac's oh-my-zsh plugins: zsh-autosuggestions + zsh-syntax-highlighting,
# plus emacs keybindings (Ctrl+A/Ctrl+E/etc) that zsh uses by default.
# Requires PSReadLine 2.2+ for inline predictions. PS 5.1 auto-loads the in-box
# 2.0.0 before this profile runs, so drop it and import the newer CurrentUser copy.
Remove-Module PSReadLine -Force -ErrorAction SilentlyContinue
Import-Module PSReadLine -MinimumVersion 2.3.4
Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -HistoryNoDuplicates -MaximumHistoryCount 10000

# zsh-autosuggestions: grey inline suggestion pulled from history. Accept the whole
# suggestion with Right/End, one word with Ctrl+f (emacs mode). Needs a VT-capable
# interactive console, so guard it (redirected/piped sessions skip it cleanly).
try {
    Set-PSReadLineOption -PredictionSource History -PredictionViewStyle InlineView
} catch { }

# zsh-syntax-highlighting: color command tokens as you type. PS 5.1 has no `e
# escape, so the grey prediction color is given as a hex RGB value.
Set-PSReadLineOption -Colors @{
    Command          = 'Green'
    Parameter        = 'DarkCyan'
    Operator         = 'Magenta'
    Number           = 'Magenta'
    String           = 'Yellow'
    Comment          = 'DarkGray'
    InlinePrediction = '#767676'
}

# git plugin parity: a few of oh-my-zsh's most-used git aliases.
function g    { git @args }
function gst  { git status @args }
function ga   { git add @args }
function gaa  { git add --all @args }
function gc   { git commit -v @args }
function gcm  { git commit -m @args }
function gco  { git checkout @args }
function gcb  { git checkout -b @args }
function gp   { git push @args }
function gl   { git pull @args }
function gd   { git diff @args }
function gb   { git branch @args }
function glog { git log --oneline --graph --decorate @args }

# --- fzf key bindings (Ctrl+T file search, Ctrl+R history search) ---
# Loaded AFTER the PSReadLine block above so EditMode Emacs doesn't reset the Ctrl+R chord.
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

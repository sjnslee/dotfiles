# --- prompt / tools init ---
# SSH doesn't forward COLORTERM (only TERM is special-cased by the protocol), so
# starship can't tell this truecolor Ghostty session supports 24-bit color and
# falls back to a washed-out palette. Force it.
$env:COLORTERM = "truecolor"

# Real Windows username/hostname are ugly over SSH (Administrator@DESKTOP-...),
# so starship.toml displays these instead via env_var modules.
$env:STARSHIP_WIN_USER = "tsum"
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

# --- fzf key bindings (Ctrl+T file search, Ctrl+R history search) ---
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

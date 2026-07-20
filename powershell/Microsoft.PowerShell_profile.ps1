# --- prompt / tools init ---
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# bun
$env:PATH = "$env:USERPROFILE\.bun\bin;$env:PATH"

fastfetch

# --- aliases translated from .zshrc ---
Set-Alias -Name vi -Value nvim

Remove-Item alias:cd -Force -ErrorAction SilentlyContinue
function cd { z @args }

Remove-Item alias:ls -Force -ErrorAction SilentlyContinue
function ls { eza --icons @args }

function ll { eza -lah --icons @args }

Remove-Item alias:cat -Force -ErrorAction SilentlyContinue
function cat { bat @args }

function c { Clear-Host }
New-Item -Path Function:\.. -Value { Set-Location .. } -Force | Out-Null
New-Item -Path Function:\... -Value { Set-Location ..\.. } -Force | Out-Null

# --- fzf key bindings (Ctrl+T file search, Ctrl+R history search) ---
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

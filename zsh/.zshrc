export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

alias vi='nvim'
alias rain='terminal-rain --rain-color cyan --lightning-color white'
alias bonsai='cbonsai --live --time=0.005 --life=40'
alias matrix='unimatrix'
alias nyan='nyancat'
alias fish='asciiquarium'
alias pipes='pipes.sh'
alias clock='tty-clock -c -s -t -C 5'
alias moon='moon-buggy'
alias dino='termrex/build/termrex'
alias type='typioca'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cd='z'
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias cat="bat"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"


fastfetch

. "$HOME/.local/bin/env"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# View a tsumpc image. ~/ maps to the Windows home C:/Users/Shane.
#   sshview  ~/Code/cosmos-proj/attacks/plain_text.png   -> render in terminal (Ghostty, no tmux)
#   sshview1 ~/Code/cosmos-proj/attacks/plain_text.png   -> popup in Preview
_sshview_resolve() {
  local src="${1//\\//}"                              # backslashes -> /
  case "$src" in
    [A-Za-z]:/*) ;;                                   # absolute drive path
    "$HOME"/*)  src="C:/Users/Shane/${src#$HOME/}" ;; # zsh-expanded ~/
    '~/'*)      src="C:/Users/Shane/${src#\~/}" ;;    # quoted ~/
    '~')        src="C:/Users/Shane" ;;
    *)          src="C:/Users/Shane/$src" ;;          # bare -> home
  esac
  print -r -- "$src"
}
sshview() {   # render in the terminal (Ghostty, not tmux)
  local src win; src="$(_sshview_resolve "$1")"; win="${src//\//\\}"
  /usr/bin/ssh shane@tsumpc "cmd /c type \"$win\"" | /opt/homebrew/bin/kitten icat
}
sshview1() {  # popup in Preview
  local src; src="$(_sshview_resolve "$1")"
  local dst="/tmp/${src:t}"
  scp -q "shane@tsumpc:$src" "$dst" && open "$dst"
}

# ---- cosmos-proj sync (code only; venv is machine-local, never synced) ----
syncosmos() {  # pull everything from tsumpc -> Mac EXCEPT the venv (tar over ssh; tsumpc has no rsync)
  mkdir -p ~/code/cosmos-proj
  ssh tsumpc "tar -czf - -C C:/Users/Shane/Code/cosmos-proj --exclude .venv --exclude '*/.venv/*' ." \
    | tar -xzf - -C ~/code/cosmos-proj && echo "synced -> ~/code/cosmos-proj (venv excluded)"
}

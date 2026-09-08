export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# openjdk is keg-only (brew doesn't symlink it), so put it on PATH by hand.
# Needed by nvim's <F5> runner and by mason's jdtls.
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

alias vi='nvim'
alias rain='terminal-rain --rain-color cyan --lightning-color white'
alias bonsai='cbonsai --live --time=0.005 --life=40'
alias matrix='unimatrix'
alias nyan='nyancat'
alias fish='asciiquarium'
alias pipes='pipes.sh'
alias clock='tty-clock -c -s -t -C 5'
alias moon='moon-buggy'
alias dino="$HOME/.local/src/termrex/build/termrex"
alias type='typioca'
alias ff='fastfetch'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cd='z'
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias cat="bat"
alias :q="exit"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"


fastfetch

. "$HOME/.local/bin/env"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# machine-local settings that do not belong in a public repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

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



# WAKE_HOST is the always-on box that sends the wake-on-lan packet. It is a
# private hostname, so it lives in ~/.zshrc.local (untracked) rather than here.
wakepc() {
    if [[ -z "$WAKE_HOST" ]]; then
        echo "wakepc: set WAKE_HOST in ~/.zshrc.local" >&2
        return 1
    fi

    ssh "$WAKE_HOST" "~/scripts/wake-pc.sh"

    echo "waiting"

    until ssh shane@tsumpc exit 2>/dev/null
    do
        sleep 3
    done

    echo "connecting"

    ssh shane@tsumpc
}



shutdownpc() {
    ssh shane@tsumpc "shutdown /s /t 0"
}

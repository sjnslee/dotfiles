export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# openjdk is keg-only (brew doesn't symlink it), so put it on PATH by hand.
# Needed by nvim's <F5> runner and by mason's jdtls.
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

export EDITOR=nvim
export VISUAL=nvim

alias vi='nvim'
alias rain='terminal-rain --rain-color cyan --lightning-color white'
alias bonsai='cbonsai --live --time=0.005 --life=40'
alias matrix='unimatrix'
alias nyan='nyancat'
alias fish='asciiquarium'
alias pipes='pipes.sh'
alias clock='tty-clock -c -s -t -C 5'
alias moon='moon-buggy'
alias typing='typioca'
alias ff='fastfetch'
alias lg='lazygit'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cd='z'
alias ls="eza --icons=auto"
alias ll="eza -lah --icons=auto"
alias cat="bat"
alias :q="exit"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# flat ms total for starship's cmd_ms module; built-in cmd_duration can only
# print unit chunks like 2s500ms
zmodload zsh/datetime
autoload -Uz add-zsh-hook
_cmd_timer_start() { _cmd_start=$EPOCHREALTIME }
_cmd_timer_stop() {
  if [[ -z $_cmd_start ]]; then
    unset CMD_DURATION_MS
    return
  fi
  local -i ms=$(( (EPOCHREALTIME - _cmd_start) * 1000 ))
  export CMD_DURATION_MS=$ms
  unset _cmd_start
}
add-zsh-hook preexec _cmd_timer_start
add-zsh-hook precmd _cmd_timer_stop

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

    ssh "$WAKE_HOST" "~/scripts/wake-pc.sh" || return 1

    echo "waiting"

    # ~3 min: 40 tries of a 3s connect timeout plus 3s sleep
    local tries=0
    until ssh -o ConnectTimeout=3 tsumpc exit 2>/dev/null
    do
        if (( ++tries >= 40 )); then
            echo "wakepc: tsumpc did not come up" >&2
            return 1
        fi
        sleep 3
    done

    echo "connecting"

    ssh tsumpc
}



shutdownpc() {
    ssh shane@tsumpc "shutdown /s /t 0"
}

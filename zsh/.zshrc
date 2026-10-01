export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# openjdk on PATH, if installed
_jdk="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/openjdk"
if [[ -d $_jdk/libexec/openjdk.jdk ]]; then
  export PATH="$_jdk/bin:$PATH"
  export JAVA_HOME="$_jdk/libexec/openjdk.jdk/Contents/Home"
fi
unset _jdk

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

# command time in ms for starship's cmd_ms
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

# skip in tmux panes
[[ -z $TMUX ]] && command -v fastfetch >/dev/null && fastfetch

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

command -v fzf >/dev/null && source <(fzf --zsh)

# machine-local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# view a tsumpc image: sshview in terminal, sshview1 in preview
_sshview_resolve() {
  local src="${1//\\//}"                              # backslashes -> /
  case "$src" in
    [A-Za-z]:/*) ;;                                   # drive path
    "$HOME"/*)  src="C:/Users/Shane/${src#$HOME/}" ;; # expanded ~/
    '~/'*)      src="C:/Users/Shane/${src#\~/}" ;;    # quoted ~/
    '~')        src="C:/Users/Shane" ;;
    *)          src="C:/Users/Shane/$src" ;;          # relative -> home
  esac
  print -r -- "$src"
}
sshview() {
  local src win; src="$(_sshview_resolve "$1")"; win="${src//\//\\}"
  /usr/bin/ssh shane@tsumpc "cmd /c type \"$win\"" | kitten icat
}
sshview1() {
  local src; src="$(_sshview_resolve "$1")"
  local dst="/tmp/${src:t}"
  scp -q "shane@tsumpc:$src" "$dst" && open "$dst"
}

# wake tsumpc through WAKE_HOST, then ssh in
wakepc() {
    if [[ -z "$WAKE_HOST" ]]; then
        echo "wakepc: set WAKE_HOST in ~/.zshrc.local" >&2
        return 1
    fi

    ssh "$WAKE_HOST" "~/scripts/wake-pc.sh" || return 1

    echo "waiting"

    # ~3 min timeout
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

fastfetch

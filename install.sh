#!/bin/sh
# symlink dotfiles into place on macOS or linux. safe to rerun: existing links
# are replaced, and a real file in the way is moved to <path>.bak first.
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  src="$DOTFILES/$1"
  dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "moved $dst to $dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "$dst -> $src"
}

link zsh/.zshrc .zshrc
link zsh/.zprofile .zprofile
link git/.gitconfig .gitconfig
link nvim .config/nvim
link tmux .config/tmux
link starship/starship.toml .config/starship.toml
link ghostty/config .config/ghostty/config

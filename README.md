dotfiles for macOS, Linux, and Windows, symlinked

- terminal utilities config
- neovim config and plugin list: [nvim/README.md](nvim/README.md).

## prerequisites

shell

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
brew install starship zoxide eza bat fzf fd ripgrep fastfetch
curl -LsSf https://astral.sh/uv/install.sh | sh
```

terminal

```sh
brew install tmux
brew install --cask ghostty kitty font-mononoki-nerd-font
```

neovim

```sh
xcode-select --install
brew install neovim node make lazygit imagemagick openjdk
```

notebooks

```sh
uv tool install jupytext
python3 -m venv ~/.venvs/nvim
~/.venvs/nvim/bin/pip install pynvim jupyter_client ipykernel
```

toys

```sh
brew install cbonsai nyancat asciiquarium pipes-sh tty-clock moon-buggy typioca
pip install unimatrix
git clone https://github.com/rmaake1/terminal-rain-lightning
```

untracked, per machine

```
~/.zshrc.local    WAKE_HOST
~/.ssh/config     tsumpc host, RemoteForward 127.0.0.1:52371 127.0.0.1:52371
launchd agent     127.0.0.1:52371 -> pbcopy
```

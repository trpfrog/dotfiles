# .zshenv
# 環境変数などを管理するファイル
# このファイルでは特定の環境に依存しない環境変数を提供する。
# Mac や Linux によって異なる環境変数は .zshenv.darwin や .zshenv.linux に記述する。
# Git で管理しないローカル設定は、このディレクトリに .zshenv.local を作り記述する。

###############################################################################

# このリポジトリのルートディレクトリを指定する
export DOTFILES_ROOT="$HOME/dotfiles"
export DOTFILES_ZSH_DIR="$DOTFILES_ROOT/config/zsh"

# Default editor
export EDITOR=vim

###############################################################################

# local
export PATH="$HOME/.local/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/env:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

###############################################################################

# git 管理しないローカル設定 ($ZDOTDIR とこのディレクトリのどちらに置いても良い)
[ -f $DOTFILES_ZSH_DIR/.zshenv.local ] && source $DOTFILES_ZSH_DIR/.zshenv.local
[ -f $ZDOTDIR/.zshenv.local ] && source $ZDOTDIR/.zshenv.local

# 環境ごとの設定 (.zshenv.darwin, .zshenv.linux)
UNAME_LOWERCASE=${$(uname):l}
[ -f $DOTFILES_ZSH_DIR/.zshenv.$UNAME_LOWERCASE ] && source $DOTFILES_ZSH_DIR/.zshenv.$UNAME_LOWERCASE

###############################################################################

# Pure
PURE_DISPLAY_ENV_NAME=${PURE_DISPLAY_ENV_NAME+"%f%B"}${PURE_DISPLAY_ENV_NAME}${PURE_DISPLAY_ENV_NAME+"%b "}
export PURE_PROMPT_SYMBOL="${PURE_DISPLAY_ENV_NAME}%B%F{3}❯%F{2}❯%F{6}❯%f%b"
# .zshrc
# zsh の設定を記述するファイル
# このファイルでは特定の環境に依存しない設定を提供する。
# Mac や Linux によって異なる設定は .zshrc.darwin や .zshrc.linux に記述する。
# Git で管理しないローカル設定は、このディレクトリに .zshrc.local を作り記述する。

###############################################################################

# load path
export DOTFILES_ROOT="$HOME/dotfiles"
export DOTFILES_ZSH_DIR="$DOTFILES_ROOT/config/zsh"

###############################################################################
# 環境変数

# Default editor
export EDITOR=vim

# local
export PATH="$HOME/.local/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/env:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# zsh
export ZDOTDIR=${ZDOTDIR:-$HOME}

# Secrets (平文で書かず、1Password の参照を書く)
export OPENAI_API_KEY="op://Private/OpenAI API Key/credential"

###############################################################################

# 環境ごとの設定 (.zshrc.darwin, .zshrc.linux)
# Homebrew などの PATH を含むので、コマンドを使う設定より前に読み込む
UNAME_LOWERCASE=${$(uname):l}
[ -f $DOTFILES_ZSH_DIR/.zshrc.$UNAME_LOWERCASE ] && source $DOTFILES_ZSH_DIR/.zshrc.$UNAME_LOWERCASE

###############################################################################

# Pure
export PURE_PROMPT_SYMBOL="${PURE_DISPLAY_ENV_NAME:+%f%B${PURE_DISPLAY_ENV_NAME}%b }%B%F{3}❯%F{2}❯%F{6}❯%f%b"

# mise
if type mise > /dev/null 2>&1 ; then
  eval "$(mise activate zsh --shims)"
  if [[ -o interactive ]] ; then
    eval "$(mise activate zsh)"
  fi
fi

# Vite+ (https://viteplus.dev)
# 自身の bin を PATH の先頭に移すので、他の PATH 設定より後に読み込む
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# GHCup (Haskell)
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# whisper.cpp (~/GitHub/whisper.cpp でビルドしたもの)
[ -x "$HOME/GitHub/whisper.cpp/main" ] && alias whisper="$HOME/GitHub/whisper.cpp/main -m $HOME/GitHub/whisper.cpp/models/ggml-large-v3.bin"

###############################################################################

# Enable comment on interactive shell
setopt interactivecomments

# Enable agent forwarding when screen is reconnected
# http://mokokko.hatenablog.com/entry/2013/03/14/133850
AUTH_SOCK="$HOME/.ssh/.ssh-auth-sock"
if [ -S "$AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $AUTH_SOCK && export SSH_AUTH_SOCK=$AUTH_SOCK
fi

# Emacs key bindings
bindkey -e

# sheldon
command -v sheldon > /dev/null 2>&1 && eval "$(sheldon source)"

alias git-rsync='rsync -avz -C --filter=":- .gitignore" --exclude ".git" --exclude-from ~/dotfiles/.gitignore_global --verbose'

# color grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# fzf (Ctrl+t for searching cd file, Ctrl+r for searching history)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

function git-branch-fzf() {
  [ ! -d .git ] && return
  git branch --list | cut -c 3- \
    | fzf --preview "git log --pretty=format:'%h %cd %s' --date=format:'%Y-%m-%d %H:%M' {}" \
    | xargs git checkout
}
zle -N git-branch-fzf
bindkey '^[' git-branch-fzf

function worktree-pr() {
  git worktree add ./.git/worktree/pr/$1
  cd ./.git/worktree/pr/$1
  gh pr checkout $1
}

###############################################################################

# git 管理しないローカル設定 ($ZDOTDIR とこのディレクトリのどちらに置いても良い)
# 他の設定を上書きできるよう最後に読み込む
[ -f $DOTFILES_ZSH_DIR/.zshrc.local ] && source $DOTFILES_ZSH_DIR/.zshrc.local
[ -f $ZDOTDIR/.zshrc.local ] && source $ZDOTDIR/.zshrc.local

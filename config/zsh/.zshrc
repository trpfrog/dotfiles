# .zshrc
# zsh の設定を記述するファイル
# このファイルでは特定の環境に依存しない設定を提供する。
# Mac や Linux によって異なる設定は .zshrc.darwin や .zshrc.linux に記述する。
# Git で管理しないローカル設定は、このディレクトリに .zshrc.local を作り記述する。

###############################################################################

# load path
export DOTFILES_ROOT="$HOME/dotfiles"
export DOTFILES_ZSH_DIR="$DOTFILES_ROOT/config/zsh"
source $DOTFILES_ZSH_DIR/.zshrc.path

# Enable comment on interactive shell
setopt interactivecomments

# Emacs key bindings
bindkey -e

# sheldon
eval "$(sheldon source)"

# GHCup (Haskell)
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

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

###############################################################################

# git 管理しないローカル設定 ($ZDOTDIR とこのディレクトリのどちらに置いても良い)
[ -f $DOTFILES_ZSH_DIR/.zshrc.local ] && source $DOTFILES_ZSH_DIR/.zshrc.local
[ -f $ZDOTDIR/.zshrc.local ] && source $ZDOTDIR/.zshrc.local

# 環境ごとの設定 (.zshrc.darwin, .zshrc.linux)
UNAME_LOWERCASE=${$(uname):l}
[ -f $DOTFILES_ZSH_DIR/.zshrc.$UNAME_LOWERCASE ] && source $DOTFILES_ZSH_DIR/.zshrc.$UNAME_LOWERCASE

###############################################################################

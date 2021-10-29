# Ruby
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export  PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export  PATH="/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH"

# zprezto
# source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# M1 Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"

# C++ Libraries
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/homebrew/include
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/Users/trpfrog/ac-library

# Remove dotfiles
remove_dotfiles() { /usr/bin/zip --delete $@ "*__MACOSX*" "*.DS_Store" }
alias undot='remove_dotfiles'

# OpenSSL
export PATH=$(brew --prefix openssl)/bin:$PATH

# Needed to install SciPy on M1 Mac using pip
export OPENBLAS=$(brew --prefix openblas)
# export CFLAGS="-falign-functions=8 ${CFLAGS}"

# Go-lang
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# Tweet
update_twitter_status() { twurl tweet -d 'status='$1 | echo 'posted'}
alias tweet='update_twitter_status'

# Node.js
export PATH="$HOME/.nodebrew/current/bin:$PATH"

#sbin
export PATH="/opt/homebrew/sbin:$PATH"

# rust
export PATH="$HOME/.cargo/env:$PATH"

# default editor
export EDITOR=vim

alias youtube-dl-audio=youtube-dl $0 -x -f "bestaudio" --audio-quality 0
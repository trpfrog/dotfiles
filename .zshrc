# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

export  PATH="/opt/homebrew/bin:$PATH"

# Ruby
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export  PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export  PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"

# zprezto
# source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
# alias pip=pip3
# alias python=python3
# export PATH="/Users/trpfrog/Library/Python/3.9/bin:$PATH"


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

# youtube-dl bestaudio
alias youtube-dl-audio='youtube-dl -x -f "bestaudio" --audio-quality 0'

# MATLAB
alias matlab="/Applications/MATLAB_R2021b.app/bin/matlab -nosplash -nodesktop 2>>(grep -v \"font\|CoreText\")"

# OpenJDK
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

function use_llvm_clang() {
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
}

fucntion swpunc() {
  x=$(defaults read com.apple.inputmethod.Kotoeri JIMPrefPunctuationTypeKey)
  if [[ $x == 0 ]] then
    defaults write com.apple.inputmethod.Kotoeri JIMPrefPunctuationTypeKey -int 3
  else
    defaults write com.apple.inputmethod.Kotoeri JIMPrefPunctuationTypeKey -int 0
  fi
  killall -HUP JapaneseIM-RomajiTyping
}

# ChatGPT
alias chatgpt-cli="chatgpt-cli --settings=/Users/trpfrog/dotfiles/node_chatgpt.settings.js"


# ### Added by Zinit's installer
# if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#     print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
#     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
#         print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
#         print -P "%F{160}▓▒░ The clone has failed.%f%b"
# fi
# 
# source "$HOME/.zinit/bin/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
# 
# # Load a few important annexes, without Turbo
# # (this is currently required for annexes)
# zinit light-mode for \
#     zdharma-continuum/z-a-rust \
#     zdharma-continuum/z-a-as-monitor \
#     zdharma-continuum/z-a-patch-dl \
#     zdharma-continuum/z-a-bin-gem-node
# 
# ### End of Zinit's installer chunk
# 
# # Zinit Plugins
# 
# zinit ice wait lucid
# zinit light zsh-users/zsh-completions
# 
# zinit ice wait lucid
# zinit light zsh-users/zsh-autosuggestions
# 
# zinit ice wait lucid
# zinit light zsh-users/zsh-syntax-highlighting
# 
# zinit ice wait lucid
# zinit light chrissicool/zsh-256color
# 
# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure
# PURE_PROMPT_SYMBOL='%B%F{3}❯%F{2}❯%F{6}❯%f%b'

# Welcome
# echo ""
# if [ "$(networksetup -getairportnetwork en0)" = "Current Wi-Fi Network: UECWireless" ]; then
#     echo " ∠  ‾ω ‾) < Hello"
# else
#     echo " ∠  ‾ω ‾) < $(twint -u 'prgckwb' -fr --limit 20 | shuf -n 1 | cut -c 57-)"
# fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

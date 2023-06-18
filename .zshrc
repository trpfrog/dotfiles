# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

export PATH="/opt/homebrew/bin:$PATH"

# asdf (tool version manager)
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Ruby
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export  PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export  PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"

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

# sbin
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

# Whisper
alias whisper="~/GitHub/whisper.cpp/main -m ~/GitHub/whisper.cpp/models/ggml-large.bin"

# GHCup (Haskell)
[ -f "/Users/trpfrog/.ghcup/env" ] && source "/Users/trpfrog/.ghcup/env" # ghcup-env

# GitHub Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"

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

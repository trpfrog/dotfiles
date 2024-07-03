# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/trpfrog/commands:$PATH"

# mise
eval "$(mise activate zsh)"

# Ruby
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"
# export PATH="/Users/trpfrog/.local/share/mise/installs/ruby/3.2.3/lib/ruby/gems/3.2.0:$PATH"
# export PATH="/Users/trpfrog/.local/share/gem/ruby/3.2.0:$PATH"

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
export PATH="$HOME/.cargo/bin:$PATH"

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
alias whisper="~/GitHub/whisper.cpp/main -m ~/GitHub/whisper.cpp/models/ggml-large-v3.bin"

# GHCup (Haskell)
[ -f "/Users/trpfrog/.ghcup/env" ] && source "/Users/trpfrog/.ghcup/env" # ghcup-env

# pandoc
alias pandoc-tex='pandoc --pdf-engine=latexmk --pdf-engine-opt="-r" --pdf-engine-opt="/Users/trpfrog/dotfiles/uplatex-dpx.latexmk" -H "/Users/trpfrog/dotfiles/pandoc-template.tex"'

# Welcome
# echo ""
# if [ "$(networksetup -getairportnetwork en0)" = "Current Wi-Fi Network: UECWireless" ]; then
#     echo " ∠  ‾ω ‾) < Hello"
# else
#     echo " ∠  ‾ω ‾) < $(twint -u 'prgckwb' -fr --limit 20 | shuf -n 1 | cut -c 57-)"
# fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/trpfrog/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/trpfrog/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/trpfrog/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/trpfrog/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Mojo
export MODULAR_HOME="/Users/trpfrog/.modular"
export PATH="/Users/trpfrog/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

# Cloudinary
export CLOUDINARY_URL=cloudinary://198791233626164:SM0yhQRcqYrDLcwYfgr7glne0MM@trpfrog

# 1Password CLI
source /Users/trpfrog/.config/op/plugins.sh

# zoxide
eval "$(zoxide init zsh)"

alias git-rsync='rsync -avz -C --filter=":- .gitignore" --exclude ".git" --exclude-from ~/dotfiles/.gitignore_global --verbose'

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


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"
alias "??"="cw ai"

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"


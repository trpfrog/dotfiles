# mise: ランタイムのバージョン管理 (macOS では homebrew が必要)

if ! type mise > /dev/null 2>&1 ; then
  if is_mac ; then
    brew install mise || return
  elif is_linux ; then
    curl https://mise.run | sh || return
  fi
fi
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# ghq: リポジトリ管理 (macOS では homebrew、Linux では mise が必要)

if type ghq > /dev/null 2>&1 ; then
  return 0
fi
if is_mac ; then
  brew install ghq
elif is_linux ; then
  mise use -g go@latest || return
  go install github.com/x-motemen/ghq@latest
fi

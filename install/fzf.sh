# fzf: ファジーファインダー (macOS では homebrew が必要)

if type fzf > /dev/null 2>&1 ; then
  return 0
fi
if is_mac ; then
  brew install fzf
elif is_linux ; then
  apt install fzf
fi

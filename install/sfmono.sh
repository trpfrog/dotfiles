# sfmono: SF Mono Square フォント (macOS, homebrew が必要)

if ! is_mac ; then
  echo "skip: macOS only"
  return 0
fi
brew tap delphinus/sfmono-square || return
brew install sfmono-square || return
open "$(brew --prefix sfmono-square)/share/fonts/"*

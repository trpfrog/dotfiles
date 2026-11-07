# sheldon: zsh プラグインマネージャ (macOS では homebrew が必要)

if type sheldon > /dev/null 2>&1 ; then
  return 0
fi
if is_mac ; then
  brew install sheldon
elif is_linux ; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

# xcode-clt: Xcode Command Line Tools (macOS)

if ! is_mac ; then
  echo "skip: macOS only"
  return 0
fi
xcode-select --install
sudo softwareupdate

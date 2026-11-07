# homebrew: Homebrew (macOS)

if ! is_mac ; then
  echo "skip: macOS only"
  return 0
fi
if ! type brew > /dev/null 2>&1 ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

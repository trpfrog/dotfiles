#!/bin/zsh

function is_mac() { [[ `uname` = "Darwin" ]] }
function is_linux() { [[ `uname` = "Linux" ]] }

if ! is_mac && ! is_linux ; then
  echo "Warning: trpfrog/dotfiles only supports macOS and Linux"
  exit 1
fi

# if $SHELL does not zsh, exit
if [[ ! $SHELL =~ /zsh$ ]] ; then
  echo "Warning: Please change your shell to zsh"
  exit 1
fi

echo "Install TrpFrog's *personal* environment"
echo "To continue, please enter Y"
read x
if [[ $x != Y ]] ; then
  exit 0
fi

################################################################

if is_mac ; then
  brew bundle --file=$DOTFILES_ROOT/config/Brewfile
fi

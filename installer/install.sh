#!/bin/zsh

# if $SHELL does not end with zsh, exit
if [[ $SHELL != "*/zsh" ]]; then
  echo "Please change your shell to zsh"
  exit 1
fi

echo "Install TrpFrog's environment"
echo "To continue, please enter Y"
read x
if [$x != "Y"] ; then
  exit 0
fi

# symbolic links
DOTFILES_ROOT="$HOME/dotfiles"
. $DOTFILES_ROOT/bin/ln.sh

source ~/.zshenv
git config --global core.excludesfile ~/.gitignore_global

if [ "$(uname)" != "Darwin" ] ; then
  xcode-select --install
  sudo softwareupdate

  # Install homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source ~/.zshrc  

  # Install softwares
  brew bundle

  # Open SFMono folder
  open "$(brew --prefix sfmono-square)/share/fonts/*"

elif [ "$(uname)" != "Linux" ] ; then
  sudo apt update
  sudo apt upgrade

  # Install sheldon
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

source ~/.zshrc

# Set some configurations
. $DOTFILES_ROOT/bin/macos.sh


echo "Do you want to install LaTeX? [y/N]"
read x
if [ $x = "y" ]; then
  sudo apt install texlive-full
  # Install jlisting.sty
  sudo wget -P $(dirname $(kpsewhich listings.sty)) http://teacher.nagano-nct.ac.jp/fujita/files/jlisting.sty
  sudo mktexlsr
fi

# 環境ごとの設定 (.zshrc.darwin, .zshrc.linux)
UNAME_LOWERCASE=${$(uname):l}
[ -f $DOTFILES_ROOT/installer/install.${UNAME_LOWERCASE}.sh ] && . $DOTFILES_ROOT/installer/install.${UNAME_LOWERCASE}.sh

cat next_step.txt

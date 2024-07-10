#!/bin/bash

echo "Install TrpFrog's environment"
echo "To continue, please enter Y"
read x
if [$x != "Y"] ; then
  exit 0
fi

cd ~/dotfiles/config

# Create symbolic links
symlink_targets=(
  .zshrc
  .vimrc
  .gitignore_global
  .latexmkrc
)
for file in ${symlink_targets[@]}; do
    ln -fs ~/dotfiles/config/$file ~
done

git config --global core.excludesfile ~/.gitignore_global

if [ "$(uname)" != "Darwin" ] ; then
  exit 0
fi

xcode-select --install
sudo softwareupdate

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source ~/.zshrc

# Install softwares
brew bundle
source ~/.zshrc

# Set some configurations
./macos.sh

# Open SFMono folder
open "$(brew --prefix sfmono-square)/share/fonts"

# Install jlisting.sty
sudo wget -P $(dirname $(kpsewhich listings.sty)) http://teacher.nagano-nct.ac.jp/fujita/files/jlisting.sty
sudo mktexlsr

cat next_step.txt

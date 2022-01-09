#!/bin/sh

echo 'Install TrpFrog\'s environment'
echo 'To continue, please enter Y'
read x
if [$x != "Y"] ; then
    exit 0
fi

cd ~/dotfiles

ln -fs .zshrc ~
ln -fs .vimrc ~
ln -fs .gitignore_global ~
git config --global core.excludesfile ~/.gitignore_global

if [ "$(uname)" != "Darwin" ] ; then
    exit 0
fi

xcode-select --install
sudo softwareupdate --install-rosetta

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
./.macos
brew bundle

# Install zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"

# Install jlisting.sty
sudo wget -P $(dirname $(kpsewhich listings.sty)) http://teacher.nagano-nct.ac.jp/fujita/files/jlisting.sty
sudo mktexlsr

cat next_step.txt
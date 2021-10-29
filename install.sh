#!/bin/sh

ln -fs ~/dotfiles/.zshrc ~
ln -fs ~/dotfiles/.vimrc ~
ln -fs ~/dotfiles/.gitignore_global ~

if [ "$(uname)" == "Darwin" ] ; then
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ~/dotfiles/.macos
fi
#!/usr/bin/env bash

sleep 30
brew update
brew upgrade
brew cleanup
rustup update
mise upgrade
# sudo tlmgr update --self --all
echo 'Finished! [Enter to close]'
read

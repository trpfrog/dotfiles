#!/bin/sh
sleep 30
brew update
brew upgrade
brew cleanup
rustup update
# sudo tlmgr update --self --all
echo 'Finished! [Enter to close]'
read

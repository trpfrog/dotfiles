#!/bin/sh
sleep 30
brew update
yabai --stop-service
brew upgrade
yabai --start-service
brew cleanup
rustup update
mise upgrade
# sudo tlmgr update --self --all
echo 'Finished! [Enter to close]'
read

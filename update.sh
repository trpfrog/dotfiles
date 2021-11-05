#!/bin/sh
sleep 30
brew update
brew upgrade
brew cleanup
sudo tlmgr update --self --all
echo 'Finished! [Enter to close]'
read
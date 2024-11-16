#!/usr/bin/env bash

countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "The update will start in $seconds seconds\033[0K\r"
    sleep 1
    ((seconds--))
  done
  echo -ne "Start updating...\033[0K\r\n"
}

isCommandAvailable() {
  command -v $1 > /dev/null 2>&1
}

countdown 20

if isCommandAvailable brew ; then
  brew update
  brew upgrade
  brew cleanup
fi

if isCommandAvailable rustup ; then
  rustup update
fi

if isCommandAvailable mise ; then
  mise upgrade
fi

echo 'Finished! [Enter to close]'
read

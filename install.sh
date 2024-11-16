#!/usr/bin/env zsh

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

echo "Install TrpFrog's environment"
echo "To continue, please enter Y"
read x
if [[ $x != Y ]] ; then
  exit 0
fi

# Symlink dotfiles
DOTFILES_ROOT="$HOME/dotfiles"
source $DOTFILES_ROOT/bin/deploy.sh

# Load environment variables
source $DOTFILES_ROOT/config/zsh/.zshrc.path

# Xcode Command Line Tools
if is_mac ; then
  xcode-select --install
  sudo softwareupdate
fi

# Homebrew
if is_mac ; then
  # if `brew` command is not exists, install Homebrew
  if ! type brew > /dev/null 2>&1 ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Update apt
if is_linux ; then
  apt update
fi

# Open SFMono folder
if is_mac ; then
  brew tap delphinus/sfmono-square
  brew install sfmono-square
  open "$(brew --prefix sfmono-square)/share/fonts/*"
fi

# Install sheldon
if ! type sheldon > /dev/null 2>&1 ; then
  if is_mac ; then
    brew install sheldon
  elif is_linux ; then
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
  fi
fi

# Install mise
if ! type mise > /dev/null 2>&1 ; then
  if is_mac ; then
    brew install mise
  elif is_linux ; then
    curl https://mise.run | sh
  fi
fi
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Install fzf
if ! type fzf > /dev/null 2>&1 ; then
  if is_mac ; then
    brew install fzf
  elif is_linux ; then
    apt install fzf
  fi
fi

# Install ghq
if ! type ghq > /dev/null 2>&1 ; then
  if is_mac ; then
    brew install ghq
  elif is_linux ; then
    mise use -g go@latest
    go install github.com/x-motemen/ghq@latest
  fi
fi

# Set some configurationss
if is_mac ; then
  source $DOTFILES_ROOT/bin/macos.sh
fi

source $HOME/.zshrc
cat $DOTFILES_ROOT/next_step.txt

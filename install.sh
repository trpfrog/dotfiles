#!/bin/zsh

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

################################################################

# Symlink dotfiles
DOTFILES_ROOT="$HOME/dotfiles"
symlink_targets=(
  config/zsh/.zshenv
  config/zsh/.zshrc
  config/.vimrc
  config/.latexmkrc
)
for file in ${symlink_targets[@]}; do
    ln -fs $DOTFILES_ROOT/$file ~
done

mkdir -p $HOME/.config/sheldon
ln -fs $DOTFILES_ROOT/config/sheldon/plugins.toml $HOME/.config/sheldon

# Load environment variables
source $HOME/.zshenv

################################################################

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
  brew bundle
fi

# Update apt
if is_linux ; then
  apt update
fi

# Open SFMono folder
if is_mac ; then
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

# Apply global gitignore
git config --global core.excludesfile $DOTFILES_ROOT/config/.gitignore_global

# Set some configurationss
if is_mac ; then
  source $DOTFILES_ROOT/bin/macos.sh
fi

source $HOME/.zshrc
cat $DOTFILES_ROOT/next_step.txt
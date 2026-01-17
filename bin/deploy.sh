#!/usr/bin/env zsh

function is_mac() { [[ `uname` = "Darwin" ]] }

DOTFILES_ROOT="$HOME/dotfiles"
symlink_targets=(
  config/zsh/.zshrc
  config/.vimrc
  config/.latexmkrc
)
for file in ${symlink_targets[@]}; do
  ln -fs $DOTFILES_ROOT/$file ~
done

mkdir -p $HOME/.config/sheldon
ln -fs $DOTFILES_ROOT/config/sheldon/plugins.toml $HOME/.config/sheldon

# Include common .gitconfig
git config --global --add include.path $DOTFILES_ROOT/config/git/.gitconfig

# Xcode
if is_mac ; then
  # Change default template
  LN_TO=~/Library/Developer/Xcode/UserData/
  mkdir -p $LN_TO
  ln -fs $DOTFILES_ROOT/config/xcode/IDETemplateMacros.plist $LN_TO
  # Add theme using SFMono Square
  LN_TO=~/Library/Developer/Xcode/UserData/FontAndColorThemes/
  mkdir -p $LN_TO
  ln -fs $DOTFILES_ROOT/config/xcode/'Default (Dark, JA).xccolortheme' $LN_TO
fi

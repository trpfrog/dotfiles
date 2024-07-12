function is_mac() { [[ `uname` = "Darwin" ]] }

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

# Apply global gitignore
git config --global core.excludesfile $DOTFILES_ROOT/config/.gitignore_global

# Xcode
if is_mac ; then
  # Change default template
  ln -fs $DOTFILES_ROOT/config/xcode/IDETemplateMacros.plist ~/Library/Developer/Xcode/UserData/
  # Add theme using SFMono Square
  ln -fs $DOTFILES_ROOT/config/xcode/'Default (Dark, JA).xccolortheme' ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
fi

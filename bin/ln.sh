DOTFILES_ROOT="$HOME/dotfiles"

# Create symbolic links
symlink_targets=(
  config/zsh/.zshenv
  config/zsh/.zshrc
  config/.vimrc
  config/.gitignore_global
  config/.latexmkrc
)
for file in ${symlink_targets[@]}; do
    ln -fs $DOTFILES_ROOT/$file ~
done

ln -fs $DOTFILES_ROOT/config/sheldon/plugins.toml $HOME/.config/sheldon

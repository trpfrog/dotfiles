#!/usr/bin/env zsh

# 外部ツールのインストールを伴わない処理 (シンボリックリンク、共通の git 設定、macOS の設定など) と、
# 端末ごとの設定 (config.yaml) に書かれた値の反映を行う。
# 外部ツールをインストールする処理と、端末ごとに選びたい処理 (agent-signing など) は
# install/<項目>.sh に書き、config.yaml の install で選ぶ。

DOTFILES_ROOT="$HOME/dotfiles"

# 設定に不備があれば、何もせずに終了する
source $DOTFILES_ROOT/lib/config.zsh
if ! dotfiles_config_load || ! dotfiles_config_check ; then
  echo "Nothing was deployed."
  exit 1
fi

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

# macOS の設定 (defaults write など)
if [[ `uname` = "Darwin" ]] ; then
  bash "$DOTFILES_ROOT/bin/macos.sh"
fi

# Xcode のファイルテンプレートとカラーテーマ (macOS)
if [[ `uname` = "Darwin" ]] ; then
  LN_TO=~/Library/Developer/Xcode/UserData/
  mkdir -p $LN_TO
  ln -fs "$DOTFILES_ROOT/config/xcode/IDETemplateMacros.plist" $LN_TO
  LN_TO=~/Library/Developer/Xcode/UserData/FontAndColorThemes/
  mkdir -p $LN_TO
  ln -fs "$DOTFILES_ROOT/config/xcode/Default (Dark, JA).xccolortheme" $LN_TO
fi

# Include common .gitconfig (何度実行しても 1 つだけ追加する)
if ! git config --global --get-all include.path | grep -qxF "$DOTFILES_ROOT/config/git/.gitconfig" ; then
  git config --global --add include.path $DOTFILES_ROOT/config/git/.gitconfig
fi

# Git identity (config.yaml に書かれているときだけ)
dotfiles_config_get git.name && git config --global user.name "$REPLY"
dotfiles_config_get git.email && git config --global user.email "$REPLY"

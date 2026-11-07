# agent-signing: Coding agent のコミット署名 (macOS)
# 署名の設定は .zshrc にある。ここではログイン時に鍵を読み込むジョブを入れる
# 詳細は config/agent-signing/README.md

if ! is_mac ; then
  echo "skip: macOS only"
  return 0
fi

() {
  local label=net.trpfrog.coding-agent-signing

  mkdir -p ~/.local/bin ~/Library/LaunchAgents || return
  ln -sfn $DOTFILES_ROOT/bin/git-agent-unlock ~/.local/bin/git-agent-unlock || return
  cp $DOTFILES_ROOT/config/agent-signing/$label.plist ~/Library/LaunchAgents/ || return
  launchctl bootout gui/$UID/$label 2>/dev/null
  launchctl bootstrap gui/$UID ~/Library/LaunchAgents/$label.plist
}

# agent-signing: Coding agent のコミット署名 (macOS)
# 詳細は config/agent-signing/README.md

if ! is_mac ; then
  echo "skip: macOS only"
  return 0
fi
"$DOTFILES_ROOT/bin/coding-agent-signing" install

#!/bin/sh

# Config

# [テキストエディット]

# デフォルトをplainにする
defaults write com.apple.TextEdit RichText -bool false


# [Finder]

# Pathバーを表示
defaults write com.apple.finder ShowPathbar -bool true


# [スクリーンショット]

# 影を消す
defaults write com.apple.screencapture disable-shadow -bool true
# 保存場所の変更
mkdir Screenshot
defaults write com.apple.screencapture location ~/Screenshot


# [お節介機能の解除]

# DLしたファイルからの警告を無視
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Capitalizeしない
defaults write -g NSAutomaticCapitalizationEnabled -bool false
# スペルチェックしない
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# .DS_Storeをネットワークボリュームに作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# .DS_Storeを外部ストレージに作らない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


# [便利機能]

# QuickLookでテキストを選択可能に
defaults write com.apple.finder QLEnableTextSelection -bool true
# デフォルトで拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# バッテリーパーセント表示
defaults write com.apple.menuextra.battery ShowPercent -string "YES"


# [高速化]

# Tooltip表示高速化
defaults write -g NSInitialToolTipDelay -int 100
# キーリピートの設定
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

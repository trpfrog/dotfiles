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
# フローティングサムネイルを消す
defaults write com.apple.screencapture show-thumbnail -bool false
# 保存場所の変更
mkdir ~/スクリーンショット
defaults write com.apple.screencapture location ~/スクリーンショット


# [お節介機能の解除]

# DLしたファイルからの警告を無視
defaults write com.apple.LaunchServices LSQuarantine -bool false
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


# [マウス]

# カーソルの速度
defaults write com.apple.mouse.scaling -float 2.5


# [キーボード]

# Capitalizeしない
defaults write -g NSAutomaticCapitalizationEnabled -bool false
# スペルチェックしない
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# アルファベット長押しで文字種の候補が出ないようにする
defaults write -g ApplePressAndHoldEnabled -bool false
# スペースキー2回でピリオドが自動挿入されないようにする
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
# タイプミスの自動修正
defaults write com.apple.inputmethod.Kotoeri.JIMPrefAutocorrectionKey -bool false
# 日本語モードでも半角数字を使う
defaults write com.apple.inputmethod.Kotoeri.JIMPrefFullWidthNumeralCharactersKey -bool false
# Shift を押したときにカタカナが入力されるようにする
defaults write com.apple.inputmethod.Kotoeri.JIMPrefShiftKeyActionKey -int 0
# キーリピートの設定
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

# [その他]

# Tooltip表示高速化
defaults write -g NSInitialToolTipDelay -int 100

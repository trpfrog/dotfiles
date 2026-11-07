# install items

`install.sh` が実行するインストール項目。1 項目 1 ファイルで置く。
外部ツールをインストールする処理と、端末ごとに選びたい処理 (`agent-signing`) を置く。それ以外は `bin/deploy.sh` で常に実行する。
`install.sh` は、端末ごとの設定 (`config.yaml`) の `install` に書かれた項目だけを、上から順に実行する。

```yaml
install:
  - homebrew
  - sheldon
  - mise
```

設定に不備 (書き方の誤り、存在しない項目、重複) があるときや、引数で指定した設定が読めないときは、`bin/deploy.sh` も含めて何も実行せずに終了する。
項目を追加したら、`config.schema.json` の `install` の `oneOf` にも説明付きで追加する。

どの端末でどの項目を有効にしているかは、この公開リポジトリに書かない。

各項目は `install.sh` と同じシェルで読み込まれる。`is_mac` / `is_linux` と `$DOTFILES_ROOT` を使える。
失敗したら 0 以外を返す (`exit` は使わず `return` する)。

| 項目 | 内容 | 必要な項目 |
|---|---|---|
| `xcode-clt` | Xcode Command Line Tools (macOS) | |
| `homebrew` | Homebrew (macOS) | |
| `sfmono` | SF Mono Square フォント (macOS) | `homebrew` |
| `sheldon` | zsh プラグインマネージャ | macOS では `homebrew` |
| `mise` | ランタイムのバージョン管理 | macOS では `homebrew` |
| `fzf` | ファジーファインダー | macOS では `homebrew` |
| `ghq` | リポジトリ管理 | macOS では `homebrew`、Linux では `mise` |
| `agent-signing` | Coding agent のコミット署名 (macOS) | |

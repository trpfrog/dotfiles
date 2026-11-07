# lib/config.zsh
# 端末ごとの設定ファイル (config.yaml) を読み込む。
#
# config.yaml は YAML のサブセットで書く。zsh の組み込み機能だけで読むので、
# まっさらな端末でも追加のツールなしに読み込める。
# サブセット外の書き方や、知らないキーはエラーにする。
#
# 使える書き方:
#   key: value          スカラー (英数字と ._@/:+-~ だけの値、または "..." / '...')
#   key:                入れ子 (2 スペース下げた行が続く。2 段まで)
#     - value           リストの要素
#   key: []             空のリスト
#   # comment          行全体のコメント、値の後ろの " # comment"
# 使えない書き方: タブ、[a, b] や {a: b}、アンカー、複数行の文字列、エスケープ
#
# 使い方:
#   dotfiles_config_load [file]        読み込む。不備があれば 1 を返す
#   dotfiles_config_get git.email      スカラーを REPLY に入れる (なければ 1 を返す)
#   dotfiles_config_get_path homebrew.brewfile
#                                      パスを展開して REPLY に入れる (なければ 1 を返す)
#                                      ~/ はホームディレクトリ、相対パスは config.yaml のあるディレクトリから
#   dotfiles_config_list install       リストを reply に入れる
#
# キーを増やすときは、下の _dotfiles_config_keys と config.schema.json の両方を更新する。

# 使えるキーと種類 (scalar / list / path)。path は、書き方は scalar で、存在するファイルを指す必要がある
typeset -gA _dotfiles_config_keys=(
  install      list
  git.name     scalar
  git.email    scalar
  homebrew.brewfile  path
)

typeset -gA dotfiles_config
typeset -g dotfiles_config_file
typeset -gi dotfiles_config_found=0

# 読み込む設定ファイルのパス: $DOTFILES_CONFIG、なければ ~/dotfiles/config.yaml
function dotfiles_config_path() {
  REPLY=${DOTFILES_CONFIG:-${DOTFILES_ROOT:-$HOME/dotfiles}/config.yaml}
}

function dotfiles_config_get() {
  (( ${+dotfiles_config[$1]} )) || return 1
  REPLY=${dotfiles_config[$1]}
}

function dotfiles_config_get_path() {
  dotfiles_config_get $1 || return 1
  local p=$REPLY
  if [[ $p == '~' || $p == '~/'* ]] ; then
    p=$HOME${p#\~}
  elif [[ $p != /* ]] ; then
    p=${dotfiles_config_file:A:h}/$p
  fi
  REPLY=$p
}

function dotfiles_config_list() {
  reply=(${(f)dotfiles_config[$1]})
}

function _dotfiles_config_err() {
  print -u2 "$_dotfiles_config_pos: $1"
  return 1
}

# 値を検証して REPLY に入れる
function _dotfiles_config_scalar() {
  local v=$1 q rest
  if [[ $v == [\"\']* ]] ; then
    # 引用符で囲んだ値。閉じ引用符の後ろはコメントだけを許す
    q=${v[1]}
    rest=${v[2,-1]}
    [[ $rest == *$q* ]] || { _dotfiles_config_err "unterminated quote: $1"; return 1 }
    v=${rest%%$q*}
    rest=${rest#*$q}
    [[ -z $rest || $rest == ' '##'#'* ]] || { _dotfiles_config_err "unexpected text after quote: $1"; return 1 }
    [[ $q == \" && $v == *\\* ]] && { _dotfiles_config_err "escapes are not supported: $1"; return 1 }
  elif [[ $v == [\[\{]* ]] ; then
    _dotfiles_config_err "flow style ([a, b] / {a: b}) is not supported; use one '- value' per line: $1"
    return 1
  elif [[ $v == '~' || ! $v =~ '^[A-Za-z0-9._@/:+~-]+$' ]] ; then
    _dotfiles_config_err "unsupported value (quote it): $1"
    return 1
  fi
  REPLY=$v
}

# 読み込んだ値を、キーの種類を確認してから保存する
function _dotfiles_config_set() {
  local key=$1 kind=$2 value=$3
  local expected=${_dotfiles_config_keys[$key]}
  [[ -n $expected ]] || { _dotfiles_config_err "unknown key: $key"; return 1 }
  [[ $expected == path ]] && expected=scalar
  [[ $expected == $kind ]] || { _dotfiles_config_err "$key must be a $expected"; return 1 }
  if [[ $kind == list ]] ; then
    [[ $value == *[[:space:]]* ]] && { _dotfiles_config_err "list items cannot contain spaces: $value"; return 1 }
    dotfiles_config[$key]+=${dotfiles_config[$key]:+$'\n'}$value
  else
    dotfiles_config[$key]=$value
  fi
}

function dotfiles_config_load() {
  emulate -L zsh
  setopt extendedglob
  local file=$1 line body indent key value full n=0 depth
  local -a path_stack kind_stack   # kind: map / list / ? (中身がまだない)
  local -A seen
  local _dotfiles_config_pos

  if [[ -z $file ]] ; then
    dotfiles_config_path
    file=$REPLY
  fi
  dotfiles_config=()
  dotfiles_config_file=$file
  dotfiles_config_found=0
  [[ -e $file ]] || return 0
  [[ -f $file && -r $file ]] || { print -u2 "cannot read config: $file"; return 1 }
  dotfiles_config_found=1

  while IFS= read -r line || [[ -n $line ]] ; do
    (( n++ ))
    _dotfiles_config_pos="$file:$n"
    [[ $line == *$'\t'* ]] && { _dotfiles_config_err "tabs are not allowed"; return 1 }
    # 値の後ろのコメントと行末の空白を除く (引用符を含む行は _dotfiles_config_scalar で扱う)
    [[ $line != *[\"\']* ]] && line=${line%% \#*}
    line=${line%%[[:space:]]#}
    [[ -z $line || $line == [[:space:]]#\#* ]] && continue

    body=${line##[ ]#}
    indent=$(( ${#line} - ${#body} ))
    (( indent % 2 )) && { _dotfiles_config_err "indent must be a multiple of 2"; return 1 }
    depth=$(( indent / 2 ))
    (( depth > ${#path_stack} )) && { _dotfiles_config_err "unexpected indent"; return 1 }

    # インデントが戻った分だけ入れ子を閉じる
    path_stack=(${path_stack[1,depth]})
    kind_stack=(${kind_stack[1,depth]})

    if [[ $body == '-' || $body == '- '* ]] ; then
      (( depth == 0 )) && { _dotfiles_config_err "list item without a key"; return 1 }
      [[ ${kind_stack[-1]} == map ]] && { _dotfiles_config_err "cannot mix list items and keys"; return 1 }
      kind_stack[-1]=list
      _dotfiles_config_scalar "${body##-[ ]#}" || return 1
      _dotfiles_config_set "${(j:.:)path_stack}" list "$REPLY" || return 1
      continue
    fi

    [[ $body == *:* ]] || { _dotfiles_config_err "expected 'key:' or '- value'"; return 1 }
    key=${body%%:*}
    value=${body#*:}
    [[ $key =~ '^[a-z0-9_-]+$' ]] || { _dotfiles_config_err "invalid key: $key"; return 1 }
    if (( depth > 0 )) ; then
      [[ ${kind_stack[-1]} == list ]] && { _dotfiles_config_err "cannot mix list items and keys"; return 1 }
      kind_stack[-1]=map
    fi
    full=${${(j:.:)path_stack}:+${(j:.:)path_stack}.}$key
    [[ -n ${seen[$full]} ]] && { _dotfiles_config_err "duplicate key: $full"; return 1 }
    seen[$full]=1

    if [[ -z $value ]] ; then
      # 入れ子を開くキーも、使えるキーのどれかにつながっていなければエラーにする
      if [[ ${_dotfiles_config_keys[$full]} == (scalar|path) ]] ; then
        _dotfiles_config_err "$full must be a scalar"; return 1
      elif [[ -z ${_dotfiles_config_keys[$full]} && -z ${(M)${(k)_dotfiles_config_keys}:#$full.*} ]] ; then
        _dotfiles_config_err "unknown key: $full"; return 1
      fi
      path_stack+=($key)
      kind_stack+=('?')
    else
      [[ $value == ' '* ]] || { _dotfiles_config_err "a space is required after ':'"; return 1 }
      if [[ $value == ' []' ]] ; then
        # 空のリスト
        [[ ${_dotfiles_config_keys[$full]} == list ]] || { _dotfiles_config_err "$full is not a list"; return 1 }
        dotfiles_config[$full]=
        continue
      fi
      _dotfiles_config_scalar "${value# }" || return 1
      _dotfiles_config_set "$full" scalar "$REPLY" || return 1
    fi
  done < $file
}

# 読み込んだ設定が、この repo にある項目やモジュールを指しているか確認する。
# 問題があれば、すべて表示して 1 を返す
function dotfiles_config_check() {
  emulate -L zsh
  local root=${DOTFILES_ROOT:-$HOME/dotfiles} key name dir ext
  local -a errors
  local -A seen
  for key dir ext in install install .sh ; do
    seen=()
    dotfiles_config_list $key
    for name in $reply ; do
      if [[ ! $name =~ '^[a-z0-9-]+$' ]] ; then
        errors+=("$key: invalid name: $name")
      elif [[ ! -f $root/$dir/$name$ext ]] ; then
        errors+=("$key: unknown item: $name")
      elif [[ -n ${seen[$name]} ]] ; then
        errors+=("$key: duplicate item: $name")
      fi
      seen[$name]=1
    done
  done
  # path の値は、存在するファイルを指していなければならない
  for key in ${(k)_dotfiles_config_keys[(R)path]} ; do
    dotfiles_config_get_path $key || continue
    [[ -f $REPLY ]] || errors+=("$key: file not found: $REPLY")
  done
  if (( ${#errors} )) ; then
    print -u2 "invalid config: $dotfiles_config_file"
    print -u2 -l -- "  - "${^errors}
    return 1
  fi
}

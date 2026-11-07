#!/usr/bin/env zsh

function is_mac() { [[ `uname` = "Darwin" ]] }
function is_linux() { [[ `uname` = "Linux" ]] }

if ! is_mac && ! is_linux ; then
  echo "Warning: trpfrog/dotfiles only supports macOS and Linux"
  exit 1
fi

# if $SHELL does not zsh, exit
if [[ ! $SHELL =~ /zsh$ ]] ; then
  echo "Warning: Please change your shell to zsh"
  exit 1
fi

DOTFILES_ROOT="$HOME/dotfiles"

# 端末ごとの設定: 引数で指定するか、$DOTFILES_CONFIG か ~/dotfiles/config.yaml を使う
# 書き方は config.example.yaml を参照
source $DOTFILES_ROOT/lib/config.zsh
if [[ -n $1 ]] ; then
  if [[ ! -f $1 ]] ; then
    echo "Error: cannot read config: $1"
    exit 1
  fi
  export DOTFILES_CONFIG=${1:A}
fi

# 設定に不備があれば、deploy.sh も含めて何もせずに終了する
if ! dotfiles_config_load || ! dotfiles_config_check ; then
  echo "Nothing was installed."
  exit 1
fi
dotfiles_config_list install
items=($reply)

echo "Install TrpFrog's environment"
if (( dotfiles_config_found )) ; then
  echo "Config: $dotfiles_config_file"
else
  echo "No config found at $dotfiles_config_file; only symlinks will be created."
fi
if (( ${#items} )) ; then
  echo "Install items:"
  printf '  - %s\n' $items
fi
if dotfiles_config_get_path homebrew.brewfile ; then
  brewfile=$REPLY
  echo "Brewfile: $brewfile (installed with brew bundle if Homebrew is available)"
else
  brewfile=
  echo "Brewfile: not set (homebrew.brewfile)"
fi
echo "To continue, please enter Y"
read x
if [[ $x != Y ]] ; then
  exit 0
fi

# Symlink dotfiles
source $DOTFILES_ROOT/bin/deploy.sh

# Minimal environment variables needed during installation
export PATH="$HOME/.local/bin:$PATH"

# Update apt
if is_linux && (( ${#items} )) ; then
  apt update
fi

# リストの順に実行する。項目は同じシェルで読み込むので、PATH などは後の項目に引き継がれる
for item in $items ; do
  echo "==> $item"
  if ! source "$DOTFILES_ROOT/install/$item.sh" ; then
    echo "Error: install item failed: $item"
    exit 1
  fi
done

# Brewfile: config.yaml の homebrew.brewfile に明示したときだけ
# 書かなければ何もしない (別の端末の Brewfile を誤って入れないため)
if [[ -n $brewfile ]] ; then
  if type brew > /dev/null 2>&1 ; then
    echo "==> brew bundle ($brewfile)"
    if ! brew bundle --file="$brewfile" ; then
      echo "Error: brew bundle failed"
      exit 1
    fi
  else
    echo "Skip brew bundle: Homebrew is not available"
  fi
fi

source $HOME/.zshrc
cat $DOTFILES_ROOT/next_step.txt

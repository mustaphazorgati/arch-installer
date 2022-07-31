#!/bin/sh

DOTFILES_HOME="$HOME/.dotfiles"
DOTFILES_REPO_HTTP_URL="https://github.com/mustaphazorgati/dotfiles.git"

function config {
   /usr/bin/git --git-dir="$DOTFILES_HOME" --work-tree=$HOME $@
}

function backup_file {
  echo "backing up $1"
  mkdir -p "$(dirname ".config-backup/$1")"
  mv "$1" ".config-backup/$1"
}
export -f backup_file

function checkout {
  mkdir -p $HOME/.config-backup
  config checkout
  if [ $? = 0 ]; then
    echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    cd 
    config checkout 2>&1 | egrep "^[[:space:]]+\S+" | awk {'print $1'} | xargs -n1 sh -c 'backup_file "$@"' _
    cd -
  fi;
  config checkout
}

if [[ -d "$DOTFILES_HOME" ]]; then
  echo "dotfiles repo already exists. updating repo..."
  checkout
  config pull
  config config --local status.showUntrackedFiles no
  exit 0
fi
git clone --bare "$DOTFILES_REPO_HTTP_URL" "$DOTFILES_HOME"
checkout
config config --local status.showUntrackedFiles no

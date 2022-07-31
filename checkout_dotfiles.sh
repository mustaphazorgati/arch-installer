#!/bin/sh

DOTFILES_HOME="$HOME/.dotfiles"
DOTFILES_REPO_HTTP_URL="https://github.com/mustaphazorgati/dotfiles.git"

function config {
   /usr/bin/git --git-dir="$DOTFILES_HOME" --work-tree=$HOME $@
}

if [[ -d "$DOTFILES_HOME" ]]; then
       echo "dotfiles repo already exists. updating repo..."
       config checkout
       config pull
       exit 0
fi

git clone --bare "$DOTFILES_REPO_HTTP_URL" "$DOTFILES_HOME"
mkdir -p $HOME/.config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config --local status.showUntrackedFiles no

#!/bin/sh

if [[ -d "$HOME/.installer" ]]; then
  cd "$HOME/.installer"
  git pull
  cd -
else
  git clone https://github.com/mustaphazorgati/arch-installer.git $HOME/.installer
fi

$HOME/.installer/install.sh

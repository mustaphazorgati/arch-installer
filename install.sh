#/bin/sh
set +x

REL="$(dirname "$0")"
DOTFILES_HOME="$HOME/.dotfiles"

function config {
   /usr/bin/git --git-dir="$DOTFILES_HOME" --work-tree=$HOME $@
}

"$REL/yay/install_yay.sh"
"$REL/yay/install_yay_packages.sh"

"$REL/checkout_dotfiles.sh"

cd $REL
git remote set-url origin git@github.com:mustaphazorgati/arch-installer.git
cd -
config remote set-url origin git@github.com:mustaphazorgati/dotfiles.git

"$REL/system-connections/restore_system_connections.sh"
"$REL/gpg/restore_gpg_keys.sh"
"$REL/ssh/restore_ssh_folder.sh"

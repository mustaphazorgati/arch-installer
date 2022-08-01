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

"$REL/restore.sh"

# BLUETOOTH
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# SCREENSHOT
mkdir -p $HOME/Pictures
gsettings set org.gnome.gnome-screenshot auto-save-directory $HOME/Pictures/

# SECURITY
sudo passwd -l root
sudo systemctl disable sshd
sudo systemctl stop sshd

# VIM
VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if [[ -d "$VUNDLE_DIR" ]]; then
  cd "$VUNDLE_DIR"
  git pull
  cd -
else
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
fi
echo | vim +PluginInstall +qall

# SWAP

if [[ ! -e "/swapfile" ]]; then
  sudo dd if=/dev/zero of=/swapfile bs=4M count=12288 status=progress
  sudo chmod 0600 /swapfile
  sudo mkswap -U clear /swapfile
  sudo swapon /swapfile
  echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
fi

#/bin/sh
set -e

REL="$(dirname "$0")"
DOTFILES_HOME="$HOME/.dotfiles"

function config {
   /usr/bin/git --git-dir="$DOTFILES_HOME" --work-tree=$HOME $@
}

# enable multilib repository, if not enabled yet
sudo sed -i -r '/^#?\[multilib\]$/,+2 s/^#//' /etc/pacman.conf
if [[ ! "$(grep "^\[multilib\]$" /etc/pacman.conf)" ]]; then 
  echo '[multilib]' | sudo tee -a /etc/pacman.conf
  echo 'Include = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf
fi

"$REL/yay/install_yay.sh"
yay -Syy
"$REL/yay/install_yay_packages.sh"

"$REL/checkout_dotfiles.sh"

cd $REL
git remote set-url origin git@github.com:mustaphazorgati/arch-installer.git
cd -
config remote set-url origin git@github.com:mustaphazorgati/dotfiles.git

gdown --folder https://drive.google.com/drive/folders/12NUcpJUnYEIr2X7bSQR9gvvwpwl25tZa -O "$REL/.encrypted"
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

# SSH Agent
systemctl --user start ssh-agent
systemctl --user enable ssh-agent

# Docker
sudo systemctl start docker
sudo systemctl enable docker
[[ -z "$(getent group docker)" ]] && sudo groupadd docker
sudo usermod -aG docker $USER

# Disable Laptop speaker
sudo modprobe -r pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/blacklist.conf

# X11 config
[[ -e /etc/X11/xorg.conf.d/30-touchpad.conf ]] && sudo rm /etc/X11/xorg.conf.d/30-touchpad.conf
sudo ln -s ~/.config/X11/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

# NetworkManager
[[ -e /etc/NetworkManager/dispatcher.d/10-ntp-over-dhcp ]] && sudo rm /etc/NetworkManager/dispatcher.d/10-ntp-over-dhcp
sudo cp ~/.config/NetworkManager/dispatcher.d/10-ntp-over-dhcp /etc/NetworkManager/dispatcher.d/10-ntp-over-dhcp

# enforce keymap during boot
sudo mkinitcpio -P

# configure fish
[[ cat /etc/shells | grep "$(which fish)" ]] || echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"

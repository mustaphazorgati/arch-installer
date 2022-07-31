#!/bin/sh

sudo pacman -S git --noconfirm --needed

sudo rm -rf /tmp/yay
sudo git clone https://aur.archlinux.org/yay.git /tmp/yay
sudo chown -R ""$(whoami)":"$(id -g -n)"" /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm --needed
cd -

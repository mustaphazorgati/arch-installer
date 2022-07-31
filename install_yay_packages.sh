#!/bin/sh

packages_file="$(dirname "$0")/packages.txt"

if [[ -e "$packages_file" ]]; then
  yay -S - --needed --noconfirm < "$packages_file"
fi

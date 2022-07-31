#!/bin/sh

ENV_FILE="$(dirname "$0")/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

TARGET_FILE="$HOME/.encrypted_dotfiles/system-connections.7z"
[[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"
sudo 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p"${SYSTEM_CONNECTIONS_PW}" "$TARGET_FILE" /etc/NetworkManager/system-connections/*
sudo chown ""$(whoami)":"$(id -g -n)"" "$TARGET_FILE"



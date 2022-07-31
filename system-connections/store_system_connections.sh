#!/bin/sh

REL="$(dirname "$0")"
ENV_FILE="$REL/../.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

TARGET_FILE="$HOME/.encrypted_dotfiles/system-connections.7z"
[[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

"$REL/../7z/encrypt.sh" -s -i /etc/NetworkManager/system-connections/* -t "$TARGET_FILE" -p "${SYSTEM_CONNECTIONS_PW}"

sudo chown ""$(whoami)":"$(id -g -n)"" "$TARGET_FILE"



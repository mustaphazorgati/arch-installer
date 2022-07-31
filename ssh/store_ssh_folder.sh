#!/bin/sh

REL="$(dirname "$0")"
ENV_FILE="$REL/../.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

TARGET_FILE="$HOME/.encrypted_dotfiles/ssh.7z"
[[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

"$REL/../7z/encrypt.sh" -i "$HOME/.ssh/*" -t "$TARGET_FILE" -p "${SSH_PW}"


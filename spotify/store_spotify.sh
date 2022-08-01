#!/bin/sh

REL="$(dirname "$0")"
ENV_FILE="$REL/../.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

TARGET_FILE="$HOME/.encrypted_dotfiles/spotify.7z"
[[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

"$REL/../7z/encrypt.sh" -i "$HOME/.config/spotify/*" -t "$TARGET_FILE" -p "$SPOTIFY_PW"

sudo chown ""$(whoami)":"$(id -g -n)"" "$TARGET_FILE"


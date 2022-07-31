#!/bin/sh

REL="$(dirname "$0")"
ENV_FILE="$REL/../.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

gpg --export-secret-keys > private.key

TARGET_FILE="$HOME/.encrypted_dotfiles/gpg.7z"
[[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

"$REL/../7z/encrypt.sh" -i private.key -t "$TARGET_FILE" -p "$GPG_PW"

rm -f private.key

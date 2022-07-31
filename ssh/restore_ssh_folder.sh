#!/bin/sh
set +x

REL="$(dirname "$0")"

RESTORE_FILE="$HOME/.encrypted_dotfiles/ssh.7z"
[[ ! -e "$RESTORE_FILE" ]] && echo "'$RESTORE_FILE' does not exist. Can't restore system-connections" >&2 && exit 1

ENV_FILE="$REL/../.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

"$REL/../7z/decrypt.sh" -i "$RESTORE_FILE" -t $HOME/.ssh -p "$SSH_PW"


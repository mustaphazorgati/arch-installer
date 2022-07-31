#!/bin/sh

RESTORE_FILE="$HOME/.encrypted_dotfiles/system-connections.7z"
[[ ! -e "$RESTORE_FILE" ]] && echo "'$RESTORE_FILE' does not exist. Can't restore system-connections" >&2 && exit 1

ENV_FILE="$(dirname "$0")/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

sudo 7z e -aoa $( [[ -n "$SYSTEM_CONNECTIONS_PW" ]] && echo "-p${SYSTEM_CONNECTIONS_PW}" ) -o/etc/NetworkManager/system-connections/ "$RESTORE_FILE"

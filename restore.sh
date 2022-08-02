#!/bin/sh
set +x

REL="$(dirname "$0")"
ENV_FILE="$REL/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

function restore() {
  RESTORE_FILE="$HOME/.encrypted_dotfiles/$SOURCE.7z"
  [[ ! -e "$RESTORE_FILE" ]] && echo "'$RESTORE_FILE' does not exist. Can't restore system-connections" >&2 && exit 1

  $SUDO 7z x -aoa $( [[ -n "$PASSWORD" ]] && echo "-p${PASSWORD}" ) -o"$TARGET" "$RESTORE_FILE"
}

module="$1"
[[ -z "$module" ]] && module="all"

if [[ "$module" == "ssh" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SSH_PW"
  SOURCE="ssh"
  TARGET="$HOME/.ssh"

  restore
fi

if [[ "$module" == "spotify" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SPOTIFY_PW"
  SOURCE="spotify"
  TARGET="$HOME/.config/spotify"

  restore
fi

if [[ "$module" == "system-connections" || "$module" == "all" ]]; then
  SUDO="sudo"
  PASSWORD="$SYSTEM_CONNECTIONS_PW"
  SOURCE="system-connections"
  TARGET="/etc/NetworkManager/system-connections"

  restore
fi

if [[ "$module" == "gpg" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GPG_PW"
  SOURCE="gpg"
  TARGET="."

  restore
  gpg --import private.key
  rm -f private.key
fi

if [[ "$module" == "google-chrome" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GOOGLE_CHROME_PW"
  SOURCE="google-chrome"
  TARGET="$HOME/.config/google-chrome"

  restore
fi


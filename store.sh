#!/bin/sh
set +x

REL="$(dirname "$0")"
ENV_FILE="$REL/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

function store() {
  TARGET_FILE="$HOME/.encrypted_dotfiles/$TARGET.7z"
  [[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

  $SUDO 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p"${PASSWORD}" "$TARGET_FILE" "$SOURCE"

}

module="$1"
[[ -z "$module" ]] && module="all"

if [[ "$module" == "ssh" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SSH_PW"
  SOURCE="$HOME/.ssh/*"
  TARGET="ssh"

  store
fi

if [[ "$module" == "spotify" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SPOTIFY_PW"
  SOURCE="$HOME/.config/spotify/*"
  TARGET="spotify"

  store
fi

if [[ "$module" == "system-connections" || "$module" == "all" ]]; then
  SUDO="sudo"
  PASSWORD="$SYSTEM_CONNECTIONS_PW"
  SOURCE="/etc/NetworkManager/system-connections/*"
  TARGET="system-connections"

  store
  sudo chown ""$(whoami)":"$(id -g -n)"" "$TARGET_FILE"
fi

if [[ "$module" == "gpg" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GPG_PW"
  SOURCE="private.key"
  TARGET="gpg"
  
  gpg --export-secret-keys > "$SOURCE"
  store
  rm -f "$SOURCE"
fi


#!/bin/sh
set -e

REL="$(dirname "$0")"
ENV_FILE="$REL/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

function store() {
  TARGET_FILE="$REL/.encrypted/$TARGET.7z"
  [[ -e "$TARGET_FILE" ]] && rm "$TARGET_FILE"

  eval "$SUDO 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on -mhe=on -p'${PASSWORD}' \"$TARGET_FILE\" \"$SOURCE\" $ADDITIONAL"
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
  SOURCE="$(dirname "$0")/.export/*"
  TARGET="gpg"

  mkdir -p "$(dirname "$SOURCE")"
  gpg --export-secret-keys > "$(dirname "$SOURCE")/private.key"
  gpg --export-ownertrust > "$(dirname "$SOURCE")/ownertrust.key"
  store
  rm -rf "$(dirname "$SOURCE")"
fi

if [[ "$module" == "google-chrome" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GOOGLE_CHROME_PW"
  SOURCE="$HOME/.config/google-chrome/*"
  TARGET="google-chrome"
  
  store
fi

if [[ "$module" == "gitkraken" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GITKRAKEN_PW"
  SOURCE="$HOME/.gitkraken/*"
  TARGET="gitkraken"
  
  store
fi

if [[ "$module" == "telegram" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$TELEGRAM_PW"
  SOURCE="$HOME/.local/share/TelegramDesktop/*"
  TARGET="telegram"
  
  store
fi


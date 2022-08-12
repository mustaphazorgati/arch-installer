#!/bin/sh
set -e

REL="$(dirname "$0")"
ENV_FILE="$REL/.env"
[[ -e "$ENV_FILE" ]] && export $(grep -v '^#' "$ENV_FILE" | xargs)

function restore() {
  RESTORE_FILE="$REL/.encrypted/$SOURCE.7z"
  [[ ! -e "$RESTORE_FILE" ]] && echo "'$RESTORE_FILE' does not exist. Can't restore system-connections" >&2 && exit 1
  [[ -e "$TARGET" ]] && sudo rm -rf "$TARGET"

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
  sudo systemctl restart NetworkManager
fi

if [[ "$module" == "gpg" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GPG_PW"
  SOURCE="gpg"
  TARGET="$(dirname "$0")/.export"

  restore
  gpg --import "$(realpath "$TARGET/private.key")"
  gpg --import-ownertrust "$(realpath "$TARGET/ownertrust.key")"
  rm -rf "$TARGET"
fi

if [[ "$module" == "google-chrome" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GOOGLE_CHROME_PW"
  SOURCE="google-chrome"
  TARGET="$HOME/.config/google-chrome"

  restore
fi

if [[ "$module" == "gitkraken" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$GITKRAKEN_PW"
  SOURCE="gitkraken"
  TARGET="$HOME/.gitkraken"

  restore
fi

if [[ "$module" == "telegram" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$TELEGRAM_PW"
  SOURCE="telegram"
  TARGET="$HOME/.local/share/TelegramDesktop"

  restore
fi

if [[ "$module" == "slack" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SLACK_PW"
  SOURCE="slack"
  TARGET="$HOME/.config/Slack"

  restore
fi

if [[ "$module" == "signal" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$SIGNAL_PW"
  SOURCE="signal"
  TARGET="$HOME/.config/Signal"

  restore
fi

if [[ "$module" == "jetbrains" || "$module" == "all" ]]; then
  SUDO=""
  PASSWORD="$JETBRAINS_PW"
  SOURCE="jetbrains"
  TARGET="$HOME/.config/JetBrains"

  restore
fi


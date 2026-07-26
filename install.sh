#!/usr/bin/env bash
#
# One-line installer for this Karabiner-Elements config.
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kyleczhang/karabiner-config/main/install.sh)"
#
# It downloads karabiner.json into Karabiner-Elements' config directory,
# replacing any existing config.

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/kyleczhang/karabiner-config/main"
SRC_NAME="karabiner.json"

# Karabiner-Elements reads its config from
# $XDG_CONFIG_HOME/karabiner/karabiner.json (defaults to
# ~/.config/karabiner/karabiner.json).
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/karabiner"
CONFIG_FILE="$CONFIG_DIR/karabiner.json"

# --- pretty output --------------------------------------------------------
bold() { printf '\033[1m%s\033[0m\n' "$1"; }
info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31mError:\033[0m %s\n' "$1" >&2; }

# --- prerequisites --------------------------------------------------------
if ! command -v curl >/dev/null 2>&1; then
  err "curl is required but not found."
  exit 1
fi

bold "Karabiner-Elements config installer"
info "Target: $CONFIG_FILE"

# --- create config dir ----------------------------------------------------
mkdir -p "$CONFIG_DIR"

# --- download into a temp file, then move into place ----------------------
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

info "Downloading $SRC_NAME ..."
if ! curl -fsSL "$REPO_RAW/$SRC_NAME" -o "$TMP_FILE"; then
  err "Download failed from $REPO_RAW/$SRC_NAME"
  exit 1
fi

# Sanity check: file is non-empty.
if [ ! -s "$TMP_FILE" ]; then
  err "Downloaded file is empty."
  exit 1
fi

mv "$TMP_FILE" "$CONFIG_FILE"
trap - EXIT

ok "Installed config to $CONFIG_FILE"

# --- next steps -----------------------------------------------------------
echo
bold "Done!"
echo "  • Karabiner-Elements reloads the config automatically on change."
echo "  • If it isn't installed yet, get it with:"
echo "      brew install --cask karabiner-elements"
echo "  • Open Karabiner-Elements and grant it Input Monitoring + Accessibility"
echo "    permissions in System Settings > Privacy & Security."

#!/usr/bin/env bash
#
# Local installer for this Karabiner-Elements config.
#
# Installs karabiner.json from this repo (the file sitting next to this
# script) into Karabiner-Elements' config directory, replacing any existing
# config. Use this instead of install.sh when you have the repo checked out
# locally and want to install your working copy.
#
#   ./install-local.sh
#
set -euo pipefail

# Directory this script lives in, so it works from any cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC_CONFIG="$SCRIPT_DIR/karabiner.json"

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

bold "Karabiner-Elements config installer (local)"
info "Source: $SRC_CONFIG"
info "Target: $CONFIG_FILE"

# --- prerequisites: source file must exist --------------------------------
if [ ! -f "$SRC_CONFIG" ]; then
  err "Missing source file: $SRC_CONFIG"
  exit 1
fi

# --- create config dir ----------------------------------------------------
mkdir -p "$CONFIG_DIR"

# --- install file ---------------------------------------------------------
cp "$SRC_CONFIG" "$CONFIG_FILE"
ok "Installed config to $CONFIG_FILE"

echo
bold "Done!"

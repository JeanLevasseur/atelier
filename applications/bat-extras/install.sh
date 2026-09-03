#!/bin/sh

###############################################################################
# Configuration
###############################################################################

APPLICATION="bat-extras"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

FISH_CONFIG_DIR="$XDG_CONFIG_HOME/fish/conf.d"
SOURCE_FISH_CONFIG="$SCRIPT_DIR/shells/fish/conf.d/$APPLICATION.fish"
TARGET_FISH_CONFIG="$FISH_CONFIG_DIR/$APPLICATION.fish"

###############################################################################
# Library
###############################################################################

. "$SCRIPT_DIR/../../lib/application_install.sh"

###############################################################################
# Preconditions
###############################################################################

require_directory "$FISH_CONFIG_DIR"
check_target_path "$TARGET_FISH_CONFIG"
warn_if_missing_command "bat"
require_installed "fish"

###############################################################################
# Installation
###############################################################################

ln -s "$SOURCE_FISH_CONFIG" "$TARGET_FISH_CONFIG"

###############################################################################
# Verification
###############################################################################

verify_symlink "$TARGET_FISH_CONFIG" "$SOURCE_FISH_CONFIG"

###############################################################################
# Success
###############################################################################

mark_installed "$APPLICATION"
success "$APPLICATION module installed."

#!/bin/sh

###############################################################################
# Configuration
###############################################################################

APPLICATION="bat"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

SOURCE_DIR="$SCRIPT_DIR/config"
TARGET_DIR="$XDG_CONFIG_HOME/$APPLICATION"

###############################################################################
# Library
###############################################################################

. "$SCRIPT_DIR/../../lib/application_install.sh"

###############################################################################
# Preconditions
###############################################################################

require_directory "$XDG_CONFIG_HOME"
check_target_path "$TARGET_DIR"
warn_if_missing_command "$APPLICATION"

###############################################################################
# Installation
###############################################################################

ln -s "$SOURCE_DIR" "$TARGET_DIR"

###############################################################################
# Verification
###############################################################################

verify_symlink "$TARGET_DIR" "$SOURCE_DIR"

success "$APPLICATION module installed."

#!/bin/sh

###############################################################################
# Logging
###############################################################################

info() {
    printf 'INFO: %s\n' "$*"
}

success() {
    printf 'SUCCESS: %s\n' "$*"
}

warning() {
    printf 'WARNING: %s\n' "$*" >&2
}

error() {
    printf 'ERROR: %s\n' "$*" >&2
}

###############################################################################
# Errors
###############################################################################

die() {
    error "$@"
    exit 1
}

###############################################################################
# Preconditions
###############################################################################

require_variable() {
    variable_name="$1"

    eval "value=\${$variable_name:-}"

    if [ -z "$value" ]; then
        die "Required variable '$variable_name' is not defined."
    fi
}

require_directory() {
    directory="$1"

    if [ ! -d "$directory" ]; then
        die "Required directory does not exist: $directory"
    fi
}

check_target_path() {
    target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        die "Target already exists: $target"
    fi
}

###############################################################################
# Dependencies
###############################################################################

warn_if_missing_command() {
    command_name="$1"

    if ! command -v "$command_name" >/dev/null 2>&1; then
        warning "'$command_name' was not found in PATH."
    fi
}

###############################################################################
# Filesystem inspection
###############################################################################

symlink_points_to() {
    link="$1"
    expected="$2"

    if [ ! -L "$link" ]; then
        return 1
    fi

    actual=$(readlink "$link")

    if [ "$actual" = "$expected" ]; then
        return 0
    fi

    return 1
}

verify_symlink() {
    target="$1"
    source="$2"

    if ! symlink_points_to "$target" "$source"; then
        die "Verification failed: $target does not point to $source."
    fi
}

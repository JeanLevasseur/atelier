#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Atelier — Arch Linux root setup
# This script prepares a fresh Arch Linux installation for normal administration.
# It:
# - verifies that it is running as root
# - verifies that the system is Arch Linux
# - updates the system
# - installs sudo
# - creates an administrative user
# - adds the user to the wheel group
# - configures sudo
# - installs an SSH public key for the user
# It intentionally DOES NOT disable root SSH login.
# After this script completes:
# 1. Open a new SSH session using the new user.
# 2. Verify that SSH authentication works.
# 3. Verify that sudo works.
# 4. Only then disable root SSH login.
###############################################################################

###############################################################################
# Configuration
###############################################################################

USERNAME="wheezy"
#Change this before running the script.
SSH_PUBLIC_KEYS=(
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDq7bszJl8zRkh4OTLrmj0XaJ6Ke/pjA8XaTSs89PpQ/ wheezy@daneel"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAzCJESngg+WjIgDlW3XM8ZnQgeXtBDCHSA/8JXYhvbbtL8HZMcZG+oy6KRu8pLgFYwyA1y4N8QSua6QdDTnSd4= wheezy@iphone-16082026"
    ""
)

###############################################################################
# Helper functions
###############################################################################

error() {
    printf ‘Error: %s\n’ “$1” >&2
    exit 1
}

require_root() {
    if [[ “${EUID}” -ne 0 ]]; then
    error “This script must be run as root.”
    fi
}

require_arch_linux() {
    if [[ ! -f /etc/os-release ]]; then
        error “Unable to identify the operating system.”
    fi

    # shellcheck disable=SC1091
    source /etc/os-release
    if [[ "${ID}" != "arch" ]]; then
        error "This script must be run on Arch Linux."
    fi
}

###############################################################################
# System setup
###############################################################################

update_system() {
    printf ‘\n==> Updating system…\n’
    pacman -Syu --noconfirm
}

install_sudo() {
    printf ‘\n==> Installing sudo…\n’
    pacman -S --needed --noconfirm sudo
}

###############################################################################
# User setup
###############################################################################

create_user() {
    if id “${USERNAME}” &>/dev/null; then
        printf ‘\n==> User “%s” already exists.\n’ “${USERNAME}”
        return
    fi

    printf '\n==> Creating user "%s"...\n' "${USERNAME}"
    useradd \
        --create-home \
        --groups wheel \
        --shell /bin/bash \
        "${USERNAME}"
}

configure_sudo() {
    local sudoers_file=”/etc/sudoers.d/10-wheel”

    printf '\n==> Configuring sudo...\n'
    cat > "${sudoers_file}" <<'EOF'
%wheel ALL=(ALL:ALL) ALL
EOF

    chmod 440 "${sudoers_file}"
    visudo -cf "${sudoers_file}"
}

configure_ssh_key() {
    local user_home
    local ssh_directory
    local authorized_keys

    user_home="$(getent passwd "${USERNAME}" | cut -d: -f6)"
    ssh_directory="${user_home}/.ssh"
    authorized_keys="${ssh_directory}/authorized_keys"
    printf '\n==> Configuring SSH key for "%s"...\n' "${USERNAME}"
    install \
        --directory \
        --mode 700 \
        --owner "${USERNAME}" \
        --group "${USERNAME}" \
        "${ssh_directory}"
    printf '%s\n' "${SSH_PUBLIC_KEY}" > "${authorized_keys}"
    chown "${USERNAME}:${USERNAME}" "${authorized_keys}"
    chmod 600 "${authorized_keys}"
}

###############################################################################
# Main
###############################################################################

main() {
    require_root
    require_arch_linux

    update_system
    install_sudo
    create_user
    configure_sudo
    configure_ssh_key
    cat <<EOF
=============================================================================
Root setup complete.
The new user is:
${USERNAME}
IMPORTANT: Root SSH login has NOT been disabled yet.
Before continuing:
1. Open a NEW SSH session.
2. Log in as:
       ${USERNAME}
3. Verify:
       whoami
   Expected:
       ${USERNAME}
4. Verify sudo:
       sudo whoami
   Expected:
       root

Only after these tests succeed should root SSH login be disabled.
=============================================================================
EOF
}

main “$@”

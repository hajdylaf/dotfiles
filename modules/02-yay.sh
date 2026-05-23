#!/usr/bin/env bash
# Build and install yay AUR helper
# Builds as user, installs as root — no sudoers modification needed

MODULE_NAME="Yay Install"

module_run() {
    log "Running $MODULE_NAME..."

    if command -v yay &>/dev/null; then
        log "yay already installed, skipping"
        return
    fi

    # Clone and build as the new user (makepkg refuses to run as root)
    su - "$NEW_USER" -c 'git clone https://aur.archlinux.org/yay.git /tmp/yay-build && cd /tmp/yay-build && makepkg -s --noconfirm'

    # Install the built package as root
    pacman -U --noconfirm /tmp/yay-build/*.pkg.tar.zst

    rm -rf /tmp/yay-build

    log "$MODULE_NAME complete"
}

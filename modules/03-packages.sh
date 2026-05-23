#!/usr/bin/env bash
# Install AUR packages via yay

MODULE_NAME="AUR Packages"

module_run() {
    log "Running $MODULE_NAME..."

    packages=$(grep -v '^\s*#' "$REPO_DIR/packages/aur.txt" | grep -v '^\s*$' | tr '\n' ' ')

    if [ -z "$packages" ]; then
        log "No AUR packages to install"
        return
    fi

    yay -S --needed --noconfirm $packages

    log "$MODULE_NAME complete"
}

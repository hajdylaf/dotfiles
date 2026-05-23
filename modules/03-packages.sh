#!/usr/bin/env bash
# Install AUR packages via yay

MODULE_NAME="AUR Packages"

module_run() {
    log "Running $MODULE_NAME..."

    mapfile -t packages < <(grep -v '^\s*#' "$REPO_DIR/packages/aur.txt" | grep -v '^\s*$')

    if [ ${#packages[@]} -eq 0 ]; then
        log "No AUR packages to install"
        return
    fi

    yay -S --needed --noconfirm "${packages[@]}"

    log "$MODULE_NAME complete"
}

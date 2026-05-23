#!/usr/bin/env bash
# System update and official package installation

MODULE_NAME="System Update"

module_run() {
    log "Running $MODULE_NAME..."

    pacman -Syuu --noconfirm
    packages=$(grep -v '^\s*#' "$REPO_DIR/packages/official.txt" | grep -v '^\s*$' | tr '\n' ' ')
    pacman -S --needed --noconfirm $packages
    pacman -Scc --noconfirm

    log "$MODULE_NAME complete"
}

#!/usr/bin/env bash
# Generate Ed25519 SSH key
# Runs as user via su

MODULE_NAME="SSH Key"

module_run() {
    log "Running $MODULE_NAME..."

    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        log "SSH key already exists, skipping"
        return
    fi

    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""

    log "$MODULE_NAME complete"
}

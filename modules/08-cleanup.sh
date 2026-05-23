#!/usr/bin/env bash
# Clean up temporary files

MODULE_NAME="Cleanup"

module_run() {
    log "Running $MODULE_NAME..."

    rm -rf "$TMPDIR"
    rm -f /tmp/dotfiles-user.sh

    log "$MODULE_NAME complete"
}

#!/usr/bin/env bash
# Run script-based installs (curl, binary downloads, etc.)
# Runs as user via su

MODULE_NAME="Curl Installs"

module_run() {
    log "Running $MODULE_NAME..."

    if [ -f "$REPO_DIR/scripts/curl-installs.sh" ]; then
        # shellcheck disable=SC1090
        source "$REPO_DIR/scripts/curl-installs.sh"
    fi

    log "$MODULE_NAME complete"
}

#!/usr/bin/env bash
# Sync dotfiles to user's home directory
# Runs as user via su

MODULE_NAME="Dotfiles Sync"

module_run() {
    log "Running $MODULE_NAME..."

    if [ -d "$REPO_DIR/overlay/home" ]; then
        rsync -rv "$REPO_DIR/overlay/home/." "$HOME/."
    fi

    # Make scripts executable
    if [ -d "$HOME/.local/bin" ]; then
        chmod +x "$HOME/.local/bin/"*
    fi

    # Clean up oh-my-zsh and bash leftovers from fresh system
    rm -f "$HOME"/.*.pre-oh-my-zsh "$HOME"/.bash*

    log "$MODULE_NAME complete"
}

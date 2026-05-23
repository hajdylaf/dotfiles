#!/usr/bin/env bash
# Install Oh My Zsh unattended
# Runs as user via su

MODULE_NAME="Oh My Zsh"

module_run() {
    log "Running $MODULE_NAME..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log "Oh My Zsh already installed, skipping"
        return
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log "$MODULE_NAME complete"
}

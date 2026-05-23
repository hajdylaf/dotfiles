#!/usr/bin/env bash
# Create user, set passwords, configure sudo

MODULE_NAME="User Setup"

module_run() {
    log "Running $MODULE_NAME..."

    # Create user if not exists
    if ! id "$NEW_USER" &>/dev/null; then
        useradd -G wheel -m "$NEW_USER"
    else
        log "User $NEW_USER already exists, skipping creation"
    fi

    # Set user password
    echo "$NEW_USER:$USER_PASS" | chpasswd

    # Set root password if provided
    if [ -n "$ROOT_PASS" ]; then
        echo "root:$ROOT_PASS" | chpasswd
    fi

    # Install sudo drop-in for wheel group
    mkdir -p /etc/sudoers.d
    install -m 440 "$REPO_DIR/etc/sudoers.d/99-dotfiles" /etc/sudoers.d/99-dotfiles

    # Sync any etc/ files to system (runs as root)
    rsync -rv "$REPO_DIR/etc/" /etc/.

    log "$MODULE_NAME complete"
}

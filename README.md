# dotfiles

My configuration files for Arch Linux WSL, ZSH and other tools.

## Quick start

1. Install WSL (PowerShell):

   ```powershell
   wsl --install -d ArchLinux --location E:/
   ```

2. Run the unified setup (as root inside WSL):

   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/setup.sh)"
   ```

   You'll be prompted for: **username**, **user password**, **root password** (optional), and **SSH email**. Everything else runs automatically.

3. Set default WSL user (PowerShell):

   ```powershell
   wsl --manage ArchLinux --set-default-user user
   ```

## What the script does

| Step | Description |
|------|-------------|
| System update | `pacman -Syuu`, installs all official packages |
| User creation | Creates user with `wheel` group, sets passwords, adds sudo drop-in |
| yay | Builds and installs the AUR helper |
| AUR packages | Installs anything listed in `packages/aur.txt` |
| Dotfiles | Syncs `overlay/home/` configs, sets up scripts, removes bash defaults |
| Oh My Zsh | Installs unattended with `--unattended` flag |
| Curl installs | Runs each command in `scripts/curl-installs.sh` |
| SSH key | Generates Ed25519 key with empty passphrase |
| Cleanup | Removes temporary files |

## Project structure

```
├── setup.sh                  # Entry point — curl | sh or local
├── modules/                  # One file per step, run in numeric order
│   ├── 00-system.sh          # System update + official packages
│   ├── 01-user.sh            # User creation + sudo
│   ├── 02-yay.sh             # yay AUR helper (build as user, install as root)
│   ├── 03-packages.sh        # AUR packages
│   ├── 04-ohmyzsh.sh         # Oh My Zsh (user-phase)
│   ├── 05-dotfiles.sh        # Sync overlay/home/ dotfiles (user-phase)
│   ├── 06-curl-installs.sh   # Script-based installs (user-phase)
│   ├── 07-ssh.sh             # SSH key (user-phase)
│   └── 08-cleanup.sh         # Cleanup temp files
├── packages/
│   ├── official.txt          # Officical repo packages (one per line)
│   └── aur.txt               # AUR packages (one per line)
├── scripts/
│   └── curl-installs.sh      # Paste curl | sh commands here
├── overlay/                  # Mirrors root filesystem
│   ├── etc/
│   │   └── sudoers.d/
│   │       └── 99-dotfiles   # Enables sudo for wheel group
│   └── home/                 # Dotfiles mirrored to $HOME
│       ├── .config/
│       ├── .gitconfig
│       ├── .local/bin/
│       ├── .tmux.conf
│       └── .zshrc
```

## How to add new things

### Add an official package

Edit `packages/official.txt` and add one line per package. That's it — `00-system.sh` reads it automatically.

```
# packages/official.txt
python
nodejs
firefox
```

### Add an AUR package

Edit `packages/aur.txt`:

```
# packages/aur.txt
google-chrome
visual-studio-code-bin
```

### Add a curl-based tool

Append a line to `scripts/curl-installs.sh`. Each command handles its own headless flags:

```bash
# scripts/curl-installs.sh
curl -fsSL https://opencode.sh/install.sh | sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
yes | curl -fsSL https://some-tool.sh/install.sh | sh
```

### Add a config file

Place it in `overlay/home/` or `overlay/etc/` matching the target path:

```
overlay/home/.config/kitty/kitty.conf   →  $HOME/.config/kitty/kitty.conf
overlay/etc/modprobe.d/nobeep.conf      →  /etc/modprobe.d/nobeep.conf
```

`05-dotfiles.sh` picks up `overlay/home/` changes automatically.

### Add a new setup step

1. Create `modules/XX-description.sh` (number controls run order).
2. The module is auto-discovered by `setup.sh`.
3. If it must run as the new user, register it in the `USER_MODULES` list inside `setup.sh`.

```bash
#!/usr/bin/env bash
# modules/XX-mymodule.sh
# Description: What this module does

MODULE_NAME="My Module"

module_run() {
    log "Running $MODULE_NAME..."
    # Access variables: $NEW_USER, $USER_PASS, $SSH_EMAIL
    log "$MODULE_NAME complete"
}
```

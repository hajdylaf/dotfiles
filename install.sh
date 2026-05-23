#!/bin/sh

# check if user is root
if [ ! "$(whoami)" = "root" ]; then
    echo "User not root. Exitting..."
    exit 0
fi

# show startup message
echo
echo "===================================="
echo "#      STARTING INSTALLATION       #"
echo "===================================="
echo

# countdown
for i in {5..1}; do
    printf $i...
    sleep 1
done
echo

## package installation

# update system
pacman -Syuu --noconfirm

# install CLI utils
pacman -Sy --needed --noconfirm \
    bat \
    dust \
    fzf \
    git \
    go \
    gvfs \
    htop \
    less \
    man \
    ncdu \
    neovim \
    openssh \
    pwgen \
    rsync \
    tldr \
    tmux \
    tree \
    unzip \
    wget \
    xclip \
    zip \
    zsh

# clear pacman cache
pacman -Scc --noconfirm

# sync dotfiles
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

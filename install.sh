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
    xclip \
    zip \
    zsh

# clear pacman cache
pacman -Scc --noconfirm

# clone dotfiles repository
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles

# sync dotfiles to skel
rsync -rv home/.* $HOME/.

# make scripts executable
chmod +x $HOME/.local/bin/*

# clean up
cd - &> /dev/null
rm -rf dotfiles

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

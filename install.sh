#!/bin/sh

# startup info
echo
echo "===================================="
echo "#      STARTING INSTALLATION       #"
echo "===================================="
echo
read -p 'Enter e-mail: ' USER_EMAIL

# update system
sudo pacman -Syuu --noconfirm

# install system packages
sudo pacman -Sy --needed --noconfirm \
    bat \
    discord \
    dust \
    fzf \
    git \
    go \
    keepassxc \
    less \
    libreoffice-fresh \
    linux-zen-headers \
    man \
    ncdu \
    neovim \
    rsync \
    signal-desktop \
    tldr \
    tmux \
    tree \
    xclip \
    zsh

# clear pacman cache
sudo pacman -Scc --noconfirm

# install yay and clean up
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -i
cd - &> /dev/null
rm -rf yay

# install yay packages
yay -Sy --needed \
    vscodium

# clear yay cache
yay -Scc

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# sync dotfiles
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"

# create ssh key
ssh-keygen -t ecdsa -C $USER_EMAIL

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

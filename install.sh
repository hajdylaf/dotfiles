#!/bin/sh

echo
echo "==================================="
echo "ARCH LINUX POST-INSTALLATION SCRIPT"
echo "==================================="
echo
echo "Developed by: hajdylaf"
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
    gnome-browser-connector \
    go \
    keepassxc \
    less \
    libreoffice-fresh \
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
cd -
rm -rf yay

# install yay packages
yay -Sy --needed \
    gnome-shell-extension-desktop-icons-ng \
    vscodium

# clear yay cache
yay -Scc

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# sync dotfiles
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles
echo
echo "Syncing dotfiles:"
rsync -rv home/.* $HOME/.
rsync -rv home/* $HOME/.
echo
cd -
rm -rf dotfiles

# create ssh key
ssh-keygen -t ecdsa -C $USER_EMAIL

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

# update zen kernel headers
sudo pacman -Sy --needed --noconfirm \
    linux-zen-headers

# install CLI utils
sudo pacman -Sy --needed --noconfirm \
    bat \
    dust \
    fzf \
    git \
    go \
    less \
    man \
    ncdu \
    neovim \
    rsync \
    tldr \
    tmux \
    tree \
    unzip \
    xclip \
    zip \
    zsh

# install themes and fonts
sudo pacman -Sy --needed --noconfirm \
    ttf-fira-code \
    materia-gtk-theme \
    papirus-icon-theme

# install GUI apps
sudo pacman -Sy --needed --noconfirm \
    discord \
    nemo \
    keepassxc \
    kitty \
    libreoffice-fresh \
    signal-desktop

# make kitty default terminal for gtk-launch
sudo rm -f /usr/bin/xdg-terminal-exec
sudo ln -sf /usr/bin/kitty /usr/bin/xdg-terminal-exec

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
# TODO: make installer exit zsh shell after installation and return to next steps
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

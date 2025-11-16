#!/bin/sh

## System setup

# check if user is root
if [ ! "$(whoami)" = "root" ]; then
    echo "User not root. Exitting..."
    exit 0
fi

# startup info
echo
echo "===================================="
echo "#      STARTING INSTALLATION       #"
echo "===================================="
echo

for i in {5..1}; do
    printf $i...
done
echo

# update system
pacman -Syuu --noconfirm

# update zen kernel headers
pacman -Sy --needed --noconfirm \
    linux-zen-headers

# install CLI utils
pacman -Sy --needed --noconfirm \
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
pacman -Sy --needed --noconfirm \
    lightdm-webkit-theme-litarvan \
    lightdm-webkit2-greeter \
    materia-gtk-theme \
    papirus-icon-theme \
    ttf-fira-code

# install GUI apps
pacman -Sy --needed --noconfirm \
    chromium \
    discord \
    keepassxc \
    kitty \
    libreoffice-fresh \
    nemo \
    signal-desktop


# sync system-wide config
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles
rsync -rv etc/* /etc/.
cd - &> /dev/null
rm -rf dotfiles

# make kitty default terminal for gtk-launch
rm -f /usr/bin/xdg-terminal-exec
ln -sf /usr/bin/kitty /usr/bin/xdg-terminal-exec

# clear pacman cache
pacman -Scc --noconfirm

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

## User setup

# # install yay and clean up
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -i
# cd - &> /dev/null
# rm -rf yay

# # install oh-my-zsh
# # TODO: make installer exit zsh shell after installation and return to next steps
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# # sync dotfiles
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"

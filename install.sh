#!/bin/sh

### system setup

## start post-installation setup

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

# install desktop environment
pacman -Sy --needed --noconfirm \
    ly \
    xfce4 \
    xfce4-goodies

# update kernel headers and base package
pacman -Sy --needed --noconfirm \
    base-devel \
    linux-headers \
    linux-zen-headers

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

# install themes and fonts
pacman -Sy --needed --noconfirm \
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
    pavucontrol \
    ristretto \
    signal-desktop \
    thunderbird \
    timeshift \
    virtualbox \
    virtualbox-guest-iso

# clear unwanted packages
pacman -Rsn --noconfirm \
    xfce4-terminal

# clear pacman cache
pacman -Scc --noconfirm

# use dummy user to install yay and clean up
useradd -m -G wheel -s /bin/bash dummy
sudo -u dummy bash -c '
cd $HOME
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -s --noconfirm
'
cd /home/dummy/yay
pacman -U --noconfirm *.pkg.tar.zst
cd - &> /dev/null
userdel dummy
rm -rf /home/dummy

## configuration

# use ly as desktop manager
systemctl enable ly

# clone dotfiles repository
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles

# sync dotfiles to skel
rsync -rv home/.* /etc/skel/.
rsync -rv home/* /etc/skel/.

# make scripts executable
chmod +x /etc/skel/.local/bin/*

# clean up
cd - &> /dev/null
rm -rf dotfiles

## finish and exit

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

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

# update kernel headers and base package
pacman -Sy --needed --noconfirm \
    base-devel \
    linux-headers \
    linux-zen-headers

# install desktop environment
pacman -Sy --needed --noconfirm \
    ly \
    xfce4 \
    xfce4-goodies \
    xorg-server

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
    noto-fonts-emoji \
    papirus-icon-theme \
    ttf-fira-code

# install GUI apps
pacman -Sy --needed --noconfirm \
    chromium \
    discord \
    keepassxc \
    kitty \
    libreoffice-fresh \
    mugshot \
    network-manager-applet \
    nm-connection-editor \
    pavucontrol \
    ristretto \
    signal-desktop \
    thunderbird \
    timeshift \
    virtualbox \
    virtualbox-host-dkms

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

# configure xorg
X -configure

# use ly as desktop manager
systemctl enable ly

# turn off onboard speaker
echo "blacklist pcspkr" > /etc/modprobe.d/blacklist-pcspkr.conf

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

# sync desktop config for all existing users
USERS=$(grep -E "/home" /etc/passwd | cut -d: -f1)
for USERNAME in $USERS; do
    sudo -u "$USERNAME" bash -c '
        cd && sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"
    '
done


## finish and exit

# exit info
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo

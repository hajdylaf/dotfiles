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
    mpv \
    libreoffice-fresh \
    nemo \
    ristretto \
    signal-desktop \
    thunderbird

# clear pacman cache
pacman -Scc --noconfirm

## configuration

# make kitty default terminal for gtk-launch
rm -f /usr/bin/xdg-terminal-exec
ln -sf /usr/bin/kitty /usr/bin/xdg-terminal-exec

# clone dotfiles repository
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles

# sync dotfiles to skel
rsync -rv home/.* /etc/skel/.
rsync -rv home/* /etc/skel/.

# make scripts executable
chmod +x /etc/skel/.local/bin/*

# load desktop settings
dconf load / < desktop.cfg
nohup budgie-panel --replace &> /dev/null &

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

### user setup

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

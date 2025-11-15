#!/bin/sh

# startup info
echo
echo "===================================="
echo "#        SYNCING DOTFILES          #"
echo "===================================="
echo

# clone repository
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles

# sync dotfiles
rsync -rv home/.* $HOME/.
rsync -rv home/* $HOME/.

# make scripts executable
chmod +x $HOME/.local/bin/*

# load desktop settings
dconf load / < desktop.cfg

# clean up
cd - &> /dev/null
rm -rf dotfiles

# exit info
echo
echo "===================================="
echo "#           SYNC COMPLETE          #"
echo "===================================="
echo

#!/bin/sh

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

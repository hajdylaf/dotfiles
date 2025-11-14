#!/bin/sh

# sync dotfiles
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles
rsync -rv home/.* $HOME/.
rsync -rv home/* $HOME/.
cd - &> /dev/null
rm -rf dotfiles

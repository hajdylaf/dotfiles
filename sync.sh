#!/bin/sh

# startup info
echo
echo "===================================="
echo "#        SYNCING DOTFILES          #"
echo "===================================="
echo

# clone repository
if [ -d dotfiles ]; then
    rm -rf dotfiles
fi
git clone https://github.com/hajdylaf/dotfiles.git
cd dotfiles

# sync dotfiles
rsync -rv home/.* $HOME/.

# make scripts executable
chmod +x $HOME/.local/bin/*

# clean up
cd - &> /dev/null
rm -rf dotfiles
rm $HOME/.*.pre-oh-my-zsh
rm $HOME/.bash*

# exit info
echo
echo "===================================="
echo "#           SYNC COMPLETE          #"
echo "===================================="
echo

#!/bin/sh

# startup info
echo
echo "===================================="
echo "#        SYNCING DOTFILES          #"
echo "===================================="
echo

# fix this to be headless
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
sed -i.tmp 's:env zsh::g' install.sh
sed -i.tmp 's:chsh -s .*$::g' install.sh
sh install.sh
rm install.sh

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
nohup budgie-panel --replace &> /dev/null &

# clean up
cd - &> /dev/null
rm -rf dotfiles

# exit info
echo
echo "===================================="
echo "#           SYNC COMPLETE          #"
echo "===================================="
echo

#!/bin/sh

. linkdots.sh

# Get vim up and running
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install vim plugins specified in .vimrc
vim -e -c ':PlugInstall' -c ':GoInstallBinaries' -c ':qa'

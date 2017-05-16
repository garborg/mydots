#!/usr/bin/env bash

. linkdots.bash

# Get vim up and running

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# TODO: why are these commands not running? (thought they were before)
vim -es -c ':PlugInstall' -c ':GoInstallBinaries' -c ':qa'


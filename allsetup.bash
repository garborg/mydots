#!/usr/bin/env bash

. linkdots.bash

# Get vim up and running

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -c ':PlugInstall' -c ':qa'


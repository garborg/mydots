#!/bin/sh

# Install oh-my-zsh
#   RUNZSH=no, otherwise, a fresh zsh shell will be launched and rest of install script will not be run
#   KEEP_ZSHRC=yes, because I've added a few lines to the oh-my-zshrc-generated .zshrc
if ! [ -d "$ZSH" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# https://github.com/romkatv/powerlevel10k#oh-my-zsh
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if ! [ -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $P10K_DIR
fi

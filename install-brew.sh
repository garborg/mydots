#!/bin/sh

if ! command -v brew > /dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # - Add Homebrew to your PATH in $HOME/.zprofile:
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew install fd fzf git ripgrep tmux

/usr/local/opt/fzf/install --xdg --key-bindings --completion --update-rc

#!/bin/sh

if ! command -v brew > /dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # - Add Homebrew to your PATH in $HOME/.zprofile:
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# utilities
brew install direnv fd fzf git gnupg ripgrep tmux

# add fzf integrations
# --xdg: dotfile location respects $XDG_CONFIG
# --key-bindings, --completion: activate them
# --update-rc: no-op while lines in .rc files are current, keep on in case of changes
$(brew --prefix fzf)/install --xdg --key-bindings --completion --update-rc

# apps:
# chrome, firefox, notion, etc.
# Code:
# - from: https://code.visualstudio.com/download
# - extensions: Julia, Vim


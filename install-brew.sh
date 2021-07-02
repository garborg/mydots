#!/bin/sh

if ! command -v brew > /dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # - Add Homebrew to your PATH in $HOME/.zprofile:
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# utilities
brew install coreutils direnv fd git git-delta gnupg ripgrep tmux

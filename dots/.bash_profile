#!/usr/bin/env bash

# This file only exists to protect against tools that create
# .bash_profile, causing it to be read instead of .profile in some situations.
# (or existence of .bash_login)

# .bashrc checks if shell is interactive and/or bash, and acts accordingly
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

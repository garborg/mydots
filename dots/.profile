# Bash-specific stuff goes here instead of .bash_profile to use bash
# functionality when bash emulates sh, etc.

export order="${order:-} .profile"

## says ubuntu:

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# reset text effects to recover on login from inconsistent states
# e.g. on reconnect after disconnect with client that doesn't reset colors in PS1
# TODO: consider tput init/reset/clear instead
case $- in
  *i*) tput sgr0
esac

# .bash_profile comes here, and we got to .bashrc if in .bash
# (get bash-y goodness
# Terminal ru
if [ -n "${BASH:-}" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi


### language-specific:

# go
PATH=$PATH:/usr/local/go/bin

# rust
# info suggested: PATH="$HOME/.cargo/bin:$PATH"
PATH="$PATH:$HOME/.cargo/bin"

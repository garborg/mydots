## says ubuntu:

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


### my general additions:

export VISUAL=vim
export EDITOR="$VISUAL"

### language-specific:

# go
export GOPATH=$HOME
export PATH=$PATH:/usr/local/go/bin
gocd () { cd "$(go list -f '{{.Dir}}' "$1")"; } # gocd .../mypkg
export -f gocd

#javascript
export NVM_DIR="/home/sean/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# python (& devtools written in python)

# used to set up and activate a default virtualenv for local development tools
mkpydev () { python3 -m venv /usr/local/dev-env; }
export -f mkpydev
pydev () { . ~/.dev-env/bin/activate; }
export -f pydev

# rust
export PATH="$HOME/.cargo/bin:$PATH"


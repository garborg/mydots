#!/usr/bin/env bash

export order="$order .bashrc"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Some systems' PROMPT_COMMANDs, etc., rely on /etc/bashrc
if [ -n "$BASH_VERSION" ] && [ -f "/etc/bashrc" ]; then
	. "etc/bashrc"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/bashrc.ubuntu" ]; then
	. "$HOME/bashrc.ubuntu"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/git-prompt.sh" ]; then
	. "$HOME/git-prompt.sh"
fi

### my general additions:

export VISUAL=vim
export EDITOR="$VISUAL"

### build ps1:

# # export PS1="\[\e[31m\]$(if [ $(id -u) -ne 0 ] then echo $(nonzero_return) ; fi)\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\n\\$ "
# fi

# Start with just the git bit
GIT_PS1_SHOWDIRTYSTATE=1 # unstaged: *, staged: +
GIT_PS1_SHOWSTASHSTATE=1 # $
GIT_PS1_SHOWUNTRACKEDFILES=1 # %
GIT_PS1_SHOWUPSTREAM="verbose" # "auto"
#in prompt_command only: GIT_PS1_SHOWCOLORHINTS=1
export PS1='$(__git_ps1 "(%s)")'
# Drop the git bit into the main PS1
# export PS1="[\u@\h:\[\e[34m\]\w\[\e[m\]$PS1]\n\\$ "
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$PS1\n\\$ "
# Prepend with background job count
export PS1='`if [ -n "$(jobs -p)" ]; then echo "[\j+]"; fi`'"$PS1"
# Prepend with success status of previous command
# export PS1="\[\e[31m\]\`nonzero_return\`\[\e[m\]$PS1"
export PS1="\[\e[31m\]"'`RETVAL=$?; [ $RETVAL -ne 0 ] && echo "^^($RETVAL)"`'"\[\e[m\]$PS1"

### language-specific:

# go
export GOPATH=$HOME
gocd () { cd "$(go list -f '{{.Dir}}' "$1")"; } # gocd .../mypkg
[ -n "$BASH_VERSION" ] && export -f gocd

#javascript
export NVM_DIR="/home/sean/.nvm"
[ -n "$BASH_VERSION" ] && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# python (& devtools written in python)

# used to set up and activate a default virtualenv for local development tools
mkpydev () { python3 -m venv /usr/local/dev-env; }
[ -n "$BASH_VERSION" ] && export -f mkpydev
pydev () { . ~/.dev-env/bin/activate; }
[ -n "$BASH_VERSION" ] && export -f pydev

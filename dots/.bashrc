#!/usr/bin/env bash

export order="$order .bashrc"

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Some systems' PROMPT_COMMANDs, etc., rely on /etc/bashrc
if [ -n "$BASH_VERSION" ] && [ -f "/etc/bashrc" ]; then
  . "/etc/bashrc"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc.ubuntu" ]; then
  . "$HOME/.bashrc.ubuntu"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.config/git-prompt.sh" ]; then
  . "$HOME/.config/git-prompt.sh"
fi

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.fzf.bash" ]; then
  . ~/.fzf.bash
fi

### my general additions:

export VISUAL=vim
export EDITOR="$VISUAL"

if command -v nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
if command -v vim > /dev/null 2>&1; then
  # make vi point at local vim if installed
  alias vi='vim'
fi

# color osx/bsd ls like ubuntu/gnu ls
export CLICOLOR=1

# color osx/bsd grep like ubuntu/gnu grep
if command -v grep > /dev/null 2&>1 && grep --version | grep -q "BSD"; then
  # deprecated in GNU grep 2.x
  export GREP_OPTIONS="--color=auto"
fi
# Recommended alternative fails, e.g when piping via xargs:
# alias grep="grep --color=auto"
# alias fgrep="fgrep --color=auto"
# alias egrep="egrep --color=auto"

### build ps1:

# # export PS1="\[\e[31m\]$(if [ $(id -u) -ne 0 ] then echo $(nonzero_return) ; fi)\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\n\\$ "
# fi

# Start with just the git bit
# shellcheck disable=SC2034
GIT_PS1_SHOWDIRTYSTATE=1 # unstaged: *, staged: +
# shellcheck disable=SC2034
GIT_PS1_SHOWSTASHSTATE=1 # $
# shellcheck disable=SC2034
GIT_PS1_SHOWUNTRACKEDFILES=1 # %
# shellcheck disable=SC2034
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

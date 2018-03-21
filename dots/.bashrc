#!/usr/bin/env bash

export order="$order .bashrc"

is_interactive=false
case "$-" in
   *i*) is_interactive=true ;;
esac

if [ -n "$BASH_VERSION" ]; then
  is_login=false
  if shopt -q login_shell; then
    is_login=true
  fi
fi

is_ssh=false
if [ -n "$SSH_CLIENT" ]  || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then
  is_ssh=true
fi

export order="$order. $- $BASH_VERSION (i:$is_interactive, l: $is_login, ssh: $is_ssh)"

# Make sure non-bash non-login shells get non-bash config
export ENV="$HOME/.bashrc"

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

if [ -n "$BASH_VERSION" ]; then
  # keep more history
  HISTSIZE=5000
  HISTFILESIZE=10000
fi

# Some systems' PROMPT_COMMANDs, etc., rely on /etc/bashrc
if [ -n "$BASH_VERSION" ] && [ -f "/etc/bashrc" ]; then
  . "/etc/bashrc"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc.ubuntu" ]; then
  . "$HOME/.bashrc.ubuntu"
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
if command -v grep > /dev/null 2>&1 && grep --version | grep -q "BSD"; then
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

# set PS1
if [ -n "$BASH_VERSION" ]; then
  config_dir="$XDG_CONFIG_HOME"
  [ -z "$config_dir" ] && config_dir="$HOME/.config"

  if [ -f "$config_dir/git/git-prompt.sh" ]; then
    . "$config_dir/git/git-prompt.sh"

    # Build the git section of the ps1
    # shellcheck disable=SC2034
    GIT_PS1_SHOWDIRTYSTATE=1 # unstaged: *, staged: +
    # shellcheck disable=SC2034
    GIT_PS1_SHOWSTASHSTATE=1 # $
    # shellcheck disable=SC2034
    GIT_PS1_SHOWUNTRACKEDFILES=1 # %
    # shellcheck disable=SC2034
    GIT_PS1_SHOWUPSTREAM="verbose" # "auto"
    #in prompt_command only: GIT_PS1_SHOWCOLORHINTS=1
    PS1='$(__git_ps1 "(%s)")'
  else
    PS1='(?)'
  fi

  # Drop the git component into the main PS1
  # export PS1="[\u@\h:\[\e[34m\]\w\[\e[m\]$PS1]\n\\$ "
  PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$PS1\n\\$ "
  # Prepend with background job count
  PS1='`if [ -n "$(jobs -p)" ]; then echo "[\j+]"; fi`'"$PS1"
  # Prepend with success status of previous command
  # export PS1="\[\e[31m\]\`nonzero_return\`\[\e[m\]$PS1"
  export PS1="\[\e[31m\]"'`RETVAL=$?; [ $RETVAL -ne 0 ] && echo "^^($RETVAL)"`'"\[\e[m\]$PS1"
else
  HOSTNAME="$(hostname)"
  export PS1='$USER@$HOSTNAME:$PWD/\$ '
fi

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
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

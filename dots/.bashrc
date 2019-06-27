#!/usr/bin/env bash

# Nice overview: https://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc

# login: /etc/profile. first of .bash_profile, .bash_login, .profile
# interactive, non-login: .bashrc
# non-interactive, non-login: BASH_ENV
# some non-login commands will only hit .bashrc

# Considerations:
# - [bash startup order](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)
# - OSX graphical sessions run dots with bash, but debian-based graphical sessions run dots with dash
#   + Anything used by graphical sessions should be POSIX sh
# - OSX graphical read anything actually?
# - Unlike linux terminals Terminal.app runs login shells
# - Giving login (interactive or non) path, etc.
# - `bash --posix` has `$BASH` && `shopt -oq posix`


###
### Shared by all (bash/sh, interactive/non-interactive, etc.)
###


### General

# ENV is used by sh for interactive sessions
# .profile is used by sh and bash --posix for login sessions
# Make sure non-bash non-login shells get non-bash chunks of config
export ENV="$HOME/.bashrc"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

if command -v nvim > /dev/null 2>&1; then
  export VISUAL=nvim
else
  export VISUAL=vim
fi
export EDITOR="$VISUAL"

# If devtools are installed via miniconda, use them
CONDA_DIR=${HOME}/.miniconda
if [ -d "$CONDA_DIR" ]; then
  export PATH=${CONDA_DIR}/bin:$PATH
fi

### Language specific

# go
PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME

# rust
# info suggested: PATH="$HOME/.cargo/bin:$PATH"
PATH="$PATH:$HOME/.cargo/bin"


###
### End of non-interactive settings
###

case $- in
  *i*) ;;
    *) return;;
esac


## General

# reset text effects to recover on login from inconsistent states
# e.g. on reconnect after disconnect with client that doesn't reset colors in PS1
# TODO: consider tput init/reset/clear instead
tput sgr0

HISTSIZE=5000

HOSTNAME="$(hostname)"
export PS1='$USER@$HOSTNAME:$PWD/\$ '


## Utilities

# The ls aliases from .bashrc.ubuntu
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# color osx/bsd ls like ubuntu/gnu ls
export CLICOLOR=1

# color osx/bsd grep like ubuntu/gnu grep
# (Oft-recommended alternative of aliasing with --color=auto is not reliable,
#  e.g when piping via xargs)
if command -v grep > /dev/null 2>&1 && grep --version | grep -q "BSD"; then
  # deprecated in GNU grep 2.x
  export GREP_OPTIONS="--color=auto"
fi

if command -v nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

if command -v vim > /dev/null 2>&1; then
  # make vi point at local vim if installed
  alias vi='vim'
fi

if command -v tmux > /dev/null 2>&1; then
  # add flag for 256 color support
  alias tmux='tmux -2'
fi


## Language specific

# go
export GOPATH=$HOME

#javascript
export NVM_DIR="/home/sean/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# julia
# Swap until [#28781](https://github.com/JuliaLang/julia/issues/28781) is resolved
# alias j='julia --project'
alias j='JULIA_PROJECT="@." julia'


###
### End of non-bash settings
###

# If not bash, nothing more to do
if [ -z "${BASH:-}" ]; then
  return
fi


## General

# Some systems' PROMPT_COMMANDs, etc., rely on /etc/bashrc
if [ -f "/etc/bashrc" ]; then
  . "/etc/bashrc"
fi

# Keep ubuntu's default .bashrc as a base
# Untouched because I want to diff against new versions,
# but don't know what repo it lives in to vendor it.
if [ -f "$HOME/.bashrc.ubuntu" ]; then
  . "$HOME/.bashrc.ubuntu"
fi

# keep more history
HISTSIZE=5000
HISTFILESIZE=10000


## Build ps1:

# set PS1
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

# Coloration escapes
reset='\[\033[0m\]'
bold='\[\033[1m\]'
unbold='\[\033[21m\]'
fgdefault='\[\033[39m\]'
fgred='\[\033[31m\]'
fgcyan='\[\033[36m\]'
# i'd prefer to stripe with dimming or a grayscale color,
# but too many terminals don't dim, or
# display all grayscale colors identically when bolded, etc.
stripe="$fgcyan"
unstripe="$fgdefault"

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
  PS1='$(__git_ps1 " (%s)")'
  export -f __git_ps1
else
  PS1='(?)'
fi

# Drop the git component into the main PS1
PS1="\u@\h:$stripe\w$unstripe$PS1"

# Append with background job count
PS1="$PS1\`if [ -n \"\$(jobs -p)\" ]; then echo \" $stripe[\\j+]$unstripe\"; fi\`"

# Status code of previous command if not success
retval="\`RETVAL=\$?; [ \$RETVAL -ne 0 ] && echo \"$fgred^^\$RETVAL$fgdefault\"\`"

# Flip background/foreground, add prompt line with prepended status code
export PS1="$bold┌$retval─$PS1\n└─\\\$$unbold$reset "


## Utilities

if [ -f "$HOME/.fzf.bash" ]; then
  . ~/.fzf.bash

  # sort history matches by recency
  export FZF_CTRL_R_OPTS='--sort'
fi


## Language specific

if [ -f "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

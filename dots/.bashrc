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

add_to_PATH () {
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH="$PATH:$1"
    else
      PATH="$1:$PATH"
    fi
  fi
}

# Set PATH so it includes user's private bin(s) if found
if [ -d "$HOME/.local/bin" ]; then
  add_to_PATH "$HOME/.local/bin"
fi
if [ -d "$HOME/bin" ]; then
  add_to_PATH "$HOME/bin"
fi
# If devtools are installed via miniconda, use them
CONDA_DIR="$HOME/.miniconda"
if [ -d "$CONDA_DIR/bin" ]; then
  add_to_PATH "$CONDA_DIR/bin"
fi

if command -v nvim > /dev/null 2>&1; then
  export VISUAL=nvim
else
  export VISUAL=vim
fi
export EDITOR="$VISUAL"

### Language specific

# go
add_to_PATH "/usr/local/go/bin" after
export GOPATH=$HOME


###
### End of non-interactive settings
###

case $- in
  *i*) ;;
    *) return;;
esac


## General


HISTSIZE=5000

# reset text effects to recover on login from inconsistent states
# e.g. on reconnect after disconnect with client that doesn't reset colors in PS1
# TODO: consider tput init/reset/clear instead
tput sgr0
HOSTNAME="$(hostname)"
export PS1='$USER@$HOSTNAME:$PWD/\$ '


## Utilities

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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# julia
# Swap until [#28781](https://github.com/JuliaLang/julia/issues/28781) is resolved
# alias j='julia --project'
alias j='JULIA_PROJECT="@." julia'

# python

# if python is version 3
if command -v python > /dev/null 2>&1 && python -c 'import sys; sys.exit(sys.version_info[0] != 3)'; then
  if ! command -v python3 > /dev/null 2>&1; then
    alias python3='python'
  fi
  if ! command -v pip3 > /dev/null 2>&1; then
    alias pip3='pip'
  fi
fi

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

# keep more history
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# TODO: PS1 coloring can be a little buggy over ssh? simplify if possible

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

FZF_SHELL="$CONDA_DIR/share/fzf/shell"
if [ -d "$FZF_SHELL" ]; then
  # Auto-completion
  # ---------------
  . "$FZF_SHELL/completion.bash"

  # Key bindings
  # ------------
  . "$FZF_SHELL/key-bindings.bash"

  # sort history matches by recency
  export FZF_CTRL_R_OPTS='--sort'
fi


## Language specific

if [ -f "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

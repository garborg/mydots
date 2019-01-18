#!/usr/bin/env bash

export order="${order:-} .bashrc"

is_interactive=false
case "$-" in
   *i*) is_interactive=true ;;
esac

is_login="?"
if [ -n "${BASH:-}" ]; then
  is_login=false
  if shopt -q login_shell; then
    is_login=true
  fi
fi

is_ssh=false
if [ -n "${SSH_CLIENT:-}" ]  || [ -n "${SSH_TTY:-}" ] || [ -n "${SSH_CONNECTION:-}" ]; then
  is_ssh=true
fi

export order="$order. $- ${BASH:-} (i:$is_interactive, l: $is_login, ssh: $is_ssh)"

# If not running interactively, nothing more to do
case $- in
  *i*) ;;
    *) return;;
esac


### General

# reset text effects to recover on login from inconsistent states
# e.g. on reconnect after disconnect with client that doesn't reset colors in PS1
# TODO: consider tput init/reset/clear instead
tput sgr0

export VISUAL=vim
export EDITOR="$VISUAL"

HISTSIZE=5000

HOSTNAME="$(hostname)"
export PS1='$USER@$HOSTNAME:$PWD/\$ '

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

### Bash

# If not bash, nothing more to do
if [ -z "${BASH:-}" ]; then
  return
fi

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


### Non-posix

# If posix mode, nothing more to do
if shopt -oq posix; then
  return
fi

# other bash completion is off under posix mode
if [ -f "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# fzf uses varnames that keep it from working under `bash --posix`
if [ -f "$HOME/.fzf.bash" ]; then
  . ~/.fzf.bash

  # sort history matches by recency
  export FZF_CTRL_R_OPTS='--sort'
fi

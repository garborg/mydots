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

# BASH:

# login: /etc/profile. first of .bash_profile, .bash_login, .profile
# interactive, non-login: .bashrc
# non-interactive, non-login: BASH_ENV


# ENV is used by sh for interactive sessions
# .profile is used by sh and bash --posix for login sessions
# Make sure non-bash non-login shells get non-bash chunks of config
export ENV="$HOME/.bashrc"

### my general additions:

export VISUAL=vim
export EDITOR="$VISUAL"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

HISTSIZE=5000

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
# (Oft-recommended alternative of aliasing with --color=auto is not reliable,
#  e.g when piping via xargs)
if command -v grep > /dev/null 2>&1 && grep --version | grep -q "BSD"; then
  # deprecated in GNU grep 2.x
  export GREP_OPTIONS="--color=auto"
fi

HOSTNAME="$(hostname)"
export PS1='$USER@$HOSTNAME:$PWD/\$ '

### language-specific:

# go
export GOPATH=$HOME
gocd () { cd "$(go list -f '{{.Dir}}' "$1")"; } # gocd .../mypkg
# TODO: these exports do me any good?
[ -n "${BASH:-}" ] && export -f gocd

#javascript
export NVM_DIR="/home/sean/.nvm"
[ -f "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# other bash completion is off under posix mode
[ -n "${BASH:-}" ] && ! shopt -oq posix  && [ -f "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# python (& devtools written in python)

# used to set up and activate a default virtualenv for local development tools
mkpydev () { python3 -m venv /usr/local/dev-env; }
[ -n "${BASH:-}" ] && export -f mkpydev
pydev () { . ~/.dev-env/bin/activate; }
[ -n "${BASH:-}" ] && export -f pydev

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# here be real bash stuff
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

# fzf uses varnames that keep it from working under `bash --posix`
if [ -f "$HOME/.fzf.bash" ] && ! shopt -oq posix; then
  . ~/.fzf.bash
fi

# keep more history
HISTSIZE=5000
HISTFILESIZE=10000

### build ps1:

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

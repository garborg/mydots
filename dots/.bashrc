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


# ENV is used by sh for interactive sessions
# .profile is used by sh and bash --posix for login sessions
# Make sure non-bash non-login shells get non-bash chunks of config
export ENV="$HOME/.bashrc"

source "${XDG_CONFIG_HOME:-$HOME/.config}"/allrc.sh


###
### End of non-interactive settings
###

case $- in
  *i*) ;;
    *) return;;
esac

## General

HOSTNAME="$(hostname)"
export PS1='$USER@$HOSTNAME:$PWD/\$ '


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

# TODO: handle brew-provided bash completion
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

## Build ps1:

# Coloration escapes
reset='\[\033[0m\]'
bold='\[\033[1m\]'
# unbold='\[\033[22m\]'
fgdefault='\[\033[39m\]'
fgred='\[\033[31m\]'
fgcyan='\[\033[36m\]'
# i'd prefer to stripe with dimming or a grayscale color,
# but too many terminals don't dim, or
# display all grayscale colors identically when bolded, etc.
stripe="$fgcyan"
unstripe="$fgdefault"

gp_path="${XDG_CONFIG_HOME:-$HOME/.config}/git/git-prompt.sh"
if [ -f "$gp_path" ]; then
  . "$gp_path"

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
retval="\`RETVAL=\$?; [ \$RETVAL -ne 0 ] && echo \"$bold$fgred^^\$RETVAL$reset\"\`"

# Finish prompt line with prepended status code
export PS1="┌${retval}─$PS1\n└─\\\$ "


## Utilities

# fzf

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

# direnv

if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/Users/sean/.juliaup/bin:*)
        ;;

    *)
        export PATH=/Users/sean/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

# fnm (fast nvm)
eval "$(fnm env --use-on-cd)"

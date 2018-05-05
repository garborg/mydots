# Bash-specific stuff goes here instead of .bash_profile to use bash
# functionality when bash emulates sh, etc.

# BASH:

# login: /etc/profile. first of .bash_profile, .bash_login, .profile
# interactive, non-login: .bashrc
# non-interactive, non-login: BASH_ENV

# Considerations:
# - [bash startup order](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)
# - OSX graphical sessions run dots with bash, but debian-based graphical sessions run dots with dash
#   + Anything used by graphical sessions should be POSIX sh
# - OSX graphical read anything actually?
# - Unlike linux terminals Terminal.app runs login shells
# - Giving login (interactive or non) path, etc.
# - `bash --posix` has `$BASH` && `shopt -oq posix`

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


### General settings:

# ENV is used by sh for interactive sessions
# .profile is used by sh and bash --posix for login sessions
# Make sure non-bash non-login shells get non-bash chunks of config
export ENV="$HOME/.bashrc"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# .bash_profile comes here, so .bashrc if appropriate
if [ -n "${BASH:-}" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
else
  HISTSIZE=5000

  HOSTNAME="$(hostname)"
  export PS1='$USER@$HOSTNAME:$PWD/\$ '
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


### Everything else is only for interactive sessions

case $- in
  *i*) ;;
    *) return;;
esac

# reset text effects to recover on login from inconsistent states
# e.g. on reconnect after disconnect with client that doesn't reset colors in PS1
# TODO: consider tput init/reset/clear instead
tput sgr0

export VISUAL=vim
export EDITOR="$VISUAL"

if command -v nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
if command -v vim > /dev/null 2>&1; then
  # make vi point at local vim if installed
  alias vi='vim'
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

### language specific:

# go
export GOPATH=$HOME

#javascript
export NVM_DIR="/home/sean/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

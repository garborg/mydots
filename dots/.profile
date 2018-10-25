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

## says ubuntu:

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


### General

# ENV is used by sh for interactive sessions
# .profile is used by sh and bash --posix for login sessions
# Make sure non-bash non-login shells get non-bash chunks of config
export ENV="$HOME/.bashrc"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi


### Language-specific

# go
PATH=$PATH:/usr/local/go/bin

# rust
# info suggested: PATH="$HOME/.cargo/bin:$PATH"
PATH="$PATH:$HOME/.cargo/bin"


### Interactive mode (bash & posix)

case $- in
  *i*) ;;
  *) return;;
esac

# has non-bash interactive features as well
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

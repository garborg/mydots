###
### Shared by all (zsh/bash/sh, interactive/non-interactive, etc.)
###


### General

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

add_to_PATH () {
  if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
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


## Utilities

# Set display colors by filetype
if command -v dircolors > /dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
elif command -v gdircolors > /dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
fi

# Use gnu ls on macos if available
if command -v gls > /dev/null 2>&1; then
  alias ls='gls --color=auto'
# Use gnu ls color options if understood
elif ls --color -d . >/dev/null 2>&1; then
  alias ls='ls --color=auto'
fi

# color osx/bsd ls
export CLICOLOR=1

alias ll='ls -al'
alias la='ls -AF'
alias l='ls -CF'

# Grep color
if command -v grep > /dev/null 2>&1; then
  if grep --version | grep -q "BSD"; then
    # GREP_OPTIONS is more reliable than --color=auto, e.g when piping via xargs
    export GREP_OPTIONS="--color=auto"
  else
    # But GREP_OPTIONS was deprecated in GNU grep 2.x+
    alias grep='grep --color=auto'
  fi
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

# fzf
if command -v fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
fi
export FZF_CTRL_R_OPTS='--sort'

## Language specific

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

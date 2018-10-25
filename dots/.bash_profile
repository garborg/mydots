# This file only exists to protect against tools that create
# .bash_profile, causing it to be read instead of .profile in some situations.

export order="${order:-} .bash_profile"

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

# Hit .bashrc via .profile when in bash,
# but degrade gracefully if .profile isn't found.
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
elif [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

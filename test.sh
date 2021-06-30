# source me don't exec me

# bash, sh
# posix-ish: --posix
# login: bash -l, sh -l
# interactive pass script vs not


echo "order: $order"
echo "path: $PATH"

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

if [ -n "$BASH_VERSION" ] && ! shopt -oq posix; then
  is_posix=false
else
  is_posix=true
fi

echo "bash: $BASH"
echo "bash_version: $BASH_VERSION"
echo "pc: $POSIXLY_CORRECT"
echo "p: $is_posix"
echo "\$-: $-"
echo "interactive: $is_interactive"
echo "is_login: $is_login"
echo "is_ssh: $is_ssh"

if tty -s; then
  echo "terminal: true"
else
  echo "terminal: false"
fi

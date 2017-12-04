# This file only exists to protect against tools that create
# .bash_profile, causing it to be read instead of .profile in some situations.

export order="$order .bash_profile"

# Hit .bashrc via .profile when in bash,
# but degrade gracefully if .profile isn't found.
if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
elif [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

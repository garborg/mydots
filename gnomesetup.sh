#!/bin/sh

set -e

. ./basicsetup.sh

# rasbian missing dconf, but xkb-options ctrl:nocaps not doing anything there anyway
# if [ ! $(command -v dconf) ]; then
#   apt-get install -y dconf
# fi
if [ "$(command -v dconf)" ]; then
  dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
else
  # pi is and doesn't have dconf, but I use it via ssh -- no keymapping needed
  echo "Assuming this machine is meant for headless use"
fi

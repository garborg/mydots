#!/usr/bin/env bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 
# echo "Run 'crontab -e -u $(whoami)' and add this line:"
# echo "@reboot \"$DIR/scripts/onreboot.bash\""

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


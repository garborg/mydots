#!/bin/sh

set -e

. basicsetup.sh

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


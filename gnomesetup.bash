#!/usr/bin/env bash

set -e

. basicsetup.bash

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


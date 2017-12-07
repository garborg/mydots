#!/usr/bin/env bash

. basicsetup.bash

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


#!/usr/bin/env bash

. allsetup.bash

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


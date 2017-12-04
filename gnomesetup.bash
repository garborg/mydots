#!/bin/sh

. basicsetup.bash

dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"


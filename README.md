## mydots (My dotfiles)

#### TLDR

- My dotfiles are in [dots/](dots).
- Some of those dotfiles are links to third-party scripts vendored in [vendor/](vendor).
- The undocumented shell scripts in the top level deploy and update dotfiles.

#### Init script design

Aimed to work for any combination of:
- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- /bin/sh or bash or bash --posix

Likely okay on:
- ubuntu (ui & gnome-terminal)
- rasbian (desktop, terminal, & ssh-ed)
- osx (ui & terminal)
- debian
- centos

#### File management design

Ad-hoc script rather than picking from real [dotfile management tools](https://wiki.archlinux.org/index.php/Dotfiles).

Install/deploy with a git clone or scp, followed by executing a (symlink-farming) shell script.

Dotfiles / dotdirs are symlinked from the repo into place. This makes obvious:

- when uncommitted changes have been made to managed dots
- what dots are / aren't managed

Vendoring handles third-party scripts without letting them either get stale or change unexpectedly underfoot. See [vendor/](vendor) for details.

For OS X and basic Linux compatibility, the install and vendor scripts work with GNU or BSD utils. They're also POSIX compliant, which was an experiment to see if avoiding bashisms felt worth it -- not for me. May leave scripts POSIX in anticipation of trying this on something bash-free & without the standard GNU or BSD utils (e.g. something ash/busybox-based like Alpine Linux or OpenWRT).

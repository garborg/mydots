## mydots (My dotfiles)

#### TLDR

- My dotfiles are in [dots/](dots).
- Some of those dotfiles are links to third-party scripts vendored in [vendor/](vendor).
- The undocumented shell scripts in the top level deploy and update dotfiles.

Read on for design considerations.

#### Init script design

Work for any combination of:

- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- /bin/sh or bash or bash --posix

Apply just what's relevant (and supported) for each combination, and keep as consistent as possible across environments.

#### File management design

Ad-hoc, temporary alternative to [dotfile management tools](https://wiki.archlinux.org/index.php/Dotfiles). Rolled my own out of curiousity and to avoid getting locked into tools' abstractions until I decide what, if anyting, I need.

Install/deploy with a git clone or scp, followed by executing a (symlink-farming) shell script.

Dotfiles / dotdirs are symlinked from the repo into place. This makes obvious:

- when uncommitted changes have been made to managed dots
- what dots are / aren't managed

Vendoring strategy handles third-party scripts without letting them either get stale or change unexpectedly underfoot. See [vendor/](vendor) for details.

For Linux and OS X compatibility, the install and vendor scripts are POSIX compliant and work with GNU or BSD utils. POSIX compliance was an experiment to learn the pain of avoiding bashisms. Turns out bashisms are worth it. These scripts have only stayed POSIX in anticipation of trying this on something bash-free & without the standard GNU or BSD utils (e.g. something ash/busybox-based like Alpine Linux or OpenWRT).

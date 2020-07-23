## mydots (My dotfiles)

#### TLDR

- My dotfiles are in [dots/](dots).
- Some of those dotfiles are links to third-party scripts vendored in [vendor/](vendor).
- The shell scripts in the top level deploy and update dotfiles.

#### Init script design

Aim to fit any combination of:
- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- /bin/sh or bash or bash --posix

#### File management design

Eschewed [dotfile management tools](https://wiki.archlinux.org/index.php/Dotfiles) in favor of an ad-hoc script because I didn't know at the outset what I wanted.

Install/deploy with a git clone or scp, followed by executing a (symlink-farming) shell script.

Dotfiles / dotdirs are symlinked from the repo into place. This makes obvious:

- when uncommitted changes have been made to managed dots
- what files are / aren't managed

A couple third-party scripts are vendored for convenience but set aside for easy updating. See [vendor/](vendor) for details.

For OS X and basic Linux compatibility, the install and vendor scripts work with GNU or BSD utils. They're also POSIX compliant, which was an experiment to see if avoiding bashisms felt worth it -- not for me. Maybe I'd appreciate it if I ever played around on something ash/busybox-based like Alpine Linux or OpenWRT.

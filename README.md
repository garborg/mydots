# mydots (My dotfiles)

### TLDR

- My dotfiles are in [dots/](dots).
- Some of those dotfiles are links to third-party scripts vendored in [vendor/](vendor).
- The shell scripts in the top level deploy and update dotfiles.
    - `./setup-macos.sh` to link dots and install 'referenced utilities' on macos (mostly using brew)
    - `./setup-gnome.sh` to link dots and and install 'referenced utilities' on a gnome-based desktop environment like Ubuntu (mostly using miniconda)
    - `./setup-linux.sh` to link dots and install 'referenced utilities' on other linux environments (mostly using miniconda)
    - `./linkdots.sh` to just link dots
### Init script design

Because I used to bounce around more, it should be dialed in for:
- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- /bin/sh or bash or bash --posix

Note that `.bashrc` is a little cluttered because other than zsh (what I use these days), everything (bash, dash, sh, etc.) routes through `.bashrc` so config is fenced off by checks for interactive/not, bash/not, etc.

### File management

#### Design

Dotfiles / dotdirs are symlinked from the repo into place. Directories are linked, unless they contain a file named `._linkcontents`, in which case, each file/dir inside is linked. This makes obvious:

- when uncommitted changes have been made to managed dots, or to dot dirs that are expected to be fully managed
- what files are / aren't managed

A couple third-party scripts are vendored for convenience but set aside for easy updating. See [vendor/](vendor) for details.

For OS X and basic Linux compatibility, the install and vendor scripts work with GNU or BSD utils. They're also POSIX compliant, which was an experiment to see if avoiding bashisms felt worth it -- not for me. Maybe I'd appreciate it if I ever played around on something ash/busybox-based like Alpine Linux or OpenWRT.

#### Alternatives

[dotfile management tools](https://wiki.archlinux.org/index.php/Dotfiles)

## mydots (My dotfiles)

TLDR:
- My dotfiles are in [dots/](dots).
- Some of those dotfiles are links to third-party scripts vendored in [vendor/](vendor).
- The undocumented shell scripts in the top level deploy and update dotfiles.
- Read on for motivation and overarching design.

#### Project structure design

Install/deploy with a git clone or scp, followed by executing an included script.

Dotfiles / dotdirs are symlinked from the project into place. This makes clear when uncommitted changes have been made to managed dots. It also makes clear when browsing the home directory what files are / aren't managed.

It handles externally-maintained scripts without letting them either get stale or change unexpectedly underfoot. See [vendor/](vendor) for details.

For Linux and OS X compatibility, the install and vendor scripts work with GNU or BSD utils and are POSIX compliant. POSIX compliance was adhered to mostly to understand the pain of avoiding bashisms. It's nice that '/bin/sh' can handle the scripts, but for meaningful portability gains, I could make sure things worked somewhere without the standard GNU or BSD utils.

#### Init script design

Do the right thing for any combination of:
- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- bash or /bin/sh

Doing the right thing meaning: added functionality should hit precisely the environments it's desirable for and no others.

Considerations:
- OSX graphical sessions run dots with bash, but debian-based graphical sessions run dots with dash
  + Anything used by graphical sessions should be POSIX sh
- OSX graphical read anything actually?
- Diff between new terminal window in osx vs ubuntu?
- Giving login (interactive or non) path, etc.
- bash vs /bin/sh vs bash --posix-mode

#### Status

Paths I hit daily are pretty smooth. Shell init script structure will be cleaned up eventually (once that whole 'do the right thing' requirement feels done-ish). 'Tested' with bash, dash, and bash's posix mode. Testing in an ash / busy box environment would be instructive.

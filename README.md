## My dotfiles

TLDR: My dotfiles are in [dots/](dots) if that's what you're looking for. The rest is about how I deploy them, incorporate third-party code, etc.

#### Project structure design

Install/deploy with a git clone or scp, followed by executing an included script.

Dotfiles / dotdirs are symlinked from the project into place. This makes clear when uncommitted changes have been made to managed dots. It also makes clear when browsing the home directory what files are / aren't managed.

It handles externally-maintained scripts without letting them either get stale or change unexpectedly underfoot. (There's a 'vendor' directory and command to diff vendored projects against their latest versions and vendor/ignore/postpone changes as desired.)

For Linux and OS X compatibility, the install and vendor scripts work with GNU or BSD utils and are POSIX compliant. POSIX compliance was mostly a learning experiment to get a feel for the trade-offs of eliminating bashisms. It's nice that '/bin/sh' can handle the scripts, but for meaningful portability gains, I could make sure things worked somewhere without the standard GNU or BSD utils.

#### Init script design

Do the right thing for any combination of:
- Linux or OS X
- graphical or text console
- login or non-login
- interactive or non-interactive
- bash or /bin/sh

Doing the right thing meaning: added functionality should hit precisely the environments it's desirable for and no others.


#### Status

Paths I hit daily are pretty smooth. Dotfile structure will be cleaned up eventually (once functional improvements ease up). Has only seen bash, dash, and bash's posix mode. It would probably be useful to bump against an ash / busy box environment. 

#!/usr/bin/env bash

export order="$order .bashrc"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Some systems' PROMPT_COMMANDs, etc., rely on /etc/bashrc
if [ -n "$BASH_VERSION" ] && [ -f "/etc/bashrc" ]; then
	. "etc/bashrc"
fi

# Keep ubuntu's default .bashrc as a base
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/bashrc.ubuntu" ]; then
	. "$HOME/bashrc.ubuntu"
fi

### my general additions:

export VISUAL=vim
export EDITOR="$VISUAL"

### build ps1:

# call out exit codes
function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "^^($RETVAL) "
}
[ -n "$BASH_VERSION" ] && export -f nonzero_return

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}
[ -n "$BASH_VERSION" ] && export -f parse_git_branch

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}
[ -n "$BASH_VERSION" ] && export -f parse_git_dirty

# # export PS1="\[\e[31m\]$(if [ $(id -u) -ne 0 ] then echo $(nonzero_return) ; fi)\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\n\\$ "
# if [ -z "$(which git)" ]; then
# 	export PS1="\[\e[31m\]$(if [ $(id -u) -ne 0 ] then echo $(nonzero_return) ; fi)\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\n\\$ "
# else
# 	export PS1="\[\e[31m\]\`nonzero_return\`\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\] \`parse_git_branch\`\n\\$ "
# 	export PS1="\[\e[31m\]${nonzero_return:+(nonzero_return)}\[\e[m\]\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\] \`parse_git_branch\`\n\\$ "
# 	# ubuntu def.: "\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
# fi

### language-specific:

# go
export GOPATH=$HOME
gocd () { cd "$(go list -f '{{.Dir}}' "$1")"; } # gocd .../mypkg
[ -n "$BASH_VERSION" ] && export -f gocd

#javascript
export NVM_DIR="/home/sean/.nvm"
[ -n "$BASH_VERSION" ] && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# python (& devtools written in python)

# used to set up and activate a default virtualenv for local development tools
mkpydev () { python3 -m venv /usr/local/dev-env; }
[ -n "$BASH_VERSION" ] && export -f mkpydev
pydev () { . ~/.dev-env/bin/activate; }
[ -n "$BASH_VERSION" ] && export -f pydev

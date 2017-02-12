alias g=git $*
# Preserve bash completion when using alias
source /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g


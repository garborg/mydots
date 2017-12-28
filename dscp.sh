#!/bin/sh

set -e

if [ -z "$1" ]; then
 echo "Please specify remote host"
 exit 1
fi

tball="mydots.tar.gz"
echo "bundling"
# archives non-ignored files, whether or not tracked/added/committed
(git ls-files; git ls-files -o --exclude-standard) | xargs tar -zcf "$tball"
echo "shipping"
scp "$tball" "$1:~"
echo "unbundling and linking"
ssh -t "$1" "mkdir -p ~/mydots && tar -xzf "~/$tball" -C ~/mydots && cd mydots && ./linkdots.sh"
ssh "$1"

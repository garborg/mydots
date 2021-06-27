#!/bin/sh

set -e

. ./setup-base.sh

./install-conda.sh
./install-source.sh

git config credential.helper 'cache --timeout=3600'

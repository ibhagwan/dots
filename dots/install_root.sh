#!/bin/sh -e

## MUST BE RUN AS ROOT (sudo/doas)
if [ $(id -u) -ne 0 ]; then
	echo "error: $0 must be run as root (sudo/doas)"
	exit 1
fi

# script working directory & git root
BASEDIR=$(cd "$(dirname "$0")" ; pwd -P)
GIT_CWD=$(git -c safe.directory="*" -C ${BASEDIR} rev-parse --show-toplevel)

TARGET=${1:-"/root"}

if [ ! -d ${TARGET} ]; then
	echo "error: ${TARGET} must be a directory"
	exit 1
fi

FNAMES="\
 .ssh/config\
 .profile\
 .config/tmux\
 .config/git\
 .config/zsh\
 .config/nvim\
 .config/aliases\
"

copy() {
    local src=$1
    local dst=$2
    printf "Copying [1;33m${src}[0m\t=> [1;34m${dst}[0m\t..."
    parent=$(dirname ${dst})
    mkdir -p ${parent} > /dev/null 2>&1
    if [ -d ${dst} ]; then
        rm -rf "${dst}"
    fi
    cp -R "${src}" "${dst}"
    chown -R root:root "${dst}"
    local retVal=$?
    if [ $retVal -ne 0 ]; then
        printf " [[0;31m[0m]\n"
    else
        printf " [[0;32m[0m]\n"
    fi
}

for FNAME in ${FNAMES}; do
    copy ${GIT_CWD}/${FNAME} ${TARGET}/${FNAME}
done

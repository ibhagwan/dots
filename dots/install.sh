#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# script working directory
BASEDIR=$(cd "$(dirname "$0")"; pwd -P)
GIT_DIR=$(dirname $(cd "$(git -C ${BASEDIR} rev-parse --git-dir)"; pwd -P))
DOT_CMD="git -c status.showUntrackedFiles=no --git-dir=${GIT_DIR}/.git -C ${HOME}"
REPO_URL=$(${DOT_CMD} config --get remote.origin.url)


echo "[1;34mBASEDIR:[0;33m  ${BASEDIR}[0m"
echo "[1;34mGIT_DIR:[0;33m  ${GIT_DIR}/.git[0m"
echo "[1;34mREPO_URL:[0;33m ${REPO_URL}[0m"
echo ""

# new install, reset modules
if [ ! -d ${GIT_DIR}/.git/modules ]; then
    git -C ${GIT_DIR} submodule status | \
        perl -ne '/.\d+\s(.+?)(?=\s|$)/ && print "$1\n"' | \
        while read path; do
            echo "[1;32mNew install, deleting [0;33m${path}[0m...[0m"
            rm -rf ${path}
        done
fi

# set current git worktree to $HOME
echo "[1;32mConfiguring repo[0m [0;34mcore.worktree=[0;33m${HOME}[0m"
git -C ${BASEDIR} config core.worktree ${HOME}

# configure repo to not display untracked files
echo "[1;32mConfiguring repo[0m [0;34mstatus.showUntrackedFiles=[0;33mno[0m"
git -C ${BASEDIR} config --local status.showUntrackedFiles no

if [ ! -L ${GIT_DIR}/.git/.git ]; then
    # new install, reset to HEAD (expands into $HOME)
    echo "[1;32mNew install, resetting to [0;33mHEAD[1;32m...[0m"
    ${DOT_CMD} reset --hard HEAD
else
    # pull latest
    echo "[1;32mPulling[0m from [0;33m${REPO_URL}[1;32m...[0m"
    ${DOT_CMD} pull --ff-only --progress --rebase=true
fi

# update submodules
echo "[1;32mUpdating submodules...[0m"
${DOT_CMD} submodule update --init --recursive

# setup repo symbolic link at $HOME
echo "[1;32mSetup repo link [0m [0;33m$HOME/.git[0m -> [0;33m$GIT_DIR/.git[0m"
ln -fs ${GIT_DIR}/.git ${HOME}/.git

# Deleting local copies
if [ ${HOME} != ${GIT_DIR} ]; then
    echo "[1;32mDeleting local copies in[0;33m ${GIT_DIR} [0m..."
    ${DOT_CMD} ls-tree --name-only HEAD | while read path; do
        if [ -e ${GIT_DIR}/${path} ] || [ -L ${GIT_DIR}/${path} ]; then
            echo "[0;34mrm -rf ${GIT_DIR}/${path}[0m"
            rm -rf ${GIT_DIR}/${path}
        fi
    done
fi

# Source aliases
alias dot="${DOT_CMD}"
echo "[1;32mCreated the [0;33mdot[1;32m alias.[0m"

# If exists, run install.local
if [ -x ${BASEDIR}/install.local ]; then
    echo "[1;32mRunning [0;33minstall.local[1;32m...[0m"
    ${BASEDIR}/install.local
fi

echo "[1;32mDONE.[0m"

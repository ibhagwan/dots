#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# script working directory
BASEDIR=$(cd "$(dirname "$0")" ; pwd -P)

GIT_CWD=$(git -C ${BASEDIR} rev-parse --show-toplevel)
GIT_CMD="git -C ${GIT_CWD}"
DOT_CMD="git -c status.showUntrackedFiles=no --git-dir=${GIT_CWD}/.git -C ${HOME}"
REPO_URL=$(${GIT_CMD} config --get remote.origin.url)

# pull latest
echo "[1;32mPulling[0m from [0;33m${REPO_URL}[1;32m...[0m"
${GIT_CMD} pull --ff-only --progress --rebase=true

# reset to local HEAD
echo "[1;32mResetting to [0;33mHEAD[1;32m...[0m"
${DOT_CMD} reset --hard HEAD

# update submodules
echo "[1;32mUpdating submodules...[0m"
${DOT_CMD} submodule update --init --recursive

# Source aliases
alias dot="${DOT_CMD}"
echo "[1;32mCreated the [0;33mdot[1;32m alias.[0m"

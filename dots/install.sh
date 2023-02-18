#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# script working directory
BASEDIR=$(cd "$(dirname "$0")" ; pwd -P)

# defines 'clone_or_pull_repo' function
# `sh` has no source, use `.` instead
. $BASEDIR/fncs.sh

YADM_REPO_URL="git@github.com:ibhagwan/dots.git"
YADM_PROJ_URL="https://github.com/TheLocehiliosan/yadm.git"
YADM_PROJ_PATH=${BASEDIR}/yadm
YADM_REPO_PATH=${BASEDIR}/yadm-repo
YADM_CMD="${YADM_PROJ_PATH}/yadm --yadm-repo ${YADM_REPO_PATH}"

# clone the yadm project source
clone_or_pull_repo "git -C ${BASEDIR}" "git -C ${YADM_PROJ_PATH}" \
    "${YADM_PROJ_URL}" "${YADM_PROJ_PATH}"

# clone the yadm-repo
clone_or_pull_repo "${YADM_CMD}" "${YADM_CMD}" \
    "${YADM_REPO_URL}" "${YADM_REPO_PATH}"

# reset to local HEAD
echo "[1;32mResetting to HEAD...[0m"
${YADM_CMD} reset --hard HEAD

# update submodules
echo "[1;32mUpdating submodules...[0m"
${YADM_CMD} submodule update --init --recursive

echo "[1;32mDONE.[0m"

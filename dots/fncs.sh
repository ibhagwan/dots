#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

clone_or_pull_repo() {
    clone_cmd=${1}
    pull_cmd=${2}
    repo_url=${3}
    repo_path=${4}
    if [ ! -e ${repo_path} ]; then
        echo "[1;32mCloning[0m [0;33m${repo_url}[0m ==> [0;34m${repo_path}[0m"
        ${clone_cmd} clone "${repo_url}"
    else
        echo "[1;32mPulling[0m from [0;33m${repo_url}[0m ==> [0;34m${repo_path}[0m"
        ${pull_cmd} pull --ff-only --progress --rebase=true
    fi
}

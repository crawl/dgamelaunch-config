#!/bin/bash

set -e

source $DGL_CONF_HOME/sh-utils
source $DGL_CONF_HOME/crawl-git.conf

REPO_DIR=$PWD/$CRAWL_REPOSITORY_DIR

clone-crawl-ref() {
    if [[ -d "$CRAWL_REPOSITORY_DIR" && -d "$CRAWL_REPOSITORY_DIR/.git" ]]; then
        return 0
    fi
    CMDLINE="git clone $CRAWL_GIT_URL $CRAWL_REPOSITORY_DIR"
    say "$CMDLINE"
    $CMDLINE
}

update-crawl-ref() {
    say "Updating git repository $REPO_DIR"
    ( cd $REPO_DIR && git checkout -f &&
        git checkout $BRANCH &&
        git fetch &&
        git reset --hard FETCH_HEAD )
    if [[ -n "$REVISION" ]]; then
        say "Checking out requested revision: $REVISION"
        ( cd $REPO_DIR && git checkout "$REVISION" )
    fi
}

update-submodules() {
    say "Updating git submodules in $REPO_DIR"
    ( cd $REPO_DIR && git submodule update --init )
}

BRANCH=$1
REVISION="$2"
[[ -n "$BRANCH" ]] || abort-saying "$0: Checkout branch not specified!"
clone-crawl-ref
update-crawl-ref
update-submodules

#!/bin/bash

set -e
lock-or-die crawl-update "someone is already updating the crawl build"

source $DGL_CONF_HOME/crawl-git.conf
GAME=crawl-bot-git

export DESTDIR=$CRAWL_BASEDIR

check-crawl-basedir-exists
enable-prompts $*

TODAY="$(dgl-today)"

# Second argument can be a revision (SHA) to build
REVISION="$1"
./update-public-repository.sh $BRANCH "$REVISION"

REVISION="$(git-do rev-parse HEAD | cut -c 1-10)"
REVISION_FULL="$(git-do describe --long HEAD)"
VER_STR="$(git-do describe HEAD)"
VER_STR_OLD="$( ($CRAWL_BINARY_PATH/$GAME -version 2>/dev/null || true) | sed -ne 's/Crawl version //p')"
REVISION_OLD="${VER_STR_OLD##*-g}"

[[ "$REVISION" == "$REVISION_OLD" || "$VER_STR" = "$VER_STR_OLD" ]] && \
    abort-saying "Nothing new to install at the moment: you asked for $REVISION_FULL and it's already installed"

prompt "start update build"

cd $CRAWL_REPOSITORY_DIR/crawl-ref

echo "Copying CREDITS to docs/crawl_credits.txt..."
cp CREDITS.txt docs/crawl_credits.txt

dgl-git-log() {
    git-do log --pretty=tformat:"--------------------------------------------------------------------------------%n%h | %an | %ci%n%n%s%n%b" "$@" | grep -v "git-svn-id" | awk 1 RS= ORS="\n\n" | fold -s
}

echo "Creating changelog in docs/crawl_changelog.txt..."
dgl-git-log $BRANCH > docs/crawl_changelog.txt

if prompts-enabled; then
    echo "Changes to $BRANCH from $REVISION_OLD .. $REVISION"
    dgl-git-log ${REVISION_OLD:+$REVISION_OLD..}${REVISION} | less
fi

prompt "compile ${GAME} (${REVISION})"

# REMEMBER to adjust /var/lib/dgamelaunch/sbin/install-bot-trunk.sh as well if make parameters change!
##################################################################################################

say-do crawl-do nice make -C source \
    GAME=${GAME} \
    GAME_MAIN=${GAME} MCHMOD=0755 MCHMOD_SAVEDIR=755 \
    INSTALL_UGRP=$CRAWL_UGRP \
    WEBTILES=YesPlease USE_DGAMELAUNCH=YesPlease WIZARD=YesPlease \
    STRIP=true DESTDIR=${DESTDIR} prefix= bin_prefix=/bin \
    SAVEDIR=$CHROOT_CRAWL_BASEDIR/${GAME}/saves \
    DATADIR=$CHROOT_CRAWL_BASEDIR/${GAME}/data \
    WEBDIR=$CHROOT_CRAWL_BASEDIR/${GAME}/data/web \
    USE_PCRE=y \
    EXTERNAL_FLAGS_L="-g"

prompt "install ${GAME} (${REVISION})"

say-do sudo -H $DGL_CHROOT/sbin/install-bot-trunk.sh

echo "All done."
echo

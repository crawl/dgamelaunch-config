#! /bin/sh

NAME=$1
VERSIONS="git $(seq 11 33 | sed 's/^/0./')"

for v in $VERSIONS; do
    cp --no-clobber "%%CHROOT_DGLDIR%%/data/crawl-$v-settings/init.txt" "%%CHROOT_RCFILESDIR%%/crawl-$v/$NAME.rc"
    cp --no-clobber "%%CHROOT_DGLDIR%%/data/crawl-$v.macro" "%%CHROOT_RCFILESDIR%%/crawl-$v/$NAME.macro"
done

mkdir -p "%%CHROOT_MORGUEDIR%%/$NAME"
mkdir -p "%%CHROOT_TTYRECDIR%%/$NAME"

#! /bin/bash
#
# Publish everything other than the dgamelaunch.conf file.
#

assert-chroot-exists
set -- "--confirm" "--skip" "dgamelaunch.conf" "$@"
# shellcheck source=crawl-git.conf
source "$DGL_CONF_HOME/crawl-git.conf"

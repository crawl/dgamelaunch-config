#! /bin/bash
#
# Publish only the dgamelaunch config file.
#

assert-chroot-exists
set -- "--confirm" "--match" "dgamelaunch.conf" "$@"
# shellcheck source=crawl-git.conf
source "$DGL_CONF_HOME/crawl-git.conf"

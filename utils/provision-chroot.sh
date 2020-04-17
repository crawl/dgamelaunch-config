#!/bin/bash

# automate setting up a fresh chroot for a dgamelaunch-config setup. This will
# work as-is on a clean ubuntu system for a default setup, but you may want to
# examine the values carefully or even manually run it step by step.

# This script mainly deals with the steps that require `chroot` to be
# runnable, and aside from the bind mount step, only deals with chroot-internal
# setup that is not dgl-config-specific.

# TODO: would this script be better as a script that is run from dgl? It would
# at least allow getting the chroot location & dgl-config automatically.

[[ "$UID" != "0" ]] && echo "This script must be run as root" && exit 1

# needs to match the location and value in dgamelaunch.conf obviously
DGL_CONF_HOME=/home/crawl-dev/dgamelunch-config/
DGL_CHROOT=/home/crawl/DGL
LANG=en_US.UTF-8

CRAWL_USER=$(id -u crawl)
if [ $? -ne 0 ]; then echo "No 'crawl' user!"; exit 1; fi
CRAWL_GROUP=$(id -g crawl)
CDEV_USER=$(id -u crawl-dev)
if [ $? -ne 0 ]; then echo "No 'crawl-dev' user!"; exit 1; fi
CDEV_GROUP=$(id -g crawl-dev)

# must match the outer distribution.
debootstrap bionic $DGL_CHROOT
cp /etc/resolv.conf $DGL_CHROOT/etc/resolv.conf
cp /etc/apt/sources.list $DGL_CHROOT/etc/apt/

# these bind mounts would need to be manually added to the fstab in some setups
mount --bind /proc/ $DGL_CHROOT/proc/
mount --bind /dev/pts/ $DGL_CHROOT/dev/pts/

cat << EOF | chroot $DGL_CHROOT/
# minimal package list for running crawl and doing some basic maintenance; you
# may want to curate this further.
apt-get update && apt-get -y install bzip2 python3-minimal ncurses-term locales locales-all sqlite3 libpcre3 liblua5.1-0 autoconf build-essential lsof bison libncursesw5-dev libsqlite3-dev flex sudo libbot-basicbot-perl vim
sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG
# match the uids to the containing system
groupadd crawl -g $CRAWL_GROUP
groupadd crawl-dev -g $CDEV_GROUP
useradd crawl -u $CRAWL_USER -g $CRAWL_GROUP
useradd crawl-dev -u $CDEV_USER -g $CDEV_GROUP
EOF

# In order for the webtiles server to work when chrooted, it needs access to
# any packages that are dynamically imported. In general this is very few, but
# Tornado versions >3 rely heavily on dynamic imports. So we copy it into the
# chroot from outside.
# An alternative would be to install a full python setup into the chroot,
# including this package, but this is extremely heavy.
#
# I'm not sure if this is a reliable recipe for finding package locations in
# general, but it seems to work for tornado.
TORNADO_PATH=$(python3 -c "import tornado; print(tornado.__path__[0])")
if [ $? -ne 0 ]; then
    echo "Cannot find path to tornado; please rerun or manually copy the package into the chroot."
    exit 1
fi

# n.b. --parents here is GNU-specific
cp -R --parents "${TORNADO_PATH}" "$DGL_CHROOT/"

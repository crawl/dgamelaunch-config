#!/bin/bash
#/home/crawl-dev/dgamelaunch-config/utils/provision-chroot.sh
source "$DGL_CONF_HOME/dgl-manage.conf"
if [ "$1" = '--provision-chroot' ]; then
    /home/crawl-dev/dgamelaunch-config/bin/dgl create-versions-db
    /home/crawl-dev/dgamelaunch-config/bin/dgl create-crawl-gamedir
    /home/crawl-dev/dgamelaunch-config/bin/dgl publish --confirm
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-0.25
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-dcssca
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable 0.25 origin/stone_soup-0.25 
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-gcc6 dcssca dcssca/master
fi

if [ "$1" = '--provision-single' ]; then
    cd /home/crawl-dev/dgamelaunch-config/bin
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-$2
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable $2 $3 
fi

/home/crawl-dev/dgamelaunch-config/bin/dgl publish --confirm
/etc/init.d/ssh start
/etc/init.d/webtiles start
sleep infinity # gnu-specific trick
# would probably be more docker-ish if webtiles were running in the foreground
# for this case...
if [ "$1" = '--background' ]; then
    sleep infinity # gnu-specific trick
    exit 0
fi

# convenience: run whatever CL arguments there are if we got to this point.
# probably something like /bin/bash.
if [ ! -z $@ ]; then
    exec "$@"
fi

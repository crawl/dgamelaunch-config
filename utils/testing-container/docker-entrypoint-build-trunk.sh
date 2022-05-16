#!/bin/bash
#/home/crawl-dev/dgamelaunch-config/utils/provision-chroot.sh
source "$DGL_CONF_HOME/dgl-manage.conf"
/home/crawl-dev/dgamelaunch-config/bin/dgl create-versions-db
/home/crawl-dev/dgamelaunch-config/bin/dgl create-crawl-gamedir
/home/crawl-dev/dgamelaunch-config/bin/dgl publish --confirm
/home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk
if [ "$1" = '--provision-chroot' ]; then
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-0.25
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-dcssca
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-hellcrawl
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable 0.25 origin/stone_soup-0.25 
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-gcc6 dcssca dcssca/master
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-gcc6 hellcrawl hellcrawl/bugfix
fi

if [ "$1" = '--provision-single' ]; then
    cp -a -n $DGL_CHROOT/crawl-master/crawl-git $DGL_CHROOT/crawl-master/crawl-$2
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk
    /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable $2 $3 
fi

/etc/init.d/ssh start
rm "$CHROOT_WEBDIR/run/webtiles.pid" #in case the container was stopped without cleaning up pid file in volume
/etc/init.d/webtiles restart
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

#Otherwise just tail the webtiles log
tail -f $DGL_CHROOT/crawl-master/webserver/run/webtiles.log
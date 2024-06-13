#!/bin/bash

sed -i 's|<script src="/static/scripts/contrib/require.js" data-main="/static/scripts/app"></script>|<script src="https://cdn.jsdelivr.net/gh/refracta/dcss-webtiles-extension-module/loader/dwem-base-loader.js"></script>|g' "$CHROOT_CRAWL_BASEDIR/webserver/templates/client.html"

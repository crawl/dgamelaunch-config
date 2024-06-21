#!/bin/bash

source "$DGL_CONF_HOME/dgl-manage.conf"
sed -i 's|<script src="/static/scripts/contrib/require.js" data-main="/static/scripts/app"></script>|<script src="https://cdn.jsdelivr.net/gh/refracta/dcss-webtiles-extension-module/loader/dwem-base-loader.js"></script>|g' "$WEBDIR/templates/client.html"
sed -i 's|<script type="text/javascript">|<script type="text/javascript">
      localStorage.DWEM_MODULES = JSON.stringify(
        ["../modules/io-hook/index.js", "../modules/module-manager/index.js", "../modules/legacy-module-support/index.js"]
      );
|g' "$WEBDIR/templates/client.html"

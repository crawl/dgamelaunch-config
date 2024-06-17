#!/bin/bash

"$SCRIPTS"/dgl/setup-user.sh
"$SCRIPTS"/game/setup-cron.sh

"$SCRIPTS"/web/init.sh
"$SCRIPTS"/web/setup-apache.sh
"$SCRIPTS"/web/setup-nginx.sh

if [ "$USE_REVERSE_PROXY" = 'true' ]; then
  echo "Run setup-reverse-proxy.sh"
  "$SCRIPTS"/utils/setup-reverse-proxy.sh
fi
if [ "$USE_DWEM" = 'true' ]; then
  echo "Run setup-dwem.sh"
  "$SCRIPTS"/utils/setup-dwem.sh
fi
if [ "$USE_CNC_CONFIG" = 'true' ]; then
  echo "Run setup-cnc-config.sh"
  "$SCRIPTS"/utils/setup-cnc-config.sh
fi

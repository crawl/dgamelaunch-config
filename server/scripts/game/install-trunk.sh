#!/bin/bash

source "$DGL_CONF_HOME/dgl-manage.conf"
dgl update-trunk | tee -a /home/crawl-dev/logs/stable.log

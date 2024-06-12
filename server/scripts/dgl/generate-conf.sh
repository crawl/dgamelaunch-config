#!/bin/bash

cd "$DGL_CONF_HOME/utils/dgl-conf-generator"
python generate.py
cp "$DGL_CONF_HOME/utils/dgl-conf-generator/dgamelaunch.conf" "$DGL_CONF_HOME"

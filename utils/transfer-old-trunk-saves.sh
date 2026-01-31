#!/bin/bash

set -e

DGL=/home/crawl-dev/dgamelaunch-config/bin/dgl
# How many trunk versions to keep in total.
NUM_VERSIONS=50

# Adds to array all players on Nth newest version and older. The 4 is for the
# header lines that must be skipped.
readarray -t names < <(
$DGL remove-trunks -v | tail -n +$(( 4 + $NUM_VERSIONS )) | awk '{for(i=7;i<=NF;++i)print $i}'
)

echo -n "Transferring saves older than $NUM_VERSIONS trunk versions at "
date;

for name in "${names[@]}"
do
  $DGL savegame-transfer $name
done

echo done.
echo

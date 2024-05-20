#!/bin/bash
# build a forks container
# see utils/testing-container/README.md

# TODO: take this var as a cl argument?
CONTAINER_TAG=dgl-forks

cd `dirname "$0"`/..
docker build --tag $CONTAINER_TAG -f utils/testing-container/Dockerfile .
if [ $? -ne 0 ]; then echo "Aborting after docker build!" && exit 1; fi
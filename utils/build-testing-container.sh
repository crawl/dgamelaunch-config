#!/bin/bash
# build a test container
# see utils/testing-container/README.md

# TODO: take this var as a cl argument?
CONTAINER_TAG=dgl-test

cd `dirname "$0"`/..
docker build --tag $CONTAINER_TAG -f utils/testing-container/Dockerfile .
if [ $? -ne 0 ]; then echo "Aborting after docker build!" && exit 1; fi

if [ "$1" = '--no-tty' ]; then
    docker run --privileged $CONTAINER_TAG --provision-chroot
else
    docker run -it --privileged $CONTAINER_TAG --provision-chroot
fi

if [ $? -ne 0 ]; then
    echo "Aborting after chroot script!" && exit 1;
fi

CID=$(docker ps -lq)
docker commit $CID $CONTAINER_TAG
echo "Container commited as '$CONTAINER_TAG'!"

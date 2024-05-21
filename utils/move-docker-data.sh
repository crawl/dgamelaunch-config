#!/bin/bash
#move docker data folder from regular location to mounted drive, which contains the volumes
sudo systemctl stop docker.service
sudo systemctl stop docker.socket
sudo sed -i 's/\bExecStart\=\/usr\/bin\/dockerd -H fd:\/\/\b/ExecStart\=\/usr\/$'
sudo systemctl daemon-reload
sudo systemctl start docker

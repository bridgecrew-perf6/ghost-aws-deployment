#!/usr/bin/env bash

set -e
set -x

DOCKER_NAME="ux2play"
DOCKER_TAG="latest"

sudo mv /tmp/ux2play.systemd.unit /etc/systemd/system/ux2play.service
sudo mkdir -p /opt/ux2play
sudo mv /tmp/docker-compose.yml /opt/ux2play/docker-compose.yml
sudo mv /tmp/docker-compose.sh /opt/ux2play/docker-compose.sh

sudo systemctl daemon-reload
sudo systemctl enable ux2play

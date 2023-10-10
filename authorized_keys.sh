#!/bin/bash

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
CONTAINER_ID=$(docker ps | grep gitlab/gitlab | awk '{print $1}')

docker exec -u git $CONTAINER_ID sed "s#/opt/gitlab/embedded/service/gitlab-shell/bin/gitlab-shell#${DIR}/tunnel.sh#g" /var/opt/gitlab/.ssh/authorized_keys

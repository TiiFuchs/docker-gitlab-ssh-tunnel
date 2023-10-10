#!/bin/bash

CONTAINER_ID=$(docker ps | grep gitlab/gitlab | awk '{print $1}')

docker exec -i \
	-u git \
	-e SSH_CONNECTION="$SSH_CONNECTION" \
	-e SSH_ORIGINAL_COMMAND="$SSH_ORIGINAL_COMMAND" \
	$CONTAINER_ID \
	/opt/gitlab/embedded/service/gitlab-shell/bin/gitlab-shell $1

#!/usr/bin/env bash

set -eo pipefail

#docker rmi -f $(docker images -q)
#docker rmi $(docker images)
#docker rmi $(docker images -qf dangling=true);
docker system prune -a --force
docker ps
docker images
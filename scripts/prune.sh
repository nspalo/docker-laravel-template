#!/usr/bin/env bash

set -eo pipefail

# Delete All Images
docker system prune -a --force
docker ps
docker images
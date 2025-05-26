#!/bin/bash
mkdir -p ~/docker/config
cp docker-compose.yml ~/docker/docker-compose.yml
# cp nginx.conf ~/docker/nginx/conf.d/nginx.conf
cd ~/docker
docker compose up -d
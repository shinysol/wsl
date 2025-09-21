#!/bin/bash
mkdir -p ~/docker/config
mkdir -p ~/docker/kafka-config
cp -f docker-compose.yml ~/docker/docker-compose.yml
cp -f refresh.sh ~/docker/
cp -rf kafka-config/* ~/docker/kafka-config/
# cp nginx.conf ~/docker/nginx/conf.d/nginx.conf
cd ~/docker
docker compose up -d
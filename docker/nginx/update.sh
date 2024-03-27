#!/usr/bin/env sh

./build.sh

docker stop palabras-nginx
docker rm  palabras-nginx

./run.sh


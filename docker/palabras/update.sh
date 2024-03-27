#!/usr/bin/env sh

./build.sh

docker stop palabras-be
docker rm  palabras-be

./run.sh


#!/usr/bin/env sh

./build.sh

docker stop palabras-translator
docker rm  palabras-translator

./run.sh


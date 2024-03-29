#!/usr/bin/env sh

cd ./translator || exit 1
git fetch origin
git pull origin main
cd ..

docker build -t heatherss92065/palabras-translator-image:v1.1 .

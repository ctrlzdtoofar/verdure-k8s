#!/usr/bin/env sh

cd ./translator || exit 1
git fetch origin
git pull origin main
cd ..

docker build -t palabras-translator-image .

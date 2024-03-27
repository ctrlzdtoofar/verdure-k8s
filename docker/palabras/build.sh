#!/usr/bin/env sh

cd ./palabras || exit 1
git fetch origin
git pull origin main
cd ..

docker build -t palabras-be-image .

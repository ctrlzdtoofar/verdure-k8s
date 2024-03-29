#!/usr/bin/env sh

cd ./yew-study || exit 1
git fetch origin
git pull origin main
trunk build --release
cd ..

docker build -t heatherss92065/yew-study-nginx-image:v1.1 .

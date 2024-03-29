#!/usr/bin/env sh

mkdir -p html
cp -R ./proj/* html/.

docker build -t heatherss92065/palabras-nginx-image .

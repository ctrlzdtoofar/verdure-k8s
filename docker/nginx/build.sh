#!/usr/bin/env sh

mkdir -p html
cp -R ./proj/* html/.

docker build -t palabras-nginx-image .

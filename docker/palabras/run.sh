#!/usr/bin/env sh

docker run --name palabras-be \
  -d -p 3030:3030 \
  --network palabras-network \
  -v ~/.aws:/root/.aws \
  -e PAL_DB_LINK -e PAL_REGION -e PAL_SERVER_ADDR \
  palabras-be-image

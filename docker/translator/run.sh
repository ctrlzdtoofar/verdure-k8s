#!/usr/bin/env sh

docker run --name palabras-translator \
  -d -p 8090:8090 \
  --network palabras-network \
  -v ~/.aws:/root/.aws \
  -e DB_LINK -e REGION \
  palabras-translator-image

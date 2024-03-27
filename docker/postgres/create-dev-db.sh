#!/usr/bin/env sh

docker pull postgres:latest
docker run --name dev-postgres \
  -d -t -e POSTGRES_PASSWORD="$PGPASSWORD" \
  -p 5435:5432 \
  --network palabras-network \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v /var/lib/postgres/dev:/var/lib/postgresql/data \
  postgres


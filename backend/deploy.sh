#!/bin/bash
set -e
cat > .env <<EOF
PSQL_HOST=${PSQL_HOST}
PSQL_DBNAME=${PSQL_DBNAME}
PSQL_PORT=${PSQL_PORT}
PSQL_USERNAME=${PSQL_USERNAME}
PSQL_PASSWORD=${PSQL_PASSWORD}
MONGO_HOST=${MONGO_HOST}
MONGO_DATABASE=${MONGO_DATABASE}
MONGO_PORT=${MONGO_PORT}
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
VERSION=${VERSION}
EOF

echo $PSQL_HOST

docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest

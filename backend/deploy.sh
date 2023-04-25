#!/bin/bash
set -xe

cat > .env <<EOF
PSQL_HOST=${PSQL_HOST}
PSQL_DBNAME=${PSQL_DBNAME}
PSQL_PORT=${PSQL_PORT}
PSQL_USER=${PSQL_USER}
PSQL_PASSWORD=${PSQL_PASSWORD}
MONGO_HOST=${MONGO_HOST}
MONGO_DATABASE=${MONGO_DATABASE}
MONGO_PORT=${MONGO_PORT}
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
VERSION=${VERSION}
EOF

cp .env $GIT_FOLDER/backend/

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

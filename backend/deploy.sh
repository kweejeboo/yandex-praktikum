#!/bin/bash
set +e
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
VERSION=${VERSION}
EOF

curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} "$NEXUS_BACKEND_REPO_URL/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar"

docker network create -d bridge sausage_network || true
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true
set -e
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest 

#!/bin/bash
set -xe

cat > .backend-env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
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
docker-compose up -d sausage-backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .backend-env \
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest

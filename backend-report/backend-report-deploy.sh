#!/bin/bash
set -xe

cat > report.env <<EOF
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
VERSION=${VERSION}
EOF

cp report.env $GIT_FOLDER/backend-report/

docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest
docker stop backend || true
eocker rm backend || true
docker-compose up -d backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file report.env \
    -p 8888:8888
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend-report:latest

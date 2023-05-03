#!/bin/bash
set -xe

cat > backend-report.env <<EOF
DB=${SPRING_DATA_MONGODB_URI}?tls=true&tlsCaFile=YandexInternalRootCA.crt
CI_PROJECT_DIR=${CI_PROJECT_DIR}
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
VERSION=${VERSION}
EOF

cp ${CI_PROJECT_DIR}/docker-compose.yml $GIT_FOLDER/backend-report/
cp backend-report.env $GIT_FOLDER/backend-report/

docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true
docker-compose up -d backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file report.env \
    -p 8888:8888
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend-report:latest

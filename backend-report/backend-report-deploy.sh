#!/bin/bash
set -xe

cat > backend-report.env <<EOF
DB=${SPRING_DATA_MONGODB_URI}&tlsCaFile=YandexInternalRootCA.crt
PORT=${PY_MONGO_PORT}
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
VERSION=${VERSION}
EOF



cd $GIT_FOLDER/backend-report
docker-compose stop backend-report || true
docker-compose up -d backend-report


#!/bin/bash
set -xe

cat > backend-report.env <<EOF
DB=${SPRING_DATA_MONGODB_URI}?tls=true&tlsCaFile=YandexInternalRootCA.crt
PORT=8888
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
VERSION=${VERSION}
EOF


cp backend-report.env $GIT_FOLDER/backend-report/
cd $GIT_FOLDER/backend-report
docker stop backend-report || true
docker rm backend-report || true
docker-compose up -d backend-report


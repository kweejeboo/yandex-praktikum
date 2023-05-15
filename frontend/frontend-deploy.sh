#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe

cat > frontend.env <<EOF
GITLAB_REGISTRY=${GITLAB_REGISTRY}
GITLAB_USER=${GITLAB_USER}
GITLAB_PASS=${GITLAB_PASS}
GIT_FOLDER=${GIT_FOLDER}
EOF

cd $GIT_FOLDER/frontend/
docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-frontend:latest
docker-compose stop frontend  || true
docker-compose rm -f frontend || true

set -e
docker-compose up -d frontend 


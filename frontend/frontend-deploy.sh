#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe

cd $GIT_FOLDER/frontend/
docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-frontend:latest
docker-compose stop sausage-store-frontend  || true

set -e
docker-compose up -d frontend 


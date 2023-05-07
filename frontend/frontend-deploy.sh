#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe

docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-frontend:latest
docker-compose stop sausage-store-frontend  || true
docker-compose rm sausage-store-frontend || true
set -e
docker-compose up -d frontend \
    --network=sausage_network \
    --restart always \
    --pull always \
    -p 1080:80 \
    ${GITLAB_REGISTRY}/sausage-store/sausage-frontend:latest


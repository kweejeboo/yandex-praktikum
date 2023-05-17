#!/bin/bash
set -xe

cat > backend.env <<EOF
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

cd $GIT_FOLDER
#docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest
#docker-compose stop backend || true
#docker-compose rm -f backend || true
#docker-compose up -d backend-blue 

if [ "$(docker ps -f name=backend-blue -q)" ]
then
    NEW="backend-green"
    OLD="backend-blue"
else
    NEW="backend-blue"
    OLD="backend-green"
fi

echo "Starting "$NEW" container"
docker-compose up -d --build --force-recreate $NEW

until [ "$(docker container ls --filter health=healthy --filter name=$NEW)" ]
do
    echo "Waiting for healthcheck to be completed"
    sleep 1
done
echo -e "\nHealthcheck status: Healthy"

echo "Stopping "$OLD" container"
docker-compose stop $OLD
docker-compose rm $OLD
docker system prune -f
docker volume prune -f

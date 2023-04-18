#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
#sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
#sudo rm -f /home/jarservice/sausage-store-frontend.tar.gz||true
#Переносим артефакт в нужную папку
#curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-frontend.tar.gz ${NEXUS_FRONTEND_REPO_URL}/${VERSION}/sausage-store-${VERSION}.tar.gz
#Распакуем архив в нужную папку и скопируем файлы в директорию фронтэнда
#sudo tar -xzvf ./sausage-store-frontend.tar.gz
#sudo cp -a ./frontend/. /var/www-data/dist/frontend/
#Обновляем конфиг systemd с помощью рестарта
#sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
#sudo systemctl restart sausage-store-backend


docker network create -d bridge sausage_network || true
docker login -u $GITLAB_USER -p $GITLAB_PASS $GITLAB_REGISTRY
docker pull ${GITLAB_REGISTRY}/sausage-store/sausage-frontend:latest
docker stop backend || true
docker rm backend || true
set -e
docker run -d --name backend \
    --network=sausage_network \
    -p 8080:80
    --restart always \
    --pull always \
    ${GITLAB_REGISTRY}/sausage-store/sausage-backend:latest


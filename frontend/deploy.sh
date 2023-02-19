#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -f /home/jarservice/sausage-store-frontend.tar.gz||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-frontend.tar.gz ${NEXUS_FRONTEND_REPO_URL}/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo cp /home/${DEV_USER}/sausage-store-frontend.tar.gz /home/jarservice/sausage-store-frontend.tar.gz||true #"<...>||true" говорит, если команда обвалится — продолжай
#Распакуем архив в нужную папку и скопируем файлы в директорию фронтэнда
sudo tar -xzvf /home/jarservice/sausage-store-frontend.tar.gz
sudo cp -a /home/jarservice/frontend/. /var/www-data/dist/frontend/
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend 

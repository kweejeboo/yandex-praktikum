FROM node:16-alpine3.17 as builder 
# Create app directory
WORKDIR /usr/src/app
COPY *.json ./
RUN npm install && npm install -g @angular/cli
COPY ./src ./src
RUN npm run build



#release stage
FROM node:16-alpine3.17 as release
WORKDIR /app
RUN adduser -S -s /bin/false -G www-data www-data -D -H
COPY --chown=www-data:www-data --from=builder /usr/src/app/dist ./dist
COPY package*.json .
RUN npm install -g http-server
USER ww-data
EXPOSE 80


ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]

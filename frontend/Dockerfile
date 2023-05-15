FROM node:16.17.0-bullseye-slim as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm run build


FROM nginxproxy/nginx-proxy
WORKDIR /app
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY nginx.tmpl .


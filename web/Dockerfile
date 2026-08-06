# D-56: Vite + React SPA, прод = статика за nginx + /db-прокси к SurrealDB
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --no-audit --no-fund
COPY . .
RUN npm run build

FROM nginx:alpine
RUN apk add --no-cache openssl
COPY docker/default.conf.template /etc/nginx/templates-src/default.conf.template
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]

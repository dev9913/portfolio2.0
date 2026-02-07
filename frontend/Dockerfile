# -------- Build Stage --------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
# -------- Runtime Stage --------
FROM nginx:stable-alpine
RUN apk update && apk upgrade --no-cache busybox busybox-binsh c-ares libcrypto3 libpng libssl3 libxml2 ssl_client libexpat
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

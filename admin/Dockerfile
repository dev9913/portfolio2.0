FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production
RUN npm install -g npm@11.10.1
COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

RUN addgroup -S app && adduser -S app -G app
USER app

EXPOSE 5001

CMD ["node", "server.js"]

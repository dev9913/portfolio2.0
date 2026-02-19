FROM node:20-alpine

WORKDIR /app

RUN npm install -g npm@11.9.0
RUN apk update 
COPY package*.json ./

RUN npm install  

COPY . .

RUN addgroup -S app && adduser -S app -G app
USER app

EXPOSE 5001 

CMD ["node", "server.js"]


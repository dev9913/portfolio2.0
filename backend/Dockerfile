FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm  ci
RUN npm install nodemailer mysql2 multer express dotenv cors body-parser

COPY . .
 
EXPOSE 5000

CMD ["node","src/server.js"]

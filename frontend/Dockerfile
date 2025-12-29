FROM node:18-alpine AS builder 

WORKDIR /app

COPY package*.json ./
RUN npm install  

COPY . . 
ENV REACT_APP_API_URL=http://localhost:5000

RUN  npm run build 

#--------- Second Stage ----

FROM nginx:stable-alpine 

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build  /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx","-g","daemon off;"]



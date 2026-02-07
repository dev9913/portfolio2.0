FROM php:8.3-alpine

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk upgrade --no-cache \
 && apk add --no-cache \
    linux-headers \
    musl \
    musl-dev \
    libexpat \
    curl \
    git \
    unzip \
    vim \
 && rm -rf /var/cache/apk/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]

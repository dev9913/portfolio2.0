FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git unzip vim  \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80
CMD ["apache2-foreground"]

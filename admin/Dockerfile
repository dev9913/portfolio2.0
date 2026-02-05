FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN a2enmod headers \
 && echo "ServerTokens Prod" >> /etc/apache2/apache2.conf \
 && echo "ServerSignature Off" >> /etc/apache2/apache2.conf

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

USER www-data

EXPOSE 80
CMD ["apache2-foreground"]


FROM php:8.2-apache

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN composer require phpmailer/phpmailer

COPY .env  /var/www/html/.env
COPY . /var/www/html/ 

RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80 

CMD ["apache2-foreground"]

FROM php:8.2-apache

RUN apt-get update && apt-get install -y  curl git unzip && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN composer require phpmailer/phpmailer

COPY . /var/www/html/ 
RUN composer install
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80 

CMD ["apache2-foreground"]



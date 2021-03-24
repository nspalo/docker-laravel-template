# Install PHP 7.2
FROM php:7.2-fpm-alpine

# Install PHP Extension
RUN docker-php-ext-install pdo pdo_mysql

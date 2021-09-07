# Install PHP 7.4
FROM php:7.4-fpm-alpine

# Install PHP Extension
RUN apk --no-cache add zip libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Install PHP 8.1
FROM php:8.1-fpm-alpine

# Install PHP Extension
RUN apk --no-cache add zip libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql

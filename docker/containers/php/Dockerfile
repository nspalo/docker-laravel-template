# Install PHP 8.2
FROM php:8.2-fpm-alpine

# Install PHP Extension
RUN apk --no-cache add zip libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \

# Install Composer
FROM composer:2.1.5

# Copy PHP from previous Dockerfile with a tag of php:php-7.4-fpm-alpine
# See docker/docker-compose.yml
COPY --from=php:php-7.4-fpm-alpine  /usr/local/bin/php /usr/local/bin/php
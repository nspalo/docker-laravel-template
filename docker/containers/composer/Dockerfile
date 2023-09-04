# Pull from PHP from previous Dockerfile - php/Dockerfile
# - see docker/docker-compose.yml for more info
# - use the image tag php:php-8.1-fpm-alpine
FROM php:php-8.1-fpm-alpine

# Install Composer 2.6.1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.6.1

# Add composer bin files path to environment variable
RUN export PATH=$PATH":/usr/bin"

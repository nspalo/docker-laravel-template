#=====================================================================
# PHP Dockerfile (Multi-Stage Build)
#---------------------------------------------------------------------
# docker/containers/php/Dockerfile
#
# Stages:
#   1. builder    — Compiles extensions, installs tools (Composer)
#   2. runtime    — Base image for development (code mounted via volumes)
#   3. production — Self-contained image with code baked in
#=====================================================================

# =====================================================================
# Stage 1: Builder
# ---------------------------------------------------------------------
# Installs system dependencies, compiles PHP extensions, and prepares tools.
# This stage is NOT included in the final image.
# =====================================================================
ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm-alpine AS builder

WORKDIR /var/www/html

# Install system dependencies required to COMPILE PHP extensions
RUN apk add --no-cache \
    git \
    zip \
    unzip \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    linux-headers \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev

# Install and configure PHP extensions
# --- Laravel required extensions ---
RUN docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        opcache \
        zip \
        intl \
        mbstring \
        gd \
        exif \
        bcmath

# --- Optional extensions (uncomment as needed) ---
# RUN pecl install redis && docker-php-ext-enable redis
# RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install Composer binary from the official Composer image
COPY --from=composer:2.8 /usr/bin/composer /usr/local/bin/composer

# =====================================================================
# Stage 2: Runtime
# ---------------------------------------------------------------------
# Base image for development. In dev, source code is mounted via volumes.
# This stage is also the foundation for the production stage.
# =====================================================================
FROM php:${PHP_VERSION}-fpm-alpine AS runtime

ARG SYS_ENV=dev

WORKDIR /var/www/html

# Install ONLY runtime libraries (shared libs that extensions link against)
RUN apk add --no-cache \
    libzip \
    icu-libs \
    oniguruma \
    freetype \
    libjpeg-turbo \
    libpng

# Copy compiled PHP extensions from the builder stage
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

# Copy extension configuration (.ini files that enable the extensions)
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# Copy Composer binary
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer

# Copy environment-specific PHP configuration
COPY ./containers/php/config/php-${SYS_ENV}.ini /usr/local/etc/php/conf.d/99-custom.ini

# Create a non-root user for running PHP-FPM (security best practice)
RUN addgroup -g 1000 appuser \
    && adduser -u 1000 -G appuser -s /bin/sh -D appuser \
    && chown -R appuser:appuser /var/www/html

# Pre-create directories that will be used as named volume mount points.
# Docker inherits ownership from the image on first volume creation.
RUN mkdir -p /var/www/html/vendor \
    && mkdir -p /var/www/html/node_modules \
    && chown -R appuser:appuser /var/www/html/vendor \
    && chown -R appuser:appuser /var/www/html/node_modules

# Laravel requires writable storage and cache directories
RUN mkdir -p /var/www/html/storage/logs \
    && mkdir -p /var/www/html/bootstrap/cache \
    && chown -R appuser:appuser /var/www/html/storage \
    && chown -R appuser:appuser /var/www/html/bootstrap/cache

# Switch to non-root user
USER appuser

# Expose PHP-FPM port
EXPOSE 9000

# Health check — verifies PHP-FPM config is valid
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD php-fpm -t || exit 1

CMD ["php-fpm"]

# =====================================================================
# Stage 3: Production
# ---------------------------------------------------------------------
# Self-contained image with source code and vendor dependencies baked in.
# No volume mounts needed — deploy this image directly.
#
# Build with: docker compose -f docker-compose.yml -f docker-compose.prod.yml build
# =====================================================================
FROM runtime AS production

# Switch to root temporarily to copy files with correct ownership
USER root

# Copy application source code
COPY --chown=appuser:appuser ./src /var/www/html

# Copy production PHP config (build context is project root in prod)
COPY ./docker/containers/php/config/php-prod.ini /usr/local/etc/php/conf.d/99-custom.ini

# Install production dependencies only (no dev packages)
RUN composer install --no-dev --no-interaction --optimize-autoloader --no-scripts \
    && chown -R appuser:appuser /var/www/html/vendor

# Ensure Laravel storage and cache are writable
RUN chown -R appuser:appuser /var/www/html/storage \
    && chown -R appuser:appuser /var/www/html/bootstrap/cache

# Switch back to non-root user
USER appuser

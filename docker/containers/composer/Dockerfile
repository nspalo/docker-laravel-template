# =====================================================================
# Composer Dockerfile
# ---------------------------------------------------------------------
# docker/containers/composer/Dockerfile
#
# This image reuses the PHP service (via additional_contexts in docker-compose.yml)
# which already includes Composer from the multi-stage build.
# This Dockerfile simply sets up the working directory and ensures the entrypoint is ready.
# =====================================================================

# Use the PHP service image as the base (defined in docker-compose.yml
# via additional_contexts -> base: service:php)
FROM base AS composer_base

# Set working directory
WORKDIR /var/www/html

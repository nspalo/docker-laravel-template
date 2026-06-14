#=====================================================================
# NginX Dockerfile
#---------------------------------------------------------------------
# docker/containers/nginx/Dockerfile
#=====================================================================

FROM nginx:stable-alpine

WORKDIR /var/www/html

# Copy NginX configuration
COPY ./containers/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Security: Run Nginx as non-root user
# 1. Create app user matching PHP container's user
# 2. Adjust ownership of directories Nginx needs to write to
# 3. Configure Nginx to run as non-root (listen on 8080 internally)
RUN addgroup -g 1000 appuser \
    && adduser -u 1000 -G appuser -s /bin/sh -D appuser \
    && chown -R appuser:appuser /var/cache/nginx \
    && chown -R appuser:appuser /var/log/nginx \
    && chown -R appuser:appuser /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown appuser:appuser /var/run/nginx.pid

# Switch to non-root user
USER appuser

# Expose unprivileged port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]

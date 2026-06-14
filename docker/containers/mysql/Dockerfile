#=====================================================================
# MySQL Dockerfile
#---------------------------------------------------------------------
# docker/containers/mysql/Dockerfile
#=====================================================================

# Build argument for MySQL version (passed from docker-compose.yml)
ARG DB_VERSION=8.0

FROM mysql:${DB_VERSION}

# Copy custom MySQL configuration
COPY ./containers/mysql/conf.d/my.cnf /etc/mysql/conf.d/my.cnf

EXPOSE 3306

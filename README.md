# Docker Laravel Template
> A ready-to-use Docker LEMP stack template for Laravel development — configurable, secure by default, and structured for real-world projects.

![CI BUILD](https://github.com/nspalo/docker-laravel-template/actions/workflows/build.yml/badge.svg)

## Features

- **Multi-stage PHP build** — minimal runtime image, extensions compiled separately
- **Compose overrides** — dev (hot-reload, debug ports) and prod (locked down, resource limits)
- **Single config file** — one place to change PHP version, DB version, ports, environment
- **Makefile interface** — `make help` shows all commands, no scripts to memorize
- **Secure by default** — non-root containers, security headers, hidden files blocked, no-new-privileges
- **Laravel-ready** — Artisan, Composer, NPM containers with proper volume handling
- **Configurable** — PHP 8.4, MySQL 8.0, Node 20, all swappable via `config.env`

## Quick Start

```bash
# 1. Clone and enter the project
git clone https://github.com/nspalo/docker-laravel-template.git my-laravel-app
cd my-laravel-app

# 2. Set up environment
cp docker/environments/dev.env.example docker/environments/dev.env
# Edit dev.env with your database credentials

# 3. Build and start
make build
make up

# 4. Install dependencies
make composer cmd="install"
make npm cmd="install"

# 5. Laravel setup
make artisan cmd="key:generate"
make migrate

# 6. Visit the site
# http://localhost (or whatever APP_PORT is set to in config.env)
```

Run `make help` to see all available commands.

## Configuration

All settings are controlled from a single file: `docker/environments/config.env`

```env
SYS_ENV=dev               # Environment: dev | staging | prod
COMPOSE_PROJECT_NAME=docker_laravel
PHP_VERSION=8.4           # PHP version
DB_VERSION=8.0            # MySQL version
NODE_VERSION=20           # Node.js version
APP_PORT=80               # Web server port
```

## Commands

```bash
make build                # Build all Docker images
make up                   # Start services (detached)
make up-build             # Build and start in one command
make down                 # Stop and remove containers
make down-v               # Stop, remove containers and volumes
make restart              # Restart all services
make logs                 # Follow logs from all containers
make ps                   # List running containers
make shell                # Open a shell in the PHP container

# Package Managers
make composer cmd="install"
make composer cmd="dump-autoload"
make npm cmd="install"
make npm cmd="run build"

# Laravel / Artisan
make artisan cmd="migrate"
make artisan cmd="key:generate"
make artisan cmd="make:model Post -m"
make migrate              # Shortcut: run migrations
make seed                 # Shortcut: run seeders
make fresh                # Shortcut: migrate:fresh --seed

# Maintenance
make prune                # Remove ALL Docker resources (dangerous)
make clean                # Stop services, remove volumes, prune images
```

## Directory Structure

```
my-laravel-app/
├── docker/
│   ├── containers/
│   │   ├── nginx/
│   │   │   ├── conf.d/default.conf
│   │   │   └── Dockerfile
│   │   ├── php/
│   │   │   ├── config/
│   │   │   │   ├── php-dev.ini
│   │   │   │   └── php-prod.ini
│   │   │   └── Dockerfile          # Multi-stage build
│   │   ├── mysql/
│   │   │   ├── conf.d/my.cnf
│   │   │   └── Dockerfile
│   │   └── composer/
│   │       └── Dockerfile
│   ├── environments/
│   │   ├── config.env               # Single control panel
│   │   ├── dev.env.example          # Credential template (dev)
│   │   └── prod.env.example         # Credential template (prod)
│   ├── docker-compose.yml           # Base compose (shared)
│   ├── docker-compose.dev.yml       # Dev override (volumes, debug ports)
│   ├── docker-compose.prod.yml      # Prod override (locked down)
│   └── .dockerignore
├── src/                             # Laravel application source
│   ├── app/
│   ├── config/
│   ├── database/
│   ├── public/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   └── ...
├── Makefile                         # Primary command interface
├── .gitignore
└── README.md
```

## Environments

| Environment | Compose Override | Behavior |
|-------------|----------------|----------|
| `dev` | `docker-compose.dev.yml` | Volume mounts, all ports exposed, debug-friendly |
| `staging` | `docker-compose.prod.yml` | Production-like, no debug ports |
| `prod` | `docker-compose.prod.yml` | Locked down, resource limits, health checks |

Change environment by editing `SYS_ENV` in `docker/environments/config.env`.

## Security

- Nginx and PHP containers run as non-root user (`appuser:1000`)
- Nginx listens on unprivileged port 8080 internally
- Production override enables read-only filesystems, `no-new-privileges`, and resource limits
- Security headers added: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection, Referrer-Policy
- Hidden files (`.env`, `.git`) are blocked by Nginx
- Credentials are stored in gitignored `.env` files, only `.example` templates are committed
- `.dockerignore` prevents secrets from leaking into build context

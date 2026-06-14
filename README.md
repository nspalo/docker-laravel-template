# Docker Laravel Template
> A Docker LEMP stack template for Laravel development — production-ready, configurable, and structured for real-world projects.

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
```

Run `make help` to see all available commands.

## Running the Project

### Step 1: Install Dependencies
```bash
make composer cmd="install"
make npm cmd="install"
```

### Step 2: Laravel Setup
```bash
# One command handles: copy .env, generate key, run migrations
make setup
```

### Step 3: Build Frontend Assets
```bash
make npm cmd="run build"
```

### Step 4: Access the Site
Hit the browser at `http://localhost` (or whatever `APP_PORT` is set to in `config.env`)

Optionally, update your host file for a custom local domain:
```
127.0.0.1 my-laravel-app.local
```
Then access via `http://my-laravel-app.local` instead of `localhost`.

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
# Container Management
make build                # Build all Docker images
make up                   # Start services in detached mode
make rebuild              # Force recreate and rebuild all services
make restart              # Restart all services
make down                 # Stop and remove containers, networks
make down-v               # Stop, remove containers, networks, and volumes
make stop                 # Stop running services without removing them
make reset                # Full reset — tear down everything, rebuild
make shell                # Open a shell in the PHP container

# Package Managers
make composer cmd="install"
make composer cmd="dump-autoload"
make npm cmd="install"
make npm cmd="run build"

# Laravel
make artisan cmd="migrate"
make artisan cmd="key:generate"
make artisan cmd="make:model Post -m"
make setup                # First-time setup (env, key, migrations)
make migrate              # Run database migrations
make seed                 # Run database seeders
make fresh                # Drop all tables, re-run migrations + seeders
make cache-clear          # Clear all Laravel caches
make route-list           # List all registered routes

# Monitoring & Debugging
make logs                 # View logs from all containers (follow mode)
make ps                   # List running containers with status
make info                 # Display current environment and configuration

# Maintenance
make clean                # Stop services, remove volumes, prune images
```

## Directory Structure

```
my-laravel-app/
├── docker/
│   ├── containers/                // Service Dockerfiles and configs
│   │   ├── nginx/
│   │   │   ├── conf.d/default.conf
│   │   │   └── Dockerfile
│   │   ├── php/
│   │   │   ├── config/
│   │   │   │   ├── php-dev.ini
│   │   │   │   └── php-prod.ini
│   │   │   └── Dockerfile         // Multi-stage build
│   │   ├── mysql/
│   │   │   ├── conf.d/my.cnf
│   │   │   └── Dockerfile
│   │   └── composer/
│   │       └── Dockerfile
│   ├── environments/
│   │   ├── config.env             // Single control panel
│   │   ├── dev.env.example        // Credential templates
│   │   ├── staging.env.example
│   │   └── prod.env.example
│   ├── docker-compose.yml         // Base compose (shared)
│   ├── docker-compose.dev.yml     // Dev override (volumes, debug ports)
│   ├── docker-compose.prod.yml    // Prod override (locked down)
│   └── .dockerignore
├── src/                           // Laravel application source code
│   ├── app/
│   ├── config/
│   ├── database/
│   ├── public/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   └── ...
├── Makefile                       // Primary command interface
└── README.md
```

## Environments

| Environment | Compose Override | Behavior |
|-------------|----------------|----------|
| `dev` | `docker-compose.dev.yml` | Volume mounts, all ports exposed, debug-friendly |
| `staging` | `docker-compose.prod.yml` | Production-like, no debug ports |
| `prod` | `docker-compose.prod.yml` | Locked down, resource limits, health checks |

Change environment by editing `SYS_ENV` in `docker/environments/config.env`.

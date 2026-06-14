# ===========================================================================
# Docker Laravel Template (DLT) - Makefile
# ===========================================================================
# Usage: make <command>
# Run `make` or `make help` to see all available commands.
# ===========================================================================

# Ensure consistent shell behavior across systems
SHELL := /bin/bash
.DEFAULT_GOAL := help

# Suppress "Entering directory" messages in recursive make calls
MAKEFLAGS += --no-print-directory

# ---------------------------------------------------------------------------
# Variables & Environment Setup
# ---------------------------------------------------------------------------

# Capture the current host user's UID and GID to ensure file permissions
# inside the container match the developer's local machine.
HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

# Load SYS_ENV from config to determine which compose override to use
SYS_ENV := $(shell grep -E '^SYS_ENV=' docker/environments/config.env | cut -d '=' -f2)

# Map SYS_ENV to compose override (dev → dev, everything else → prod)
ifeq ($(SYS_ENV),dev)
  DOCKER_COMPOSE_OVERRIDE := dev
else
  DOCKER_COMPOSE_OVERRIDE := prod
endif

# Build metadata for image tagging and traceability
BUILD_COMMIT := $(shell git describe --always --abbrev=40 --dirty 2>/dev/null || echo 'unknown')
BUILD_DATE   := $(shell date --rfc-3339=seconds 2>/dev/null || date '+%Y-%m-%d %H:%M:%S')

# Collection of environment variables passed into docker compose commands
DOCKER_COMPOSE_VARS := HOST_UID=$(HOST_UID) \
                       HOST_GID=$(HOST_GID) \
                       BUILD_COMMIT="$(BUILD_COMMIT)" \
                       BUILD_DATE="$(BUILD_DATE)"

# Base docker compose command
DOCKER_COMPOSE := $(DOCKER_COMPOSE_VARS) docker compose \
  --env-file docker/environments/config.env \
  -f docker/docker-compose.yml \
  -f docker/docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml

# Default container for shell access (override: make shell APP_CONTAINER=nginx)
APP_CONTAINER ?= php

# ===========================================================================
# HELP & INFO
# ===========================================================================

.PHONY: help info

help: ## Show available commands
	@echo ""
	@echo "Docker Laravel Template (DLT)"
	@echo "Environment: $(SYS_ENV) | Override: docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml"
	@echo ""
	@echo "Usage: make <command>"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

info: ## Display current environment and configuration
	@echo ""
	@echo "Current Configuration:"
	@echo "  SYS_ENV:          $(SYS_ENV)"
	@echo "  DOCKER_COMPOSE_OVERRIDE: docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml"
	@echo "  HOST_UID:         $(HOST_UID)"
	@echo "  HOST_GID:         $(HOST_GID)"
	@echo "  BUILD_COMMIT:     $(BUILD_COMMIT)"
	@echo "  BUILD_DATE:       $(BUILD_DATE)"
	@echo "  APP_CONTAINER:    $(APP_CONTAINER)"
	@echo ""

# ===========================================================================
# BUILD & START
# ===========================================================================

.PHONY: build build-no-cache rebuild up start up-build restart

build: ## Build all Docker images
	$(DOCKER_COMPOSE) build

build-no-cache: ## Build images from scratch without Docker layer cache
	$(DOCKER_COMPOSE) build --no-cache

rebuild: ## Force recreate and rebuild all services (detached)
	$(DOCKER_COMPOSE) up -d --force-recreate --build

up: ## Start services in detached mode
	$(DOCKER_COMPOSE) up -d

start: ## Start services in foreground (abort on container exit, useful for debugging)
	$(DOCKER_COMPOSE) up --abort-on-container-exit

up-build: ## Build and start services in detached mode
	$(DOCKER_COMPOSE) up -d --build

restart: down up ## Restart all services

# ===========================================================================
# STOP & TEARDOWN
# ===========================================================================

.PHONY: down down-v stop reset

down: ## Stop and remove containers, networks
	$(DOCKER_COMPOSE) down

down-v: ## Stop and remove containers, networks, and volumes
	$(DOCKER_COMPOSE) down -v

stop: ## Stop running services without removing them
	$(DOCKER_COMPOSE) stop

reset: down-v rebuild ## Full reset — tear down everything, rebuild from scratch

# ===========================================================================
# EXEC & RUN
# ===========================================================================

.PHONY: exec run shell

exec: ## Execute command in a running container (usage: make exec c=php cmd="php -v")
ifndef c
	$(error "c" is required. Usage: make exec c=<container> cmd="<command>")
endif
ifndef cmd
	$(error "cmd" is required. Usage: make exec c=<container> cmd="<command>")
endif
	$(DOCKER_COMPOSE) exec $(c) $(cmd)

run: ## Run a one-off command in a new container (usage: make run c=php cmd="php -v")
ifndef c
	$(error "c" is required. Usage: make run c=<container> cmd="<command>")
endif
ifndef cmd
	$(error "cmd" is required. Usage: make run c=<container> cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm $(c) $(cmd)

shell: ## Open a shell in the app container (default: php, override: make shell APP_CONTAINER=nginx)
	$(DOCKER_COMPOSE) exec $(APP_CONTAINER) sh

# ===========================================================================
# PACKAGE MANAGERS
# ===========================================================================

.PHONY: composer npm

composer: ## Run Composer commands (usage: make composer cmd="install")
ifndef cmd
	$(error "cmd" is required. Usage: make composer cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm composer $(cmd)

npm: ## Run NPM commands (usage: make npm cmd="install")
ifndef cmd
	$(error "cmd" is required. Usage: make npm cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm npm $(cmd)

# ===========================================================================
# LARAVEL (Artisan)
# ===========================================================================

.PHONY: artisan migrate seed fresh setup key-generate route-list cache-clear

artisan: ## Run Artisan commands (usage: make artisan cmd="migrate")
ifndef cmd
	$(error "cmd" is required. Usage: make artisan cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm artisan $(cmd)

migrate: ## Run database migrations
	$(DOCKER_COMPOSE) run --rm artisan migrate

seed: ## Run database seeders
	$(DOCKER_COMPOSE) run --rm artisan db:seed

fresh: ## Drop all tables and re-run migrations + seeders
	$(DOCKER_COMPOSE) run --rm artisan migrate:fresh --seed

setup: ## First-time Laravel setup (env, key, migrations)
	@cp -n src/.env.example src/.env 2>/dev/null || true
	$(DOCKER_COMPOSE) run --rm artisan key:generate
	$(DOCKER_COMPOSE) run --rm artisan migrate

key-generate: ## Generate application key
	$(DOCKER_COMPOSE) run --rm artisan key:generate

route-list: ## List all registered routes
	$(DOCKER_COMPOSE) run --rm artisan route:list

cache-clear: ## Clear all Laravel caches (config, route, view, app)
	$(DOCKER_COMPOSE) run --rm artisan config:clear
	$(DOCKER_COMPOSE) run --rm artisan route:clear
	$(DOCKER_COMPOSE) run --rm artisan view:clear
	$(DOCKER_COMPOSE) run --rm artisan cache:clear

# ===========================================================================
# MONITORING & DEBUGGING
# ===========================================================================

.PHONY: logs ps

logs: ## View logs from all containers (follow mode)
	$(DOCKER_COMPOSE) logs -f

ps: ## List running containers with status
	$(DOCKER_COMPOSE) ps

# ===========================================================================
# MAINTENANCE
# ===========================================================================

.PHONY: prune clean

prune: ## Remove ALL Docker images, containers, volumes system-wide (DANGEROUS)
	@echo "⚠️  WARNING: This will remove ALL Docker images, containers, and volumes."
	@echo "Press Ctrl+C to cancel, or wait 5 seconds to continue..."
	@sleep 5
	docker system prune -a --force

clean: down-v ## Stop services, remove volumes, and prune unused images
	docker image prune -f

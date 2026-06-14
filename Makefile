# ===========================================================================
# Docker Laravel Template (DLT) - Makefile
# ===========================================================================
# Usage: make <command>
# Run `make` or `make help` to see all available commands.
# ===========================================================================

SHELL := /bin/bash
.DEFAULT_GOAL := help
MAKEFLAGS += --no-print-directory

# ---------------------------------------------------------------------------
# Variables & Environment Setup
# ---------------------------------------------------------------------------

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

SYS_ENV := $(shell grep -E '^SYS_ENV=' docker/environments/config.env | cut -d '=' -f2)

ifeq ($(SYS_ENV),dev)
  DOCKER_COMPOSE_OVERRIDE := dev
else
  DOCKER_COMPOSE_OVERRIDE := prod
endif

BUILD_COMMIT := $(shell git describe --always --abbrev=40 --dirty 2>/dev/null || echo 'unknown')
BUILD_DATE   := $(shell date --rfc-3339=seconds 2>/dev/null || date '+%Y-%m-%d %H:%M:%S')

DOCKER_COMPOSE_VARS := HOST_UID=$(HOST_UID) \
                       HOST_GID=$(HOST_GID) \
                       BUILD_COMMIT="$(BUILD_COMMIT)" \
                       BUILD_DATE="$(BUILD_DATE)"

DOCKER_COMPOSE := $(DOCKER_COMPOSE_VARS) docker compose \
  --env-file docker/environments/config.env \
  -f docker/docker-compose.yml \
  -f docker/docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml

APP_CONTAINER ?= php

# ===========================================================================
##@ Help & Info
# ===========================================================================

.PHONY: help info

help: ## Show available commands
	@echo ""
	@echo "Docker Laravel Template (DLT)"
	@echo "Environment: $(SYS_ENV) | Override: docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml"
	@echo ""
	@echo "Usage: make <command>"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; section=""} \
		/^##@/ { section=substr($$0, 5); next } \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (section != "") { printf "\n\033[1m%s\033[0m\n", section; section="" } \
			printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""

info: ## Display current environment and configuration
	@echo ""
	@echo "Docker Laravel Template (DLT)"
	@echo ""
	@echo "  SYS_ENV:       $(SYS_ENV)"
	@echo "  OVERRIDE:      docker-compose.$(DOCKER_COMPOSE_OVERRIDE).yml"
	@echo "  HOST_UID:      $(HOST_UID)"
	@echo "  HOST_GID:      $(HOST_GID)"
	@echo "  BUILD_COMMIT:  $(BUILD_COMMIT)"
	@echo "  BUILD_DATE:    $(BUILD_DATE)"
	@echo ""

# ===========================================================================
##@ Container Management
# ===========================================================================

# ===========================================================================
## Build & Start:
# ===========================================================================

.PHONY: build rebuild up restart

build: ## Build all Docker images
	$(DOCKER_COMPOSE) build

rebuild: ## Force recreate and rebuild all services
	$(DOCKER_COMPOSE) up -d --force-recreate --build

up: ## Start services in detached mode
	$(DOCKER_COMPOSE) up -d

restart: down up ## Restart all services

# ===========================================================================
## Stop & Teardown:
# ===========================================================================

.PHONY: down down-v stop reset

down: ## Stop and remove containers, networks
	$(DOCKER_COMPOSE) down

down-v: ## Stop, remove containers, networks, and volumes
	$(DOCKER_COMPOSE) down -v

stop: ## Stop running services without removing them
	$(DOCKER_COMPOSE) stop

reset: down-v rebuild ## Full reset — tear down everything, rebuild

# ===========================================================================
## Shell & Access
# ===========================================================================

.PHONY: shell

shell: ## Open a shell in the PHP container
	$(DOCKER_COMPOSE) exec $(APP_CONTAINER) sh

# ===========================================================================
##@ Package Managers
# ===========================================================================

.PHONY: composer npm

composer: ## Run Composer commands (cmd=)
ifndef cmd
	$(error Usage: make composer cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm composer $(cmd)

npm: ## Run NPM commands (cmd=)
ifndef cmd
	$(error Usage: make npm cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm npm $(cmd)

# ===========================================================================
##@ Laravel
# ===========================================================================

.PHONY: artisan setup migrate seed fresh cache-clear route-list

artisan: ## Run Artisan commands (cmd=)
ifndef cmd
	$(error Usage: make artisan cmd="<command>")
endif
	$(DOCKER_COMPOSE) run --rm artisan $(cmd)

setup: ## First-time setup (env, key, migrations)
	@cp -n src/.env.example src/.env 2>/dev/null || true
	$(DOCKER_COMPOSE) run --rm artisan key:generate
	$(DOCKER_COMPOSE) run --rm artisan migrate

migrate: ## Run database migrations
	$(DOCKER_COMPOSE) run --rm artisan migrate

seed: ## Run database seeders
	$(DOCKER_COMPOSE) run --rm artisan db:seed

fresh: ## Drop all tables, re-run migrations + seeders
	$(DOCKER_COMPOSE) run --rm artisan migrate:fresh --seed

cache-clear: ## Clear all Laravel caches
	$(DOCKER_COMPOSE) run --rm artisan optimize:clear

route-list: ## List all registered routes
	$(DOCKER_COMPOSE) run --rm artisan route:list

# ===========================================================================
##@ Monitoring & Debugging
# ===========================================================================

.PHONY: logs ps

logs: ## View logs from all containers (follow mode)
	$(DOCKER_COMPOSE) logs -f

ps: ## List running containers with status
	$(DOCKER_COMPOSE) ps

# ===========================================================================
##@ Maintenance
# ===========================================================================

.PHONY: clean

clean: down-v ## Stop services, remove volumes, prune images
	docker image prune -f

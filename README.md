# Docker Laravel Template
> This is a simple project that aims to build a template for a
> *Dockerize web development environment with NginX, MySQL, PHP, and Laravel*.

![CI BUILD](https://github.com/nspalo/docker-laravel-template/actions/workflows/build.yml/badge.svg)

## Web Stack
**Docker containers**
- nginx
  - NginX stable-alpine
- mysql
  - MySQL 5.7.22
- php
  - PHP 8.1-fpm-alpine
- composer
  - Composer 2.6.1
- npm
  - Node 20.6-alpine
- artisan
  - Laravel ^8.0

## TLDR;
- A Quick guide to get things up and running

### Step 1: Build and Start Services
```
> ./scripts/up.sh -d --build
```

### Step 2: Running Composer
```
> ./scripts/composer.sh install
> ./scripts/composer.sh dump-autoload
```

### Step 3: Running NPM
```
// Running NPM
> ./scripts/run.sh npm install
> ./scripts/run.sh npm run build
```

### Step 4: Laravel Set-up
```
// Copying Laravel .env file
> ./scripts/composer.sh run post-root-package-install

// Generating key
> ./scripts/artisan.sh key:generate

// Running migrations
> ./scripts/artisan.sh migrate
```

### Step 5: Accessing the site
Hit the browser at `localhost`

----

## More Details ...

### Environment File and Configurations
_In here, we will use a file with `.env` extension to support multi-environment set up and load the correct variable values automatically.
For now, its just_ `local.env` but feel free to add more depending on the need like `staging.env`, `uat.env`, `test.env`, `prod.env` and the likes.
- _see:_ `docker/environments/local.env` to set up your configs and credentials for this file.
  - Take note that some values in this file will be use later on by laravel `.env` and our `config.env` file.

The generic `.env` file `config.env` should always be used in the command and should use the variable `SYS_ENV` to set the specific environment file configuration.
- _see:_ `docker/environments/config.env`

### Docker Compose Command Structure 
> **Note:** In this structure, we always need to add few flags for our docker composer commands to work.
> - `--env-file` flag is the path to the environment config we want to load.
> - `-f` flag is the path to the docker compose yaml file.  
    > which in our case it is:
> - `--env-file docker/environments/config.env`
> - `-f docker/docker-compose.yml`
>
>  - _See: `docker/docker-compose.yml` for the list of service containers_
>
> _So for our full command to build the images would look something like this_    
> `> docker-compose --env-file docker/environments/config.env -f docker/docker-compose.yml build`
>
> However, for ease of use and to make running of commands easy, a few scripts was prepared.  
> The simplified version of the command above is `> ./scripts/build.sh`   
> _See:`scripts/`_ for more info.


### Service containers: Building, Starting, and Stopping
```
// Building the services/containers
> ./scripts/build.sh

// Starting the services/containers
// - optionally add the -d (detach) flag to run in the background
> ./scripts/up.sh -d

// Or do a one-liner command for the build and start process
> ./scripts/up.sh -d --build

// Stoping the services/containers
// - To stop a specific service add the continer name
> ./scripts/stop.sh <_ContainerName_>

// Tear down routine
// - optionally add the -v to remove the images 
> ./scripts/down.sh -v
```

### Packages and Dependencies
```
// Running NPM
> ./scripts/run.sh npm install
> ./scripts/run.sh npm run build

// Running Composer
> ./scripts/composer.sh install
> ./scripts/composer.sh dump-autoload

// Copying Laravel .env file
> ./scripts/composer.sh run post-root-package-install

// Generating Key
> ./scripts/artisan.sh key:generate

// Running Migration
> ./scripts/artisan.sh migrate
```

### Importing existing database data
```
// First  we need to copy the .sql file for import to the container
// docker cp <FilePath>/<SqlFile>.sql <ContainerName>:./<SqlFile>.sql
> docker cp docker/volumes/mysql/file.sql mysql:file.sql

// Then login to mysql container
// docker exec -it <ContainerName> mysql -u<dbUsername> -p<dbPassword>
> docker exec -it mysql mysql -udbUserDev -pdbUserDev123

// Inside mysql, import the data
// source <SQL_FILE>.sql
mysql> source file.sql
```

### Code Quality and Testing
```
// Running PhpStan
> ./scripts/composer.sh run phpstan

// Running Easy Coding Standards for the entire project
> ./scripts/composer.sh run ecs-all

// Running Easy Coding Standards for App or Test ONLY
> ./scripts/composer.sh run ecs-app
> ./scripts/composer.sh run ecs-test

// Running Auto-Fix for ecs
> ./scripts/composer.sh run ecs-app-fix
> ./scripts/composer.sh run ecs-test-fix

// Running Automated Test with PhpUnit
> ./scripts/composer.sh run phpunit
```

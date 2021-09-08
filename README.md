# Docker Laravel Template
> This is a simple repo to learn the basics in setting up a
> *Web development environment with NginX, MySQL, PHP, and Laravel inside a __Docker__ container*.

## Web Stack
**Docker containers**
- nginx
  - NginX stable-alpine
- mysql
  - MySQL 5.7.22
- php
  - PHP 7.4 fpm-alpine
- composer
  - Composer 2.1.5
- npm
  - Node 16 alpine
- artisan
  - Laravel5.8
  
## Set Up Procedure
> **Note:**  
> In this structure, we always need to add few flags for our commands to work.
> --env-file flag then the path to the environment config we want to load.
> -f flag then the path to the docker compose yaml file.  
> which in our case it is
> - `--env-file docker/environments/local.env`
> - `-f docker/docker-compose.yml`
>
> _See: `docker/docker-compose.yml` for the list of service containers_
 
### Step 0: Environment File Config
Note:  
_This will soon be updated and improved to support multi-environment set up and load the correct file automatically  
So for now, its just_ `local.env`. To set up your configs and credentials for this file.    
_see:_ `docker/environment/local.env`. Take note that some values in this file will be use later on by laravel `.env` file.

### Step 1: Service containers - Building and Starting
```
// Building the services/containers
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml build

// Starting the services/containers
// - optionally add the -d (detach) flag to run in the background
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up -d

// Or do a one-liner command for the build and start process
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up -d --build
```

### Step 2 - A: Packages and Dependencies
> **_Note:_** for a specific service, use the container name  
> **_Format:_** docker-compose --env-file <_EnvFile_> -f <_DockerComposeYamlFile_> up <_ContainerName_>     
> **_E.g.:_** `docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up php`
> 
```
// Running composer install
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm composer install

// Running artisan migrate
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm artisan migrate

// Running npm
> docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm npm install
```

### Step 2 - B: Importing existing database data
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

### Step 3: Accessing the site
Hit the browser at `localhost:9100`
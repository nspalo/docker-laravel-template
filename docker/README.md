# Docker Study
> This is a simple repo to learn the basics in setting up a  
> *Web development environment with __Docker__*.

## Docker Directory
- This directory will host all docker related files.

### Docker Commands
> Notes of some simple docker commands for building, starting, and stopping the service containers and other docker related operations.
> 
> In this structure, we always need to add few flags for our commands to work.
> --env-file flag then the path to the environment config we want to load.
> -f flag then the path to the docker compose yaml file.  
> which in our case it is
> - `--env-file docker/environments/local.env`   
> - `-f docker/docker-compose.yml`
> 
> _See: `docker/docker-compose.yml` for the list of service containers_

### Helpful Basic Docker Commands
```
// List all Docker Containers
docker ps

// Stop all Running Docker Containers.
// - the -q flag will only list the IDs of those containers
docker kill $(docker ps -q)

// Stop and Remove all Docker Containers
// - the -a flag returns all containers, not just the running ones
docker rm $(docker ps -a -q)

// List All Docker Images
// - with a -q flag it will list all image IDs
docker images
docker images -q

// Remove All Docker Images
// - the rmi stands for remove images
// - the -f flag stands for force
docker rmi -f $(docker images -q)

// Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
docker system prune -a
```

### Building the service containers
```
// Build the services/containers
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml build
```

### Starting the service
```
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up

// add the -d (detach) option to run in the background
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up -d

// Can also do a one-liner build and start
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up -d --build

// use the container name for a specific service  
// docker-compose up <_ContainerName_>
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml up php
```

### Stopping the service
```
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml down -v

// -v, --volumes Remove named volumes declared in the `volumes`
//                section of the Compose file and anonymous volumes
//                attached to containers.

// to stop a specific service, use the stop command followed by th container name  
// docker-compose stop <_ContainerName_>
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml stop mysql
```

### Restarting the service
```
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml restart

// use the container name for a specific service
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml restart php
```

### Running commands inside a service container
```
// Use docker-compose run --rm <_ContainerName_> <_CommandName_>
// run command to run a one-time command against a service
// add the --rm flag to - Remove container after run. (Ignored in detached mode)
// then use the service container name and the command 
// - format: docker-compose run --rm <_ContainerName_> <_CommandName_>
// - e.g.: To run php artisan migrate commad 
// -- docker-compose run --rm artisan migrate
// Note: we still need to use -f flag and the path to our docker compose yamel file

// Running composer
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm composer dump-autoload

// Running npm
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm npm install

// Running artisan command
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml run --rm artisan migrate
```

### Running arbitrary commands inside a service container (OLD/DEPRECATED)
> **Note:**  
> This is the old way/approach and was replaced by the one above.
> For now, will keep it for reference.
```
// Use docker-compose exec to run command inside the container.
// - e.g.: To run php artisan migrate commad 
// - format: docker-compose exec <_ContainerName_> php <_PathToArtisan_> migrate
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml exec php php /var/www/html/artisan migrate

// Check if index.php exists
docker-compose --env-file docker/environments/local.env -f docker/docker-compose.yml exec nginx ls /var/www/html/public
```

### Importing existing database data
```
// Copy .sql file for import to the container
// docker cp <PATH_OF_FILE>/<SQL_FILE>.sql <CONTAINER_NAME>:./<SQL_FILE>.sql
docker cp docker/volumes/mysql/file.sql mysql:file.sql

// Then login to mysql
// docker exec -it <CONTAINER_NAME> mysql -u<DB_USERNAME> -p<DB_PASSWORD>
docker exec -it mysql mysql -udbUserDev -pdbUserDev123

// Inside mysql, import the data
// source <SQL_FILE>.sql
mysql> source file.sql
```
# Docker Study
> This is a simple repo to learn the basics in setting up a  
> *Web development environment with __Docker__*.

## Docker Directory
- This directory will host the docker related files.

## Docker Commands
> Notes of some simple docker commands for building, starting, and stopping the service containers

> ### Note:
> In this structure, we always need to add a -f flag then the path to the docker compose yaml file
> which in our case it is `-f ./docker/docker-compose/docker-compose.yml`   
> See: `./docker/docker-compose/docker-compose.yml` for the list of service containers

### Building the service containers
```
// Build the services/containers
docker-compose -f ./docker/docker-compose/docker-compose.yml build
```

### Starting the service
```
docker-compose -f ./docker/docker-compose/docker-compose.yml up

// add the -d (detach) option to run in the background
docker-compose -f ./docker/docker-compose/docker-compose.yml up -d

// Can also do a one-liner build and start
docker-compose -f ./docker/docker-compose/docker-compose.yml up -d --build

// use the container name for a specific service  
// docker-compose up <_ContainerName_>
docker-compose -f ./docker/docker-compose/docker-compose.yml up php
```

### Stopping the service
```
docker-compose -f ./docker/docker-compose/docker-compose.yml down -v

// -v, --volumes Remove named volumes declared in the `volumes`
//                section of the Compose file and anonymous volumes
//                attached to containers.

// to stop a specific service, use the stop command followed by th container name  
// docker-compose stop <_ContainerName_>
docker-compose -f ./docker/docker-compose/docker-compose.yml stop mysql
```

### Restarting the service
```
docker-compose -f ./docker/docker-compose/docker-compose.yml restart

// use the container name for a specific service
docker-compose -f ./docker/docker-compose/docker-compose.yml restart php
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
docker-compose -f ./docker/docker-compose/docker-compose.yml run --rm compsoer dump-autoload

// Running npm
docker-compose -f ./docker/docker-compose/docker-compose.yml run --rm npm install

// Running artisan
docker-compose -f ./docker/docker-compose/docker-compose.yml run --rm artisan migrate
```

### Running arbitrary commands inside a service container (OLD)
```
// Note: This is the old way and was replace by the one above.
// Use docker-compose exec to run command inside the container.
// - e.g.: To run php artisan migrate commad 
// - format: docker-compose exec <_ContainerName_> php <_PathToArtisan_> migrate
docker-compose -f ./docker/docker-compose/docker-compose.yml exec php php /var/www/html/artisan migrate

// Check if index.php exists
docker-compose -f ./docker/docker-compose/docker-compose.yml exec nginx ls /var/www/html/public
```
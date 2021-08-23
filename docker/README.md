# Docker Study
> This is a simple repo to learn the basics in setting up a  
> *Web development environment with __Docker__*.
> 
## Docker Directory
- This directory will host the docker related files.

## Docker Commands
> Notes of some simple docker commands for building, starting, and stopping the service containers

> ### Note:
> In this structure, we always need to add a -f flag and the path to the docker compose yaml file
> which in out case is -f ./docker/docker-compose/docker-compose.yml

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

### Running arbitrary commands inside a service container
```
// Use docker-compose exec to run command inside the container.
// - e.g.: To run php artisan migrate commad 
// - format: docker-compose exec <_ContainerName_> php <_PathToArtisan_> migrate
docker-compose -f ./docker/docker-compose/docker-compose.yml exec php php /var/www/html/artisan migrate
```

```
// building & starting (detach)
docker-compose -f ./docker/docker-compose/docker-compose.yml up -d --build

// Check if index.php exists
docker-compose -f ./docker/docker-compose/docker-compose.yml exec nginx ls /var/www/html/public
```
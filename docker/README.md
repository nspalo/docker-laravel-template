# Docker Study
> This is a simple repo to learn the basics in setting up a  
> *Web development environment with __Docker__*.

## Docker Directory
- This directory will host the docker related files.

## Docker Commands
> Notes of some simple docker commands for building, starting, and stopping the service containers

### Building the service containers
```
docker-compose build

// can also Build the run in one line
// adding the -d (detach) option to run in the background
docker-compose build && docker-compose up -d
```

### Starting the service
```
docker-compose up

// add the -d option to run in the background
docker-compose up -d

// use the container name for a specific service  
// docker-compose up <_ContainerName_>
docker-compose up php
```

### Stopping the service
```
docker-compose down -v

// to stop a specific service, use the stop command followed by th container name  
// docker-compose stop <_ContainerName_>
docker-compose stop mysql
```

### Restarting the service
```
docker-compose restart

// use the container name for a specific service
docker-compose restart php
```

### Running arbitrary commands inside a service container
```
// Use docker-compose exec to run command inside the container.
// - e.g.: To run php artisan migrate commad 
// - format: docker-compose exec <_ContainerName_> php <_PathToArtisan_> migrate
docker-compose exec php php /var/www/html/artisan migrate
```

```
// building & starting (detach)
docker-compose up -d --build

// Check if index.php exists
docker-compose exec nginx ls /var/www/html/public
```
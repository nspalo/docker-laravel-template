# Docker Study
> This is a simple repo to learn the basics in setting up a  
> *Web development environment with __Docker__*.

## Web App/Project Directory
- This directory will host the Web App/Project related files.

### Test Run
```
// Build and Start Services and Containers
// - see: ./docker/README file for more
docker-compose -f ./docker/docker-compose/docker-compose.yml build
docker-compose -f ./docker/docker-compose/docker-compose.yml up -d

// Access Web
http://localhost:9100/
```
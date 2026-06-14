# Docker Directory
- This directory hosts all Docker related files.

## Directory Structure
- Below is an overview of how the Docker directory structure looks.
- Add / Remove / Rename according to needs.
```
my-project/                       // Main Project Directory
├── docker/                       // Docker Related
│   ├── containers/               // Service Containers
│   │   ├── nginx/
│   │   │   ├── conf.d/           // NginX Configurations
│   │   │   │   └── default.conf  // default configuration file
│   │   │   └── Dockerfile
│   │   ├── php/
│   │   │   ├── config/           // PHP Configurations
│   │   │   │   ├── php-dev.ini   // development configuration
│   │   │   │   └── php-prod.ini  // production configuration
│   │   │   └── Dockerfile
│   │   ├── mysql/
│   │   │   ├── conf.d/           // MySql Configurations
│   │   │   │   └── my.cnf        // default configuration file
│   │   │   └── Dockerfile
│   │   └── composer/
│   │       └── Dockerfile
│   ├── environments/              // Environment variables
│   │   ├── config.env             // Main config file (single control panel)
│   │   ├── dev.env.example        // Development credentials template
│   │   ├── staging.env.example    // Staging credentials template
│   │   └── prod.env.example       // Production credentials template
│   ├── docker-compose.yml         // Base Docker compose file
│   ├── docker-compose.dev.yml     // Development override
│   ├── docker-compose.prod.yml    // Production override
│   └── .dockerignore              // Build context ignore list
└── ...
```

# Containers Directory
- This directory hosts all Docker container related files.

## Directory Structure
- Below is an overview of how the containers directory structure looks.
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
│   │   │   ├── conf.d/           // MySQL Configurations
│   │   │   │   └── my.cnf        // default configuration file
│   │   │   └── Dockerfile
│   │   └── composer/
│   │       └── Dockerfile
│   └── ...
└── ...
```

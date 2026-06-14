# Environments Directory
- This directory contains `.env` files for environment-specific variables.

## Directory Structure
```
my-project/
├── docker/
│   ├── ...
│   ├── environments/
│   │   ├── config.env             // Main config (single control panel)
│   │   ├── dev.env.example        // Development credentials template
│   │   ├── staging.env.example    // Staging credentials template
│   │   └── prod.env.example       // Production credentials template
│   └── ...
└── ...
```

### config.env
- Single control panel for the entire template.
- Set `SYS_ENV` to `dev`, `staging`, or `prod`.

### dev.env.example
- Template for development database credentials.
- Copy to `dev.env` and fill in values: `cp dev.env.example dev.env`

### staging.env.example
- Template for staging database credentials.
- Copy to `staging.env` and fill in values: `cp staging.env.example staging.env`

### prod.env.example
- Template for production database credentials.
- Copy to `prod.env` and fill in values: `cp prod.env.example prod.env`

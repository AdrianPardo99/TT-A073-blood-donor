# TT-A073

## Development

### Development Environment Setup

### Docker-related

Run project
`docker-compose up -d`

If you make any changes that requires a new Docker build:
`docker-compose up --build -d`

To run one-off processes on engine container, for example:
`docker-compose run api python api/manage.py makemigrations`

To scale up number of workers
`docker-compose up -d --scale worker=2`

To debug using pdb or ipdb
`docker attach {containerId}`

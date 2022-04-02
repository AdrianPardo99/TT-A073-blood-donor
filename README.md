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

## First local deployment

For use the project you only need to apply migrations of the project, you need to run:
`docker-compose run api python api/manage.py migrate`

## Restoring a Data Base dump

If you have one or many databases, you only need to run the next command for restoring the data:
`docker-compose exec unit_blood pg_restore --verbose --clean --no-acl --no-owner -h db -U postgres -d postgres <file.dump>`

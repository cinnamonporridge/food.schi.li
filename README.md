# food.schi.li

## Setup

Have PostgreSQL installed and running, then run

```shell
bin/setup
```

## Test

```shell
bin/test
```

Runs `rails test`, `rails test:system` and `bundle exec rubocop`

## Deploy

### Production

`main` is automatically deployed through GitHub hook on Heroku.

## Import dump

```sh
heroku pg:backups:capture --app=
heroku pg:backups:download --app=
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U [user] -d [db_name] latest.dump
```

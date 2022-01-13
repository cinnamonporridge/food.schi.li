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

#### Prerequisites

Make sure Heroku has required buildpacks

```
heroku buildpacks:add heroku/nodejs
heroku buildpacks:add heroku/ruby
```

`nodejs` has to be added before `ruby`. Without this we cannot use Node 14 (as of date 2021-04-05).

#### Deploy to Heroku

```shell
git push heroku main
```

Available at https://food-schi-li.herokuapp.com (or via https://food.schi.li)


## Import dump

```sh
pg_restore --verbose --clean --no-acl --no-owner -C -h localhost -d [db_name] latest.dump
```

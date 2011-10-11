# DbStructureExt

ActiveRecord connection adapter extensions.

Currently it extends only mysql/mysql2 adapters with structure_dump/structure_load methods.

Library **does not override** mysql adapter by default.

So you able to use extensions with MysqlConnectionProxy or extend mysql connection class.

## Installation

    gem install db_structure_ext

## Using MysqlConnectionProxy

    connection = ActiveRecord::Base.connection
    connection_proxy = DbStructureExt::MysqlConnectionProxy.new(connection)
    connection_proxy.structure_dump

## Extending mysql adapter connection

    require 'db_structure_ext/init_mysql_adapter'
    connection.structure_dump

It automaticaly detects corresponding mysql/mysq2 adapter.

## Dump structure

Extended *structure_dump* for mysql/mysql2 adapter dumps not only *tables*. It dumps:

* tables
* views
* triggers
* routines (functions and procedures)

## Load structure

Method loads sql statements separated by *\n\n*

### parallel_test support

It prepends

    ENV['TEST_ENV_NUMBER']

to any table name with test suffix in name


## Rake tasks

TODO

## Testing

We test library against AR 1.x.x and AR 3.0.x so we use multiversion.

It assumes you use RVM and Bundler.

### Create rvm aliases

    rvm alias create ar01_r186 ruby-1.8.6-pYOUR_PATCH_LEVEL
    rvm alias create ar30_r192 ruby-1.9.2-pYOUR_PATCH_LEVEL

### Install multiversion

Read more about multiversion here https://github.com/railsware/multiversion

    gem install multiversion

### Install gems

    multiversion all bundle install

### Run tests

    multiversion all rspec spec


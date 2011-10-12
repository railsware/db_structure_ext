# DbStructureExt

ActiveRecord connection adapter extensions.

Currently it extends only mysql/mysql2 adapter with structure_dump/structure_load methods.

Library **does not override** mysql adapter by default.

So you can use extensions independently (via MysqlConnectionProxy) or include extension methods into adapter.

## Installation

    gem install db_structure_ext

## Using MysqlConnectionProxy

    connection = ActiveRecord::Base.connection
    connection_proxy = DbStructureExt::MysqlConnectionProxy.new(connection)
    connection_proxy.structure_dump

## Extending mysql adapter

    require 'db_structure_ext/init_mysql_adapter'
    connection.structure_dump

It automaticaly detects corresponding mysql/mysq2 adapter.
So it should works with any rails version including v1.2.6

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

to any table name with *_test* suffix in name

## Rails db tasks extensions

Add to your *Rakefile*

    require 'db_structure_ext/tasks'

In case Rails3 its loaded automaticaly via railtie mechanizm.

### db:structure:dump

Synopsis:

    rake db:structure:dump[env,file]  # Dump the database structure to a SQL file

By default it works as original well-known rails task.
It dumps development structure to *db/development_structure.sql*
But it dumps to NOT only TABLES. It dumps also VIEWS, TRIGGERS and ROUTINES.

Additionally you can indicate another *environment* as first argument and optionally another dump *file* as second.
By default dump filename is *db/{env}_structure.sql*

### db:structure:load

Synopsis:

    rake db:structure:load[env,file]  # Load SQL structure file to the database

Its opposite task to *db:structure:load* that allows to load db structure from specified file to specified db environment.
The arguments is the same as for previous task.


### Examples

Dump *development* structure to db/development_structure.sql file:

    rake db:structure:dump[development,db/development_structure.sql]
    # or
    rake db:structure:dump[development]
    # or
    RAILS_ENV=development db:structure:dump
    # or just
    rake db:structure:dump

Dump development structure to db/my_structure.sql file:

    rake db:structure:dump[development,db/my_structure.sql]

Load db/my_structure.sql to test database:

    rake db:structure:load[test,db/my_structure.sql]

Load db/development_structure.sql to development database:

    rake db:structure:load[development,db/development_structure.sql]
    # or
    rake db:structure:load[development]
    # or
    RAILS_ENV=development rake db:structure:load[development]
    # or
    rake db:structure:load


## Testing

We have tested library against AR 1.x.x and AR 3.0.x.

We use [multiversion](https://github.com/railsware/multiversion) gem

It assumes you use RVM and Bundler.

### Create rvm aliases

    rvm alias create ar01_r186 ruby-1.8.6-pYOUR_PATCH_LEVEL
    rvm alias create ar30_r192 ruby-1.9.2-pYOUR_PATCH_LEVEL

### Install multiversion

    gem install multiversion

### Install gems

    multiversion all bundle install

### Run tests

    multiversion all rspec spec


# logging
require 'active_record'
require 'logger'
ActiveRecord::Base.logger = ::Logger.new('log/test.log')

# mysql adapter
require 'active_record/version'
case ActiveRecord::VERSION::MAJOR
when 1
  require 'active_record/connection_adapters/mysql_adapter'
when 3
  require 'active_record/connection_adapters/mysql2_adapter'
end

# mysql connection
require 'yaml'
require 'erb'
ActiveRecord::Base.establish_connection YAML::load(ERB.new(IO.read('config/database.yml')).result)['test']

# lib
require 'db_structure_ext'

begin
  require 'mysql2'
rescue LoadError
end

begin
  require 'mysql'
rescue LoadError
end

require 'active_record'
require 'active_record/version'

if defined?(Mysql2)
  require 'active_record/connection_adapters/mysql2_adapter'
  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, DbStructureExt::MysqlAdapter
elsif defined?(Mysql)
  require 'active_record/connection_adapters/mysql_adapter'
  ActiveRecord::ConnectionAdapters::MysqlAdapter.send :include, DbStructureExt::MysqlAdapter
end

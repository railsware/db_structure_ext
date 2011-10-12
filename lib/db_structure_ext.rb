require 'db_structure_ext/version'
require 'db_structure_ext/railtie' if defined?(Rails::Railtie)

module DbStructureExt
  autoload :MysqlAdapter,         'db_structure_ext/mysql_adapter'
  autoload :MysqlConnectionProxy, 'db_structure_ext/mysql_connection_proxy'
  autoload :MysqlDumpMethods,     'db_structure_ext/mysql_dump_methods'
  autoload :MysqlLoadMethods,     'db_structure_ext/mysql_load_methods'
end

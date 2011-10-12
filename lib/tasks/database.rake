# Remove standard rails tasks
original_db_structure_dump_task = Rake.application.instance_variable_get(:@tasks).delete('db:structure:dump')

namespace :db do
  namespace :structure do

    desc "Dump the database structure to a SQL file"
    task :dump, [:env, :file] => :environment do |t, args|
      env  = args[:env]  || ENV['RAILS_ENV'] || 'development'
      file = args[:file] || "db/#{env}_structure.sql"

      ActiveRecord::Base.establish_connection(env)

      puts "Dumping #{env} database to #{file}"

      case adapter_name = ActiveRecord::Base.connection.adapter_name
      when /mysql/i
        require 'db_structure_ext/mysql_connection_proxy'
        connection_proxy = DbStructureExt::MysqlConnectionProxy.new(ActiveRecord::Base.connection)
        File.open(file, "w+") { |f| f << connection_proxy.structure_dump }
      else
        original_db_structure_dump_task.invoke
      end
    end

    desc "Load SQL structure file to the database"
    task :load, [:env, :file] => :environment do |t, args|
      env  = args[:env]  || ENV['RAILS_ENV'] || 'development'
      file = args[:file] || "db/#{env}_structure.sql"

      ActiveRecord::Base.establish_connection(env)

      puts "Loading #{file} structure to #{env} database"

      case adapter_name = ActiveRecord::Base.connection.adapter_name
      when /mysql/i
        require 'db_structure_ext/mysql_connection_proxy'
        connection_proxy = DbStructureExt::MysqlConnectionProxy.new(ActiveRecord::Base.connection)
        connection_proxy.structure_load(file)
      else
        raise "Task not supported by #{adapter_name.inspect} adapter"
      end
    end

  end
end

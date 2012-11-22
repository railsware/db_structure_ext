# Remove standard rails tasks
original_db_structure_dump_task = Rake.application.instance_variable_get(:@tasks).delete('db:structure:dump')
original_db_structure_load_task = Rake.application.instance_variable_get(:@tasks).delete('db:structure:load')

namespace :db do
  namespace :structure do

    desc "Dump the database structure to a SQL file"
    task :dump, [:env, :file] => :environment do |t, args|
      env  = args[:env]  || ENV['RAILS_ENV'] || 'development'
      file = args[:file] || "db/#{env}_structure.sql"

      puts "Dumping #{env} database to #{file}"

      case adapter_name = ActiveRecord::Base.connection.adapter_name
      when /mysql/i
        require 'db_structure_ext'
        ActiveRecord::Base.establish_connection(env)
        connection_proxy = DbStructureExt::MysqlConnectionProxy.new(ActiveRecord::Base.connection)
        File.open(file, "w+") { |f| f << connection_proxy.structure_dump }
      else
        ENV['RAILS_ENV'] = env
        ENV['DB_STRUCTURE'] = file
        original_db_structure_dump_task.invoke
      end
    end

    desc "Load SQL structure file to the database"
    task :load, [:env, :file] => :environment do |t, args|
      env  = args[:env]  || ENV['RAILS_ENV'] || 'development'
      file = args[:file] || "db/#{env}_structure.sql"

      puts "Loading #{file} structure to #{env} database"

      case adapter_name = ActiveRecord::Base.connection.adapter_name
      when /mysql/i
        require 'db_structure_ext'
        ActiveRecord::Base.establish_connection(env)
        connection_proxy = DbStructureExt::MysqlConnectionProxy.new(ActiveRecord::Base.connection)
        connection_proxy.structure_load(file)
      else
        ENV['RAILS_ENV'] = env
        ENV['DB_STRUCTURE'] = file
        original_db_structure_load_task.invoke
      end
    end

  end
end

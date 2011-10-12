module DbStructureExt
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'db_structure_ext/tasks'
    end
  end
end


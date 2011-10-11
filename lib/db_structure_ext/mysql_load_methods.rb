module DbStructureExt
  module MysqlLoadMethods

    def structure_load(schema_file)
      IO.readlines(schema_file).join.split("\n\n").each do |statement|
        statement.gsub!(/`([\w\d_]+)_test`\./, "`\\1_test#{ENV['TEST_ENV_NUMBER']}`.")
        execute(statement)
      end
    end

  end
end

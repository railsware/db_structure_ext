module DbStructureExt
  module MysqlDumpMethods

    # Dump mysql base tables
    def tables_dump
      structure = ""

      sql = supports_views? ?
        "SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'" : "SHOW TABLES"

      table_names = select_all(sql).map { |table|
        table.delete('Table_type')
        table.to_a.first.last
      }

      table_names.each do |table_name|
        structure << select_one("SHOW CREATE TABLE `#{table_name}`")["Create Table"]
        structure << ";\n\n"
      end

      structure
    end

    # Dump mysql views
    def views_dump
      structure = ""
      return structure unless supports_views?

      table_names = select_all("SHOW FULL TABLES WHERE Table_type = 'VIEW'").map { |table|
        table.delete('Table_type')
        table.to_a.first.last
      }

      # Temporary structure
      table_names.each do |table_name|
        fields = select_all("SHOW FIELDS FROM #{table_name}")
        structure << "CREATE TABLE #{table_name} (\n"
        structure << fields.map { |field| "  #{quote_column_name(field['Field'])} #{field['Type']}" }.join(",\n")
        structure << "\n) ENGINE=MyISAM"
        structure << ";\n\n"
      end

      # Final structure
      table_names.each do |table_name|
        structure << "DROP TABLE IF EXISTS #{table_name}" 
        structure << ";\n\n"
        structure << "DROP VIEW IF EXISTS #{table_name}"
        structure << ";\n\n"
        structure << select_one("SHOW CREATE VIEW #{table_name}")["Create View"] 
        structure << ";\n\n"
      end

      structure.gsub!(/^(CREATE).+(VIEW)/, '\1 \2')

      structure
    end

    # dump mysql triggers
    def triggers_dump
      structure = ""
      return structure unless supports_triggers?

      sql = "SHOW TRIGGERS"

      select_all(sql).each do |row|
        structure << "CREATE TRIGGER #{row['Trigger']} #{row['Timing']} #{row['Event']} ON #{row['Table']} FOR EACH ROW #{row['Statement']}"
        structure << ";\n\n"
      end

      structure
    end

    # dump mysql routines: procedures and functions
    def routines_dump
      structure = ""
      return structure unless supports_routines?

      sql = "SELECT ROUTINE_TYPE as type, ROUTINE_NAME as name FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='#{current_database}'"

      select_all(sql).each do |row|
        structure << select_one("SHOW CREATE #{row['type']} #{row['name']}")["Create #{row['type'].capitalize}"]
        structure.gsub!(/^(CREATE).+(PROCEDURE|FUNCTION)/, '\1 \2')
        structure << ";\n\n"
      end

      structure
    end

    def structure_dump
      structure = ""
      structure << tables_dump
      structure << views_dump
      structure << triggers_dump
      structure << routines_dump
      structure
    end

    private

    # Does mysql support triggers?
    def supports_triggers?
      version[0] >= 5
    end

    # Does mysql support routines?
    def supports_routines?
      version[0] >= 5
    end
  end
end

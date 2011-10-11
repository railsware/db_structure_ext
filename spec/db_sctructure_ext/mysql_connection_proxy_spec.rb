require 'spec_helper'

describe DbStructureExt::MysqlConnectionProxy do

  def connection
    ActiveRecord::Base.connection
  end

  before(:all) do
    @connection_proxy = DbStructureExt::MysqlConnectionProxy.new(connection)

    @all_statements = File.read("db/structure.sql").strip.split("\n\n")

    connection.recreate_database "db_structure_ext_test"
    connection.execute "USE db_structure_ext_test"
    @all_statements.each { |statement| connection.execute statement }
  end

  describe "#tables_dump" do
    it "should return 'CREATE TABLE' statements" do
      statements = @connection_proxy.tables_dump.split("\n\n")

      statements.should have(2).items

      statements.should include(@all_statements[0])
      statements.should include(@all_statements[1])
    end
  end

  describe "#views_dump" do
    it "should return 'CREATE VIEW' statements" do
      statements = @connection_proxy.views_dump.split("\n\n")

      statements.should have(8).items

      statements.should include(@all_statements[2])
      statements.should include(@all_statements[3])
      statements.should include(@all_statements[4])
      statements.should include(@all_statements[5])
      statements.should include(@all_statements[6])
      statements.should include(@all_statements[7])
      statements.should include(@all_statements[8])
      statements.should include(@all_statements[9])
    end
  end

  describe "#triggers_dump" do
    it "should return 'CREATE TRIGGER' statements" do
      statements = @connection_proxy.triggers_dump.split("\n\n")

      statements.should have(1).items

      statements.should include(@all_statements[10])
    end
  end

  describe "#routines_dump" do
    it "should return 'CREATE PROCEDURE' and 'CREATE FUNCTION' statements" do
      statements = @connection_proxy.routines_dump.split("\n\n")

      statements.should have(2).items

      statements.should include(@all_statements[11])
      statements.should include(@all_statements[12])
    end
  end

  describe "#structure_dump" do
    it "should return structure with TABLES VIEWS TRIGGER PROCEDURES and FUNCTIONS statements" do
      statements = @connection_proxy.structure_dump.split("\n\n")
      statements.should have(13).items

      # tables
      tables = statements[0..1]
      tables.should include(@all_statements[0])
      tables.should include(@all_statements[1])

      # views
      views = statements[2..9]
      views.should include(@all_statements[2])
      views.should include(@all_statements[3])
      views.should include(@all_statements[4])
      views.should include(@all_statements[5])
      views.should include(@all_statements[6])
      views.should include(@all_statements[7])
      views.should include(@all_statements[8])
      views.should include(@all_statements[9])

      # triggers
      triggers = statements[10..10]
      triggers.should include(@all_statements[10])

      # routines
      routines = statements[11..12]
      routines.should include(@all_statements[11])
      routines.should include(@all_statements[12])
    end
  end

  describe "#structure_load" do
    before(:all) do
      connection.recreate_database "db_structure_ext_test"
      connection.execute "USE db_structure_ext_test"
    end

    it "should load structures from file to database" do
      @connection_proxy.structure_load 'db/structure.sql'

      connection.select_values('SHOW TABLES').sort.should == [
        "active_users", "pending_users", "profiles", "users"
      ]

      connection.select_all('SHOW TRIGGERS').map { |r| r['Trigger'] }.sort.should == [
        "update_user_state_on_insert"
      ]

      connection.select_values("SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='db_structure_ext_test'").sort.should == [
        "fix_user_state", "hello"
      ]
    end
  end
end

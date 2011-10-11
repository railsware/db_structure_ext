module DbStructureExt
  class MysqlConnectionProxy

    include DbStructureExt::MysqlAdapter

    def initialize(connection)
      @connection = connection
    end

    private

    def method_missing(sym, *args, &block)
      @connection.__send__(sym, *args, &block)
    end
  end
end

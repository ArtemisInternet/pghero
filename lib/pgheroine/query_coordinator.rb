module PGHeroine
  class QueryCoordinator
    def initialize(database_name)
      self.database_name = database_name
    end

    def respond_to?(name)
      super || query_runner.respond_to?(name)
    end

    private

    attr_accessor :database_name

    def method_missing(method_name, *args, &blk)
      if query_runner.respond_to?(method_name)
        define_proxy_method(method_name).call(*args, &blk)
      else
        super
      end
    end

    def define_proxy_method(method_name)
      self.class.send(:delegate, method_name, to: :query_runner)
      method(method_name)
    end

    def connection
      @connection ||= ConnectionBuilder.new(database_name.to_sym).connection
    end

    def query_runner
      @query_runner ||= QueryRunner.new(connection)
    end
  end
end

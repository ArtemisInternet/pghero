require 'test_helper'

class TestActiveRecordMultipleDatabases < ActiveSupport::TestCase
  setup do
    default_hash = {adapter: 'postgresql', database: '', username: 'postgres'}
    number_of_databases = 3

    @database_configurations = database_configurations = [].tap do |array|
      number_of_databases.times do |index|
        array << default_hash.merge(database: "pgheroine_test_#{index}")
      end
    end

    @database_connections = database_configurations.map do |config|
      Class.new(ActiveRecord::Base) do
        self.table_name = %q|connections|

        def self.name
          %q|Connection|
        end

        establish_connection config
      end
    end
  end

  test "using multiple anonymous classes to connect to multiple databases" do
    assert_equal 3, @database_connections.map(&:connection).size
  end

  test "querying multiple database connections" do
    results = @database_connections.map do |connection_class|
      connection_class.connection.execute("SELECT * FROM pg_stats LIMIT 1")
    end

    assert_equal 3, results.size
  end
end

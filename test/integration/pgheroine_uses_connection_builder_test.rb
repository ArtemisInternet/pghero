require 'test_helper'

module PGHeroine
  class TestPGHeroineUsesConnectionBuilderTest < ActiveSupport::TestCase
    test "queries accept a database name and execute the query for that database" do
      connection_builder = ConnectionBuilder.new(:fake_1)

      connection = Minitest::Mock.new
      connection.expect(:select_all, nil, [String])

      ConnectionBuilder.stub(:new, connection_builder) do
        connection_builder.stub(:connection, connection) do
          QueryCoordinator.new(:fake_1).running_queries
          connection.verify
        end
      end
    end
  end
end

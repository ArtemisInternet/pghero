require 'test_helper'

module PGHeroine
  class TestConnectionBuilder < ActiveSupport::TestCase
    test %q|call .new with symbol returns an instance with an active connection| do
      connection = ConnectionBuilder.new(:fake_1).connection
      connection.execute(%q|SELECT * FROM pg_stats LIMIT 1|)

      assert connection.active?
    end

    test %q|call .new with a symbol for a database that does not exist| do
      assert_raises(DatabaseConfigurationNotFound) do 
        ConnectionBuilder.new(:fake)
      end
    end
  end
end
